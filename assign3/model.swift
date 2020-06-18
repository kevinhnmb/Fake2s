//
//  model.swift
//  assign3
//
//  Created by Kevin Nogales on 3/25/20.
//  Copyright © 2020 Kevin Nogales. All rights reserved.
//

import Foundation
import UIKit

struct Scores: Equatable, Codable {
    var score: Int
    var date: String
}

struct Tile: Equatable {
    var val: Int
    var id: Int
    var row: Int
    var col: Int
}

extension Tile {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return (lhs.val == rhs.val) && (lhs.id == rhs.id) && (lhs.row == rhs.row) && (lhs.col == rhs.col)
    }
}

class BoardView: UIView {
    override func draw(_ rect: CGRect) {
        
        let width = self.frame.width
        let height = self.frame.height
        
        let outerLine = UIBezierPath()
        outerLine.move(to: CGPoint(x: 0, y: 0))
        outerLine.addLine(to: CGPoint(x: width, y: 0))
        outerLine.addLine(to: CGPoint(x: width, y: height))
        outerLine.addLine(to: CGPoint(x: 0, y: height))
        
        outerLine.close()
        
        UIColor.black.setStroke()
        //UIColor.red.setFill()
        outerLine.lineWidth = 4
        
        outerLine.stroke()
        //path.fill()
        
        let line = UIBezierPath()
        
        line.move(to: CGPoint(x: width/4, y: 0))
        line.addLine(to: CGPoint(x: width/4, y: height))
        
        line.move(to: CGPoint(x: width/4 * 2, y: 0))
        line.addLine(to: CGPoint(x: width/4 * 2, y: height))
        
        line.move(to: CGPoint(x: width/4 * 3, y: 0))
        line.addLine(to: CGPoint(x: width/4 * 3, y: height))
        
        line.move(to: CGPoint(x: 0, y: height/4))
        line.addLine(to: CGPoint(x: width, y: height/4))
        
        line.move(to: CGPoint(x: 0, y: height/4 * 2))
        line.addLine(to: CGPoint(x: width, y: height/4 * 2))
        
        line.move(to: CGPoint(x: 0, y: height/4 * 3))
        line.addLine(to: CGPoint(x: width, y: height/4 * 3))
        
        line.lineWidth = 2
        line.stroke()
    }
    
    override func layoutSubviews() {
        
        
        for current in subviews as! [ButtonTile] {
            if current.tile.id == -1 {
                UIView.animate(withDuration: 0.5, animations: {
                    current.layer.opacity = 0.0
                }, completion: { finished in
                    current.removeFromSuperview()
                })
                
            } else if current.newTile {
                
                current.layer.opacity = 0.0
                
                let newFrame = buttonFrame(row: current.tile.row, col: current.tile.col, view: self)
                
                UIView.animate(withDuration: 1, animations: {
                    current.frame = newFrame
                })
                
                if current.tile.val == 1 {
                       let str = "1"
                       let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                       current.setAttributedTitle(attStr, for: UIControl.State.normal)
                       current.layer.backgroundColor = UIColor(hue: 0.5556, saturation: 1, brightness: 0.99, alpha: 1.0).cgColor
                
                   } else if current.tile.val == 2 {
                       let str = "2"
                       let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                       current.setAttributedTitle(attStr, for: UIControl.State.normal)
                       current.layer.backgroundColor = UIColor(hue: 0.9528, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor
                   } else {
                       let str = String(current.tile.val)
                       let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                       current.setAttributedTitle(attStr, for: UIControl.State.normal)
                       current.layer.backgroundColor = UIColor.white.cgColor
                   }
                current.layer.cornerRadius = 5
                current.layer.borderWidth = 1
                
                
                UIView.animate(withDuration: 0.5, animations: {
                    current.layer.opacity = 1.0
                }, completion: { finished in
                    current.newTile = false
                })
                
            } else {
                let newFrame = buttonFrame(row: current.tile.row, col: current.tile.col, view: self)
                
                UIView.animate(withDuration: 1, animations: {
                    current.frame = newFrame
                })
                
                if current.tile.val == 1 {
                       let str = "1"
                       let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                       current.setAttributedTitle(attStr, for: UIControl.State.normal)
                       current.layer.backgroundColor = UIColor(hue: 0.5556, saturation: 1, brightness: 0.99, alpha: 1.0).cgColor
                
                   } else if current.tile.val == 2 {
                       let str = "2"
                       let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                       current.setAttributedTitle(attStr, for: UIControl.State.normal)
                       current.layer.backgroundColor = UIColor(hue: 0.9528, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor
                   } else {
                       let str = String(current.tile.val)
                       let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                       current.setAttributedTitle(attStr, for: UIControl.State.normal)
                       current.layer.backgroundColor = UIColor.white.cgColor
                   }
                current.layer.cornerRadius = 5
                current.layer.borderWidth = 1
            }
            
        }
    }
}

class ButtonTile: UIButton {
    var tile = Tile(val: 0, id: 0, row: 0, col: 0)
    var newTile: Bool = true
    
    convenience init(t: Tile) {
        self.init()
        tile = t
    }
}

enum Direction {
    case left
    case right
    case down
    case up
}

class Triples {
    var board: [[Tile?]]
    var score: Int
    var id: Int
    
    init() {
        board = []
        score = 0
        id = 0
    }
    
    func newgame(rand: Bool) {
        
        board = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        
        score = 0
        id = 0
        
        if rand {
            srand48(Int.random(in: 1...1000))
        } else {
            srand48(42)
        }
    }
    
    func prng(max: Int) -> Int {
        let ret = Int(floor(drand48() * (Double(max))))
        return (ret < max) ? ret : (ret-1)
    }
    
    func spawn() {
        var openPositions = [Int: (Int,Int)]()
        
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                if board[i][j] == nil {
                    openPositions[openPositions.count] = (i,j)
                }
            }
        }
        
        if openPositions.count != 0 {
            let val = prng(max: 2) + 1
            let pos = prng(max: openPositions.keys.max()! + 1)
            
            board[openPositions[pos]!.0][openPositions[pos]!.1] = Tile(val: val, id: id, row: openPositions[pos]!.0, col: openPositions[pos]!.1)
            
            id += 1
            
            score += val
        }
    }
    
    func isDone() -> Bool {
        let boardCopy = board
        
        if collapse(dir: .up) || collapse(dir: .down) || collapse(dir: .left) || collapse(dir: .right) {
            board = boardCopy
            return false
        } else {
            return true
        }
    }
    
    func rotate() {
        board = rotate2D(input: board)
    }
    
    func shift() {
        if !board.isEmpty {
            for i in 0..<board.count {
                for j in 1..<board[i].count {
                    
                    if board[i][j] != nil && board[i][j-1] == nil {
                        
                        board[i][j-1] = board[i][j]
                                            
                    } else if (board[i][j] != nil && board[i][j]?.val == 1 && board[i][j-1] != nil && board[i][j-1]?.val == 2 ||
                               board[i][j-1] != nil && board[i][j-1]?.val == 1 && board[i][j] != nil && board[i][j]?.val == 2 ) {
                        
                        board[i][j-1] = board[i][j]
                        board[i][j-1]?.val = 3
                        
                        score += 3
                        
                    } else if ((board[i][j] != nil && board[i][j]!.val >= 3) && (board[i][j-1] != nil && board[i][j]?.val == board[i][j-1]?.val)) {
                        let lval = board[i][j]!.val
                        
                        board[i][j-1] = board[i][j]
                        
                        board[i][j-1]?.val = lval * 2
                        
                        score += board[i][j-1]!.val
                    } else {
                        continue
                    }
                    
                    // Shift the rest of the tiles.
                    for g in j..<board[i].count - 1 {
                        
                        if board[i][g] != nil {
                        
                            board[i][g] = board[i][g+1]
                        
                        } else {
                            board[i][g] = board[i][g+1]
                        }
                    }
                    
                    // Since tiles shifted, make last tile nil.
                    board[i][board[i].count - 1] = nil
                    break
                }
            }
        }
    }
    
    func updateTiles() {
        if !board.isEmpty {
            for i in 0..<board.count {
                for j in 0..<board[i].count {
                    if board[i][j] != nil {
                        board[i][j]?.row = i
                        board[i][j]?.col = j
                    }
                }
            }
        }
    }
    
    func collapse(dir: Direction) -> Bool {
        let copyOfBoard = board
        
        switch dir {
        case .left:
            shift()
        case .right:
            rotate()
            rotate()
            shift()
            rotate()
            rotate()
        case .down:
            rotate()
            shift()
            rotate()
            rotate()
            rotate()
        case .up:
            rotate()
            rotate()
            rotate()
            shift()
            rotate()
        }
        
        updateTiles()
        
        return !(copyOfBoard == board)
    }
}





public func rotate2DInts(input: [[Int]]) -> [[Int]] {
    var newBoard = Array(repeating: Array(repeating: 0, count: 4), count: 4)

    for i in 0..<input.count {
        
        var newI = 0
        
        switch i {
        case 0:
            newI = i+3
        case 1:
            newI = i+1
        case 2:
            newI = i-1
        case 3:
            newI = i-3
        default:
            newI = 0
        }
        
        for j in 0..<input[0].count {
            newBoard[j][newI] = input[i][j]
        }
    }
    
    return newBoard
}

public func rotate2D<T>(input: [[T]]) -> [[T]] {
    var newBoard = Array(repeating: Array(repeating: input[0][0], count: 4), count: 4)
    
    for i in 0..<input.count {
        
        var newI = 0
        
        switch i {
        case 0:
            newI = i+3
        case 1:
            newI = i+1
        case 2:
            newI = i-1
        case 3:
            newI = i-3
        default:
            newI = 0
        }
        
        for j in 0..<input[0].count {
            newBoard[j][newI] = input[i][j]
        }
    }
    
    return newBoard
}

func buttonFrame(row: Int, col: Int, view:UIView) -> CGRect {
    
    let viewWidth = view.frame.width
    let viewHeight = view.frame.height
    let buttonWidth = viewWidth / 4
    let buttonHeigh = viewHeight / 4
    
    let x = buttonWidth * CGFloat(col)
    let y = buttonHeigh * CGFloat(row)
    
    let r = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeigh)
    
    return r
}
