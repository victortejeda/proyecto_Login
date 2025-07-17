//
//  GoogleFormViewModel.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

import SwiftUI
import Combine
import Alamofire
import SwiftyJSON

class GoogleFormViewModel: ObservableObject {
    @Published var forms: [FormModel] = []
    @Published var currentForm: FormModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    // private let baseURL = "https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec" // Desactivado para persistencia local
    private let userDefaultsKey = "savedForms"
    
    // MARK: - Inicialización
    init() {
        loadForms()
    }
    
    // MARK: - Persistencia local
    /// Guarda la lista de formularios en UserDefaults
    private func saveForms() {
        if let data = try? JSONEncoder().encode(forms) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    /// Carga la lista de formularios desde UserDefaults
    private func loadForms() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedForms = try? JSONDecoder().decode([FormModel].self, from: data) {
            self.forms = savedForms
        }
    }
    
    // MARK: - Operaciones CRUD locales
    /// Obtiene los formularios guardados localmente
    func fetchForms() {
        loadForms()
    }
    /// Crea un nuevo formulario y lo guarda localmente
    func createForm(title: String, description: String) {
        isLoading = true
        errorMessage = nil
        let newForm = FormModel(
            id: UUID().uuidString,
            title: title,
            description: description,
            questions: [],
            createdAt: Date(),
            updatedAt: Date()
        )
        forms.append(newForm)
        currentForm = newForm
        saveForms()
        isLoading = false
    }
    /// Actualiza el formulario actual y lo guarda localmente
    func updateForm() {
        guard let form = currentForm else { return }
        isLoading = true
        errorMessage = nil
        if let index = forms.firstIndex(where: { $0.id == form.id }) {
            var updatedForm = form
            updatedForm.updatedAt = Date()
            forms[index] = updatedForm
            saveForms()
        }
        isLoading = false
    }
    /// Elimina un formulario por id y actualiza la persistencia local
    func deleteForm(id: String) {
        isLoading = true
        errorMessage = nil
        forms.removeAll { $0.id == id }
        if currentForm?.id == id {
            currentForm = nil
        }
        saveForms()
        isLoading = false
    }
    
    /// Marca o desmarca un formulario como favorito
    func toggleFavorite(for form: FormModel) {
        if let index = forms.firstIndex(where: { $0.id == form.id }) {
            forms[index].isFavorite.toggle()
            saveForms()
        }
    }
    /// Establece o elimina la contraseña de un formulario
    func setPassword(for form: FormModel, password: String?) {
        if let index = forms.firstIndex(where: { $0.id == form.id }) {
            forms[index].password = password
            saveForms()
        }
    }
    /// Verifica si la contraseña ingresada es correcta
    func checkPassword(for form: FormModel, input: String) -> Bool {
        return form.password == input
    }
}

