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

    
    
    @IBAction func generalPreferences(sender: AnyObject) {
        generalPreferencesWindow.contentView = generalPreferencesView
    }
    
    
    @IBAction func podcastsPreferences(sender: AnyObject) {
        generalPreferencesWindow.contentView = podcastsPreferencesView
    }
    
}
