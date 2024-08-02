//
//  QueListCell.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import UIKit

class QueListCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet var lblQue : UILabel!
    @IBOutlet var lblYourAnswer : UILabel!
    @IBOutlet var lblCorrectAnswer : UILabel!
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Configure Cell
    func configureCell(obj : QuizResults, indx : Int){
        if let quetion = obj.question?.decodeHtmlEntities(){
            self.lblQue.text = "\(indx). \(quetion)"
        }
        
        self.lblYourAnswer.text = obj.userAnswer?.decodeHtmlEntities()
        self.lblCorrectAnswer.text = obj.CorrectAnswer ?? ""
        self.lblCorrectAnswer.textColor = appColor.green
        self.lblYourAnswer.textColor =  obj.isAnswerCorrect ? appColor.green : appColor.red
    }
    
}
