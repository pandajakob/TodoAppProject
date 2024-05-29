//
//  ContentView.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 10/03/2024.
//

import SwiftUI
import CoreData

struct UpcommingTasks: View {
        
    @EnvironmentObject var viewModel: TaskData

    var body: some View {
        
        NavigationStack {
          
            if viewModel.savedData.isEmpty {
                Text(viewModel.taskFilter == .all ? "You're all cleared! ✅" : "No completed tasks 🗓️" )
                    .font(.headline)
            } else {
            ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.savedData) { group in
                                Text(group.fmDueDate)
                                    .font(.headline)
                                    .padding()
                                    .padding(.top, 22)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.taskFilter == .all ? group.uwTasks : group.compTasks, id: \.self) { task in
                                     
                                    TaskView(task: task)
                                        
                                }.scrollTransition(axis: .vertical) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.75)
                                        .scaleEffect(x: phase.isIdentity ? 1 : 0.98, y: phase.isIdentity ? 1 : 0.98)
                                }
                            }.padding(.horizontal)
                        }
                        

                        
                    }

            }
            }


        }



    }
}



#Preview {
    UpcommingTasks()
}
