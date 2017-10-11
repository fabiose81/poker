//
//  ViewController.swift
//  poker
//
//  Created by eleves on 2017-10-10.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

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
  
    override func viewDidLoad() {
        //---
        
        initArrayOfSlots()
        
        initArrayOfBlurCards()
        
        super.viewDidLoad()
    }
    
    @IBAction func action(_ sender: UIButton)
    {
       btStart.setBackgroundImage(UIImage(named: "button2"), for: .normal)
     //  btStart.isEnabled = false;
      // btStart.adjustsImageWhenDisabled = false;
        
       prepareAnimation()
    }
    
    private func prepareAnimation()
    {
        for index in 0..<arrayOfSlots.count
        {
            let delay = Double(index) * 0.3
            UIView.animate(withDuration: 0.2, delay: TimeInterval(delay), options: .curveEaseOut, animations: {
                self.arrayOfSlots[index].alpha = 0.5
            }) { (true) in
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                    self.arrayOfSlots[index].alpha = 1
                }) { (true) in
                    if index == self.arrayOfSlots.count - 1{
                        self.btStart.setBackgroundImage(UIImage(named: "button"), for: .normal)
                        self.startAnimation()
                    }
                }
            }
        }
    }
    
    private func startAnimation()
    {
        for index in 0..<arrayOfSlots.count
        {
            arrayOfSlots[index].animationImages = retournArrayOfImages()
            arrayOfSlots[index].animationRepeatCount = Int((index + 1))
            arrayOfSlots[index].animationDuration = 1.0
            arrayOfSlots[index].startAnimating()
        }
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
}

