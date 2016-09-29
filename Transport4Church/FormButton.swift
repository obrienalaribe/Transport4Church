//
//  FormButton.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation


class FormButton: UIButton {
    init(title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.setTitle(title, forState: .Normal)
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = BrandColours.PRIMARY.color
        self.tintColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum BrandColours {
    case PRIMARY
    
    private static let associatedValues = [
        PRIMARY: (color: UIColor(red:0.03, green:0.79, blue:0.49, alpha:1.0), value: "primary")
    ]
    
    var color: UIColor {
        return BrandColours.associatedValues[self]!.color
    }
    
    var value: String {
        return BrandColours.associatedValues[self]!.value;
    }
    
}
