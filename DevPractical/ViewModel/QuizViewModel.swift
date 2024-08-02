//
//  QuizViewModel.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 04/01/24.
//

import Foundation

final class QuizViewModel {
    
    //MARK: -  Variable
    var questions: [QuizResults] = []
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    /// API call of Questions
    func fetchQuiz() {
        
        self.eventHandler?(.loading)
        
        APIManager.shared.request(
            modelType: QuizResponseModel.self,
            type: ProductEndPoint.getQuiz(difficulty: Constant.selectedDefficulty)) { response in
        
                self.eventHandler?(.stopLoading)
                
                switch response {
                
                case .success(let aryQuiz):
                    self.questions = aryQuiz.results ?? []
                    self.eventHandler?(.dataLoaded)
                
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    
    //MARK: -  Quiz Methods
    func totalQue()-> Int{
        return questions.count 
    }
    
    func getTotalScore() -> Int{
        return self.questions.filter { $0.isAnswerCorrect == true }.count
    }
    
    func isAllAttempted() -> Bool{
        return self.questions.filter { $0.isAnswerSubmited == true }.count == questions.count
    }
    /// Auto complete ans if time is pased
    func autoSubmit(index : Int){
        self.eventHandler?(.stopTimer)
        let dict = self.questions[index]
        if dict.userAnswer == nil && dict.isAnswerSubmited == false{
            self.questions = self.questions.enumerated().map { (currentIndex, quizResult) in
                var result = quizResult
                    if currentIndex == index {
                        result.isTimeOut = true
                        result.isAnswerSubmited = true
                        result.isAnswerCorrect = false
                    }
                    return result
                }
        }
        self.eventHandler?(.dataLoaded)
        self.eventHandler?(.showToast("Time Out"))
    }
    
    /// Managing the response array as per the answer
    func checkAnswerAndUpdateScore(answer : String) {
       
        let indx = self.questions.firstIndex(where: {$0.allOptions.contains(answer)})
        
        self.questions = self.questions.enumerated().map { (index, quizResult) in
            var obj = quizResult
            if index == indx {
                obj.userAnswer = answer
                obj.isAnswerSubmited = true
                obj.isAnswerCorrect = obj.CorrectAnswer == answer
                self.eventHandler?(.showToast("\(obj.CorrectAnswer == answer ? "Well done! Excellent 🤩" : "Better Luck Next Time 👍🏻")"))
            }
            return obj
        }
        self.eventHandler?(.stopTimer)
    }
}

extension QuizViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case updateData
        case stopTimer
        case showToast(String?)
        case error(Error?)
    }
}
