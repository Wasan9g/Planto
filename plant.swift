//
//  plant.swift
//  planto
//
//  Created by wasan on 02/06/1448 AH.
//


import Foundation

struct Plant: Identifiable {

    let id = UUID()
    
    
    
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var water: String
    var isWatered = false
}

