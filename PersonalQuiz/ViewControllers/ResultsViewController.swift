//
//  ResultsViewController.swift
//  PersonalQuiz
//
//  Created by Mac on 05.04.2021.
//

import UIKit



class ResultsViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var resultDescription: UILabel!
    
    var answers: [Answer]!
    private var quantityOfAnimals: [AnimalType: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResult()
    }
    
    private func getResult() {
        let animalsType = answers.map({ $0.type })
        
        for animal in animalsType {
            quantityOfAnimals[animal] = (quantityOfAnimals[animal] ?? 0) + 1
        }
        
        let sortedAnimals = quantityOfAnimals.sorted(by: { $0.value > $1.value })
        guard let mostAnimal = sortedAnimals.first?.key else { return }
        
        setupUI(with: mostAnimal)
    }
    
    private func setupUI(with animal: AnimalType) {
        navigationItem.hidesBackButton = true
        resultLabel.text = "Вы - \(animal.rawValue)"
        resultDescription.text = animal.definition
    }
    
}
