//
//  ViewController.swift
//  ProjetProgMobile_MACHECOURT-REDJEM
//
//  Created by Reyane Redjem on 02/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var t: Timer!
    var velocity = CGPoint(x: 15, y: 13)
    var isBallmoving = false
    
    
    @IBOutlet weak var ball: UIImageView!
    
    func move(){ // We should manage here the movement of the ball
        print("La balle est en x(\(ball.frame.origin.x)) et y(\(ball.frame.origin.y))")
        var p : CGPoint = ball.frame.origin
        let s = ball.frame.size
        let e = CGRect(x: 25, y: 200, width: 375, height: 650)
        p.x += velocity.x
        p.y += velocity.y
        ball.frame.origin = p
        if p.x + s.width > e.width || p.x < e.minX {
            velocity.x = -velocity.x
        }
        if p.y < e.minY {
            velocity.y = -velocity.y
        }
        if p.y + s.height > e.height {
            ball.isHidden = true
            velocity.x = 0
            velocity.y = 0
        }
    }
    
    @objc func loop(t:Timer){
        if isBallmoving {
            move()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ball.frame.origin = CGPoint(x: 200, y: 200)
        isBallmoving = true // we can choose if the ball is moving or not here
        
        t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
    }


}

