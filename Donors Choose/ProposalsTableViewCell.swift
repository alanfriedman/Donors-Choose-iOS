//
//  ProposalsTableViewCell.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/19/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import UIKit

class ProposalsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subtitleLable: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var prop: Proposal?
    var proposals: [Proposal]?
    var indexPath: NSIndexPath?
    var imageLoaded: ((indexPath: NSIndexPath) -> ())?
//    
//    init(prop: Proposal, proposals: [Proposal], indexPath: NSIndexPath) {
//        self.prop = prop
//        self.proposals = proposals
//        self.indexPath = indexPath
//        super.init(style: .Subtitle, reuseIdentifier: "ProposalsTableViewCell")
//        self.loadInfo()
//    }
//    
//    func loadInfo() {
//        println("HERE")
//        var prop = self.prop!
//        var title: String = prop.title
//        
//        self.titleLabel.text = title
//        
//        //        if let detailText = cell!.detailTextLabel {
//        self.subtitleLable.text = "\(prop.schoolName) (\(prop.city), \(prop.state))"
//        //        }
//        
//        if !prop.thumbImageURL.isEmpty {
//            let url = NSURL(string: prop.thumbImageURL)
//            self.thumbImageView.image = UIImage(named: "logo")
//            
//            if let thumbImg = prop.thumbImage {
//                self.thumbImageView.image = thumbImg
//            } else {
//                dispatch_async(dispatch_get_main_queue(), {
//                    let data = NSData(contentsOfURL: url!)
//                    let img: UIImage = UIImage(data: data!)!
//                    
//                    self.prop!.thumbImage = img
//                    
//                    let index = find(self.proposals!, prop)
//                    if let i = index {
//                        self.proposals!.removeAtIndex(i)
//                        self.proposals!.insert(prop, atIndex: i)
//                        self.imageLoaded!(indexPath: self.indexPath!)
//                        self.thumbImageView.image = prop.thumbImage
//                    }
//                    
//                })
//                
//            }
//            
//        }
//
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//    }
    
//    override func didMoveToSuperview() {
//        sleep(5)
//       self.loadInfo()
//    }
}
