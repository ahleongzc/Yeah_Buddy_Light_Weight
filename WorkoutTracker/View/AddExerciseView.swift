//
//  AddExerciseView.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 16/05/2022.
//

import SwiftUI

struct AddExerciseView: View {
    
    @State private var name: String = ""
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Exercise) -> Void
    
    var body: some View {
        VStack {
            TextField("Enter exercise name", text: $name)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button("Add exercise to workout") {
                let exercise = Exercise(name: name)
                onSave(exercise)
                dismiss()
            }
            .padding()
            .disabled(name.isEmpty)
        }
        .navigationTitle("Add Exercise")
    }
    
    init(onSave: @escaping (Exercise) -> Void) {
        self.onSave = onSave
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddExerciseView() { _ in }
        }
    }
}
