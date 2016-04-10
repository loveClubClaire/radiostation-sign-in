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
    @IBOutlet weak var podcastInformationWindow: NSWindow!
    @IBOutlet weak var firstPlayedSongMenu: NSPopUpButtonCell!
    @IBOutlet weak var lastPlayedSongMenu: NSPopUpButtonCell!
    @IBOutlet weak var tagsTextField: NSTextField!
    @IBOutlet weak var showDescriptionTextField: NSTextField!
    
    func submit(podcastInformation: String){
        //Get the values of the binded text fields and buttons and store them into variables
        var showName = showNameTextField.stringValue
        var emailOne = emailOneTextField.stringValue
        var emailTwo = emailTwoTextField.stringValue
        var stationStatus = stationStatusTextField.stringValue
        var podcastName = podcastNameTextField.stringValue
        
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
        csv += podcastInformation
        
        
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

    @IBAction func submitButtonClicked(sender: AnyObject) {
        let isPodcast = isPodcastButton.state
        //If we are handling podcasts, call submitWithPodcast, otherwise, just call submit directly.
        if isPodcast == NSOnState {
            submitWithPodcast()
        }
        else{
            submit("")
        }
    }
    
    func submitWithPodcast(){
        //Get the song log and convert it into an array of strings
        var songLogArray = [String]()
        do{
            let songLog = try String.init(contentsOfFile:preferencesObject.getSongLogFilepath())
            songLogArray = songLog.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            if songLogArray[songLogArray.count-1] == "" {
                songLogArray.removeAtIndex(songLogArray.count-1)
            }
        }
        catch{
            NSLog("submitWithPodcast function do block failure. Its open source, find out about it yourself :/")
        }
        //Place the first and last of the songlogArray into the first and last played song menu and select the first and last to be displayed respectivally.
        firstPlayedSongMenu.removeAllItems()
        firstPlayedSongMenu.addItemsWithTitles(songLogArray)
        lastPlayedSongMenu.removeAllItems()
        lastPlayedSongMenu.addItemsWithTitles(songLogArray)
        firstPlayedSongMenu.selectItemAtIndex(0)
        lastPlayedSongMenu.selectItemAtIndex(songLogArray.count - 1)
        
        //Make the podcast information window centered and visible and make any other visable windows unclickable using the NSApp function
        podcastInformationWindow.center()
        podcastInformationWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(podcastInformationWindow)
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
    
    //Executes an applescript that moves a podcast from one folder to another
    func movePodcast(){
        let script = "set vb2 to POSIX file \"" + preferencesObject.getPodcastOriginFilepath() + "\" \n" +
                     "set vb4 to POSIX file \"" + preferencesObject.getPodcastDestinationFilepath() + "\" \n" +
                     "set vb5 to \"" + podcastNameTextField.stringValue + ".mp3\" \n" +
                     "tell application \"Finder\"\n" +
                     "set the_files to get every file of folder vb2\n" +
                     "set latestFile to item 1 of (sort the_files by creation date) as alias\n" +
                     "set theDuplicate to duplicate latestFile to vb4\n" +
                     "set name of theDuplicate to vb5 \n" +
                     "end tell";
        
        let scriptObject = NSAppleScript.init(source: script)
        scriptObject?.executeAndReturnError(nil)
    }
    
    @IBAction func podcastInformationOk(sender: AnyObject) {
        //If the first song doesn't come before the last song, alert the user physics can't be denied.
        if lastPlayedSongMenu.indexOfSelectedItem < firstPlayedSongMenu.indexOfSelectedItem  {
            let myAlert = NSAlert()
            myAlert.addButtonWithTitle("Ok")
            myAlert.messageText = "The first song must go before the last song"
            myAlert.informativeText = "You are not a wizard. Math doesn't work like that"
            myAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
            myAlert.runModal()
        }
        //Otherwise, generate the podcast information string and pass it to the submit function. Then set the window to its defaults and dismiss the window.
        else{
            var allSongs = ""
            for index in firstPlayedSongMenu.indexOfSelectedItem...lastPlayedSongMenu.indexOfSelectedItem{
                allSongs += "<delim>" + firstPlayedSongMenu.itemTitles[index]
            }
            var tags = tagsTextField.stringValue
            var description = showDescriptionTextField.stringValue
            //I was bitter I had to write this logic at all so I crammed it into one line. Sorry.
            if tags == "" {tags = "NULL"}; if description == "" {description = "NULL"}
            let podcastInformation = "<delim>" + tags + "<delim>" + description + allSongs
            movePodcast()
            submit(podcastInformation)
            //Sets the window to its defaults and dismisses it. Don't write code twice yo.
            podcastInformationCancel(self)
           
        }
    }
    //Cancel's the action of creating a podcast. Dissmisses the podcast information window and resets it to its defaults. The state of the main sign in window is unchanged. The first and last song pop up menus don't need to be reset because they will be reconfigured when the window is called again.
    @IBAction func podcastInformationCancel(sender: AnyObject) {
        NSApp.stopModal()
        podcastInformationWindow.orderOut(self)
        tagsTextField.stringValue = ""
        showDescriptionTextField.stringValue = ""
    }
}
