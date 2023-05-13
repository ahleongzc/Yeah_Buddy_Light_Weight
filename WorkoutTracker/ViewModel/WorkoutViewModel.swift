//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 15/05/2022.
//

import Foundation

@MainActor class WorkoutViewModel: ObservableObject, Codable {
    
    @Published var exercises: [Exercise]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("savedData")
    
    enum CodingKeys: CodingKey {
        case exercises
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        exercises = try container.decode([Exercise].self, forKey: .exercises)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exercises, forKey: .exercises)
    }
    
    func removeAllExercises() {
        exercises.removeAll()
        save()
    }
    
    func removeSetIn(_ exercise: Exercise, set: WorkingSet) {
        guard exercise.workingSets.contains(set) else { return }
        objectWillChange.send()
        
        if let index = exercise.workingSets.firstIndex(of: set) {
            exercise.workingSets.remove(at: index)
            save()
        }
    }
    
    func toggleSetIn(_ exercise: Exercise, set: WorkingSet) {
        guard exercise.workingSets.contains(set) else { return }
        objectWillChange.send()
        
        if let index = exercise.workingSets.firstIndex(of: set) {
            exercise.workingSets[index].isFinished.toggle()
            save()
        }
    }
    
    func addOneSetTo(_ exercise: Exercise) {
        objectWillChange.send()
        let newSet = WorkingSet()
        exercise.workingSets.append(newSet)
        save()
    }
    
    func addExercise(_ exercise: Exercise) {
        self.exercises.append(exercise)
        save()
    }
    
    func removeExercise(_ exercise: Exercise) {
        if let index = exercises.firstIndex(of: exercise) {
            exercises.remove(at: index)
            save()
        }
    }
    
    func finishFirstRemainingSet(_ exercise: Exercise) {
        objectWillChange.send()
        for workingSet in exercise.workingSets {
            if workingSet.isFinished == false {
                workingSet.isFinished.toggle()
                save()
                return
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    func replaceWorkingSetIn(_ exercise: Exercise, oldSet: WorkingSet, newSet: [WorkingSet]){
        guard exercise.workingSets.contains(oldSet) else { return }
        objectWillChange.send()
        
        if let index = exercise.workingSets.firstIndex(of: oldSet) {
            removeSetIn(exercise, set: oldSet)
            
            for newSet in newSet {
                exercise.workingSets.insert(newSet, at: index)
            }
            save()
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self.exercises) {
            try? encoded.write(to: savePath)
            print("Successfully written")
        } else {
            print("Error in saving data")
        }
    }
    
    init(){
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Exercise].self, from: data) {
                self.exercises = decoded
                return
            } else {
                print("Error in loading data")
            }
        }
        self.exercises = []
    }
    
    init(exercises: [Exercise]) {
        self.exercises = exercises
    }
    
    static let example = WorkoutViewModel(exercises: [Exercise.example])
}


