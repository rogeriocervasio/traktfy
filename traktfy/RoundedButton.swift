//
//  RoundedButton.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 12/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    // Inspectable properties
    // Set the corner radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    // Border width
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // Border color
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    // Touch event's
    // Animation touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        UIView.animate(withDuration: 0.001) {
            self.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            self.alpha = 0.6
        }
    }
    
    // Animation touches ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.alpha = 1.0
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
        
    }
}
