//
//  QuizCell.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import UIKit

// MARK: - Delegate
protocol QuizCellDelegate: AnyObject {
    func optionSelected(questionIndex: Int, selectedOption: String)
    func startTimer(start : Bool)
}


class QuizCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet var optionButtons: [UIButton]!
    
    // MARK: - Variables
    var currentQue : QuizResults? {
        didSet{
            self.configureCell()
        }
    }
    
    var delegate: QuizCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any customizations or selected state here
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Configure Cell
    func configureCell(){
        if let obj = self.currentQue {
            
            self.lblTitle.text = obj.question?.decodeHtmlEntities() ?? ""
            
            if  obj.isTimeOut == false{
                
                self.delegate?.startTimer(start: true)
                
            }else{ }
            
            if obj.isAnswerSubmited == true {
                
                if obj.isAnswerCorrect == true { // right answer
                    
                    RightWrongAnswer(UserAnswer: obj.userAnswer ?? "",color: appColor.green)
                    
                }else{ // wrong answer
                    
                    RightWrongAnswer(UserAnswer: obj.userAnswer ?? "",color: appColor.red)
                }
            }else{
                self.enableAll()
            }
        }
    }
    
    func configureOptions(questionIndex: Int) {
        
        if let options = currentQue?.allOptions {
            for (index, title) in options.enumerated() {
                optionButtons[index].setTitle(title.decodeHtmlEntities(), for: .normal)
                optionButtons[index].tag = index
                optionButtons[index].addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    // MARK: - Methods
    @objc func optionButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedTitle = sender.titleLabel?.text ?? ""
        
        delegate?.optionSelected(questionIndex: index, selectedOption: selectedTitle )
        
        checkAnsweer(tag: index, title:selectedTitle)
    }
    
    /// Enable the all Options If It is not submited yet.
    func enableAll(){
        self.optionButtons.forEach { btn in
            btn.isUserInteractionEnabled = true
            btn.backgroundColor = .systemPink
        }
    }
    
    /// Check the Aswer and highlight the button immediateely
    func checkAnsweer(tag : Int , title : String){
        if title == currentQue?.CorrectAnswer  {
            
            SoundManager.shared.playSound(named: .positiveSound)
            self.highlightButton(tag: tag, color: appColor.green)
        }else{
            
            SoundManager.shared.playSound(named: .NegativeSound)
            self.highlightButton(tag: tag, color: appColor.red)
        }
    }
    
    /// Check Right or  Wrong answer and handle the colors
    func RightWrongAnswer(UserAnswer : String, color : UIColor){
        
        self.optionButtons.forEach { btn in
            
            let title = btn.titleLabel?.text ?? ""
            
            if title == UserAnswer  {
                btn.backgroundColor = color
            }else{
                btn.backgroundColor = appColor.grey
            }
        }
    }
    
    func highlightButton(tag : Int, color : UIColor){
        
        self.optionButtons.forEach { btn in
            
            if btn.tag == tag{
                btn.backgroundColor = color
            }else{
                btn.backgroundColor = appColor.grey
            }
            btn.isUserInteractionEnabled = false
        }
    }
}
