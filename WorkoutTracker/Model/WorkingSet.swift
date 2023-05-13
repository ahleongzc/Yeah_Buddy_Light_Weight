//
//  WorkingSet.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 15/05/2022.
//

import Foundation

class WorkingSet: Identifiable, Codable, Equatable {
    
    var id = UUID()
    var totalReps: Int
    var weight: Double
    var isFinished: Bool = false
    
    var wrappedWeight: String {
        String(format: "%.2f", weight)
    }
    
    init() {
        self.totalReps = 0
        self.weight = 0
    }
    
    init(totalReps: Int, weight: Double) {
        self.totalReps = totalReps
        self.weight = weight
    }
    
    static func == (lhs: WorkingSet, rhs: WorkingSet) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static let example = WorkingSet(totalReps: 10, weight: 60.0)
    static let example2 = WorkingSet(totalReps: 12, weight: 80.0)
}
