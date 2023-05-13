//
//  TimerView.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 16/05/2022.
//

import SwiftUI

struct TimerView: View {
    
    @Binding var timerSecondCount: Int
    @Binding var totalTime: Int
    
    var progress: Double {
        Double(timerSecondCount)/Double(totalTime)
    }
    
    var timerColor: Color {
        if progress > 0.50 {
            return .green
        } else if progress > 0.25 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.2)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .foregroundColor(
                    timerColor
                )
                .rotationEffect(Angle(degrees: 270))
                .animation(Animation.easeOut, value: progress)
            
            Text("\(timerSecondCount) sec remaining")
                .font(.title2)
                .bold()
        }
        .padding()
    }
    
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerSecondCount: .constant(1), totalTime: .constant(5))
    }
}
