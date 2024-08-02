//
//  QuizVC.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 04/01/24.
//

import UIKit

class QuizVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var colleQuiz: UICollectionView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var lblTotalQue: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnResult: UIButton!
    
    // MARK: - Variables
    private var viewModel = QuizViewModel()
    var currentQuetions : Int = 1
    fileprivate var timerTime : Int = 30
    private var timerManager: TimerManager?
    var defficulty : String?
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialView()
    }
    
    //MARK: - Initial Setup
    func setInitialView(){
        self.observeEvent()
        self.colleQuiz.delegate = self
        self.colleQuiz.dataSource = self
        self.colleQuiz.register(UINib(nibName:"QuizCell", bundle: nil), forCellWithReuseIdentifier:"QuizCell")
        
        self.viewModel.fetchQuiz()
    }
    
    //MARK: - Button Action
    @IBAction func btnTapResult(_ sender : UIButton){
        
        let vc : ResultVC = ResultVC.instantiate(appStoryboard: .main)
        vc.strScore = "\(self.viewModel.getTotalScore())"
        vc.strQuetions = "\(self.viewModel.questions.count)"
        vc.aryQuestions = self.viewModel.questions
        vc.delegate = self
        self.navigationController?.pushViewController(vc,animated:true)
        
    }
}

extension QuizVC  {
    
    /// Data binding event observe
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                JPLoader.shared.startLoading()
                print("Start loading....")
            case .stopLoading:
                JPLoader.shared.stopLoading()
                print("Stop loading...")
            case .dataLoaded: // Loaded data
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.colleQuiz.reloadData()
                    self.setData()
                }
            case .updateData: // Update the data
                DispatchQueue.main.async {
                    self.setData()
                }
            case .stopTimer:
                self.timerManager?.stop()
                self.showSubmitButton()
            case .showToast(let msg):
                self.showTost(msg: msg ?? "")
            case .error(let error):
                print(error?.localizedDescription ?? "")
            }
        }
    }
    /// Setup UI Data
    func setData(){
        self.progress.progress  = Float(self.currentQuetions) / Float(self.viewModel.questions.count)
        
        self.lblTotalQue.text = "\(Constant.selectedDefficulty.capitalized) Question: \(self.currentQuetions) / \(self.viewModel.totalQue())"
        
        self.lblScore.text = "Score: \(self.viewModel.getTotalScore())"
        
    }
    /// Start timer function for every new question
    func startTimer(){
        self.timerManager = TimerManager(timeInterval: TimeInterval(timerTime), tickHandler: { remainingTime in
        }, completion: {
           
            self.viewModel.autoSubmit(index: self.currentQuetions - 1)
            print("Timer completed!")
            
        }, updateUIHandler: { remainingTime in

            self.lblTimer.text = "\(remainingTime)"
        })
        timerManager?.start()
    }
    /// Hide show button when all que. are submited
    func showSubmitButton(){
        self.btnResult.isHidden = !self.viewModel.isAllAttempted()
    }
}

//MARK: - Collectionview Methods
extension QuizVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCell", for: indexPath) as! QuizCell
        
        cell.isSelected = false
        cell.delegate = self
        cell.currentQue = self.viewModel.questions[indexPath.row]
        cell.configureOptions(questionIndex: indexPath.row)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: collectionView.bounds.height)
        
      }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x / self.colleQuiz.frame.width)
        print(pageIndex)
        self.currentQuetions = Int(pageIndex) + 1
        self.progress.progress  = Float(self.currentQuetions) / Float(self.viewModel.questions.count)
        self.setData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? QuizCell {
            self.animateCell(cell: cell)
            cell.currentQue = self.viewModel.questions[indexPath.row]
        }
    }
    
    ///  Animation of the cell
    private func animateCell(cell: UICollectionViewCell) {
            cell.alpha = 0.5
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, animations: {
                cell.alpha = 1.0
                cell.transform = CGAffineTransform.identity
            })
    }
}

//MARK: - Delegate
/// Handle option selection, compare with correct answer, update score, etc.
///  - Timer
///  - Check Answer
extension QuizVC : QuizCellDelegate {
    
    func startTimer(start: Bool) {
        self.timerManager?.stop()
        if !self.viewModel.isAllAttempted() {
            self.startTimer()
        }
    }
    
    func optionSelected(questionIndex: Int, selectedOption: String) {
        let question = self.viewModel.questions[questionIndex]
        let isCorrect = (selectedOption == question.CorrectAnswer ?? "")
        
        print("Selected option \(selectedOption) for question \(questionIndex). Correct: \(isCorrect)")
        
        self.viewModel.checkAnswerAndUpdateScore(answer: selectedOption)
        
        self.lblScore.text = "Score: \(self.viewModel.getTotalScore())"
    }
}
///  Review All Questins and answers
extension QuizVC : ReviewDelegate{
    func gotoFirst(ary: [QuizResults]) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            self.colleQuiz.scrollToItem(at: indexPath, at: .left, animated: false)
            self.colleQuiz.reloadData()
            if self.viewModel.isAllAttempted() {
                self.timerManager?.stop()
            }
        }
    }
    
}
