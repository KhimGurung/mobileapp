//
//  GameViewController.swift
//  tetris
//
//  Created by Khim Bahadur Gurung on 11.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//  it will handle user input and communicationg between gamescene and a game logic class

import SpriteKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate, GameLogicDelegate {

    
    func gameDidEnd(gamelogic: GameLogic){
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        scene.animateCollapsingLines(linesToRemove: gamelogic.removeAllBlocks(), fallenBlocks: gamelogic.removeAllBlocks()) {
            if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "gameendVC") {
                presentedViewController.providesPresentationContextTransitionStyle = true
                presentedViewController.definesPresentationContext = true
                presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
                presentedViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.5)
                self.present(presentedViewController, animated: true, completion: nil)
            }
        }
    }
    
    func gameDidBegin(gamelogic: GameLogic) {
        levelLabel.text = "\(gamelogic.level)"
        scoreLabel.text = "\(gamelogic.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        if gamelogic.nextShape != nil && gamelogic.nextShape!.blocks[0].sprite == nil {
                scene.addPreviewShapeToScene(shape: gamelogic.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    func gameDidLevelUp(gamelogic: GameLogic) {
        levelLabel.text = "\(gamelogic.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
    }
    
    func gameShapeDidLand(gamelogic: GameLogic) {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        let removedLines = gamelogic.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(gamelogic.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                self.gameShapeDidLand(gamelogic: gamelogic)
            }

        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(gamelogic: GameLogic) {
        scene.redrawShape(shape: gamelogic.fallingShape!) {}
    }
    
    func gameShapeDidDrop(gamelogic: GameLogic) {
        scene.stopTicking()
        scene.redrawShape(shape: gamelogic.fallingShape!) {
            gamelogic.letShapeFall()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    var scene: GameScene!
    var gamelogic: GameLogic!
    var panPoint:CGPoint?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFit
        
        scene.tick = didTick
        
        gamelogic = GameLogic()
        gamelogic.delegate = self
        gamelogic.gameStart()
        
        // Present the scene.
        skView.presentScene(scene)
        
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func didTick() {
        gamelogic.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = gamelogic.otherShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    @IBAction func tapDone(_ sender: UITapGestureRecognizer) {
        gamelogic.rotateShape()
    }

    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPoint {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    gamelogic.moveShapeRight()
                    panPoint = currentPoint
                } else {
                    gamelogic.moveShapeLeft()
                    panPoint = currentPoint
                }
            }
        } else if sender.state == .began {
            panPoint = currentPoint
        }
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        gamelogic.dropShape()
    }
    
    @IBAction func pauseGame(_ sender: UIButton) {
        
        self.scene.stopTicking()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let resumeTask = UIAlertAction(title: "RESUME", style: .default) { alertAction in
            self.scene.startTicking()
        }
        alert.addAction(resumeTask)
        self.present(alert, animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
}



