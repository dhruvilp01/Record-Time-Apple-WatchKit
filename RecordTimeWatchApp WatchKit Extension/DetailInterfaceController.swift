//
//  DetailInterfaceController.swift
//  RecordTimeWatchApp WatchKit Extension
//
//  Created by Dhruvil Patel on 7/6/18.
//  Copyright © 2018 Dhruvil. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet var clockInLbl: WKInterfaceLabel!
    @IBOutlet var clockOutLbl: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let dates = context as? [Date] {
            
            let clockIn = dates[0]
            let clockOut = dates[1]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d h:mma"
            
            clockInLbl.setText(formatter.string(from: clockIn))
            clockOutLbl.setText(formatter.string(from: clockOut))
        }
    }
}
