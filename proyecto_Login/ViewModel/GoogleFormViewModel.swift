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
    private let baseURL = "https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec"
    
    func fetchForms() {
        isLoading = true
        errorMessage = nil
        
        AF.request(baseURL, method: .get)
            .validate()
            .responseJSON { response in
                self.isLoading = false
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.forms = json["forms"].arrayValue.map { FormModel(json: $0) }
                case .failure(let error):
                    self.errorMessage = "Error fetching forms: \(error.localizedDescription)"
                }
            }
    }
    
    func createForm(title: String, description: String) {
        isLoading = true
        errorMessage = nil
        
        let parameters: [String: Any] = [
            "action": "create",
            "title": title,
            "description": description
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                self.isLoading = false
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let newForm = FormModel(json: json)
                    self.forms.append(newForm)
                    self.currentForm = newForm
                case .failure(let error):
                    self.errorMessage = "Error creating form: \(error.localizedDescription)"
                }
            }
    }
    
    func updateForm() {
        guard let form = currentForm else { return }
        
        isLoading = true
        errorMessage = nil
        
        let parameters: [String: Any] = [
            "action": "update",
            "id": form.id,
            "title": form.title,
            "description": form.description,
            "questions": form.questions.map { [
                "id": $0.id,
                "type": $0.type.rawValue,
                "text": $0.text,
                "options": $0.options ?? [],
                "isRequired": $0.isRequired
            ] }
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                self.isLoading = false
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let index = self.forms.firstIndex(where: { $0.id == form.id }) {
                        self.forms[index] = FormModel(json: json)
                    }
                case .failure(let error):
                    self.errorMessage = "Error updating form: \(error.localizedDescription)"
                }
            }
    }
    
    func deleteForm(id: String) {
        isLoading = true
        errorMessage = nil
        
        let parameters: [String: Any] = [
            "action": "delete",
            "id": id
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                self.isLoading = false
                switch response.result {
                case .success:
                    self.forms.removeAll { $0.id == id }
                    if self.currentForm?.id == id {
                        self.currentForm = nil
                    }
                case .failure(let error):
                    self.errorMessage = "Error deleting form: \(error.localizedDescription)"
                }
            }
    }
}

