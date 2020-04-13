//
//  AnimalUrlService.swift
//  ar-animals
//
//  Created by Strahinja Laktovic on 11 4//20.
//  Copyright © 2020 Strahinja Laktovic. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

public class AnimalUrlService {
    public static func openUrlForAnimal(animalInfo: AnimalInfo) {
    UIApplication.shared.open(NSURL(string:"https://www.nationalgeographic.com/\(AnimalProvider.animalUrls[animalInfo.Name]!["animal"] ?? "")")! as URL)
    }
    
    public static func openUrlForFirstSimilar(animalInfo: AnimalInfo) {
    UIApplication.shared.open(NSURL(string:"https://www.nationalgeographic.com/\(AnimalProvider.animalUrls[animalInfo.Name]!["firstSimilar"] ?? "")")! as URL)
    }
    
    public static func openUrlForSecondSimilar(animalInfo: AnimalInfo) {
    UIApplication.shared.open(NSURL(string:"https://www.nationalgeographic.com/\(AnimalProvider.animalUrls[animalInfo.Name]!["secondSimilar"] ?? "")")! as URL)
    }
}
