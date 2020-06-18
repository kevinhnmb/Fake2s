//
//  HighController.swift
//  assign3
//
//  Created by Kevin Nogales on 4/1/20.
//  Copyright © 2020 Kevin Nogales. All rights reserved.
//

/*
 You should:
     - subclass the UIViewController to a new HighController class.
     - use interface builder to add a UITableView.
     - implement routines for the view controller to call providing a new high score
     - use UserDefaults to store and retrieve high scores
     - the the tableview to show at least ten of the top scores with rank / score / date-and-date, as shown in the video.
     - your game should jump to the high-scores screen at the end of a game when calling isDone() returns true for the first time.
     - you do not need to worry about landscape mode
 */


import Foundation

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var numberOutlet: UILabel!
    @IBOutlet var scoreOutlet: UILabel!
    @IBOutlet var dateTimeOutlet: UILabel!
    
    
}

class HighController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableViewOutlet: UITableView! {
        didSet {
            tableViewOutlet.delegate = self
            tableViewOutlet.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var flag = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        if let myCell = cell as? CustomCell {
            
            let defaults = UserDefaults.standard
            
            let decoder = JSONDecoder()
            
            if let savedHighScores = defaults.object(forKey: "HighScores") as? Data {
                if let loadedHighScores = try? decoder.decode(HighScores.self, from: savedHighScores) {
                    
                    if loadedHighScores.scores.count > indexPath.item {
                        myCell.numberOutlet.text = String(indexPath.item + 1) + ")"
                        myCell.scoreOutlet.text = String(loadedHighScores.scores[indexPath.item].score)
                        myCell.dateTimeOutlet.text = loadedHighScores.scores[indexPath.item].date
                    } else {
                        flag = true
                    }
                } else {
                    flag = true
                }
            } else {
                flag = true
            }
            
            if flag {
                myCell.numberOutlet.text = ""
                myCell.scoreOutlet.text = ""
                myCell.dateTimeOutlet.text = ""
            }
            
            
            
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let defaults = UserDefaults.standard
        
        let decoder = JSONDecoder()
        
        if let savedHighScores = defaults.object(forKey: "HighScores") as? Data {
            if let loadedHighScores = try? decoder.decode(HighScores.self, from: savedHighScores) {
                print(loadedHighScores.scores)
            } else {
                print("Here1")
            }
        } else {
            print("Here")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        self.tableViewOutlet.reloadData()
    }
}
