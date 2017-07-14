//
//  ScheduleEmptyStateView.swift
//  hackertracker
//
//  Created by Christopher Mays on 7/13/17.
//  Copyright © 2017 Beezle Labs. All rights reserved.
//

import UIKit

class ScheduleEmptyStateView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionIcon: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func bind(description: String, image : UIImage) {
        descriptionLabel.text = description
        descriptionIcon.image = image
    }

}
