//
//  HomeViewController.swift
//  mobileapp-tetris
//
//  Created by Khim Bahadur Gurung on 29.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//

import UIKit

var blockColor = ""

class HomeViewController: UIViewController {
    
    var block = Block(column:0 , row:0, color:blockColor)
    
    @IBOutlet weak var blueTap: UIImageView!
    @IBOutlet weak var yellowTap: UIImageView!
    @IBOutlet weak var tealTap: UIImageView!
    @IBOutlet weak var orangeTap: UIImageView!
    @IBOutlet weak var redTap: UIImageView!
    @IBOutlet weak var purpleTap: UIImageView!
    
    @IBAction func tapToPlay(_ sender: UIButton) {
        performSegue(withIdentifier: "showGameBoard", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.blueColorSelected))
        let yellowTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.yellowColorSelected))
        let tealTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tealColorSelected))
        let orangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.orangeColorSelected))
        let redTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.redColorSelected))
        let purpleTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.purpleColorSelected))
        
        self.blueTap.addGestureRecognizer(blueTapGesture)
        self.yellowTap.addGestureRecognizer(yellowTapGesture)
        self.tealTap.addGestureRecognizer(tealTapGesture)
        self.orangeTap.addGestureRecognizer(orangeTapGesture)
        self.redTap.addGestureRecognizer(redTapGesture)
        self.purpleTap.addGestureRecognizer(purpleTapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    func getBlockColor()->String{
        return blockColor
    }
    
    @objc func blueColorSelected() {
        blockColor = "blue"
        blueTap.layer.borderWidth = 6
        yellowTap.layer.borderWidth = 0
        tealTap.layer.borderWidth = 0
        orangeTap.layer.borderWidth = 0
        redTap.layer.borderWidth = 0
        purpleTap.layer.borderWidth = 0
    }
    @objc func yellowColorSelected() {
        blockColor = "yellow"
        blueTap.layer.borderWidth = 0
        yellowTap.layer.borderWidth = 6
        tealTap.layer.borderWidth = 0
        orangeTap.layer.borderWidth = 0
        redTap.layer.borderWidth = 0
        purpleTap.layer.borderWidth = 0
    }
    @objc func tealColorSelected() {
        blockColor = "teal"
        blueTap.layer.borderWidth = 0
        yellowTap.layer.borderWidth = 0
        tealTap.layer.borderWidth = 6
        orangeTap.layer.borderWidth = 0
        redTap.layer.borderWidth = 0
        purpleTap.layer.borderWidth = 0
    }
    @objc func orangeColorSelected() {
        blockColor = "orange"
        blueTap.layer.borderWidth = 0
        yellowTap.layer.borderWidth = 0
        tealTap.layer.borderWidth = 0
        orangeTap.layer.borderWidth = 6
        redTap.layer.borderWidth = 0
        purpleTap.layer.borderWidth = 0
    }
    @objc func redColorSelected() {
        blockColor = "red"
        blueTap.layer.borderWidth = 0
        yellowTap.layer.borderWidth = 0
        tealTap.layer.borderWidth = 0
        orangeTap.layer.borderWidth = 0
        redTap.layer.borderWidth = 6
        purpleTap.layer.borderWidth = 0
    }
    @objc func purpleColorSelected() {
         blockColor = "purple"
         blueTap.layer.borderWidth = 0
         yellowTap.layer.borderWidth = 0
         tealTap.layer.borderWidth = 0
         orangeTap.layer.borderWidth = 0
         redTap.layer.borderWidth = 0
         purpleTap.layer.borderWidth = 6
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
