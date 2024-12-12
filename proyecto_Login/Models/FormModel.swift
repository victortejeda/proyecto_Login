//
//  FormModels.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

import Foundation
import SwiftyJSON

struct FormModel: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var questions: [QuestionModel]
    var createdAt: Date
    var updatedAt: Date
    
    init(json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        questions = json["questions"].arrayValue.map { QuestionModel(json: $0) }
        createdAt = Date(timeIntervalSince1970: json["createdAt"].doubleValue)
        updatedAt = Date(timeIntervalSince1970: json["updatedAt"].doubleValue)
    }
}

struct QuestionModel: Identifiable, Codable {
    let id: String
    var type: QuestionType
    var text: String
    var options: [String]?
    var isRequired: Bool
    
    init(json: JSON) {
        id = json["id"].stringValue
        type = QuestionType(rawValue: json["type"].stringValue) ?? .shortAnswer
        text = json["text"].stringValue
        options = json["options"].arrayObject as? [String]
        isRequired = json["isRequired"].boolValue
    }
}

enum QuestionType: String, Codable {
    case shortAnswer
    case paragraph
    case multipleChoice
    case checkboxes
}


