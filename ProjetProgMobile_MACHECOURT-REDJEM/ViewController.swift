//
//  ViewController.swift
//  ProjetProgMobile_MACHECOURT-REDJEM
//
//  Created by Reyane Redjem on 02/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var cible:CGPoint! // endroit visé par le doigt
    var radians:CGFloat! // angle entre le canon et la cible
    @IBOutlet var Joueur: [UIImageView]! //liste Joueur 0:canon,1:kart
    
    var t: Timer!
    var tempsEcoule = 0.0
    var vitesse = 15.0
    var velocity: CGPoint! // velocité de la balle
    var isBallmoving = false // drapeau mouvement balle
    
    
    @IBOutlet weak var ball: UIImageView!
    
    func move(){ // We should manage here the movement of the ball
        tempsEcoule = 0 // remise du timer a 0
        vitesse = 15 // remise de la vitesse a sa valeur originel
        
        ball.isHidden = false
        
        var p : CGPoint = ball.frame.origin //position de la balle
        let s = ball.frame.size //taille de la balle
        let e = CGRect(x: 50, y: 235, width: 345, height: 640) //taille de l'ecran
        
        p.x += velocity.x
        p.y += velocity.y
        ball.frame.origin = p
        
        if p.x + s.width > e.width || p.x < e.minX { //rebond sur un mur vertical
            velocity.x = -velocity.x
        }
        if p.y < e.minY { //rebond sur le mur du haut
            velocity.y = -velocity.y
        }
        if p.y + s.height > e.height { //arret sur le mur du bas
            ball.isHidden = true
            isBallmoving = false
            velocity.x = 0
            velocity.y = 0
        }
    }
    
    @objc func loop(t:Timer){
        if isBallmoving {
            move()
            
            vitesse += 0.8 * Double(tempsEcoule)
            tempsEcoule += 0.05
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        if !isBallmoving {
            let dX = cible!.x-Joueur[0].center.x // distance X entre la cible et le canon
            let dY = cible!.y-Joueur[0].center.y // distance Y entre la cible et le canon
            radians = atan2(dY, dX) + .pi/2 // calcul de l'angle entre la cible et le canon
            // limitation de l'angle max et min
            if radians > 1 && radians < 3 {
                radians = 1
            }
            if radians < -1 || radians > 3 {
                radians = -1
            }
            
            Joueur[0].transform = CGAffineTransformMakeRotation(radians) // rotation du canon vers la cible
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,     with event: UIEvent?) {
        if !isBallmoving {
            if radians != nil {
                let joueurHeight = Joueur[0].bounds.size.height / 2.0
                let joueurWidth = Joueur[0].bounds.size.width / 2.0
                let distance = sqrt(pow(joueurHeight,2.0)+pow(joueurWidth,2.0)) - 25.0// distance entre la balle et le centre du cannon
                
                let ballX = Joueur[0].center.x + CGFloat(cos(radians - .pi/2)) * distance
                let ballY = Joueur[0].center.y + CGFloat(sin(radians - .pi/2)) * distance
                
                ball.center = CGPoint(x:ballX,y:ballY) // set de la position de la balle par rapport a la nouvelle orientation du canon
                velocity = CGPoint(x: cos(radians - .pi/2) * CGFloat(vitesse), y: sin(radians - .pi/2) * CGFloat(vitesse)) // set de la direction dans laquelle la balle part
                isBallmoving = true // fait bouger la balle
            }
        }
    }
}
