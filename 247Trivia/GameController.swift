//
//  GameController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import GTProgressBar
import GoogleMobileAds
import AdSupport

typealias CompletionHandler = (_ success:Bool) -> Void

class GameController: UIViewController, UITableViewDelegate, UITableViewDataSource, BEMCheckBoxDelegate, GADRewardBasedVideoAdDelegate {
    
    var rewardBasedVideo: GADRewardBasedVideoAd?
    
    var question = String()
    var leftTime = Int()
    var waitingTime = Int()
    var points = Int()
    var currentPoints = Int()
    var lockedPoints = Int()
    var answers = [String]()
    var answersChecks = [Int]()
    var answersIsChecks = [Int]()
    
    var adMobCount = 0
    var correctAnswer = String()
    
    var secondsTimer = Timer()
    var waitingTimer = Timer()
    
    var requestStatus = RequestStatus.First
    
    let cellId = "cellId"
    
    let questionLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.055)
        label.text = "What is the Next Question?"
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let secondsLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04, weight: UIFontWeightHeavy)
        label.text = "10 SECONDS"
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let pointInfoLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04, weight: UIFontWeightHeavy)
        label.text = "ANSWER LOCKED IN FOR 0 PTS"
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let pointLockedInfoLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04, weight: UIFontWeightHeavy)
        label.text = "ANSWER LOCKED IN FOR 0 PTS"
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var answersTableView: UITableView = {
        
        var tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView;
    }()
    
    let progressBar: GTProgressBar = {
        
        let bar = GTProgressBar()
        
        bar.progress = 1
        bar.barBorderColor = .white
        bar.barFillColor = .yellow
        bar.barBackgroundColor = .clear
        bar.barBorderWidth = 2.5
        bar.barFillInset = 1
        bar.displayLabel = false
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        return bar
        
    }()
    
    let containerWaitView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to 24/7Trivia"
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.06)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let waitingLabel: UILabel = {
        let label = UILabel()
        label.text = "Please wait next question!"
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.045)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let correctAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "Correct Answer"
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.045)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let waitingNumLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.05)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "1000 PTS"
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.05)
        label.textAlignment = .right
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var questionLabelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupQuestionViews()
        setupAnswersTableView()
        settupContainerWaitView()
        setupScoreLabel()
        
        answersTableView.register(AnswersCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        adMobCount = 0
        self.tabBarController?.navigationItem.title = "Enjoy!"
        
        requestStatus = .First
        requestToServerWithPoints(points: 0)
        requestAdmob()
    }
    
//    let request = GADRequest()
    
    private func requestAdmob() {
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self

        let uuid: UUID = ASIdentifierManager.shared().advertisingIdentifier
        print("\(uuid.uuidString.md5)")
        
        let deviceId = uuid.uuidString.md5 as String
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,                                   deviceId ]
        rewardBasedVideo?.load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
    }
    
    func handleShowAdmob() {
        if rewardBasedVideo?.isReady == true {
            rewardBasedVideo?.present(fromRootViewController: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        answersTableView.isUserInteractionEnabled = true
        secondsTimer.invalidate()
        waitingTimer.invalidate()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshQuestionsAndAnswers), object: nil)
    }
    
    func downloadQuestionsFromServer(completionHandler: CompletionHandler) {
        
        let flag = true
        
        completionHandler(flag)
    }
    
    
    func refreshQuestionsAndAnswers() {
        
        leftTime = ShowAnswersTime
        currentPoints = 1000
        lockedPoints = 0
        
        let height = estimateFrameForText(text: question, width: Int(questionLabel.frame.size.width), fontSize: Int(DEVICE_WIDTH * 0.06)).height + 15
        
        questionLabelHeight.constant = height
        questionLabel.text = question
        secondsLabel.text = String(leftTime) + " SECONDS"
        
        pointLockedInfoLabel.isHidden = true
        pointInfoLabel.isHidden = false
        pointInfoLabel.text = "ANSWER WILL LOCK IN FOR " + String(currentPoints) + " PTS"
        progressBar.progress = 1
        
        answersTableView.reloadData()
        
        perform(#selector(handleWaitingForAnswer), with: nil, afterDelay: 2.0)
    }
    
    func handleWaitingForAnswer() {
        secondsTimer.invalidate()
        
        secondsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerGameAction), userInfo: nil, repeats: true)
        
        perform(#selector(handleProgressBarAnimate), with: nil, afterDelay: 1.0)
    }
    
    func handleProgressBarAnimate() {
        progressBar.animateTo(progress: 0.0)
    }
    
    func timerGameAction() {
        
        leftTime -= 1
        currentPoints -= 100
        secondsLabel.text = String(leftTime) + " SECONDS"
        pointInfoLabel.text = "ANSWER WILL LOCK IN FOR " + String(currentPoints) + " PTS"
        
        if leftTime == 0 {
            secondsTimer.invalidate()
            waitingTime = WaitingTime
            let judge = self.judgeAnswers()
            
            if judge == "Correct!" {
                points = points + lockedPoints
                requestToServerWithPoints(points: points)
                showWaitingViewWith(type: "Correct!", points: lockedPoints)
            } else {
                requestToServerWithPoints(points: points)
                showWaitingViewWith(type: "Wrong!", points: 0)
            }
            
            scoreLabel.text = String(points) + " PTS"
            
            perform(#selector(refreshQuestionsAndAnswers), with: nil, afterDelay: TimeInterval(WaitingTime))
            
        }
    }
    
    func judgeAnswers() -> String {
        var count = 0
        for i in 0 ..< answersChecks.count {
            if answersChecks[i] == answersIsChecks[i] {
                count += 1
            }
            if answersChecks[i] == 1 {
                correctAnswer = answers[i]
            }
        }
        
        var judge = "Wrong!"
        if count == answersChecks.count {
            judge = "Correct!"
        }
        return judge
    }
    
    func requestToServerWithPoints(points: Int) {
        
        let userId = defaults.string(forKey: "userId")!
        
        let paramDic = ["userId": userId, "points": points] as [String : Any]
        
        API?.executeHTTPRequest(Post, url: GET_PROBLEM_URL, parameters: paramDic , completionHandler: { (responseDic) in
            
            self.parseResponseWith(responseDic: responseDic!)
            
        }, errorHandler: { (error) in
            print("problemError--", error!)
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        })
        
        
    }
    
    private func parseResponseWith(responseDic: [AnyHashable: Any]) {
        
        question = ""
        answers.removeAll()
        answersChecks.removeAll()
        answersIsChecks.removeAll()

        let service = Service()

        service.question = responseDic["question"] as? String
        service.answers = responseDic["answers"] as? [[String: Any]]
        service.leftTime = responseDic["leftTime"] as? Int
        service.points = responseDic["points"] as? String

        question = service.question!
        leftTime = service.leftTime!
        points = Int(service.points!)!
        
        scoreLabel.text = String(points) + " PTS"

        for i in 0 ..< (service.answers!.count) {
            
            let answer = service.answers?[i]["text"] as! String
            let answerCheck = service.answers?[i]["correct"] as! String

            answers.append(answer)
            answersChecks.append(Int(answerCheck)!)
            answersIsChecks.append(0)
        }
        if requestStatus == .First {
            requestStatus = .Second
            
            if leftTime > ShowAnswersTime {
                let remainTime = Int(leftTime) - ShowAnswersTime
                waitingTime = remainTime
                self.showWaitingViewWith(type: "Other", points: 0)
                perform(#selector(refreshQuestionsAndAnswers), with: nil, afterDelay: TimeInterval(remainTime))
            } else if leftTime < ShowAnswersTime {
                waitingTime = Int(leftTime) + WaitingTime
                self.showWaitingViewWith(type: "Other", points: 0)
                
                perform(#selector(requestToServer), with: nil, afterDelay: TimeInterval(leftTime))
                
                perform(#selector(refreshQuestionsAndAnswers), with: nil, afterDelay: TimeInterval(leftTime) + TimeInterval(WaitingTime))
            } else {
                refreshQuestionsAndAnswers()
            }
        }
        
    }
    
    func showWaitingViewWith(type: String, points: Int) {
        
        containerWaitView.isHidden = false
        answersTableView.isUserInteractionEnabled = false
        
        if type == "Correct!" || type == "Wrong!" {
            welcomeLabel.text = type
            waitingLabel.text = "You scored " + String(points) + " points"
            correctAnswerLabel.isHidden = true
            if type == "Wrong!" {
                correctAnswerLabel.isHidden = false
                correctAnswerLabel.text = "Correct: " + correctAnswer
            }
        } else {
            welcomeLabel.text = "Welcome to 24/7Trivia"
            waitingLabel.text = "Please wait for the next question!"
            correctAnswerLabel.isHidden = true
        }
        
        waitingNumLabel.text = String(waitingTime)
        
        waitingTimer.invalidate()
        
        waitingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerWaitingAction), userInfo: nil, repeats: true)
        
    }
    
    func timerWaitingAction() {
        waitingTime -= 1
        
        waitingNumLabel.text = String(waitingTime)
        
        if waitingTime == 0 {
            waitingTimer.invalidate()
            
            containerWaitView.isHidden = true
            answersTableView.isUserInteractionEnabled = true
            
            adMobCount += 1
            print("admobcount", adMobCount)
            if adMobCount == 5 {
                adMobCount = 0
                self.handleShowAdmob()
            }
        }

    }
    
    func requestToServer() {
        requestToServerWithPoints(points: points)
    }
    
    private func setupNavigationBar() {
        
        view.backgroundColor = UIColor(r: 255, g: 89, b: 100, a: 1)
        
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "247_clock")
        backgroundImageView.alpha = 0.4
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
        
    }
    
    private func setupAnswersTableView() {
        
        view.addSubview(answersTableView)
        
        answersTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        answersTableView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        answersTableView.topAnchor.constraint(equalTo: pointInfoLabel.bottomAnchor, constant: 60).isActive = true
        answersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    private func setupScoreLabel() {
        view.addSubview(scoreLabel)
        
        scoreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.5).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupQuestionViews() {
        view.addSubview(questionLabel)
        view.addSubview(progressBar)
        view.addSubview(secondsLabel)
        view.addSubview(pointInfoLabel)
        view.addSubview(pointLockedInfoLabel)
        
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        questionLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.8).isActive = true
        questionLabelHeight = questionLabel.heightAnchor.constraint(equalToConstant: 25)
        questionLabelHeight.isActive = true
        
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.7).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        progressBar.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20).isActive = true
        
        
        secondsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondsLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10).isActive = true
        secondsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        secondsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pointInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pointInfoLabel.topAnchor.constraint(equalTo: secondsLabel.bottomAnchor, constant: 5).isActive = true
        pointInfoLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pointInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pointLockedInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pointLockedInfoLabel.topAnchor.constraint(equalTo: secondsLabel.bottomAnchor, constant: 5).isActive = true
        pointLockedInfoLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pointLockedInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pointInfoLabel.isHidden = false
        pointLockedInfoLabel.isHidden = true
        
        
    }
    
    private func settupContainerWaitView() {
        
        view.addSubview(containerWaitView)
        
        containerWaitView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerWaitView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerWaitView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.75).isActive = true
        containerWaitView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.4).isActive = true
        
        containerWaitView.addSubview(welcomeLabel)
        containerWaitView.addSubview(waitingLabel)
        containerWaitView.addSubview(waitingNumLabel)
        containerWaitView.addSubview(correctAnswerLabel)
        
        waitingLabel.centerXAnchor.constraint(equalTo: containerWaitView.centerXAnchor).isActive = true
        waitingLabel.centerYAnchor.constraint(equalTo: containerWaitView.centerYAnchor, constant: -10).isActive = true
        waitingLabel.widthAnchor.constraint(equalTo: containerWaitView.widthAnchor).isActive = true
        waitingLabel.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.05).isActive = true
        
        
        welcomeLabel.centerXAnchor.constraint(equalTo: containerWaitView.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: containerWaitView.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.07).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: containerWaitView.topAnchor, constant: 15).isActive = true
        
        correctAnswerLabel.centerXAnchor.constraint(equalTo: containerWaitView.centerXAnchor).isActive = true
        correctAnswerLabel.widthAnchor.constraint(equalTo: containerWaitView.widthAnchor).isActive = true
        correctAnswerLabel.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.07).isActive = true
        correctAnswerLabel.topAnchor.constraint(equalTo: waitingLabel.bottomAnchor, constant: 15).isActive = true
        
        waitingNumLabel.centerXAnchor.constraint(equalTo: containerWaitView.centerXAnchor).isActive = true
        waitingNumLabel.widthAnchor.constraint(equalTo: containerWaitView.widthAnchor).isActive = true
        waitingNumLabel.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.06).isActive = true
        waitingNumLabel.bottomAnchor.constraint(equalTo: containerWaitView.bottomAnchor, constant: -10).isActive = true
        
        containerWaitView.isHidden = true
    }
    
    private func estimateFrameForText(text: String, width: Int, fontSize: Int) -> CGRect {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(fontSize))], context: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AnswersCell
        
        cell.checkBox.tag = indexPath.row
        
        if answersIsChecks[indexPath.row] == 0 {
            cell.checkBox.setOn(false, animated: true)
        } else {
            cell.checkBox.setOn(true, animated: true)
        }

        
        cell.checkBox.delegate = self
        
        cell.answerLabel.text = answers[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            return DEVICE_WIDTH * 0.09
        }
        return DEVICE_WIDTH * 0.125
    }

    func didTap(_ checkBox: BEMCheckBox) {
        
        if answersIsChecks[checkBox.tag] == 0 {
            answersIsChecks[checkBox.tag] = 1
            
            pointInfoLabel.isHidden = true
            pointLockedInfoLabel.isHidden = false
            pointLockedInfoLabel.text = "ANSWER LOCKED IN FOR " + String(currentPoints) + " PTS"
            lockedPoints = currentPoints
        } else {
            answersIsChecks[checkBox.tag] = 0
        }
        
        for i in 0 ..< answersIsChecks.count {
            if answersIsChecks[checkBox.tag] == 1 {
                if i != checkBox.tag {
                    answersIsChecks[i] = 0
                }
            }
            let indexPath = IndexPath(row: i, section: 0)
            let cell = self.answersTableView.cellForRow(at: indexPath as IndexPath) as! AnswersCell
            if answersIsChecks[i] == 0 {
                cell.checkBox.setOn(false, animated: true)
            }
        }
    }
    
}


