//
//  InterfaceController.swift
//  RecordTimeWatchApp WatchKit Extension
//
//  Created by Dhruvil Patel on 7/5/18.
//  Copyright © 2018 Dhruvil. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var topLbl: WKInterfaceLabel!
    @IBOutlet var middleLbl: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    var clockedIn = false
    
    var timer : Timer? = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
       
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        if UserDefaults.standard.value(forKey: "clockedIn") != nil {
            
            if timer == nil {
                startUpTimer()
            }
            
            clockedIn = true
            
            updateUI(clockedIn: true)
        } else {
            clockedIn = false
            updateUI(clockedIn: false)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updateUI(clockedIn: Bool) {
        if clockedIn {
            topLbl.setHidden(false)
            self.topLbl.setText("Today's  \(totalTimeWorkedAsString())")
            middleLbl.setText("0 : 0 : 0")
            button.setTitle("Clock-Out")
            button.setBackgroundColor(UIColor.red)
        } else {
            topLbl.setHidden(true)
            button.setTitle("Clock-In")
            button.setBackgroundColor(UIColor.green)
            middleLbl.setText("Today\n \(totalTimeWorkedAsString ()) ")
            
        }
    }
    
    @IBAction func clockInOutTapped() {
        if clockedIn {
            clockOut()
        } else {
            clockIn()
        }
        updateUI(clockedIn: clockedIn)
    }
    
    func startUpTimer () {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let secound = timeInterval % 60
                
                var currentClockedInString = ""
                
                if hours != 0 {
                    currentClockedInString += "\(hours) : "
                }
                if minutes != 0 || hours != 0 {
                    currentClockedInString += "\(minutes) : "
                }
                
                currentClockedInString += "\(secound)"
                
                self.middleLbl.setText(currentClockedInString)
                
                self.topLbl.setText("Today's  \(self.totalTimeWorkedAsString())")
                
            }
        }

    }
    
    func clockIn() {
        clockedIn = true
        
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        
        startUpTimer()
    }
    
    func clockOut() {
        clockedIn = false
        
        timer?.invalidate()
        timer = nil
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            // Adding the clockin time to the clockins arrray
            if var clockins = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
                clockins.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockins, forKey: "clockIns")
                print(clockins)
            } else {
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            // Addint the clockout time to the clockouts array
            if var clockouts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                clockouts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockouts, forKey: "clockOuts")
                print(clockouts)
            } else {
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
            }
            UserDefaults.standard.set(nil, forKey: "clockedIn")
        }
        UserDefaults.standard.synchronize()
        
    }
    
    func totalClockedTime () -> Int {
         if var clockins = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
            if var clockouts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                
                var secounds = 0
                for index in 0..<clockins.count {
                    let currentSecounds = Int(clockouts[index].timeIntervalSince(clockins[index]))
                   
                    secounds += currentSecounds
                }
                return secounds
            }
         }
        return 0
    }
    
    func totalTimeWorkedAsString () -> String {
        
        var currentClockedInSeconds = 0
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            currentClockedInSeconds = Int(Date().timeIntervalSince(clockedInDate))
            
        }
            let totalTimeInterval = currentClockedInSeconds + self.totalClockedTime()
            let totalHours = totalTimeInterval / 3600
            let totalMinutes = (totalTimeInterval % 3600) / 60
        
        return "\(totalHours) : \(totalMinutes)"
    }


    @IBAction func resetAllTapped() {

        UserDefaults.standard.set(nil, forKey: "clockedIn")
        UserDefaults.standard.set(nil, forKey: "clockIns")
        UserDefaults.standard.set(nil, forKey: "clockOuts")

    
        UserDefaults.standard.synchronize()
        
        updateUI(clockedIn: false)

    }
    
    @IBAction func historyTapped() {
        pushController(withName: "TimeTabelController", context: nil)
    }
    
}
