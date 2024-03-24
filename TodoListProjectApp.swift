//
//  TodoListProjectApp.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 10/03/2024.
//

import SwiftUI

@main
struct TodoListProjectApp: App {
    @StateObject private var vm = TaskData()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, vm.container.viewContext)
                .environmentObject(vm)
        }
    }
}
