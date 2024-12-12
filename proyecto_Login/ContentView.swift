//
//  ContentView.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 7/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GoogleFormViewModel()
    
    var body: some View {
        TabView {
            FormListView(viewModel: viewModel)
                .tabItem {
                    Label("Forms", systemImage: "list.bullet")
                }
            
            if let currentForm = viewModel.currentForm {
                FormDetailView(viewModel: viewModel)
                    .tabItem {
                        Label("Edit Form", systemImage: "square.and.pencil")
                    }
            }
        }
        .alert(item: Binding<AlertItem?>(
            get: { viewModel.errorMessage.map { AlertItem(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { alertItem in
            Alert(title: Text("Error"), message: Text(alertItem.message))
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}

