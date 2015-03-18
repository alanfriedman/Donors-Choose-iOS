//
//  TableViewController.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/14/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import UIKit

class ProposalsViewController: UITableViewController {
    
    let lat: Double?
    let lng: Double?
    let zipCode: Int?
    
    var locHelper: LocationHelper = LocationHelper()
    var latlng: [Float]? = nil
    
    var proposals: [Proposal] = [] {
        didSet {
//            self.tableView.reloadData()
//            self.tableView.endUpdates()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(lat: Double?, lng: Double?, zip: String?) {
        super.init(style: .Plain)
//        self.lat = lat
//        self.lng = lng
        getProposals(lat, lng: lng, zip: zip)
    }
    
//    convenience init(zip: Int) {
//        self.init(lat: nil, lng: nil, zip: zip)
//        
//        getProposals(nil, lng: nil, zip: zip)
//    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationChanged:", name:"locationChanged", object: nil)
//        locHelper.getUserLocation()
    }
    
    func getProposals(lat: Double?, lng: Double?, zip: String?) {
//        var params: [String:AnyObject] = ["keywords": "30324", "APIKey": "DONORSCHOOSE"]
        
        var qStr: String = ""
        if let lat1 = lat {
            if let lng1 = lng {
                qStr = "centerLat=\(lat1)&centerLng=\(lng1)&APIKey=DONORSCHOOSE&max=50&sortBy=1"
            }
        } else {
            qStr = "keywords=\(zip!)&APIKey=DONORSCHOOSE&max=50&sortBy=1"
        }
        
        urlRequestHelper.performHTTPRequest("api.donorschoose.org", path: "/common/json_feed.html", query: qStr, method: "GET", params: nil) {
            (json) -> Void in

            if let props = json["proposals"] as? NSArray {
                for prop in props {
                    let fundURL: String = prop["fundURL"] as? String ?? ""
                    let title: String = prop["title"] as? String ?? ""
                    let shortDescription: String = prop["shortDescription"] as? String ?? ""
                    let thumb: String = prop["thumb"] as? String ?? ""
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
                    
                    let prop = Proposal(fundURL: fundURL, title: title, description: shortDescription, thumb: thumb, schoolName: schoolName, city: city, state: state, miniDescription: miniDescription, costToComplete: costToComplete, totalPrice: totalPrice, gradeName: gradeName!, proposalURL: proposalURL, teacherName: teacherName, thumbImageURL: thumbImageURL)
                    
                    self.proposals.append(prop)
                }
                
                self.tableView.reloadData()
                self.tableView.endUpdates()
//                self.proposals = props
            }
        }
        
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell!
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell?

//        if cell == nil {
        cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"UITableViewCell")
//        }
//        self.configureCell(cell, atIndexPath: indexPath)
        
        let prop: Proposal = self.proposals[indexPath.row]
        var title: String = prop.title
        
        cell.textLabel?.text = title
//
        if let detailText = cell.detailTextLabel {
            detailText.text = "\(prop.schoolName) (\(prop.city), \(prop.state))"
//            detailText.text = prop.miniDescription
        }
        
//        var cellSwitch = UISwitch(frame: CGRectZero)
//        cell.accessoryView = cellSwitch
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
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
