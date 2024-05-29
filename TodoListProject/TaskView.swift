//
//  TaskView.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 11/03/2024.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var time = 0.0
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var timeStart = false
    @State var rotation = false
    
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var ViewModel: TaskData
    @State var showSheet = false
    
    let opacity = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 68)
                .shadow(radius: 3, x: 3, y: 3)
                .opacity(task.completed ? 0.4 : opacity)
                .foregroundStyle(Color("taskColor"))

            HStack {
                
                Text(task.uwName)
                    .font(.headline)
                    .foregroundStyle(colorScheme == .light ? .white : .black)
                    .padding()
                    .strikethrough(task.completed)
                Spacer()
                Image(systemName: task.completed ? "checkmark" : "circle")
                    .padding()
                    .foregroundStyle(colorScheme == .light ? .white : .black)

                
            }
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text("Delete Task?")
                        .font(.headline)
                    
                    HStack {
                        Button {
                            withAnimation {
                                ViewModel.removeTask(task: task)
                            }
                            dismiss()
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 60)
                                .foregroundStyle(.red)
                                .overlay {
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.white)
                                    
                                }
                                .padding()
                        }
                        .presentationDetents([.height(180)])
                        
                        if task.repeated {
                            Button {
                                withAnimation {
                                    ViewModel.removeAllRepeated(task: task)
                                    dismiss()
                                }
                                
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 60)
                                    .foregroundStyle(.red)
                                    .overlay {
                                        Text("Delete all future tasks").bold()
                                            .foregroundStyle(.white)
                                    }
                                    .padding()
                            }
                            .presentationDetents([.height(180)])
                        }
                    }
                }
            }
        }
        .scaleEffect(1 + (time/(15+time*7)))
        .rotationEffect(.degrees(rotation ? -1.2*time : 1.2*time))
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.65, blendDuration: 0.3)) {
                task.completed.toggle()
                ViewModel.save()
            }
        }
        .onLongPressGesture(minimumDuration: 0.4) {
            showSheet.toggle()
        } onPressingChanged: { Bool in
            withAnimation {
                time = 0
                timeStart.toggle()
            }
        }.onReceive(timer) { input in
            if timeStart {
                time += 0.01
                withAnimation(.interactiveSpring(response: 0.1, dampingFraction: 0.65, blendDuration: 0.3)) {
                    rotation.toggle()
                }
            }
        }

    }
}

