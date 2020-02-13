//
//  ViewController.swift
//  emojiquiz
//
//  Created by Rose, Jacob on 2/5/20.
//  Copyright © 2020 Rose, Jacob. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    struct Puzzle
    {
        var m_Solution: String
        var m_Prompt: String
        init(solution: String, prompt: String)
        {
            m_Solution = solution
            m_Prompt = prompt
        }
    }
    
    static var m_Puzzles: Array<Puzzle> = Array<Puzzle>()
    static var m_PuzzlesToComplete: Int = 0
    var m_PuzzlesCompleted: Int = 0
    var m_Lives = 3
    
    var m_Guesses: Array<Character> = Array<Character>()
    var m_CurrentPuzzle: Puzzle = Puzzle(solution: "", prompt: "")
    var m_CorrectSoundEffect: AVAudioPlayer?
    
    @IBOutlet weak var m_PromptLabel: UILabel!
    @IBOutlet weak var m_GuessLabel: UILabel!
    @IBOutlet weak var m_LivesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_LivesLabel.text = String(m_Lives)
        startNewQuestion()
        updateGuessLabel()
    }
    @IBAction func guessPressed(_ sender: UIButton) {
        if let label = sender.titleLabel
        {
            if let labelChar = label.text?.first
            {
                if !m_Guesses.contains(labelChar.lowercased().first!)
                {
                    m_Guesses.append(labelChar.lowercased().first!)
                    updateGuessLabel()
                    sender.alpha = 0.2
                    if !m_CurrentPuzzle.m_Solution.lowercased().contains(labelChar.lowercased())
                    {
                        loseLife()
                        playAudio(filename: "no.mp3")
                    }
                }
            }
        }
    }
    
    func loseLife()
    {
        m_Lives -= 1
        m_LivesLabel.text = String(m_Lives)
        if m_Lives <= 0
        {
            playerLostGame()
        }
    }
    
    func playerLostGame()
    {
        let alert = UIAlertController(title: "You have lost!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true)
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    func updateGuessLabel()
    {
        m_GuessLabel.text = ""
        var isFinished = true
        for char in m_CurrentPuzzle.m_Solution
        {
            if m_Guesses.contains(char.lowercased().first!) || char == " "
            {
                m_GuessLabel.text?.append(char.uppercased())
            }
            else
            {
               m_GuessLabel.text?.append("-")
                isFinished = false
            }
        }
        if isFinished
        {
            //play sound
            playAudio(filename: "ding.wav")
            m_PuzzlesCompleted += 1
            if m_PuzzlesCompleted < GameViewController.m_PuzzlesToComplete
            {
                startNewQuestion()
            }
            else
            {
                savePlayerScore()
            }
        }
    }
    //https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    func savePlayerScore()
    {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let name = alert.textFields?.first?.text {
                ScoreViewController.addPosition(name: name, score: self.m_Lives)
            }
            self.dismiss(animated: true)
        }))

        self.present(alert, animated: true)
        
    }
    
    @IBOutlet var keyboardButtons: [UIButton]!
    func startNewQuestion()
    {
        m_CurrentPuzzle = GameViewController.m_Puzzles[m_PuzzlesCompleted]
        
        UIView.animate(withDuration: 1.0, animations: {
            self.m_PromptLabel.alpha = 0.0
            self.m_GuessLabel.alpha = 0.0
            
        }, completion: { finished in
            for button in self.keyboardButtons
            {
                button.alpha = 1.0
            }
            self.m_Guesses.removeAll()
            self.m_PromptLabel.text = self.m_CurrentPuzzle.m_Prompt
            self.updateGuessLabel()
            UIView.animate(withDuration: 1.0) {
                self.m_PromptLabel.alpha = 1.0
                self.m_GuessLabel.alpha = 1.0
            }
        })
    }
    
    static func loadFile(filename: String)
    {
        GameViewController.m_Puzzles.removeAll()
        if  let path = Bundle.main.path(forResource: filename, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            if let options = (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String:String]
            {
                for (key, value) in options
                {
                    GameViewController.m_Puzzles.append(Puzzle(solution: value, prompt: key))
                }
            }
        }
        GameViewController.m_Puzzles.shuffle()
    }
    
    func playAudio(filename:String)
    {
        let path = Bundle.main.path(forResource: filename, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            m_CorrectSoundEffect = try AVAudioPlayer(contentsOf: url)
            m_CorrectSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
}

