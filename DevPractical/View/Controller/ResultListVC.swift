//
//  ResultListVC.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import UIKit

class ResultListVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet var tblList : UITableView!
    
    //MARK: - Variable
    var aryQuestions: [QuizResults] = []
    var score = ""
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialView()
    }
    
    //MARK: - Initial Setup
    func setInitialView(){
        self.tblList.register(UINib(nibName: "QueListCell", bundle: nil), forCellReuseIdentifier: "QueListCell")
        self.tblList.reloadData()
        self.title = "Score: \(score)/\(aryQuestions.count)"
    }
    
    //MARK: - Button Action

}

//MARK: - TableView Methods
extension ResultListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: QueListCell.self,for: indexPath) as? QueListCell else { return UITableViewCell() }
        
        cell.configureCell(obj: aryQuestions[indexPath.row], indx: indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
