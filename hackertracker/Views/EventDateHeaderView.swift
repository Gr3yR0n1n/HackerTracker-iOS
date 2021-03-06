//
//  EventDateHeaderView.swift
//  hackertracker
//
//  Created by Christopher Mays on 7/13/17.
//  Copyright © 2017 Beezle Labs. All rights reserved.
//

import UIKit

class EventDateHeaderView: UITableViewHeaderFooterView {

    
    private let dateLabel = UILabel()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dateLabel.textColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func bindToDate(date : Date?)
    {
        if let date = date {
            if Calendar.current.isDateInYesterday(date) {
                dateLabel.text = "Yesterday"
            } else if Calendar.current.isDateInToday(date) {
                dateLabel.text = "Today"
            } else if Calendar.current.isDateInTomorrow(date) {
                dateLabel.text = "Tomorrow"
            } else {
                dateLabel.text = DateFormatterUtility.dayOfWeekFormatter.string(from: date)
            }
        } else {
            dateLabel.text = "Unknown"
        }
    }
    

}
