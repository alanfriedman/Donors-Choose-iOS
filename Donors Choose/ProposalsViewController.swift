//
//  TableViewController.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/14/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import UIKit

class ProposalsViewController: UITableViewController {
    
    var lat: Double?
    var lng: Double?
    var zipCode: String?
    
    var locHelper: LocationHelper = LocationHelper()
    var latlng: [Float]? = nil
    
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var proposals: [Proposal] = []
    
    var images: [UIImage] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        let appBundle = NSBundle.mainBundle()
        super.init(nibName: nibNameOrNil, bundle: appBundle)
        
        navigationItem.title = "Proposals"
        
        let locButton = UIBarButtonItem(title: "Location", style: UIBarButtonItemStyle.Plain, target: self, action: "openLocationView:")
        self.navigationItem.leftBarButtonItem = locButton
        
        self.tableView.rowHeight = 55
    }
    
    func startActivityIndicator() {
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        activityView.hidden = false
        activityView.startAnimating()
        
        let loaderButton = UIBarButtonItem(customView: activityView)
        navigationItem.rightBarButtonItem = loaderButton
    }
    
    func openLocationView(sender: AnyObject) {
        let hasLoc: Bool = lat != nil || zipCode != nil
        openLocView(hasLoc)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        let hasLoc: Bool = lat != nil || zipCode != nil
        if !hasLoc {
            openLocView(hasLoc)
        }
    }
    
    func openLocView(hasLoc: Bool) {
        let locViewController = LocationViewController(hasLoc: hasLoc)
        
        locViewController.useCurrentLocationClosure = {
            (lat: Double, lng: Double) in
            self.lat = lat
            self.lng = lng
            self.getProposals(lat, lng: lng, zip: nil)
            self.startActivityIndicator()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        locViewController.useZipCodeClosure = {
            (zip: String) in
            self.zipCode = zip
            self.getProposals(nil, lng: nil, zip: zip)
            self.startActivityIndicator()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        locViewController.cancelClosure = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let locNC = UINavigationController(rootViewController: locViewController)
        
        presentViewController(locNC, animated: true, completion: nil)
    }
    
    func getProposals(lat: Double?, lng: Double?, zip: String?) {

        var qStr: String = ""
        if let lat1 = lat {
            if let lng1 = lng {
                qStr = "centerLat=\(lat1)&centerLng=\(lng1)&APIKey=DONORSCHOOSE&max=50&sortBy=1"
            }
        } else {
            qStr = "keywords=\(zip!)&APIKey=DONORSCHOOSE&max=50&sortBy=1"
        }
        
        urlRequestHelper.performHTTPRequest("api.donorschoose.org", path: "/common/json_feed.html", query: qStr, method: "GET", params: nil, {
            (json) -> () in

            self.activityView.stopAnimating()

            self.proposals = []
            
            if let props = json["proposals"] as? NSArray {
                for prop in props {
                    let fundURL: String = prop["fundURL"] as? String ?? ""
                    let title: String = prop["title"] as? String ?? ""
                    let shortDescription: String = prop["shortDescription"] as? String ?? ""
                    let schoolName: String = prop["schoolName"] as? String ?? ""
                    let city: String = prop["city"] as? String ?? ""
                    let state: String = prop["state"] as? String ?? ""
                    let miniDescription: String = prop["fulfillmentTrailer"] as? String ?? ""
                    let costToComplete: String = prop["costToComplete"] as? String ?? "0.00"
                    let totalPrice: String = prop["totalPrice"] as? String ?? "0.00"
                    
                    var gradeName: String?
                    if let gradeLevel: [String:String] = prop["gradeLevel"] as? [String:String] {
                        gradeName = gradeLevel["name"]!
                    }
                    
                    let proposalURL: String = prop["proposalURL"] as? String ?? ""
                    let teacherName: String = prop["teacherName"] as? String ?? ""
                    let thumbImageURL: String = prop["thumbImageURL"] as? String ?? ""
                    let imageURL: String = prop["imageURL"] as? String ?? ""
                    
                    let prop = Proposal(fundURL: fundURL, title: title, description: shortDescription, schoolName: schoolName, city: city, state: state, miniDescription: miniDescription, costToComplete: costToComplete, totalPrice: totalPrice, gradeName: gradeName!, proposalURL: proposalURL, teacherName: teacherName, thumbImageURL: thumbImageURL, imageURL: imageURL, thumbImage: nil)
                    
                    self.proposals.append(prop)
                }
                
                self.tableView.reloadData()
                self.tableView.endUpdates()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proposals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"UITableViewCell")
        }
        
        var prop: Proposal = self.proposals[indexPath.row]
        var title: String = prop.title
        
        cell!.textLabel?.text = title

        if let detailText = cell!.detailTextLabel {
            detailText.text = "\(prop.schoolName) (\(prop.city), \(prop.state))"
        }
        
        if !prop.thumbImageURL.isEmpty {
            let url = NSURL(string: prop.thumbImageURL)
            cell!.imageView?.image = UIImage(named: "logo")
            
            if let thumbImg = prop.thumbImage {
                cell!.imageView?.image = thumbImg
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let data = NSData(contentsOfURL: url!)
                    let img: UIImage = UIImage(data: data!)!
                    
                    prop.thumbImage = img
                    
                    let index = find(self.proposals, prop)
                    if let i = index {
                        self.proposals.removeAtIndex(i)
                        self.proposals.insert(prop, atIndex: i)
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                        cell!.imageView?.image = prop.thumbImage
                    }
                    
                })
                
            }
            
        }
        
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell!
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let index = indexPath.row
        let prop: Proposal = proposals[index]
        
        let propDetailVC = ProposalDetailViewController(prop: prop)
        navigationController?.pushViewController(propDetailVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
