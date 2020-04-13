//
//  TextNodeService.swift
//  ar-animals
//
//  Created by Strahinja Laktovic on 11 4//20.
//  Copyright © 2020 Strahinja Laktovic. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

public class TextNodeService {
    public static func createTitleNode(text: String) -> SCNNode {
        return createTextNode(text: text, name: "animal-title", scale: SCNVector3(0.001, 0.001, 0.001), position: SCNVector3(0, -0.02, 0.06), eulerX: .pi / 2, bgColor: UIColor.black.withAlphaComponent(0.9), fontSize: 10)
    }
    
    public static func createFirstSimilarAnimalNode(text: String) -> SCNNode {
        return createTextNode(text: text, name: "similar-animal-1", scale: SCNVector3(0.001, 0.001, 0.001), position: SCNVector3(-0.01, -0.06, 0.01), eulerX: 0, bgColor: UIColor.yellow.withAlphaComponent(0.9), fontSize: 5)
    }
    
    public static func createSecondSimilarAnimalNode(text: String) -> SCNNode {
        return createTextNode(text: text, name: "similar-animal-2", scale: SCNVector3(0.001, 0.001, 0.001), position: SCNVector3(-0.01, -0.065, 0.01), eulerX: 0, bgColor: UIColor.yellow.withAlphaComponent(0.9), fontSize: 5)
    }
    
    private static func createTextNode(text: String, name: String, scale: SCNVector3, position: SCNVector3, eulerX: Float, bgColor: UIColor, fontSize: CGFloat) -> SCNNode {
        let title = SCNText(string: text, extrusionDepth: 0.6)
        title.font = UIFont(name: "Helvetica", size: fontSize)
        
        let titleNode = SCNNode(geometry: title)
        titleNode.scale = scale
        titleNode.eulerAngles.x = eulerX
        titleNode.name = name
        titleNode.position = position
        
        let minVec = titleNode.boundingBox.min
        let maxVec = titleNode.boundingBox.max
        let bound = SCNVector3Make(maxVec.x - minVec.x,
                                   maxVec.y - minVec.y,
                                   maxVec.z - minVec.z);

        let plane = SCNPlane(width: CGFloat(bound.x + 1),
                            height: CGFloat(bound.y + 1))
        plane.cornerRadius = 0.2
        plane.firstMaterial?.diffuse.contents = bgColor

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat( minVec.x) + CGFloat(bound.x) / 2 ,
                                        CGFloat( minVec.y) + CGFloat(bound.y) / 2,CGFloat(minVec.z - 0.01))

        titleNode.addChildNode(planeNode)
        return titleNode
    }
}
