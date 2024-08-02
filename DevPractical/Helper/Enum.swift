//
//  Enum.swift
//  DevPracticle
//
//  Created by Jalpesh Patel on 05/01/24.
//

import Foundation
import UIKit

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

enum SoundName: String {
    case positiveSound = "positive_sound"
    case NegativeSound = "negative_Sound"
}

enum Defficulty : String, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}

enum FetchResult<T: Codable> {
    case success(T)
    case failure(Error)
}

enum AppStoryboard: String {
   case main = "Main"
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

enum ProductEndPoint {
    case getQuiz(difficulty: String)
}

extension ProductEndPoint: EndPointType {

    var path: String {
        switch self {
        case .getQuiz(let  defficulty):
            return "?amount=10&category=9&\(defficulty)=medium&type=multiple"
        }
    }

    var baseURL: String {
        switch self {
        case .getQuiz:
            return "https://opentdb.com/api.php"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .getQuiz:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .getQuiz:
            return nil
        }
    }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
