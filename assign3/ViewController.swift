//
//  ViewController.swift
//  assign3
//
//  Created by Kevin Nogales on 3/25/20.
//  Copyright © 2020 Kevin Nogales. All rights reserved.
//

import UIKit

struct HighScores: Codable {
    var scores: [Scores]
}

class ViewController: UIViewController {
    
    var game = Triples()
    var randOpt = true;
    var currentGameActive = true
    
    
    @IBOutlet var upOutlet: UIButton!
    @IBOutlet var downOutlet: UIButton!
    @IBOutlet var leftOutlet: UIButton!
    @IBOutlet var rightOutlet: UIButton!
    
    @IBOutlet var newGameOutlet: UIButton!
    @IBOutlet var scoreOutlet: UILabel!
    @IBOutlet var randOptOutlet: UISegmentedControl!
    
    
    @IBOutlet var boardView: BoardView!
    
    @IBAction func newGameAction(_ sender: UIButton) {
        currentGameActive = true
        
        for current in boardView.subviews {
            current.removeFromSuperview()
        }
        
        game.newgame(rand: randOpt)
        game.spawn()
        game.spawn()
        game.spawn()
        game.spawn()
        updateTiles()
        
        printBoard()
    }
    
    func checkIsDone() {
        if game.isDone() {
            let alert = UIAlertController(title: "Game Over", message: String(game.score) + " points.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Bummer", style: .default, handler: saveAndSwitchTab))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func upAction(_ sender: UIButton) {
        if !game.isDone() && game.collapse(dir: .up) {
            updateTiles()
            game.spawn()
            updateTiles()
        }
        printBoard()
        
        checkIsDone()
    }
    
    @IBAction func downAction(_ sender: UIButton) {
        if !game.isDone() && game.collapse(dir: .down) {
            updateTiles()
            game.spawn()
            updateTiles()
        }
        printBoard()
        
        checkIsDone()
    }
    
    @IBAction func leftAction(_ sender: UIButton) {
        if !game.isDone() && game.collapse(dir: .left) {
            updateTiles()
            game.spawn()
            updateTiles()
        }
        printBoard()
        
        checkIsDone()
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        if !game.isDone() && game.collapse(dir: .right) {
            updateTiles()
            game.spawn()
            updateTiles()
        }
        printBoard()
        
        checkIsDone()
    }
    
    
    @IBAction func randOptStateChange(_ sender: UISegmentedControl) {
        
        switch randOptOutlet.selectedSegmentIndex {
        case 1:
            randOpt = false
        default:
            randOpt = true
        }
    }
    
    func updateTiles() {
        
        var boardViewIds = Set<Int>()
        
        for current in boardView.subviews as! [ButtonTile] {
            boardViewIds.insert(current.tile.id)
        }
        
        var boardIds = Set<Int>()
        
        for i in 0..<game.board.count {
            for j in 0..<game.board[i].count {
                if game.board[i][j] != nil {
                    boardIds.insert(game.board[i][j]!.id)
                }
            }
        }
        
        let toAdd = boardIds.subtracting(boardViewIds)
        let toRemove = boardViewIds.subtracting(boardIds)
        let remaining = boardIds.intersection(boardViewIds)
    
        
        // Add unseen tiles.
        for i in 0..<game.board.count {
            for j in 0..<game.board[i].count {
                if game.board[i][j] != nil && toAdd.contains(game.board[i][j]!.id) {
                    
                    let newTileButton = ButtonTile(t: game.board[i][j]!)
                    let newFrame = buttonFrame(row: game.board[i][j]!.row, col: game.board[i][j]!.col, view: boardView)
                    
                    newTileButton.frame = newFrame
                    
                    boardView.addSubview(newTileButton)
                }
            }
        }
        
        // Remove no longer existing tiles.
        for current in toRemove {
            for currentButtonTile in boardView.subviews as! [ButtonTile] {
                if currentButtonTile.tile.id == current {
                    //currentButtonTile.removeFromSuperview()
                    
                    currentButtonTile.tile.id = -1
                    
                }
            }
        }
        
        // Update remaining tiles for corresponding buttontiles.
        for i in 0..<game.board.count {
            for j in 0..<game.board[i].count {
                
                if game.board[i][j] != nil && remaining.contains(game.board[i][j]!.id) {
                    let updatedTile = game.board[i][j]!
                    
                    
                    // Look for ButtonTile
                    for current in boardView.subviews as! [ButtonTile] {
                        if current.tile.id == updatedTile.id {
                            
                            current.tile = updatedTile
                            
                            break
                        }
                    }
                    
                }
                
            }
        }
        
        scoreOutlet.text = "Score : " + String(game.score)
         
        boardView.setNeedsDisplay()
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Update buttons for controls.
        upOutlet.layer.backgroundColor = UIColor.white.cgColor
        upOutlet.layer.cornerRadius = 5
        upOutlet.layer.borderWidth = 1
        
        downOutlet.layer.backgroundColor = UIColor.white.cgColor
        downOutlet.layer.cornerRadius = 5
        downOutlet.layer.borderWidth = 1
        
        leftOutlet.layer.backgroundColor = UIColor.white.cgColor
        leftOutlet.layer.cornerRadius = 5
        leftOutlet.layer.borderWidth = 1
        
        rightOutlet.layer.backgroundColor = UIColor.white.cgColor
        rightOutlet.layer.cornerRadius = 5
        rightOutlet.layer.borderWidth = 1
        
        newGameOutlet.layer.backgroundColor = UIColor.white.cgColor
        newGameOutlet.layer.cornerRadius = 5
        newGameOutlet.layer.borderWidth = 1
        
        // Create new game.
        game.newgame(rand: randOpt)
        game.spawn()
        game.spawn()
        game.spawn()
        game.spawn()
        
        printBoard()
        
        updateTiles()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(upSwipe))
        swipeUp.direction = .up
        boardView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(downSwipe))
        swipeDown.direction = .down
        boardView.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        swipeLeft.direction = .left
        boardView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        swipeRight.direction = .right
        boardView.addGestureRecognizer(swipeRight)
        
        let defaults = UserDefaults.standard
        
        /*
        
        // Encode high scores.
        let encoder = JSONEncoder()

        if let encoded = try? encoder.encode(HighScores(scores: ["One", "Two"])) {
            
            defaults.set(encoded, forKey: "HighScores")
        }*/
        
        // Decode high scores.
        let decoder = JSONDecoder()
        
        if let savedHighScores = defaults.object(forKey: "HighScores") as? Data {
            if let loadedHighScores = try? decoder.decode(HighScores.self, from: savedHighScores) {
                print(loadedHighScores.scores)
            }
        }
    }
    
    @objc func upSwipe() {
        upAction(upOutlet)
    }
    
    @objc func downSwipe() {
        downAction(downOutlet)
    }
    
    @objc func leftSwipe() {
        leftAction(leftOutlet)
    }
    
    @objc func rightSwipe() {
        rightAction(rightOutlet)
    }
    
    func saveAndSwitchTab(alert: UIAlertAction!) {
        if currentGameActive {
            let savedScore = scoreOutlet.text!.split(separator: " ")[2]
                var savedDate = ""
            
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = format.string(from: date)
                
                savedDate += formattedDate
            
                let scoreToSave = Scores(score: Int(String(savedScore))!, date: savedDate)
            
                let defaults = UserDefaults.standard
                let encoder = JSONEncoder()
                let decoder = JSONDecoder()
                
                
                if let savedHighScores = defaults.object(forKey: "HighScores") as? Data {
                    // If highscore previously stored, append high score.
                    
                    if var loadedHighScores = try? decoder.decode(HighScores.self, from: savedHighScores) {
                        loadedHighScores.scores.append(scoreToSave)
                        loadedHighScores.scores.sort(by: { (i1, i2) in i1.score > i2.score })
                        
                        if let encoded = try? encoder.encode(loadedHighScores) {
                            defaults.set(encoded, forKey: "HighScores")
                            print("Appended, encoded and saved.")
                        } else {
                            print("Not appended, encoded and saved.")
                        }
                    } else {
                        print("Decoder not working.")
                        print(savedHighScores)
                    }
                    
                } else {
                    // If highscore not previously stored, store high score.
                    if let encoded = try? encoder.encode(HighScores(scores: [scoreToSave])) {
                        defaults.set(encoded, forKey: "HighScores")
                        print("Encoded and saved.")
                    } else {
                        print("Not encoded and saved.")
                    }
                }
                
                if let savedHighScores = defaults.object(forKey: "HighScores") as? Data {
                    
                    if let loadedHighScores = try? decoder.decode(HighScores.self, from: savedHighScores) {
                        print("Here1")
                        print(loadedHighScores.scores)
                    } else {
                        print("Here2")
                    }
                } else {
                    print("Here3")
                }
            
            currentGameActive = false
        }
        
        tabBarController?.selectedIndex = 1
    }

    /* TESTING FUNCTIONS*/
    
    func printBoard() {
        print(game.board)
    }
}

