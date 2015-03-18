//
//  ProposalDetailViewController.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/17/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import UIKit

class ProposalDetailViewController: UIViewController {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var propTitle: UILabel!
    @IBOutlet weak var propSubTitle: UILabel!
    @IBOutlet weak var moneyNeeded: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    
    
    var prop: Proposal
    
    init(prop: Proposal) {
        self.prop = prop
        super.init(nibName: "ProposalDetailViewController", bundle: nil)
    }
    
    override func viewDidLoad() {

        if !prop.thumbImageURL.isEmpty {
            let url = NSURL(string: prop.thumbImageURL)
            let data = NSData(contentsOfURL: url!)
            thumbImage.image = UIImage(data: data!)
        }
        
        self.propTitle.text = self.prop.title
        self.propSubTitle.text = prop.schoolName
        self.cityStateLabel.text = "\(prop.city), \(prop.state)"
        self.moneyNeeded.text = "Funding needed: $\(prop.costToComplete)"
        self.descriptionText.text = prop.description
        self.teacherLabel.text = prop.teacherName
        self.gradeLabel.text = prop.gradeName
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func fundProject(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.prop.fundURL)!)
    }
    
    @IBAction func moreDetails(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.prop.proposalURL)!)
    }
    
}
