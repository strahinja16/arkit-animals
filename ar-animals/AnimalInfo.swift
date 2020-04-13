//
//  AnimalInfo.swift
//  ar-animals
//
//  Created by Strahinja Laktovic on 11 4//20.
//  Copyright © 2020 Strahinja Laktovic. All rights reserved.
//

import Foundation

public class AnimalInfo {
    public var Name: String
    public var FirstSimilar: String
    public var SecondSimilar: String
    public var EulerX: Float
    
    public init(name: String, firstSimilar: String, secondSimilar: String, eulerX: Float) {
        Name = name
        FirstSimilar = firstSimilar
        SecondSimilar = secondSimilar
        EulerX = eulerX
    }
}
