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
    
    @IBOutlet weak var btStart: UIButton!
    
    var arrayOfSlots = [UIImageView]()
    var arrayOfBlurCards = [UIImage]()
    var arrayOfImageCards = [UIImage]()
    
    var arrayDeckOfCards = [(Int, String)]()
    
    var playerBackground: AVAudioPlayer?
    var playerPlay: AVAudioPlayer?
  
    override func viewDidLoad() {
        //---
        
        initArrayOfSlots()
        
        initArrayOfBlurCards()
        
        initArrayOfCards()
        
        initSound()
        
        super.viewDidLoad()
    }
    
    @IBAction func action(_ sender: UIButton)
    {
       btStart.setBackgroundImage(UIImage(named: "button2"), for: .normal)
     //  btStart.isEnabled = false;
      // btStart.adjustsImageWhenDisabled = false;
        
       loading()
    }
    
    private func loading()
    {
        for index in 0..<arrayOfSlots.count
        {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.1, delay: TimeInterval(delay), options: .curveEaseOut, animations: {
                self.arrayOfSlots[index].alpha = 0.5
            }) { (true) in
                UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseOut, animations: {
                    self.arrayOfSlots[index].alpha = 1
                }) { (true) in
                    if index == self.arrayOfSlots.count - 1{
                        self.btStart.setBackgroundImage(UIImage(named: "button"), for: .normal)
                        self.prepareAnimation()
                    }
                }
            }
        }
    }
    
    var timer : Timer?
    
    private func prepareAnimation()
    {
        playerBackground?.stop()
        playerPlay?.play()
        
        var arrayOfDeckSelected = selectDeckOfCard()
        
        let time = DispatchTime.now()
        
        for index in 0..<arrayOfSlots.count
        {
            arrayOfSlots[index].animationImages = retournArrayOfImages()
            arrayOfSlots[index].animationRepeatCount = Int((index + 1))
            arrayOfSlots[index].animationDuration = 1.4
            arrayOfSlots[index].startAnimating()
            
            let delay = Double(index) + 0.9
            
            DispatchQueue.main.asyncAfter(deadline: time + delay, execute: {
                self.arrayOfSlots[index].stopAnimating()
                self.arrayOfSlots[index].image = self.retournImage(named: String(arrayOfDeckSelected[index].0) + String(arrayOfDeckSelected[index].1))
            })
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

