//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 14/05/2022.
//

import Foundation

class Exercise: Identifiable, Codable, Equatable {
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.name == rhs.name
    }
    
    var allSetsFinished: Bool {
        for workingSet in workingSets {
            if workingSet.isFinished == false  {
                return false
            }
        }
        return true
    }
    
    enum CodingKeys: CodingKey {
        case name
        case workingSets
        case isFinished
    }
    
    @Published var name: String
    @Published var workingSets: [WorkingSet] = []
    @Published var isFinished: Bool = false
    
    required init(from decoder: Decoder) throws {
        
        // all of the coding key is stored in this container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        workingSets = try container.decode([WorkingSet].self, forKey: .workingSets)
        isFinished = try container.decode(Bool.self, forKey: .isFinished)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(workingSets, forKey: .workingSets)
        try container.encode(isFinished, forKey: .isFinished)
    }
    
    init(name: String) {
        self.name = name
        self.workingSets = [WorkingSet()]
    }
    
    init(name: String, workingSets: [WorkingSet]) {
        self.name = name
        self.workingSets = workingSets
    }
    
    static let example = Exercise(name: "Bench Press", workingSets: [WorkingSet.example, WorkingSet.example2])
}
