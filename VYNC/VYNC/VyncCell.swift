//
//  VyncCell.swift
//  VYNC
//
//  Created by Thomas Abend on 1/21/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import UIKit

class VyncCell: UITableViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lengthLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var statusLogo: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    var isMoving = false
    var isFlipped = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        lengthLabel.layer.masksToBounds = true
        lengthLabel.layer.cornerRadius = 12.5
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTapCell:")
        singleTap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target:self, action: "doubleTapCell:")
        doubleTap.numberOfTapsRequired = 2
        
        self.addGestureRecognizer(singleTap)
        self.addGestureRecognizer(doubleTap)
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.subTitle.hidden = true
        // Configure the view for the selected state
//        self.backgroundColor = UIColor.redColor()
    }
    
    func singleTapCell(sender:UITapGestureRecognizer){
        println("single tapped")
        self.selectCellAnimation()
    }
    
    func doubleTapCell(sender:UITapGestureRecognizer){
        println("double tapped \(self.contentView)")
        
        
        if self.isFlipped {
            println("going back")
            let view = viewWithTag(19)
            UIView.transitionFromView(view!, toView: self.contentView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromBottom, completion: nil)
            self.isFlipped = false
        } else {
            let view = UIView()
            view.bounds = self.bounds
            view.backgroundColor = UIColor.redColor()
            view.tag = 19
            UIView.transitionFromView(self.contentView, toView: view, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromTop, completion: nil)
            self.isFlipped = true
            println(view)
        }
        
    }
    
    func selectCellAnimation() {
        if self.isMoving == false {
            self.isMoving = true
            UIView.animateWithDuration(0.33, delay:0, options: .CurveEaseIn, animations:{
                self.titleLabel.transform = CGAffineTransformMakeTranslation(0, -3)
                self.contentView.layoutIfNeeded()
                }, completion:
                { finished in
                    self.subTitle.textColor = UIColor.blackColor()
                    self.deselectCellAnimation()
                })
        }
    }
    
    func deselectCellAnimation() {
        UIView.animateWithDuration(0.5, delay:2.5, options: .CurveEaseIn, animations:{
            self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.contentView.layoutIfNeeded()
            }, completion:
            { finished in
                self.subTitle.textColor = UIColor.clearColor()
                self.isMoving = false
            }
        )
    }
    
}


//class ClickCellAnimator {
//    // placeholder for things to come -- only fades in for now
//    class func animate(cell:VyncCell) {
//        UIView.animateWithDuration(0.5, delay:0, options: .CurveEaseIn, animations:{
//            cell.titleLabel.transform = CGAffineTransformMakeTranslation(0, -5)
//            cell.subTitle.text = "January 14"
//            cell.contentView.layoutIfNeeded()
//            
//        }, completion: nil)
//    }
//}

