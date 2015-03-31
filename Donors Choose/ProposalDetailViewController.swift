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
        navigationItem.title = prop.title
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
        openWebview(self.prop.fundURL)
    }
    
    func openWebview(url: String) {
        let webView = UIWebView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        webView.hidden = false
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view = webView
        
        let nc = UINavigationController(rootViewController: vc)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "closeWebView:")
        vc.navigationItem.leftBarButtonItem = doneButton
        
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func closeWebView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func moreDetails(sender: AnyObject) {
        openWebview(self.prop.proposalURL)
    }
    
}
