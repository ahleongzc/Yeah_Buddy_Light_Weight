//
//  ContentView.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 14/05/2022.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @StateObject var workout = WorkoutViewModel()
    @State private var deleteAll = false
    @State private var showAddExercise = false
    @State private var searchText = ""
    
    var filteredExercise: [Exercise] {
        if searchText.isEmpty {
            return workout.exercises
        } else {
            return workout.exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredExercise) { exercise in
                        NavigationLink {
                            ExerciseView(exercise: exercise)
                        } label: {
                            HStack {
                                Image("opm\(Int.random(in: 1..<4))")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Capsule())
                                    .scaledToFit()
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.purple)
                                    )
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(exercise.name)
                                        .bold()
                                    
                                    HStack {
                                        Text("\(exercise.workingSets.count) sets")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                    }
                                }
                                .padding(.horizontal, 5)
                            }
                        }.swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                withAnimation {
                                    workout.removeExercise(exercise)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.circle")
                            }
                        }
                    }.onMove(perform: workout.move)
                }
                .searchable(text: $searchText)
                .navigationTitle("Exercise List")
                
                Spacer()
                
                Button(role: .destructive) {
                    deleteAll = true
                } label: {
                    Text("Delete all")
                }
            }
            .toolbar() {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddExercise.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.purple)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddExercise) {
            NavigationView {
                AddExerciseView { exercise in
                    workout.addExercise(exercise)
                }
            }
        }
        .alert("Are you sure?", isPresented: $deleteAll) {
            
            Button(role: .cancel) { } label: { Text("Cancle") }
            
            Button(role: .destructive) {
                withAnimation {
                    workout.removeAllExercises()
                }
            } label: { Text("100%") }
            
        } message: {
            Text("This action will delete all exercises")
        }
        .environmentObject(workout)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView(workout: WorkoutViewModel.example)
        }
    }
}
