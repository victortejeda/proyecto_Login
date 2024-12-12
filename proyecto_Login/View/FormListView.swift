//
//  FormListView.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

import SwiftUI

struct FormListView: View {
    @ObservedObject var viewModel: GoogleFormViewModel
    @State private var showingCreateForm = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.forms) { form in
                    FormListItem(form: form, onTap: {
                        viewModel.currentForm = form
                    }, onDelete: {
                        viewModel.deleteForm(id: form.id)
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("My Forms")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateForm) {
                CreateFormView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchForms()
        }
    }
}

struct CreateFormView: View {
    @ObservedObject var viewModel: GoogleFormViewModel
    @State private var title = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Form Details")) {
                    CustomTextField(placeholder: "Title", text: $title)
                    CustomTextField(placeholder: "Description", text: $description)
                }
                
                Section {
                    CustomButton(title: "Create Form", action: createForm, isLoading: viewModel.isLoading, color: .blue)
                }
            }
            .navigationTitle("Create New Form")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func createForm() {
        viewModel.createForm(title: title, description: description)
        presentationMode.wrappedValue.dismiss()
    }
}


