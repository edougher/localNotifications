//
//  ViewController.swift
//  pizzaApp
//
//  Created by Aaron Dougher on 9/10/18.
//  Copyright © 2018 Erin Dougher. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    
    var pizzaNumber = 0
    let pizzaSteps = ["Make pizza", "Roll Dough", "Add Sauce", "Add Cheese", "Add Other Ingredients", "Bake", "Done"]
    
    var isGrantedNotificationAccess = false
    
    func updatePizzaStep(request:UNNotificationRequest){
        if request.identifier.hasPrefix("message.pizza"){
            var stepNumber = request.content.userInfo["step"] as! Int
            stepNumber = (stepNumber + 1) % pizzaSteps.count
            let updatedContent = makePizzaContent()
            updatedContent.body = pizzaSteps[stepNumber]
            updatedContent.subtitle = request.content.subtitle
            addNotification(trigger: request.trigger, content: updatedContent, identifier: request.identifier)
            
        }
    }
    
    
    func makePizzaContent() -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "A Timed Step"
        content.body = "Making Pizza"
        content.userInfo = ["Step":0]
        return content
        
    }
    
    func addNotification(trigger: UNNotificationTrigger?, content: UNMutableNotificationContent, identifier: String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){
            (error) in
            if error != nil {
                print("error adding notification:\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    @IBAction func schedulePizza(_ sender: UIButton) {
        if isGrantedNotificationAccess{
            let content = UNMutableNotificationContent()
            content.title = "A Scheduled Pizza"
            content.body = "Time to Make a Pizza!"
            content.categoryIdentifier = "snooze.category"
            let unitFlags:Set<Calendar.Component> = [.minute, .hour, .second]
            var date = Calendar.current.dateComponents(unitFlags, from: Date())
            date.second = date.second! + 15
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            addNotification(trigger: trigger, content: content, identifier: "message.scheduled")
        }
    }
    
    @IBAction func makePizza(_sender: UIButton){
        if isGrantedNotificationAccess{
            let content = makePizzaContent()
            pizzaNumber += 1
            content.subtitle = "Pizza \(pizzaNumber)"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
            
            addNotification(trigger: trigger, content: content, identifier: "message.pizza.\(pizzaNumber)")
        }
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
    }
    
    @IBAction func viewPending(_ sender: UIButton) {
    }
    
    @IBAction func viewDelivered(_ sender: UIButton) {
    }
    @IBAction func removeNotifications(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in self.isGrantedNotificationAccess = granted
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

