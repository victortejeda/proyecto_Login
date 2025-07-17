//
//  CustomTextField.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

import SwiftUI

// Paleta de colores profesional y llamativa (ajustada para mejor contraste)
extension Color {
    static let primaryBlue = Color(red: 24/255, green: 45/255, blue: 90/255) // Azul oscuro profesional
    static let accentOrange = Color(red: 255/255, green: 140/255, blue: 0/255) // Naranja vibrante
    static let darkGrayBG = Color(red: 30/255, green: 41/255, blue: 59/255) // Gris oscuro elegante
    static let lightText = Color.white // Texto claro para títulos
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.darkGrayBG.opacity(0.8))
            .foregroundColor(.lightText)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primaryBlue, lineWidth: 2)
            )
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
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .background(isLoading ? Color.gray : color)
        .foregroundColor(.lightText)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
        .disabled(isLoading)
    }
}

struct FormListItem: View {
    let form: FormModel
    let onTap: () -> Void
    let onDelete: () -> Void
    let onToggleFavorite: () -> Void
    
    @State private var animate = false
    
    var titleColor: Color {
        // Si es favorito (naranja) o azul, usar texto blanco
        .lightText
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(form.title)
                        .font(.headline)
                        .foregroundColor(titleColor)
                    if form.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.accentOrange)
                            .scaleEffect(animate ? 1.5 : 1.0)
                            .shadow(color: .accentOrange, radius: animate ? 10 : 0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.5), value: animate)
                    }
                }
                Text(form.description)
                    .font(.subheadline)
                    .foregroundColor(.lightText.opacity(0.85))
            }
            Spacer()
            Button(action: {
                animate = true
                onToggleFavorite()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    animate = false
                }
            }) {
                Image(systemName: form.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.accentOrange)
            }
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [form.isFavorite ? .accentOrange : .primaryBlue, .darkGrayBG]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(color: .primaryBlue.opacity(0.18), radius: 8, x: 0, y: 4)
        )
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

