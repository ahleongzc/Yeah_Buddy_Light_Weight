//
//  ProgressBarView.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 19/05/2022.
//

import SwiftUI

struct ProgressBarView: View {
    
    @EnvironmentObject var workout: WorkoutViewModel
    var exercise: Exercise
    
    var body: some View {
        HStack {
            ForEach(exercise.workingSets) { workingSet in
                Image(systemName: "circle.fill")
                    .foregroundColor(
                        workingSet.isFinished ? .green : .red
                    )
            }
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(exercise: Exercise.example)
    }
}
