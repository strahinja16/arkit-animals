//
//  ViewController.swift
//  ar-animals
//
//  Created by Strahinja Laktovic on 11 4//20.
//  Copyright © 2020 Strahinja Laktovic. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var shrinkBtn: UIButton!
    
    var currentAnimal: AnimalInfo? 
    
    var textNodesShown: Bool = false
    
    var currentPlaneNode: SCNNode? = nil
    var textNodes: [SCNNode] = []
    
    // The scnNodeAnimal variable will be the node to be added when the animal image is found
    var scnNodeAnimal: SCNNode = SCNNode()
    // Currently added scnNode (in this case scnNodeAnimal when the animal image is found)
    var currentNode: SCNNode? = nil
    // UUID of the found Image Anchor that is used to add a scnNode
    var currentARImageAnchorIdentifier: UUID?
    // This variable is used to call a function when there is no new anchor added for 1 second
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
               
       // Create a session configuration
       let configuration = ARWorldTrackingConfiguration()
       
       if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Animals", bundle: Bundle.main){

           configuration.detectionImages = trackedImages

           configuration.maximumNumberOfTrackedImages = 1
       }
        
        expandBtn.layer.cornerRadius = 15
        shrinkBtn.layer.cornerRadius = 15
        rotateBtn.layer.cornerRadius = 15
        infoBtn.layer.cornerRadius = 15
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func addTextNodes() {
        if let currPlane = currentPlaneNode {
            let textNode = TextNodeService.createTitleNode(text: currentAnimal!.Name)
            let firstSimilarAnimalNode = TextNodeService.createFirstSimilarAnimalNode(text: "Related: \(currentAnimal!.FirstSimilar)")
            let secondSimilarAnimalNode = TextNodeService.createSecondSimilarAnimalNode(text: "Related: \(currentAnimal!.SecondSimilar)")

            currPlane.addChildNode(textNode)
            currPlane.addChildNode(firstSimilarAnimalNode)
            currPlane.addChildNode(secondSimilarAnimalNode)
            
            textNodes.append(textNode)
            textNodes.append(firstSimilarAnimalNode)
            textNodes.append(secondSimilarAnimalNode)
            
            textNodesShown = true
        }
    }
    
    private func removeTextNodes() {
        textNodes.forEach { node in
            node.removeFromParentNode()
        }
        
        textNodes.removeAll()
        
        textNodesShown = false
    }
    
    private func tryToShowMoreInfo(_ touchLocation: CGPoint) {
        let tappedNode = self.sceneView.hitTest(touchLocation, options: [:])

        if tappedNode.count == 0 {
            return
        }
        
        let node = tappedNode[0].node
        if node.name == "animal-title" {
            if let animalForUrl = currentAnimal {
                AnimalUrlService.openUrlForAnimal(animalInfo: animalForUrl)
            }
        }
        
        if node.name == "similar-animal-1" {
            if let animalForUrl = currentAnimal {
                AnimalUrlService.openUrlForFirstSimilar(animalInfo: animalForUrl)
            }
        }
        
        if node.name == "similar-animal-2" {
            if let animalForUrl = currentAnimal {
                AnimalUrlService.openUrlForSecondSimilar(animalInfo: animalForUrl)
            }
        }
    }
    
    @IBAction func expandClicked(_ sender: Any) {
        guard let animal = currentAnimal else { return }
        
        guard let animalNode = currentPlaneNode?.childNodes.first(where: { $0.name == animal.Name }) else {
            return
        }
    
        animalNode.scale = SCNVector3(
            x: 1.1 * animalNode.scale.x,
            y: 1.1 * animalNode.scale.y,
            z: 1.1 * animalNode.scale.z
        )

    }
    @IBAction func shrinkClicked(_ sender: Any) {
        guard let animal = currentAnimal else { return }
            
        guard let animalNode = currentPlaneNode?.childNodes.first(where: { $0.name == animal.Name }) else {
            return
        }
    
        animalNode.scale = SCNVector3(
            x: 0.9 * animalNode.scale.x,
            y: 0.9 * animalNode.scale.y,
            z: 0.9 * animalNode.scale.z
        )
    }
    
    @IBAction func rotateClicked(_ sender: Any) {
        guard let animal = currentAnimal else { return }
                
        guard let animalNode = currentPlaneNode?.childNodes.first(where: { $0.name == animal.Name }) else {
            return
        }
    
        animalNode.eulerAngles.z = animalNode.eulerAngles.z + .pi / 7
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        textNodesShown ? removeTextNodes() : addTextNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
            tryToShowMoreInfo(touchLocation)
        }
    }
    
    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        DispatchQueue.main.async {
            if(self.timer != nil){
                self.timer.invalidate()
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1 , target: self, selector: #selector(self.imageLost(_:)), userInfo: nil, repeats: false)
        }

        if(self.currentARImageAnchorIdentifier != imageAnchor.identifier &&
            self.currentARImageAnchorIdentifier != nil
            && self.currentNode != nil){
                self.currentNode!.removeFromParentNode()
                self.currentNode = nil
        }

        DispatchQueue.main.async {
            self.currentARImageAnchorIdentifier = imageAnchor.identifier

            // Delete anchor from the session to reactivate the image recognition
            self.sceneView.session.remove(anchor: anchor)
        }

    }
    
    @objc
    func imageLost(_ sender:Timer){
        if let currNode = self.currentNode {
            currNode.removeFromParentNode()
            currentNode = nil
        }
    }
 
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi / 2
            
            if currentPlaneNode != nil {
                currentPlaneNode = nil
            }
            node.addChildNode(planeNode)
                        
            guard let animalName = imageAnchor.referenceImage.name else { return node }
            
            guard let animal = AnimalProvider.getAnimal(name: animalName) else { return node }
            guard let aniScene = SCNScene(named: "art.scnassets/\(animalName.lowercased()).scn") else { return node
            }
            guard let aniNode = aniScene.rootNode.childNodes.first else { return node }
            
                        
            aniNode.eulerAngles.x = animal.EulerX
            aniNode.name = animalName

            planeNode.addChildNode(aniNode)
            currentAnimal = animal
            currentPlaneNode = planeNode
        }
        
        return node
    }
}
