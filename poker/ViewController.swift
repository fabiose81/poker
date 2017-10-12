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
    
    //---
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
    
    @IBOutlet weak var slideMise: UISlider!
    
    @IBOutlet weak var btStart: UIButton!
    @IBOutlet weak var btSound: UIButton!
    
    @IBOutlet weak var labelCredit: UILabel!
    @IBOutlet weak var labelMise: UILabel!
    
    var arrayOfSlots = [UIImageView]()
    var arrayOfBlurCards = [UIImage]()
    var arrayOfImageCards = [UIImage]()
    
    var arrayDeckOfCards = [(Int, String)]()
    
    var playerBackground: AVAudioPlayer?
    var playerPlay: AVAudioPlayer?
    
    var countTurn: Int = 0
    var valueCredit: Int = 2000
    var valueMise: Int = 0
    
    var soundOn: Bool = true
    
    var currentSound = "background"
  
    override func viewDidLoad() {
        //---
        
        countTurn = 0;
        
        initAddGestures()
        
        initArrayOfSlots()
        
        initArrayOfBlurCards()
        
        initArrayOfCards()
        
       // initSound()
        
        super.viewDidLoad()
    }
    
    @IBAction func setMise(_ sender: UISlider)
    {
        
        let roundedValue = round(sender.value / 25) * 25
        sender.value = roundedValue
        valueMise = Int(roundedValue)
        
        let mise = String("Mises :") + String(Int(sender.value))
        labelMise.text = mise
        
        let credit = String("Crédits :") + String(valueCredit - Int(sender.value))
        labelCredit.text = credit
        
    }
    
    @objc func showBorderSlot1()
    {
        if countTurn > 0
        {
            borderSlot_1.isHidden = !borderSlot_1.isHidden
            slot_1.tag = slot_1.tag * -1
        }
    }
    
    @objc func showBorderSlot2()
    {
        if countTurn > 0
        {
            borderSlot_2.isHidden = !borderSlot_2.isHidden
            slot_2.tag = slot_2.tag * -1
        }
    }
    
    @objc func showBorderSlot3()
    {
        if countTurn > 0
        {
            borderSlot_3.isHidden = !borderSlot_3.isHidden
            slot_3.tag = slot_3.tag * -1
        }
    }
    
    @objc func showBorderSlot4()
    {
        if countTurn > 0
        {
            borderSlot_4.isHidden = !borderSlot_4.isHidden
            slot_4.tag = slot_4.tag * -1
        }
    }
    
    @objc func showBorderSlot5()
    {
        if countTurn > 0
        {
            borderSlot_5.isHidden = !borderSlot_5.isHidden
            slot_5.tag = slot_5.tag * -1
        }
    }

    @IBAction func actionRecommancer(_ sender: UIButton)
    {
        
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
        
        countTurn = 0
        
        valueCredit = 2000
        
        valueMise = 0
        
        
        let mise = String("Mises :") + String(valueMise)
        labelMise.text = mise
        
        let credit = String("Crédits :") + String(valueCredit)
        labelCredit.text = credit
        
        slideMise.maximumValue = Float(self.valueCredit)
        slideMise.minimumValue = 25
        slideMise.value = 25
        
    }
    
    @IBAction func action(_ sender: UIButton)
    {
            currentSound = "play"
        
            valueCredit -= valueMise
        
            btStart.setBackgroundImage(UIImage(named: "button2"), for: .normal)
            /*btStart.isEnabled = false;
            btStart.adjustsImageWhenDisabled = false;*/
        
            countTurn += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 , execute: {
            self.btStart.setBackgroundImage(UIImage(named: "button"), for: .normal)
      
            if self.countTurn == 1
            {
                self.loading()
            }
            else
            {
                self.prepareAnimation()
            }
        })
    }
    
    @IBAction func actionSound(_ sender: UIButton)
    {
        if soundOn
        {
            btSound.setBackgroundImage(UIImage(named: "speakeroff"), for: .normal)
            soundOn = false
            playerBackground?.stop()
            playerPlay?.stop()
        }
        else
        {
            btSound.setBackgroundImage(UIImage(named: "speakeron"), for: .normal)
            soundOn = true
            
            if currentSound == "background"
            {
               playerBackground?.play()
            }
            else
            {
                playerPlay?.play()
            }
            
        }
    }
    
    private func animationFlipFromLeft(slot: UIImageView, image: String)
    {
        slot.image = retournImage(named: image)
        UIView.transition(with: slot, duration: 0.5, options: .transitionFlipFromLeft, animations: nil){ (true) in}
    }
    
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
    
    private func prepareAnimation()
    {
        
        if soundOn {
            playerBackground?.stop()
            playerPlay?.play()
        }
        
        var arrayOfDeckSelected = selectDeckOfCard()
        
        let time = DispatchTime.now()
        
        for index in 0..<arrayOfSlots.count
        {
            if arrayOfSlots[index].tag == -1
            {
                arrayOfSlots[index].animationImages = retournArrayOfImages()
                arrayOfSlots[index].animationRepeatCount = Int((index + 1))
                arrayOfSlots[index].animationDuration = 1.4
                arrayOfSlots[index].startAnimating()
            
                let delay = Double(index) + 0.9
            
                DispatchQueue.main.asyncAfter(deadline: time + delay, execute: {
                    self.arrayOfSlots[index].stopAnimating()
                    self.arrayOfSlots[index].image = self.retournImage(named: String(arrayOfDeckSelected[index].0) + String(arrayOfDeckSelected[index].1))
                   
                    if index == self.arrayOfSlots.count - 1 {
                        self.slideMise.maximumValue = Float(self.valueCredit)
                        self.slideMise.minimumValue = 25
                        self.slideMise.value = 25
                    }
                })
            }
        }
    }

    
    private func selectDeckOfCard() -> [(Int, String)]
    {
        var arrayOfDeckSelected = [(Int, String)]()
        var arrayDeckOfCardsTemp = arrayDeckOfCards
        
        for _ in 1...5
        {
            let randomIndex = Int(arc4random_uniform(UInt32(arrayDeckOfCardsTemp.count)))
            arrayOfDeckSelected.append(arrayDeckOfCardsTemp[randomIndex])
            arrayDeckOfCardsTemp.remove(at: randomIndex)
        }
        
        return arrayOfDeckSelected
    }
    
    private func retournArrayOfImages() -> [UIImage]
    {
        var array = [UIImage]()
        
        for _ in 1..<6 {
            let randomIndex = Int(arc4random_uniform(UInt32(arrayOfBlurCards.count)))
            array.append(arrayOfBlurCards[randomIndex])
        }
        
        return array
    }
    
    private func retournImage(named: String) -> UIImage
    {
        return UIImage(named: named)!
    }
    
    
    private func initAddGestures()
    {
        slot_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot1)))
        slot_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot2)))
        slot_3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot3)))
        slot_4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot4)))
        slot_5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.showBorderSlot5)))
    }
    
    private func initArrayOfSlots()
    {
      arrayOfSlots = [slot_1, slot_2, slot_3, slot_4, slot_5]
    }
    
    private func initArrayOfBlurCards()
    {
        for index in 1..<11
        {
            arrayOfBlurCards.append(retournImage(named: String("blur") + String(index)))
        }
    }
    
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
    
    func initSound()
    {
        guard let urlBackground = Bundle.main.url(forResource: "background", withExtension: "mp3") else { return }
        guard let urlPlay = Bundle.main.url(forResource: "play", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            playerBackground = try AVAudioPlayer(contentsOf: urlBackground)
            playerBackground?.setVolume(1.0, fadeDuration: 0)
            playerBackground?.numberOfLoops = 10
            playerBackground?.play()
            
            playerPlay = try AVAudioPlayer(contentsOf: urlPlay)
            playerPlay?.setVolume(1.0, fadeDuration: 0)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

