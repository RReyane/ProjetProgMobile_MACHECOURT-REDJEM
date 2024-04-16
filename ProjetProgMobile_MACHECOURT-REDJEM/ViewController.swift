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
    var tempsEcoule = 0.0 // temps ecoulé durant chaque tour
    var vitesse = 15.0
    var velocity: CGPoint! // velocité de la balle
    var isBallmoving = false // drapeau mouvement balle
    
    @IBOutlet weak var ballImage: UIImageView!
    struct monstre { //structure de monstre, une image et des PV
        var image: UIImageView
        var pv = 1
        var attackType = 1 //0= corpsAcorps, 1 = distance
    }
    var listeMonstres: [monstre]! //liste de monstre
    
    @IBOutlet weak var numVague: UILabel!
    var cptVague = 0
    
    func move(){ // We should manage here the movement of the ball

        
        ballImage.isHidden = false
        
        var p : CGPoint = ballImage.frame.origin //position de la balle
        let s = ballImage.frame.size //taille de la balle
        let e = CGRect(x: 50, y: 235, width: 345, height: 640) //taille de l'ecran
        
        p.x += velocity.x
        p.y += velocity.y
        ballImage.frame.origin = p
        
        if p.x + s.width > e.width || p.x < e.minX { //rebond sur un mur vertical
            velocity.x = -velocity.x
        }
        if p.y < e.minY { //rebond sur le mur du haut
            velocity.y = -velocity.y
        }
        if p.y + s.height > e.height { //arret sur le mur du bas
            ballImage.isHidden = true
            isBallmoving = false
            
            cptVague += 1
            numVague.text = String(cptVague)
            
            velocity.x = 0
            velocity.y = 0
            
        }
        
        
    }
    
    @objc func loop(t:Timer){
        if isBallmoving {
            move()
            
            Joueur[0].center.x = ballImage.center.x
            Joueur[1].center.x = ballImage.center.x
            
            vitesse += 0.8 * Double(tempsEcoule)
            tempsEcoule += 0.05
        }
        else{
            tempsEcoule = 0 // remise du timer a 0
            vitesse = 15 // remise de la vitesse a sa valeur originel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(ballImage.center)
//        listeBalles.append(Balle(image:UIImageView(image:UIImage(named: "Punball_Ball.png"))))
        t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(loop), userInfo: nil, repeats: true) // initialisation de la boucle de jeu
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
                
                ballImage.center = CGPoint(x:ballX,y:ballY) // set de la position de la balle par rapport a la nouvelle orientation du canon
                velocity = CGPoint(x: cos(radians - .pi/2) * CGFloat(vitesse), y: sin(radians - .pi/2) * CGFloat(vitesse)) // set de la direction dans laquelle la balle part
                isBallmoving = true // fait bouger la balle
            }
        }
    }
    
    
    func spawnRandomEnnemies(){
        let nomsMonstre = ["Punball_Ennemi_PeaLauncher","PunBall_Ennemi_Skeleton"]
        
        var nbMonstre: Int!
        
        switch Int.random(in: 0...10) {
        case 5...8:
            nbMonstre = 2
        case 9...10:
            nbMonstre = 3
        default:
            nbMonstre = 1
        }
        
//        for _ in 1...nbMonstre!{
//            listeMonstres.append(monstre(image: UIImageView(image: UIImage(named: nomsMonstre[0]))))
//        }
    }
}
