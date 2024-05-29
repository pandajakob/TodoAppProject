//
//  ModifyTaskView.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 11/03/2024.
//

import SwiftUI

struct ModifyTaskView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focused: Bool
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var ViewModel: TaskData
    
    @State var taskName: String = ""
    @State private var taskDates: Set<DateComponents> = []
    @State var repeatOption: RepeatOptions = .never
    
    var formIsValid: Bool {
        !taskName.isEmpty && !taskDates.isEmpty
    }
    var repeatIsValid: Bool {
        taskDates.count <= 1
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Form {
                    Section("Task") {
                        TextField("Take supplement💊...", text: $taskName)
                            .font(.headline)
                            .focused($focused)
                    }
                    
                    Section("Date") {
                        MultiDatePicker("Due to", selection: $taskDates)
                    }
                    
                    
                    Section("Repeat task") {
                        Picker("Repeat", selection: $repeatOption) {
                            if taskDates.count > 1 {
                                Text("never").tag(RepeatOptions.never)
                            } else {
                                ForEach(RepeatOptions.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                        }.font(.headline)
                        .disabled(!repeatIsValid)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            if !repeatIsValid {
                                ViewModel.addTask(name: taskName, repeated: false, dates: taskDates)
                            } else {
                                ViewModel.repeatTask(repeatOption: repeatOption, name: taskName, rootDate: taskDates.first ?? .init(day: 0))
                            }
                            dismiss()
                        } label: {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .frame(width: 110, height: 55)
                                .shadow(radius: 3, x: 3, y: 3)
                                .overlay {
                                    Image(systemName: "plus").foregroundStyle(.white)
                                }
                                .padding()
                        }
                    }
                }
                
            }
            
        }.onAppear(perform: {
            focused = true
        })
    }
}

#Preview {
    ModifyTaskView()
}
