//
//  Preferences.swift
//  WCNU Station Sign In
//
//  Created by Zachary Whitten on 4/9/16.
//  Copyright © 2016 WCNURadio. All rights reserved.
//

import Foundation
import Cocoa

class Preferences: NSObject {
    @IBOutlet weak var generalPreferencesWindow: NSWindow!
    @IBOutlet weak var podcastsPreferencesView: NSView!
    @IBOutlet weak var generalPreferencesView: NSView!
    @IBOutlet weak var signinMenu: NSMenu!
    var signinFilepath = ""
   

    
    //place the generalPreferencesView onto the generalPreferenceWindow and change the size of the window to fit the frame. Change the title of the window as well
    @IBAction func generalPreferences(sender: AnyObject) {
        generalPreferencesWindow.contentView = generalPreferencesView
        var tempFrame = generalPreferencesWindow.frame
        tempFrame.origin.y += tempFrame.size.height;
        tempFrame.origin.y -= 229;
        tempFrame.size.height = 229;
        generalPreferencesWindow.setFrame(tempFrame, display: true, animate: true)
        generalPreferencesWindow.title = "General"
    }
    
    
    //place the posdastsPreferencesView onto the generalPreferenceWindow and change the size of the window to fit the frame. Change the title of the window as well
    @IBAction func podcastsPreferences(sender: AnyObject) {
        generalPreferencesWindow.contentView = podcastsPreferencesView
        var tempFrame = generalPreferencesWindow.frame
        tempFrame.origin.y += tempFrame.size.height;
        tempFrame.origin.y -= 229;
        tempFrame.size.height = 229;
        generalPreferencesWindow.setFrame(tempFrame, display: true, animate: true)
        generalPreferencesWindow.title = "Podcasts"
    }
    
    @IBAction func getSignInLogsFolder(sender: AnyObject) {
        
        let myPanel = NSOpenPanel()
        myPanel.allowsMultipleSelection = false
        myPanel.canChooseDirectories = true
        myPanel.canChooseFiles = false;
        if myPanel.runModal() == NSModalResponseOK {
            setFolderMenu(myPanel.URLs[0].path!, aMenu: signinMenu)
        }
        else{
            
        }
    }
    
    
    func setFolderMenu(aFilepath: String, aMenu: NSMenu){
        let myWorkspace = NSWorkspace()
        let fileImage = myWorkspace.iconForFile(aFilepath)
        var imageSize = NSSize(); imageSize.width = 16; imageSize.height = 16;
        fileImage.size = imageSize
        var filepathParts = aFilepath.componentsSeparatedByString("/")
        let fileName = filepathParts[filepathParts.count - 1]
        aMenu.itemAtIndex(0)?.image = fileImage
        aMenu.itemAtIndex(0)?.title = fileName
        aMenu.performActionForItemAtIndex(0)
    }
    
    
}
