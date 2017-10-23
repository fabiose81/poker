//
//  ViewController.swift
//  poker
//
//  Created by eleves on 2017-10-10.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //--- Déclaration des variables pour l'interface
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    
    @IBOutlet weak var borderSlot_1: UIImageView!
    @IBOutlet weak var borderSlot_2: UIImageView!
    @IBOutlet weak var borderSlot_3: UIImageView!
    @IBOutlet weak var borderSlot_4: UIImageView!
    @IBOutlet weak var borderSlot_5: UIImageView!
    
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var viewBorder2: UIView!
    
    @IBOutlet weak var slideMise: UISlider!
    
    @IBOutlet weak var btStart: UIButton!
    @IBOutlet weak var btRestart: UIButton!
    @IBOutlet weak var btSound: UIButton!
    
    @IBOutlet weak var labelCredit: UILabel!
    @IBOutlet weak var labelMise: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    
    //--- Déclaration des variables pour le code
    var arrayOfSlots = [UIImageView]()
    var arrayOfBlurCards = [UIImage]()
    var arrayOfImageCards = [UIImage]()
    
    var arrayDeckOfCards = [(Int, String)]()
    var arrayOfDeckSelected = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    
    var playerBackground: AVAudioPlayer?
    
    var hand: Int = 0
    var valueCredit: Int = 0
    var valueMise: Int = 0
    
    var soundOn: Bool = true
    
    var pokerHands = PokerHands()
    
    var userDefaultsManager = UserDefaultsManager()
    
    
    //---------
    override func viewDidLoad() {
       
        initFields()
        
        initArrayOfSlots()
        
        initArrayOfBlurCards()
        
        initArrayOfCards()
        
        initSound()
        
        addGestures()
        
        super.viewDidLoad()
    }
    
    
    //--- Fonctions pour mettrer le valeur du mise
    @IBAction func setMise(_ sender: UISlider)
    {
        let roundedValue = round(sender.value / 25) * 25
        sender.value = roundedValue
        valueMise = Int(roundedValue)
        
        let mise = String("Mises: ") + String(Int(sender.value))
        textMise(mise: mise)
        
        let credit = String("Crédits: ") + String(valueCredit - Int(sender.value))
        textCredit(credit: credit)
        
    }
    
    
    //--- Fonctions pour montrer et cacher les cartes
    @objc func showBorderSlot1()
    {
        borderSlot_1.isHidden = !borderSlot_1.isHidden
        slot_1.tag = slot_1.tag * -1
    }
    
    @objc func showBorderSlot2()
    {
       borderSlot_2.isHidden = !borderSlot_2.isHidden
       slot_2.tag = slot_2.tag * -1
    }
    
    @objc func showBorderSlot3()
    {
        borderSlot_3.isHidden = !borderSlot_3.isHidden
        slot_3.tag = slot_3.tag * -1
    }
    
    @objc func showBorderSlot4()
    {
        borderSlot_4.isHidden = !borderSlot_4.isHidden
        slot_4.tag = slot_4.tag * -1
    }
    
    @objc func showBorderSlot5()
    {
       borderSlot_5.isHidden = !borderSlot_5.isHidden
       slot_5.tag = slot_5.tag * -1
    }

    //--- Fonctions action pour recommancer le jeu
    @IBAction func actionRecommancer(_ sender: UIButton)
    {
        textInfo(info: "Sélectionnez votre misse et appuyer le bouton vert")
        recommancer(flag: 0)
    }
    
    //--- Fonctions pour recommancer le jeu
    private func recommancer(flag: Int)
    {
        btStart.isEnabled = true
        btRestart.isEnabled = false
        
        borderSlot_1.isHidden = true
        borderSlot_2.isHidden = true
        borderSlot_3.isHidden = true
        borderSlot_4.isHidden = true
        borderSlot_5.isHidden = true
        
        slot_1.tag = -1
        slot_2.tag = -1
        slot_3.tag = -1
        slot_4.tag = -1
        slot_5.tag = -1
        
        for index in 0..<arrayOfSlots.count
        {
            animationFlipFromLeft(slot: arrayOfSlots[index], image: String("back")+String(index+1))
        }
        
        if flag == 0
        {
            valueCredit = 2000
            labelCredit.textColor = UIColor(rgb: 0xC3C3C3)
        }
        
        slideMise.isEnabled = true
        slideMise.maximumValue = Float(valueCredit)
        slideMise.minimumValue = 0
        slideMise.value = 0
        
        hand = 0
        valueMise = 0
        
        let mise = String("Mises: ") + String(valueMise)
        textMise(mise: mise)
        
        let credit = String("Crédits: ") + String(valueCredit)
        textCredit(credit: credit)
        
    }
    
    //--- Fonctions pour démarrer les champs
    private func initFields()
    {
        if userDefaultsManager.doesKeyExist(theKey: "credit") {
            valueCredit = userDefaultsManager.getValue(theKey: "credit") as! Int
            
            if valueCredit == 0 {
                valueCredit = 2000
            }
        }else{
            valueCredit = 2000
        }
        
        viewBorder.layer.borderWidth = 2
        viewBorder.layer.cornerRadius = 10
        viewBorder.layer.borderColor = UIColor(rgb: 0xC3C3C3).cgColor
        
        viewBorder2.layer.borderWidth = 2
        viewBorder2.layer.cornerRadius = 10
        viewBorder2.layer.borderColor = UIColor(rgb: 0xC3C3C3).cgColor
        
        labelInfo.layer.borderWidth = 2
        labelInfo.layer.cornerRadius = 10
        labelInfo.layer.borderColor = UIColor(rgb: 0xC3C3C3).cgColor
        
        let credit = String("Crédits: ") + String(valueCredit)
        textCredit(credit: credit)
        
        slideMise.maximumValue = Float(self.valueCredit)
        
        if UIScreen.main.bounds.size.width == 480 {
            // iPhone 4
            labelInfo.font = labelInfo.font.withSize(14)
            labelCredit.font = labelCredit.font.withSize(10)
            labelMise.font = labelMise.font.withSize(10)
        } else if UIScreen.main.bounds.size.width == 568 {
            // IPhone 5
            labelInfo.font = labelInfo.font.withSize(16)
            labelCredit.font = labelCredit.font.withSize(12)
            labelMise.font = labelMise.font.withSize(12)
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            labelInfo.font = labelInfo.font.withSize(18)
            labelCredit.font = labelCredit.font.withSize(14)
            labelMise.font = labelMise.font.withSize(14)
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            labelInfo.font = labelInfo.font.withSize(20)
            labelCredit.font = labelCredit.font.withSize(16)
            labelMise.font = labelMise.font.withSize(16)
        }
        
        textInfo(info: "Bienvenue au vidéo-poker Rio!")
    }
    
    //--- Fonctions action pour commencer le jeu
    @IBAction func action(_ sender: UIButton)
    {
        if hand == 0
        {
            if valueMise > 0
            {
               textInfo(info: "Distribuer des cartes...")
               hand += 1
               slideMise.isEnabled = false
               btStart.isEnabled = false
               loading()
            }
            else
            {
               textInfo(info: "Sélectionnez votre misse et appuyer le bouton vert")
               animationFadeIn()
            }
        }
        else
        {
            textInfo(info: "On commance, bonne chance!")
            hand += 1
            btStart.isEnabled = false
            prepareAnimation()
        }
        
    }
    
    //--- Fonctions pour contrôler l'audio
    @IBAction func actionSound(_ sender: UIButton)
    {
        if soundOn
        {
            btSound.setBackgroundImage(UIImage(named: "speakeroff"), for: .normal)
            soundOn = false
            playerBackground?.setVolume(0, fadeDuration: 0)
        }
        else
        {
            btSound.setBackgroundImage(UIImage(named: "speakeron"), for: .normal)
            soundOn = true
            playerBackground?.setVolume(1.0, fadeDuration: 0)
        }
    }
    
    //--- Fonctions pour l'animation avant le jeu commencer
    private func loading()
    {
        for index in 0..<arrayOfSlots.count
        {
            if arrayOfSlots[index].tag == -1
            {
                let delay = Double(index) * 0.2
                UIView.animate(withDuration: 0.2, delay: TimeInterval(delay), options: .curveEaseOut, animations: {
                    self.arrayOfSlots[index].alpha = 0.5
                }) { (true) in
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                        self.arrayOfSlots[index].alpha = 1
                    }) { (true) in
                        if index == self.arrayOfSlots.count - 1{
                            self.prepareAnimation()
                        }
                    }
                }
            }
        }
    }
    
    //--- Fonctions pour commencer le jeu
    private func prepareAnimation()
    {
        arrayOfDeckSelected = selectDeckOfCard()
        
        setInteraction(flag: false)
        
        let time = DispatchTime.now()
        
        var loop = 0;
        
        for index in 0..<arrayOfSlots.count
        {
            if arrayOfSlots[index].tag == -1
            {
                loop += 1
                
                arrayOfSlots[index].animationImages = retournArrayOfImages()
                arrayOfSlots[index].animationRepeatCount = loop   
                arrayOfSlots[index].animationDuration = 1
                arrayOfSlots[index].startAnimating()
            
                let x = Double(loop) - Double(0.5)
                let delay = Double(x)
            
                DispatchQueue.main.asyncAfter(deadline: time + delay, execute: {
                    self.arrayOfSlots[index].stopAnimating()
                    self.arrayOfSlots[index].image = self.retournImage(named: String(self.arrayOfDeckSelected[index].0) + String(self.arrayOfDeckSelected[index].1))
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: time + Double(loop), execute: {
            if self.hand == 2
            {
                self.checkHand(hand: self.arrayOfDeckSelected)
            }
            else
            {
                self.textInfo(info: "Sélectionnez ou pas votre cartes et appuyer le bouton vert")
                self.btStart.isEnabled = true;
                self.setInteraction(flag: true)
            }
        })
    }
    
    //--- Fonctions pour obtenir les cartes sélectionnées
    private func selectDeckOfCard() -> [(Int, String)]
    {
        var arrayDeckOfCardsTemp = arrayDeckOfCards
        
        for index in 0..<arrayOfSlots.count
        {
            if arrayOfSlots[index].tag == -1
            {
                let randomIndex = Int(arc4random_uniform(UInt32(arrayDeckOfCardsTemp.count)))
                arrayOfDeckSelected[index] = arrayDeckOfCardsTemp[randomIndex]
                arrayDeckOfCardsTemp.remove(at: randomIndex)
            }
        }
        
        return arrayOfDeckSelected
    }
    
    //--- Fonctions pour fair la comparaison de les cartes obtenu
    private func checkHand(hand: [(Int, String)])
    { 
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "Quinte Flush Royale")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "Quinte Flush")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "Carré")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "Full")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "Couleur")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "Quinte")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "Brelan")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "Deux Paires")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "Paires")
        } else {
            calculateHand(times: 0, handToDisplay: "Rien...")
        }
    }
    
    //--- Fonctions pour monttre le résultat
    func calculateHand(times: Int, handToDisplay: String)
    {
        textInfo(info: handToDisplay)
       
        valueCredit += (times * valueMise)
        
        userDefaultsManager.setKey(theValue: valueCredit as AnyObject, key: "credit")
        
        if valueCredit <= 0
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(1.5), execute: {
                self.textInfo(info: "Fin de jeu, appuyez le bouton bleu pour recommencer")
                self.btRestart.isEnabled = true
            })
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(1.5), execute: {
                self.textInfo(info: "Sélectionnez votre misse et appuyer le bouton vert")
                self.textCredit(credit: "Crédits: \(self.valueCredit)")
                self.labelCredit.textColor = (times == 0 ? UIColor(rgb: 0xE12B2E) : UIColor(rgb: 0x007C3D))
                self.animationScaleUp(view: self.labelCredit)
                self.recommancer(flag: 1)
            })
        }
    }

    
    //--- Fonctions pour obtenir le table de cartes
    private func retournArrayOfImages() -> [UIImage]
    {
        var array = [UIImage]()
        
        for _ in 1..<6 {
            let randomIndex = Int(arc4random_uniform(UInt32(arrayOfBlurCards.count)))
            array.append(arrayOfBlurCards[randomIndex])
        }
        
        return array
    }
    
    //--- Fonctions pour obtenir l'image
    private func retournImage(named: String) -> UIImage
    {
        return UIImage(named: named)!
    }
    
    //--- Fonctions pour mettre l'interaction des cartes
    private func addGestures()
    {
        slot_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot1)))
        slot_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot2)))
        slot_3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot3)))
        slot_4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot4)))
        slot_5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot5)))
        
        setInteraction(flag: false)
    }
    
    //--- Fonctions pour enlever l'interaction des cartes
    private func setInteraction(flag : Bool)
    {
        slot_1.isUserInteractionEnabled = flag;
        slot_2.isUserInteractionEnabled = flag;
        slot_3.isUserInteractionEnabled = flag;
        slot_4.isUserInteractionEnabled = flag;
        slot_5.isUserInteractionEnabled = flag;
    }
    
    //--- Fonctions pour commencer insérer des images sur le table
    private func initArrayOfSlots()
    {
      arrayOfSlots = [slot_1, slot_2, slot_3, slot_4, slot_5]
    }
    
    //--- Fonctions pour commencer le table des cardes d'animation
    private func initArrayOfBlurCards()
    {
        for index in 1..<11
        {
            arrayOfBlurCards.append(retournImage(named: String("blur") + String(index)))
        }
    }
    
    //--- Fonctions pour commencer le table des cardes
    private func initArrayOfCards()
    {
        for a in 0...3
        {
            let suits = ["d", "c", "cl", "s"]
            for b in 1...13
            {
                arrayDeckOfCards.append((b, suits[a]))
            }
        }
    }
    
    //--- Fonctions pour commencer l'audio
    func initSound()
    {
        guard let urlBackground = Bundle.main.url(forResource: "background", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            playerBackground = try AVAudioPlayer(contentsOf: urlBackground)
            playerBackground?.setVolume(1.0, fadeDuration: 0)
            playerBackground?.numberOfLoops = -1
            playerBackground?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    //--- Fonctions des animations
    private func animationFlipFromLeft(slot: UIImageView, image: String)
    {
        slot.image = retournImage(named: image)
        UIView.transition(with: slot, duration: 0.5, options: .transitionFlipFromLeft, animations: nil){ (true) in}
    }
    
    private func animationScaleUp(view: UIView)
    {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (true) in
            self.animationScaleDown(view: view)
        }
    }
    
    private func animationScaleDown(view: UIView)
    {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (true) in
        }
    }
    
    private func animationFadeIn(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.slideMise.alpha = 0
        }) { (true) in
            self.animationFadeOut()
        }
    }
    
    private func animationFadeOut(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.slideMise.alpha = 1
        }) { (true) in
        }
    }
    
    //--- Fonctions pour mettre des informations (Info, Credit, Mise)
    private func textInfo(info: String) {
        labelInfo.text = info
    }
    
    private func textCredit(credit: String) {
        labelCredit.text = credit
    }
    
    private func textMise(mise: String) {
        labelMise.text = mise
    }
}

