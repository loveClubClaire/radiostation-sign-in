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
    @IBOutlet weak var podcastDestinationMenu: NSMenu!
    @IBOutlet weak var songLogMenu: NSMenu!
    @IBOutlet weak var podcastLocationMenu: NSMenu!
    
    var signinFilepath = ""
    var podcastFilepath = ""
    var songLogFilepath = ""
    var podcastDestinationFilepath = ""
    

    override init() {
        var fileManager
    }
    
//    //Load saved preference data
//    NSFileManager *fileManager = [[NSFileManager alloc]init];
//    NSURL *filepath = [[NSURL alloc]init];
//    filepath = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    NSString *stringFilepath = [filepath path];
//    NSString *savedDataFilepath = [NSString stringWithFormat:@"%@/WCNURadio Automated Secretary",stringFilepath];
//    if ([fileManager fileExistsAtPath:savedDataFilepath] == false) {
//    [fileManager createDirectoryAtPath:savedDataFilepath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    _preferencesFilePath = [savedDataFilepath stringByAppendingPathComponent:@"preferences.txt"];

    
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
    
    //When the user requests to change the location of the signin logs folder this function is called. It spawns a file selector panel which can only select a single directory. If the user selects a directory, setFolderMenu is called to update the menu item so that it shows the new directory.
    @IBAction func getSignInLogsFolder(sender: AnyObject) {
        let myPanel = NSOpenPanel()
        myPanel.allowsMultipleSelection = false
        myPanel.canChooseDirectories = true
        myPanel.canChooseFiles = false;
        //If user confirms then call setFolderMenu to update the menu object and update the filepath by setting the signinFilepath variable
        if myPanel.runModal() == NSModalResponseOK {
            setFolderMenu(myPanel.URLs[0].path!, aMenu: signinMenu)
            signinFilepath = myPanel.URLs[0].path!
        }
        //If the user cancels then make the menu have the currect directory selected, not the change filepath option selected. Its a UI thing.
        else{
            signinMenu.performActionForItemAtIndex(0)
        }
    }
    
    //When the user requests to change the location of the podcast location folder this function is called. It spawns a file selector panel which can only select a single directory. If the user selects a directory, setFolderMenu is called to update the menu item so that it shows the new directory.
    @IBAction func getPodcastLocationFolder(sender: AnyObject) {
        let myPanel = NSOpenPanel()
        myPanel.allowsMultipleSelection = false
        myPanel.canChooseDirectories = true
        myPanel.canChooseFiles = false;
        //If user confirms then call setFolderMenu to update the menu object and update the filepath by setting the podcastFilepath variable
        if myPanel.runModal() == NSModalResponseOK {
            setFolderMenu(myPanel.URLs[0].path!, aMenu: podcastLocationMenu)
            podcastFilepath = myPanel.URLs[0].path!
        }
            //If the user cancels then make the menu have the currect directory selected, not the change filepath option selected. Its a UI thing.
        else{
            podcastLocationMenu.performActionForItemAtIndex(0)
        }

    }
    
    //When the user requests to change the location of the song log folder this function is called. It spawns a file selector panel which can only select a single directory. If the user selects a directory, setFolderMenu is called to update the menu item so that it shows the new directory.
    @IBAction func getSongLogFolder(sender: AnyObject) {
        let myPanel = NSOpenPanel()
        myPanel.allowsMultipleSelection = false
        myPanel.canChooseDirectories = true
        myPanel.canChooseFiles = false;
        //If user confirms then call songLogMenu to update the menu object and update the filepath by setting the songLogFilepath variable
        if myPanel.runModal() == NSModalResponseOK {
            setFolderMenu(myPanel.URLs[0].path!, aMenu: songLogMenu)
            songLogFilepath = myPanel.URLs[0].path!
        }
            //If the user cancels then make the menu have the currect directory selected, not the change filepath option selected. Its a UI thing.
        else{
            songLogMenu.performActionForItemAtIndex(0)
        }
    }
    
    //When the user requests to change the location of the podcast destination folder this function is called. It spawns a file selector panel which can only select a single directory. If the user selects a directory, setFolderMenu is called to update the menu item so that it shows the new directory.
    @IBAction func getPodcastDestinationFolder(sender: AnyObject) {
        let myPanel = NSOpenPanel()
        myPanel.allowsMultipleSelection = false
        myPanel.canChooseDirectories = true
        myPanel.canChooseFiles = false;
        //If user confirms then call podcastDestinationMenu to update the menu object and update the filepath by setting the podcastDestinationFilepath variable
        if myPanel.runModal() == NSModalResponseOK {
            setFolderMenu(myPanel.URLs[0].path!, aMenu: podcastDestinationMenu)
            podcastDestinationFilepath = myPanel.URLs[0].path!
        }
            //If the user cancels then make the menu have the currect directory selected, not the change filepath option selected. Its a UI thing.
        else{
            podcastDestinationMenu.performActionForItemAtIndex(0)
        }

    }
    
    //Gets a filepath and a menu and sets the first menuItem in the menu to the file given by the filepath and then selects that menuItem
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
