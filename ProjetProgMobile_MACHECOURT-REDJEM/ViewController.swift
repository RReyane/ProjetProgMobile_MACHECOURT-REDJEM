//
//  ViewController.swift
//  ProjetProgMobile_MACHECOURT-REDJEM
//
//  Created by Reyane Redjem on 02/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var cible:CGPoint!
    var radians:CGFloat!
    @IBOutlet var Joueur: [UIImageView]!
    
    var t: Timer!
    var velocity = CGPoint(x: 15, y: 13)
    var isBallmoving = false
    
    
    @IBOutlet weak var ball: UIImageView!
    
    func move(){ // We should manage here the movement of the ball
        print("La balle est en x(\(ball.frame.origin.x)) et y(\(ball.frame.origin.y))")
        ball.isHidden = false
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
        
        t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let doigt = touches.randomElement()!
//        let point = doigt.location(in: view)
//        print("vous avez touché a la position x:\(point.x) y:\(point.y)")
//    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt = touches.randomElement()!
        cible = doigt.location(in: view)
        
        var dX = cible!.x-Joueur[0].center.x;        // distance along X
        var dY = cible!.y-Joueur[0].center.y;        // distance along Y
        radians = atan2(dY, dX)+1.5;
        if radians > 1 {
            radians = 1
        }
        if radians < -1 {
            radians = -1
        }
        print(radians)
        
        Joueur[0].transform = CGAffineTransformMakeRotation(radians)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //ball.frame.origin = CGPoint(x:Joueur[0].center.x+20,y:Joueur[0].center.y+(radians*20))
        //BESOIN DE FAIRE EN SORTE QUE LA BALLE PARTE DANS LA DIRECTION DU CANON
        isBallmoving = true
    }
}

