//
//  ScoreViewController.swift
//  emojiquiz
//
//  Created by Rose, Jacob on 2/12/20.
//  Copyright © 2020 Rose, Jacob. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var firstPlaceLabel: UILabel!
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    
    private static var positions: Array<PlayerScore> = Array<PlayerScore>()
    struct PlayerScore: Codable
    {
        var score:Int
        var name:String
        init(score s:Int,name n: String)
        {
            score = s
            name = n
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreViewController.loadScores()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) { //calls everytime view is opened
        if ScoreViewController.positions.count > 0
        {
            firstPlaceLabel.text = ScoreViewController.positions[0].name + " | " + String(ScoreViewController.positions[0].score);
        }
        else
        {
            firstPlaceLabel.text = ""
        }
        
        if ScoreViewController.positions.count > 1
        {
            secondPlaceLabel.text = ScoreViewController.positions[1].name + " | " + String(ScoreViewController.positions[1].score);
        }
        else
        {
            secondPlaceLabel.text = ""
        }
        
        if ScoreViewController.positions.count > 2
        {
            thirdPlaceLabel.text = ScoreViewController.positions[2].name + " | " + String(ScoreViewController.positions[2].score);
        }
        else
        {
            thirdPlaceLabel.text = ""
        }
        
    }
    
    //https://stackoverflow.com/questions/44876420/save-struct-to-userdefaults
    static func loadScores()
    {
        if let data = UserDefaults.standard.value(forKey:"scores") as? Data {
            if let scores = try? PropertyListDecoder().decode(Array<PlayerScore>.self, from: data)
            {
                ScoreViewController.positions = scores
            }
        }
    }
    
    static func saveScores()
    {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(ScoreViewController.positions), forKey:"scores")
    }
    
    static func addPosition(name:String, score:Int)
    {
        positions.append(PlayerScore(score: score, name: name))
        ScoreViewController.sortScores()
        ScoreViewController.saveScores()
    }
    
    static func sortScores()
    {
        positions.sort { (lhs: ScoreViewController.PlayerScore, rhs:ScoreViewController.PlayerScore) -> Bool in
            return lhs.score > rhs.score
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
