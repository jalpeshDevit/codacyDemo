//
//  QuizResponseModel.swift
//  DevPracticle
//
//  Created by Jalpesh Patel on 04/01/24.
//

import Foundation

struct QuizResponseModel : Codable {
    let response_code : Int?
    let results : [QuizResults]?

    enum CodingKeys: String, CodingKey {

        case response_code = "response_code"
        case results = "results"
    }
}

struct QuizResults : Codable {
    let type : String?
    let difficulty : String?
    let category : String?
    let question : String?
    let correct_answer: String?

    var CorrectAnswer: String? {
        return correct_answer?.decodeHtmlEntities()
    }
    var decodedQuetion: String? {
        return question?.decodeHtmlEntities()
    }
    
    let incorrect_answers : [String]?
    var userAnswer : String?
    var isAnswerCorrect : Bool = false
    var isAnswerSubmited : Bool = false
    var isTimeOut : Bool = false
    
    enum CodingKeys: String, CodingKey {

        case type = "type"
        case difficulty = "difficulty"
        case category = "category"
        case question = "question"
        case correct_answer = "correct_answer"
        case incorrect_answers = "incorrect_answers"
    }
    
    var allOptions: [String] {
        
        let decodedIncorrectAnswers = incorrect_answers?.map { $0.decodeHtmlEntities() ?? "" } ?? []

        var allOps = (decodedIncorrectAnswers) + [CorrectAnswer ?? ""]
        allOps.shuffle()
        return allOps
    }
}
