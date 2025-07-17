//
//  CustomTextField.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let color: Color
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text(title)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isLoading ? Color.gray : color)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .disabled(isLoading)
    }
}

struct FormListItem: View {
    let form: FormModel
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(form.title)
                    .font(.headline)
                Text(form.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture(perform: onTap)
    }
}

struct QuestionView: View {
    @Binding var question: QuestionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Question", text: $question.text)
                .font(.headline)
            
            Picker("Type", selection: $question.type) {
                Text("Short Answer").tag(QuestionType.shortAnswer)
                Text("Paragraph").tag(QuestionType.paragraph)
                Text("Multiple Choice").tag(QuestionType.multipleChoice)
                Text("Checkboxes").tag(QuestionType.checkboxes)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if question.type == .multipleChoice || question.type == .checkboxes {
                ForEach(question.options.indices, id: \.self) { index in
                    TextField("Option", text: $question.options[index])
                }
                Button("Add Option") {
                    question.options.append("")
                }
            }
            
            Toggle("Required", isOn: $question.isRequired)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

