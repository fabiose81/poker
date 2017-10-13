//
//  CustomSlider.swift
//  poker
//
//  Created by eleves on 2017-10-13.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider: UISlider {

    @IBInspectable var thumbImage: UIImage?
    {
        didSet{
            setThumbImage(#imageLiteral(resourceName: "chip.png"), for: .normal)
        }
    }

}
