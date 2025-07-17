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
    @State private var showFavoritesOnly = false
    @State private var showPasswordPrompt = false
    @State private var passwordInput = ""
    @State private var formToOpen: FormModel?
    
    var filteredForms: [FormModel] {
        showFavoritesOnly ? viewModel.forms.filter { $0.isFavorite } : viewModel.forms
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    HStack {
                        Toggle(isOn: $showFavoritesOnly) {
                            Label("Solo favoritos", systemImage: "star.fill")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .padding(.horizontal)
                        Spacer()
                    }
                    List {
                        ForEach(filteredForms) { form in
                            FormListItem(
                                form: form,
                                onTap: {
                                    if let password = form.password, !password.isEmpty {
                                        formToOpen = form
                                        showPasswordPrompt = true
                                    } else {
                                        viewModel.currentForm = form
                                    }
                                },
                                onDelete: {
                                    viewModel.deleteForm(id: form.id)
                                },
                                onToggleFavorite: {
                                    viewModel.toggleFavorite(for: form)
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .navigationTitle("Mis Formularios")
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
                .alert("Contraseña requerida", isPresented: $showPasswordPrompt, actions: {
                    SecureField("Contraseña", text: $passwordInput)
                    Button("Abrir") {
                        if let form = formToOpen, viewModel.checkPassword(for: form, input: passwordInput) {
                            viewModel.currentForm = form
                        }
                        passwordInput = ""
                        formToOpen = nil
                    }
                    Button("Cancelar", role: .cancel) {
                        passwordInput = ""
                        formToOpen = nil
                    }
                }, message: {
                    Text("Este formulario está protegido. Ingresa la contraseña para abrirlo.")
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(width: geometry.size.width, height: geometry.size.height)
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


