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
    let onToggleFavorite: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(form.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    if form.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .scaleEffect(animate ? 1.2 : 1.0)
                            .animation(.spring(), value: animate)
                    }
                }
                Text(form.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: form.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [form.isFavorite ? .orange : .blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .onTapGesture {
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animate = false
                onTap()
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 2)
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

