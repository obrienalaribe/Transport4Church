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
    
    func centerItemToParent(item:UIView, parent:UIView) {
        //center to parent
        addConstraint(NSLayoutConstraint(item: item, attribute: .CenterY, relatedBy: .Equal, toItem: parent, attribute: .CenterY, multiplier: 1, constant: 0))
        
    }
    
    
    
    
    // Given an item, stretches the width and height of the view to the toItem.
    func  stretchToBoundsOfSuperView()  {
        let constraints =
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[item]|", options:  NSLayoutFormatOptions(), metrics: nil, views: ["item" : self]) +
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[item]|", options:  NSLayoutFormatOptions(), metrics: nil, views: ["item" : self])
        if let superview = self.superview {
            superview.addConstraints(constraints)
        }
    }
    
    func alignTopTo(toItem: UIView, padding: CGFloat)  {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: padding)
        self.superview?.addConstraint(constraint)
    }
    
    func centerHorizontallyTo(toItem: UIView)  {
        return self.centerHorizontallyTo(toItem, padding: 0)
    }
    
    func centerHorizontallyTo(toItem: UIView, padding: CGFloat)  {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: padding)
        self.superview?.addConstraint(constraint)
    }
    
    func centerVerticallyTo(toItem: UIView)  {
        return self.centerVerticallyTo(toItem, padding: 0)
    }
    
    func centerVerticallyTo(toItem: UIView, padding: CGFloat)  {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: padding)
        self.superview?.addConstraint(constraint)
    }
    
    func stretchToWidthOfSuperView()  {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[item]|", options:  NSLayoutFormatOptions(), metrics: nil, views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func stretchToWidthOfSuperView(padding: CGFloat) {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[item]-padding-|", options:  NSLayoutFormatOptions(), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func stretchToHeightOfSuperView() {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[item]|", options:  NSLayoutFormatOptions(), metrics: nil, views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func stretchToHeightOfSuperView(padding: CGFloat) {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[item]-padding-|", options:  NSLayoutFormatOptions(), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainToTopOfSuperView(padding: CGFloat) {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[item]", options:  NSLayoutFormatOptions(), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainToLeftOfSuperView(padding: CGFloat) {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-padding-[item]", options:  NSLayoutFormatOptions(), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainToBottomOfSuperView(padding: CGFloat)  {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[item]-padding-|", options:  NSLayoutFormatOptions(), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainToRightOfSuperView(padding: CGFloat) {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[item]-padding-|", options:  NSLayoutFormatOptions(), metrics: ["padding" : padding], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainWidth(width: CGFloat)  {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[item(width)]", options:  NSLayoutFormatOptions(), metrics: ["width" : width], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainHeight(height: CGFloat) {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[item(height)]", options:  NSLayoutFormatOptions(), metrics: ["height" : height], views: ["item" : self])
        self.superview?.addConstraints(constraints)
    }
    
    func constrainWidthTo(toItem: UIView)  {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        self.superview?.addConstraint(constraint)
    }
    
    func constrainHeightTo(toItem: UIView) {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        self.superview?.addConstraint(constraint)
    }
    
    func anchorToBottom(toItem: UIView, padding: CGFloat) {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: padding)
        self.superview?.addConstraint(constraint)
    }
    
    func anchorToRight(toItem: UIView, padding: CGFloat) {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
        
        self.superview?.addConstraint(constraint)
    }
    
    func anchorToTop(toItem: UIView, padding: CGFloat)  {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -padding)
        self.superview?.addConstraint(constraint)
    }
    
    func anchorToLeft(toItem: UIView, padding: CGFloat)  {
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Left , multiplier: 1.0, constant: -padding)
        self.superview?.addConstraint(constraint)
    }
    
}

