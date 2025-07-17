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
    @State private var showEditPasswordPrompt = false
    @State private var formToEdit: FormModel?
    
    var filteredForms: [FormModel] {
        showFavoritesOnly ? viewModel.forms.filter { $0.isFavorite } : viewModel.forms
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.darkGrayBG.ignoresSafeArea()
                NavigationView {
                    VStack {
                        HStack {
                            Toggle(isOn: $showFavoritesOnly) {
                                Label("Solo favoritos", systemImage: "star.fill")
                                    .foregroundColor(.accentOrange)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .accentOrange))
                            .padding(.horizontal)
                            Spacer()
                        }
                        if filteredForms.isEmpty {
                            Text(showFavoritesOnly ? "No tienes formularios marcados como favoritos." : "No tienes formularios todavía.")
                                .foregroundColor(.lightText)
                                .padding()
                        } else {
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
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                                                viewModel.toggleFavorite(for: form)
                                            }
                                        },
                                        onEdit: {
                                            if let password = form.password, !password.isEmpty {
                                                formToEdit = form
                                                showEditPasswordPrompt = true
                                            } else {
                                                viewModel.currentForm = form
                                            }
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                    }
                    .background(Color.darkGrayBG)
                    .navigationTitle("Mis Formularios")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showingCreateForm = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.primaryBlue)
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
                            } else {
                                viewModel.currentForm = nil
                            }
                            passwordInput = ""
                            formToOpen = nil
                        }
                        Button("Cancelar", role: .cancel) {
                            passwordInput = ""
                            formToOpen = nil
                            viewModel.currentForm = nil
                        }
                    }, message: {
                        Text("Este formulario está protegido. Ingresa la contraseña para abrirlo.")
                    })
                    .alert("Contraseña para editar", isPresented: $showEditPasswordPrompt, actions: {
                        SecureField("Contraseña", text: $passwordInput)
                        Button("Editar") {
                            if let form = formToEdit, viewModel.checkPassword(for: form, input: passwordInput) {
                                viewModel.currentForm = form
                            }
                            passwordInput = ""
                            formToEdit = nil
                        }
                        Button("Cancelar", role: .cancel) {
                            passwordInput = ""
                            formToEdit = nil
                        }
                    }, message: {
                        Text("Este formulario está protegido. Ingresa la contraseña para editarlo.")
                    })
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .frame(width: geometry.size.width, height: geometry.size.height)
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
                Section(header: Text("Detalles del formulario").foregroundColor(.primaryBlue)) {
                    CustomTextField(placeholder: "Título", text: $title)
                    CustomTextField(placeholder: "Descripción", text: $description)
                }
                Section {
                    CustomButton(title: "Crear formulario", action: createForm, isLoading: viewModel.isLoading, color: .accentOrange)
                }
            }
            .navigationTitle("Crear nuevo formulario")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func createForm() {
        viewModel.createForm(title: title, description: description)
        presentationMode.wrappedValue.dismiss()
    }
}


