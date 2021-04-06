//
//  QuestionsViewController.swift
//  PersonalQuiz
//
//  Created by Mac on 05.04.2021.
//

import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var firstStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var secondStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentsAnswers.count - 1)
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    
    private var answerChoosen: [Answer] = []
    private var currentsAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
        
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswers = currentsAnswers[buttonIndex]
        answerChoosen.append(currentAnswers)
        nextQuestion()
    }
    
    @IBAction func multipleButtonAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentsAnswers) {
            if multipleSwitch.isOn {
                answerChoosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answerChoosen.append(currentsAnswers[index])
        nextQuestion()
    }
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsVC = segue.destination as? ResultsViewController
        resultsVC?.answers = answerChoosen
    }
}

// MARK: - Private Methods
extension QuestionsViewController {
    private func setupUI() {
        for stackView in [firstStackView, secondStackView, rangedStackView]{
            stackView?.isHidden = true
        }
        for multiSwitches in multipleSwitches {
            multiSwitches.isOn = false
        }
        
        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.title
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        questionProgressView.setProgress(totalProgress, animated: true)
        
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
        }
    
    private func showCurrentAnswers(for type: ResponceType) {
        switch type {
        case .single:
            showSingleStackView(with: currentsAnswers)
        case .multiple:
            showMultipleStackView(with: currentsAnswers)
        case .ranged:
            showRangedStackView(with: currentsAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        firstStackView.isHidden = false
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        secondStackView.isHidden = false
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            setupUI()
            return
        } else {
            performSegue(withIdentifier: "showResult", sender: nil)
        }
    }
}
