//
//  Proposal.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/16/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import Foundation
import UIKit

struct Proposal: Equatable {
    
    var fundURL: String
    var title: String
    var description: String
    var schoolName: String
    var city: String
    var state: String
    var miniDescription: String
    var costToComplete: String
    var totalPrice: String
    var gradeName: String
    var proposalURL: String
    var teacherName: String
    var thumbImageURL: String
    var imageURL: String
    var thumbImage: UIImage?
    
}

func ==(lhs: Proposal, rhs: Proposal) -> Bool {
    if lhs.title == rhs.title {
        return true
    } else {
        return false
    }
}