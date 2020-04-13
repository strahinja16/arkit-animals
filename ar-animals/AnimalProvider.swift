//
//  AnimalProvider.swift
//  ar-animals
//
//  Created by Strahinja Laktovic on 11 4//20.
//  Copyright © 2020 Strahinja Laktovic. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

public class AnimalProvider {
    private static let animals: [String: AnimalInfo] = [
        "Deer" : AnimalInfo(name: "Deer", firstSimilar: "Impala", secondSimilar: "Gazelle", eulerX: .pi),
        "Elephant" :AnimalInfo(name: "Elephant", firstSimilar: "Manatee", secondSimilar: "Dugong", eulerX: .pi / 2),
    ]
    
    public static let animalNames: [String] = ["Deer", "Elephant"]

    public static let animalUrls: [String: [String: String]] = [
        "Deer": [
            "animal": "/animals/mammals/w/white-tailed-deer/",
            "firstSimilar": "/animals/mammals/i/impala/",
            "secondSimilar": "/animals/mammals/t/thomsons-gazelle/"
        ],
        "Elephant": [
            "animal": "/animals/mammals/a/african-elephant/",
            "firstSimilar": "/animals/mammals/group/manatees/",
            "secondSimilar": "/animals/mammals/d/dugong/"
        ]
    ]
    
    public static func getAnimal(name: String) -> AnimalInfo? {
        if let animal = animals[name] {
            return animal
        }
        return nil
    }
}
