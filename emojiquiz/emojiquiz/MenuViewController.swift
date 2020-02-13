//
//  MenuViewController.swift
//  emojiquiz
//
//  Created by Rose, Jacob on 2/12/20.
//  Copyright © 2020 Rose, Jacob. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
    @IBOutlet weak var numQuestionsStepper: UIStepper!
    @IBOutlet weak var numQuestionsLabel: UILabel!
    @IBOutlet weak var quizTypeSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        numQuestionStepperPressed(numQuestionsStepper)
        onQuizTypeChanged(quizTypeSegmentedControl)
    }
    @IBAction func numQuestionStepperPressed(_ sender: UIStepper) {
        numQuestionsLabel.text = String(Int(sender.value))
        GameViewController.m_PuzzlesToComplete = Int(sender.value)
    }
    
    @IBAction func onQuizTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 //movie quiz
        {
            GameViewController.loadFile(filename: "moviequestions")
        }
        else
        {
            GameViewController.loadFile(filename: "gamequestions")
        }
    }

}
