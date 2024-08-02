//
//  ResultVC.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import UIKit

protocol ReviewDelegate : AnyObject {
    func gotoFirst(ary : [QuizResults])
}

class ResultVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet var lblResult : UILabel!
    //MARK: - Variable
    weak var delegate : ReviewDelegate?
     var strScore : String = ""
     var strQuetions : String = ""
    var aryQuestions: [QuizResults] = []
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialView()
    }
    
    //MARK: - Initial Setup
    func setInitialView(){
        self.lblResult.text = strScore
    }
    
    //MARK: - Button Action
    @IBAction func btnTapBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnTapReview(_ sender: UIButton) {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is QuizVC }) as? QuizVC {
            self.delegate?.gotoFirst(ary: self.aryQuestions)
            self.navigationController?.popToViewController(vc, animated: true)
        } else {
            
            let newViewController = QuizVC()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func btnTapResultList(_ sender: UIButton) {
        let vc : ResultListVC = ResultListVC.instantiate(appStoryboard: .main)
        vc.aryQuestions = self.aryQuestions
        vc.score = strScore
        self.navigationController?.pushViewController(vc,animated:true)
    }

}
