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
                
                CustomButton(title: "Add Question", action: { showingAddQuestion = true }, isLoading: false, color: .green)
                
                CustomButton(title: "Save Changes", action: viewModel.updateForm, isLoading: viewModel.isLoading, color: .blue)
            }
            .padding()
        }
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
                Section(header: Text("Question Details")) {
                    TextField("Question Text", text: $questionText)
                    Picker("Question Type", selection: $questionType) {
                        Text("Short Answer").tag(QuestionType.shortAnswer)
                        Text("Paragraph").tag(QuestionType.paragraph)
                        Text("Multiple Choice").tag(QuestionType.multipleChoice)
                        Text("Checkboxes").tag(QuestionType.checkboxes)
                    }
                    Toggle("Required", isOn: $isRequired)
                }
                
                if questionType == .multipleChoice || questionType == .checkboxes {
                    Section(header: Text("Options")) {
                        ForEach(options.indices, id: \.self) { index in
                            TextField("Option \(index + 1)", text: $options[index])
                        }
                        Button("Add Option") {
                            options.append("")
                        }
                    }
                }
                
                Section {
                    Button("Save Question") {
                        let newQuestion = QuestionModel(
                            id: UUID().uuidString,
                            type: questionType,
                            text: questionText,
                            options: options.isEmpty ? nil : options,
                            isRequired: isRequired
                        )
                        onSave(newQuestion)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Add Question")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


