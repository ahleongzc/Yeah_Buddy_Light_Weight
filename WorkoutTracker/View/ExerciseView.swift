//
//  ExerciseView.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 15/05/2022.
//

import SwiftUI
import AVFAudio

struct ExerciseView: View {
    
    var exercise: Exercise
    
    @EnvironmentObject var workout: WorkoutViewModel
    @State private var timerRunning = false
    @State private var endOfTimer = false
    @State private var totalTime = 1
    @State private var timerSecondCount = 1
    @State private var currentSet: WorkingSet? = nil
    @State private var percent: CGFloat = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            List {
                ForEach(exercise.workingSets) { workingSet in
                    let index = exercise.workingSets.firstIndex(of: workingSet)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Set \((index ?? 0) + 1)")
                                .bold()
                                .font(.title3)
                            Text("Reps : \(workingSet.totalReps)")
                        }
                        Spacer()
                        HStack {
                            Text("\(workingSet.wrappedWeight) kg")
                            Image(systemName: workingSet.isFinished ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(workingSet.isFinished ? .green : .red)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            currentSet = workingSet
                        } label: {
                            Label("Edit", systemImage: "pencil.and.outline")
                        }
                        .tint(Color.blue)
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            withAnimation {
                                workout.removeSetIn(exercise, set: workingSet)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                        Button {
                            withAnimation {
                                workout.toggleSetIn(exercise, set: workingSet)
                            }
                        } label: {
                            Label("Toggle", systemImage: "pencil.circle.fill")
                        }
                        .tint(workingSet.isFinished ? Color.orange : Color.green)
                    }
                }
            }
            
            if exercise.allSetsFinished {
                Text("No sets remaining")
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 20)
            } else {
                if timerRunning {
                    TimerView(timerSecondCount: $timerSecondCount, totalTime: $totalTime)
                        .onReceive(timer) { _ in startTimer() }
                        .padding(.vertical, 20)
                    
                    HStack {
                        Spacer()
                        Button("Pause") { pauseTimer() }
                        Spacer()
                        Button("Skip") { resetTimer() }
                        Spacer()
                    }
                    .padding(.vertical, 30)
                } else {
                    HStack {
                        Picker("Second", selection: $timerSecondCount) {
                            ForEach(1..<300, id: \.self) { Text("\($0)") }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 10)
                    }
                    
                    Button("Start timer") {
                        totalTime = timerSecondCount
                        timerRunning = true
                    }
                    .padding(.vertical, 30)
                }
            }
        }
        .navigationTitle("\(exercise.name)")
        .toolbar {
            Button("Add") {
                workout.addOneSetTo(exercise)
            }
        }
        .sheet(item: $currentSet) { workingSet in
            NavigationView {
                EditWorkingSetView(workingSet: workingSet) { newWorkingSets in
                    workout.replaceWorkingSetIn(exercise, oldSet: workingSet, newSet: newWorkingSets)
                }
            }
        }
        
    }
    
    func startTimer() {
        guard timerSecondCount > 0 && timerRunning else { timerRunning = false; return }
        timerSecondCount -= 1
        
        if timerSecondCount == 0 {
            resetTimer()
            workout.finishFirstRemainingSet(exercise)
            playSound()
        }
    }
    
    func resetTimer() {
        timerRunning = false
        timerSecondCount = totalTime
    }
    
    func pauseTimer() {
        timerRunning = false
    }
    
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExerciseView(exercise: Exercise.example)
        }
        .environmentObject(WorkoutViewModel())
    }
}
