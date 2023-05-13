//
//  EditWorkingSetView.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 17/05/2022.
//

import SwiftUI

struct EditWorkingSetView: View {
    
    //    @ObservedObject var weight = NumbersOnly()
    //    @ObservedObject var totalReps = NumbersOnly()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var workout: WorkoutViewModel
    @State private var weight: String = ""
    @State private var totalReps: String = ""
    @State private var repeatTime: Int = 1
    
    var workingSet: WorkingSet
    var onSave: ([WorkingSet]) -> Void
    
    var weightInDouble: Double {
        Double(weight) ?? 0.0
    }
    
    var totalRepsInInt: Int {
        Int(totalReps) ?? 0
    }
    
    var DetailsFilled: Bool {
        !(weight.isEmpty || totalReps.isEmpty)
    }
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Weight :")
                        .font(.body)
                        .bold()
                    TextField("\(workingSet.wrappedWeight)", text: $weight)
                }
                
                HStack {
                    Text("Reps :")
                        .font(.body)
                        .bold()
                    TextField("\(workingSet.totalReps)", text: $totalReps)
                        .keyboardType(.numberPad)
                }
                
                VStack(alignment: .leading) {
                    Text("Repeat")
                    Picker("Repeat set", selection: $repeatTime) {
                        ForEach(1..<11, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 20)
                
                if DetailsFilled {
                    Button("Done") {
                        onSave(generateSameSets(for: repeatTime))
                        dismiss()
                    }
                    .frame(width: 100, height: 30)
                    .foregroundColor(.white)
                    .background(.red)
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
        .keyboardType(.decimalPad)
        .navigationTitle("Edit working set")
    }
    
    func generateSameSets(for times: Int) -> [WorkingSet] {
        
        var workingSets: [WorkingSet] = []
        
        for _ in 0..<times {
            let newSet = WorkingSet(totalReps: totalRepsInInt, weight: weightInDouble)
            workingSets.append(newSet)
        }
        
        return workingSets
    }
}

struct EditWorkingSetView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkingSetView(workingSet: WorkingSet()) { _ in }
            .environmentObject(WorkoutViewModel())
    }
}

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
