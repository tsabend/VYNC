//
//  VyncCell.swift
//  VYNC
//
//  Created by Thomas Abend on 1/21/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import UIKit

class VyncCell: UITableViewCell {
    
    @IBOutlet weak var lengthLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var statusLogo: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        lengthLabel.layer.masksToBounds = true
        lengthLabel.layer.cornerRadius = 12.5
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.subTitle.hidden = true
        // Configure the view for the selected state
//        self.backgroundColor = UIColor.redColor()
    }
    
    func selectCellAnimation() {
        UIView.animateWithDuration(0.33, delay:0, options: .CurveEaseIn, animations:{
            self.titleLabel.transform = CGAffineTransformMakeTranslation(0, -3)
            self.subTitle.textColor = UIColor.blackColor()


            self.contentView.layoutIfNeeded()
            
            }, completion:
            { finished in
                self.subTitle.hidden = false
            })
        
    }
    
    func deselectCellAnimation() {
        UIView.animateWithDuration(0.5, delay:3.5, options: .CurveEaseIn, animations:{
            self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.contentView.layoutIfNeeded()
            println("hi")
            }, completion:
            { finished in
                self.subTitle.hidden = true
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

