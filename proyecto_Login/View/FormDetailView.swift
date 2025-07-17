//
//  FormDetailView.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

import SwiftUI

struct FormDetailView: View {
    @ObservedObject var viewModel: GoogleFormViewModel
    @State private var showingAddQuestion = false
    @State private var showPasswordField = false
    @State private var passwordInput = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Title", text: Binding(
                    get: { viewModel.currentForm?.title ?? "" },
                    set: { viewModel.currentForm?.title = $0 }
                ))
                CustomTextField(placeholder: "Description", text: Binding(
                    get: { viewModel.currentForm?.description ?? "" },
                    set: { viewModel.currentForm?.description = $0 }
                ))
                HStack {
                    Button(action: {
                        showPasswordField.toggle()
                        passwordInput = viewModel.currentForm?.password ?? ""
                    }) {
                        Label(viewModel.currentForm?.password == nil || viewModel.currentForm?.password == "" ? "Proteger con contraseña" : "Quitar contraseña", systemImage: "lock")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.accentOrange.opacity(0.9))
                    .foregroundColor(.darkGrayBG)
                    .cornerRadius(8)
                    .animation(.easeInOut, value: showPasswordField)
                }
                if showPasswordField {
                    VStack {
                        SecureField("Contraseña", text: $passwordInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack {
                            Button("Guardar") {
                                if let form = viewModel.currentForm {
                                    viewModel.setPassword(for: form, password: passwordInput.isEmpty ? nil : passwordInput)
                                }
                                showPasswordField = false
                            }
                            .foregroundColor(.primaryBlue)
                            Button("Cancelar") {
                                showPasswordField = false
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .transition(.opacity.combined(with: .slide))
                }
                ForEach(viewModel.currentForm?.questions ?? []) { question in
                    QuestionView(question: Binding(
                        get: { question },
                        set: { newValue in
                            if let index = viewModel.currentForm?.questions.firstIndex(where: { $0.id == question.id }) {
                                viewModel.currentForm?.questions[index] = newValue
                            }
                        }
                    ))
                }
                CustomButton(title: "Add Question", action: { showingAddQuestion = true }, isLoading: false, color: .accentOrange)
                CustomButton(title: "Save Changes", action: viewModel.updateForm, isLoading: viewModel.isLoading, color: .primaryBlue)
            }
            .padding()
            .background(Color.darkGrayBG)
            .cornerRadius(18)
            .padding(.horizontal, 8)
        }
        .background(Color.darkGrayBG.ignoresSafeArea())
        .navigationTitle("Edit Form")
        .sheet(isPresented: $showingAddQuestion) {
            AddQuestionView(onSave: { newQuestion in
                viewModel.currentForm?.questions.append(newQuestion)
            })
        }
    }
}

struct AddQuestionView: View {
    @State private var questionText = ""
    @State private var questionType = QuestionType.shortAnswer
    @State private var isRequired = false
    @State private var options: [String] = []
    @Environment(\.presentationMode) var presentationMode
    var onSave: (QuestionModel) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question Details").foregroundColor(.primaryBlue)) {
                    TextField("Question Text", text: $questionText)
                        .foregroundColor(.darkGrayBG)
                    Picker("Question Type", selection: $questionType) {
                        Text("Short Answer").tag(QuestionType.shortAnswer)
                        Text("Paragraph").tag(QuestionType.paragraph)
                        Text("Multiple Choice").tag(QuestionType.multipleChoice)
                        Text("Checkboxes").tag(QuestionType.checkboxes)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Toggle("Required", isOn: $isRequired)
                        .toggleStyle(SwitchToggleStyle(tint: .accentOrange))
                }
                if questionType == .multipleChoice || questionType == .checkboxes {
                    Section(header: Text("Options").foregroundColor(.accentOrange)) {
                        ForEach(options.indices, id: \.self) { index in
                            TextField("Option \(index + 1)", text: $options[index])
                                .foregroundColor(.darkGrayBG)
                        }
                        Button("Add Option") {
                            options.append("")
                        }
                        .foregroundColor(.primaryBlue)
                    }
                }
                Section {
                    Button("Save Question") {
                        let newQuestion = QuestionModel(
                            id: UUID().uuidString,
                            type: questionType,
                            text: questionText,
                            options: options,
                            isRequired: isRequired
                        )
                        onSave(newQuestion)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.primaryBlue)
                }
            }
            .navigationTitle("Add Question")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}


