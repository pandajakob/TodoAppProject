//
//  MainTabView.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 11/03/2024.
//

import SwiftUI
import CoreData
struct MainTabView: View {
    @EnvironmentObject var viewModel: TaskData
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Picker("filter", selection: $viewModel.taskFilter) {
                Text("all").tag(TaskFilter.all)
                Text("completed").tag(TaskFilter.completed)
            }.pickerStyle(.segmented)
                .padding()
            .onChange(of: viewModel.taskFilter) {
                withAnimation {
                    viewModel.fetchTaskGroups()
                }
            }
            TabView {
                UpcommingTasks()
                    .tabItem { Image(systemName: "calendar")
                    }
                    .navigationTitle("Tasks")
                    .navigationBarTitleDisplayMode(.large)
                    .environmentObject(viewModel)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            .background(Color("taskViewBG"))
            .navigationBarTitleDisplayMode(.large)
            .ignoresSafeArea(edges: .bottom)
            .toolbarBackground(Color("taskViewBG"))
            .toolbarBackground(.visible, for: .tabBar, .bottomBar, .navigationBar)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ModifyTaskView()
                            .navigationTitle("New Task")
                            .environmentObject(viewModel)
                        
                    } label: {
                        Image(systemName: "plus")
                        
                    }        .toolbarBackground(.orange, for: .navigationBar, .tabBar)
                    
                    
                }
                ToolbarItem(placement: .topBarLeading) {
                    
                    NavigationLink {
                        Button("remove all") {
                            viewModel.removeAll()
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "gear")
                    }

                    NavigationLink {
                      
                        
                    } label: {
                        Image(systemName: "plus")
                        
                    }        .toolbarBackground(.orange, for: .navigationBar, .tabBar)
                    
                    
                }
                   
            }
            
            
        }
        
    }
}

#Preview {
    MainTabView()
}
