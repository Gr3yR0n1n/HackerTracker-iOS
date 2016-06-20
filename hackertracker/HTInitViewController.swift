//
//  HTInitViewController.swift
//  hackertracker
//
//  Created by Seth Law on 3/30/15.
//  Copyright (c) 2015 Beezle Labs. All rights reserved.
//

import UIKit
import CoreData

class HTInitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext!
        
        let fr:NSFetchRequest = NSFetchRequest(entityName:"Status")
        fr.returnsObjectsAsFaults = false
        
        let status : NSArray = try! context.executeFetchRequest(fr)
        
        if status.count < 1 {
            // First time setup. Load pre-con JSON file included from DCIB.
            
            let df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.timeZone = NSTimeZone(name: "PDT")
            NSLog("Database not setup, preloading with initial schedule")

            let path = NSBundle.mainBundle().pathForResource("schedule-full", ofType: "json")
            //NSLog("Path : \(path!)")
            
            let content = try? NSString(contentsOfFile: path!, encoding: NSASCIIStringEncoding)
            //NSLog("Content: \(content)")
            let dataFromString = content?.dataUsingEncoding(NSUTF8StringEncoding)
            let json = JSON(data: dataFromString!, options: NSJSONReadingOptions.AllowFragments, error: nil)

            let updateTime = json["updateTime"].string!
            let updateDate = json["updateDate"].string!
            NSLog("Schedule last updated at \(updateDate) \(updateTime)")
            let first_status = NSEntityDescription.insertNewObjectForEntityForName("Status", inManagedObjectContext: context) as! Status
            let syncDate = df.dateFromString("\(updateDate) \(updateTime)")
            first_status.lastsync = syncDate!
            
            let message1 = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            message1.date = first_status.lastsync
            message1.msg = "Welcome to HackerTracker iOS version 2016. If you have any events, parties, or contests to add, or if you find any errors or typos, email info@beezle.org. We are working directly with DEF CON this year to provide updates to the schedule with the official website. Code for this app can be found at https://github.com/BeezleLabs/HackerTracker-iOS."
            
            //let message2 = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            //message2.date = first_status.lastsync
            //message2.msg = "ATTENTION: The initial schedule only has the talks. Sync with defcon.org during DEF CON for an updated schedule of events."
            
            let schedule = json["schedule"].array!
            
            NSLog("Total events: \(schedule.count)")
            
            var mySched : [Event] = []
            
            df.dateFormat = "yyyy-MM-dd HH:mm z"
            
            for item in schedule {
                let te: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
                te.who = item["who"].string!
                var d = item["date"].string!
                te.location = item["location"].string!
                te.title = item["title"].string!
                te.details = item["description"].string!
                te.link = item["link"].string!
                te.type = item["type"].string!
                te.demo = item["demo"].boolValue
                te.tool = item["tool"].boolValue
                te.exploit = item["exploit"].boolValue
                te.id = item["id"].int32Value
                
                //NSLog("Adding Item - id: \(te.id) type \(te.type) who: \(te.who) date: \(d)")
                let b = item["begin"].string!
                let e = item["end"].string!
                if ( d == "" ) {
                    d = "2016-08-04"
                }
                if ( b != "" ) {
                    te.begin = df.dateFromString("\(d) \(b) PDT")!
                } else {
                    te.begin = df.dateFromString("\(d) 00:00 PDT")!
                }
                if ( e != "" ) {
                    te.end = df.dateFromString("\(d) \(e) PDT")!
                } else {
                    te.end = df.dateFromString("\(d) 23:59 PDT")!
                }
                
                te.starred = false
                mySched.append(te)
            }
            
            var err:NSError? = nil
            do {
                try context.save()
            } catch let error as NSError {
                err = error
            }
            
            if err != nil {
                NSLog("%@",err!)
            }

        }

        //self.performSegueWithIdentifier("HTHomeSegue", sender: self)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: #selector(HTInitViewController.go), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func go() {
        self.performSegueWithIdentifier("HTHomeSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
