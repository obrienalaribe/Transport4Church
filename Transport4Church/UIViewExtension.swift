//
//  UIViewExtension.swift
//  Transport4Church
//
//  Created by mac on 8/7/16.
//  Copyright © 2016 rccg. All rights reserved.
//


//
//  UIViewExtension.swift
//  SLOCO
//
//  Created by mac on 5/24/16.
//  Copyright © 2016 sloco. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(format:String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        
        //push all the views into a dictionary
        for(index, view) in views.enumerate() {
            let key = "v\(index)" //i.e v0, v1
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}

extension UILabel {
    func flash() {
        self.alpha = 0.0;
        UIView.animateWithDuration(1.1, //Time duration you want,
            delay: 0.0,
            options: [.CurveEaseInOut, .Autoreverse, .Repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
}

extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(self.size.width + insets.left + insets.right,
                self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.drawAtPoint(origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
}