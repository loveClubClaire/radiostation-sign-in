//
//  AppDelegate.h
//  WCNU Station Sign In
//
//  Created by Zachary Whitten on 8/29/13.
//  Copyright (c) 2013 WCNURadio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *textFieldOne;
@property (weak) IBOutlet NSTextField *textFieldTwo;
@property (weak) IBOutlet NSTextField *textBoxOne;
@property (weak) IBOutlet NSTextField *textFieldThree;
@property (weak) IBOutlet NSTextField *textFieldFour;
@property (weak) IBOutlet NSWindow *extraWindow;
@property (weak) IBOutlet NSWindow *thirdWindow;
@property (weak) IBOutlet NSWindow *WCNUWindow;
@property (weak) IBOutlet NSPopUpButton *popup;
@property (weak) IBOutlet NSPopUpButton *popupTwo;
@property (weak) IBOutlet NSTextField *textFieldFive;
@property (weak) IBOutlet NSTextField *textBoxTwo;
@property (weak) IBOutlet NSButton *podcastButton;


- (IBAction)submit:(id)sender;
-(IBAction)changeTxtFileURL:(id)sender;
-(IBAction)getButtonValue:(id)sender;
-(IBAction)changePodcastOriginURL:(id)sender;
-(IBAction)changePodcastFinalURL:(id)sender;
-(IBAction)songLogURL:(id)sender;
-(IBAction)closeWindow:(id)sender;
-(IBAction)closeInfoWindow:(id)sender;


@end
