//
//  MasterController.swift
//  WCNU Station Sign In
//
//  Created by Zachary Whitten on 4/8/16.
//  Copyright © 2016 WCNURadio. All rights reserved.
//

import Foundation
import Cocoa

class MasterController: NSObject{

    @IBOutlet weak var showNameTextField: NSTextField!
    @IBOutlet weak var emailOneTextField: NSTextField!
    @IBOutlet weak var emailTwoTextField: NSTextField!
    @IBOutlet weak var stationStatusTextField: NSTextField!
    @IBOutlet weak var podcastNameTextField: NSTextField!
    @IBOutlet weak var isPodcastButton: NSButton!
    @IBOutlet weak var preferencesObject: Preferences!
    
    

    @IBAction func submit(sender: AnyObject) {
        //Get the values of the binded text fields and buttons and store them into variables
        var showName = showNameTextField.stringValue
        var emailOne = emailOneTextField.stringValue
        var emailTwo = emailTwoTextField.stringValue
        var stationStatus = stationStatusTextField.stringValue
        var podcastName = podcastNameTextField.stringValue
        let isPodcast = isPodcastButton.state
        
        //Replace any empty string with "NULL". This is done for legacy reasons. And I believe that reason is to make the resulting string easier to parse. I never said it was a good reason.
        if showName == "" {
            showName = "NULL"
        }
        if emailOne == "" {
            emailOne = "NULL"
        }
        if emailTwo == "" {
            emailTwo = "NULL"
        }
        if stationStatus == "" {
            stationStatus = "NULL"
        }
        if podcastName == "" {
            podcastName = "NULL"
        }
        
        //Concatenate the string together
        var csv = showName + "<delim>" + emailOne + "<delim>" + emailTwo + "<delim>" + stationStatus + "<delim>" + podcastName
        
        //If we are handling podcasts, call the get podcast information function
        if isPodcast == NSOnState {
            //Call get podcast information function
        }
        
        //Write the resulting csv string to a file
        csv += "\n\n"
        writeToAttendanceFile(csv)
        
        //Run confirmation dialog for user to see
        let myAlert = NSAlert()
        myAlert.addButtonWithTitle("Ok")
        myAlert.messageText = "Your sign in has been submitted!"
        myAlert.informativeText = "This counts as attendance"
        myAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
        myAlert.runModal()
        
        //reset the values of the binded text fields and button 
        showNameTextField.stringValue = ""
        emailOneTextField.stringValue = ""
        emailTwoTextField.stringValue = ""
        stationStatusTextField.stringValue = ""
        podcastNameTextField.stringValue = ""
        isPodcastButton.state = NSOffState
    }
    
    func writeToAttendanceFile(signIn: String){
        //Get todays date and subtract it an hour. This is so that shows that go from 11-1AM or something show up in the attendance logs on the day they started not the day they ended. Also 10-12AM this happens all the time.
        let todaysDate =  NSDate().dateByAddingTimeInterval(-60*60)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //Get the filepath from the preferencesObject and use the date as the fileName
        let fileAndFilepath = preferencesObject.getSigninFilepath() + "/" + dateFormatter.stringFromDate(todaysDate) + ".txt"
        //If the file doesn't exist, the create the file and write the passed signIn to it. If the file does exist, concatinate the signIn to that file.
        if NSFileManager().fileExistsAtPath(fileAndFilepath) == false {
            do{
                try signIn.writeToFile(fileAndFilepath, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
                NSLog("Failed to write attendance to file")
            }
        }
        else{
            let fileHandle = NSFileHandle.init(forWritingAtPath: fileAndFilepath)
            fileHandle?.seekToEndOfFile()
            let textData = signIn.dataUsingEncoding(NSUTF8StringEncoding)
            fileHandle?.writeData(textData!)
            fileHandle?.closeFile()
        }
    }
}
