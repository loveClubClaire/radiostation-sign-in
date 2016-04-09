//
//  AppDelegate.m
//  WCNU Station Sign In
//
//  Created by Zachary Whitten on 8/29/13.
//  Copyright (c) 2013 WCNURadio. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

BOOL buttonBOOL;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    
    
}


-(void)writeToFile:(NSString *)aString{
    //get Filepath for file 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *test = [defaults objectForKey:@"thefilepath"];
    if(test == nil){
        [self changeTxtFileURL:nil];
    }
    //get Date for file name
    NSDate *theDate = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //NOOOOOOO Subtract an hour to acheive this goal. Don't just fucking switch the time zone. Arg
    [formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formater stringFromDate:theDate];
    
    NSString *filepathAndFile = [NSString stringWithFormat:@"%@/%@.txt", test, stringFromDate];

    //Create File Manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Test for file existing. If not create it
    if(![fileManager fileExistsAtPath:filepathAndFile]){
        [aString writeToFile:filepathAndFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    }
    else{
        NSFileHandle *filehandle = [NSFileHandle fileHandleForWritingAtPath:filepathAndFile];
        [filehandle seekToEndOfFile];
        NSData *textdata = [aString dataUsingEncoding:NSUTF8StringEncoding];
        [filehandle writeData:textdata];
        [filehandle closeFile];
    }
    
}

-(NSArray*)readLogFromFile{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    NSString *filepath = [defults objectForKey:@"thesonglog"];
    if(filepath == nil){
        [self songLogURL:nil];
    }
    
    NSString *filecontents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",filecontents);
    if(filecontents == NULL){
        filecontents = [NSString stringWithContentsOfFile:filepath encoding:NSASCIIStringEncoding error:nil];
    }
    NSArray *lineStrings = [filecontents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return lineStrings;
}

-(IBAction)closeInfoWindow:(id)sender{
    NSString *tags = [self.textFieldFive stringValue];
    NSString *description = [self.textBoxTwo stringValue];
    NSString *csv = [NSString stringWithFormat:@"<delim>%@<delim>%@", tags, description];
    [self writeToFile:csv];
    
    [_thirdWindow orderOut:self];
    [_extraWindow makeKeyAndOrderFront:self];
    [self setPopupCells:[self readLogFromFile]];
    [self setPopupCellsTwo:[self readLogFromFile]];
}

-(IBAction)closeWindow:(id)sender{
    bool firstLast = TRUE;
    NSInteger firstSong = [_popup indexOfSelectedItem];
    NSInteger secondSong = [_popupTwo indexOfSelectedItem];
    if(secondSong > firstSong){
        firstLast = false;
    }
    if(firstLast == TRUE){
    [_extraWindow orderOut:self];
    [self submitPodcast];
    [_WCNUWindow makeKeyAndOrderFront:self];
    }
    else if(firstLast == FALSE){
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessageText:@"First song first, last song second!"];
        //[alert setInformativeText:@"MGMT"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
}

-(void)setPopupCells:(NSArray *)anArray{
    [_popup removeAllItems];
    [_popup addItemsWithTitles:anArray];
}

-(void)setPopupCellsTwo:(NSArray *)anArray{
    [_popupTwo removeAllItems];
    [_popupTwo addItemsWithTitles:anArray];
}

-(IBAction)getButtonValue:(id)sender{
    NSButton *button = sender;
    if([button state]== NSOnState){
        buttonBOOL = YES;
    }
    else{
        buttonBOOL = NO;
    }
}

-(IBAction)changeTxtFileURL:(id)sender{
    NSString *theFilepath;
    NSOpenPanel *myPanel = [NSOpenPanel openPanel];
    [myPanel setAllowsMultipleSelection:NO];
    [myPanel setCanChooseDirectories:YES];
    [myPanel setCanChooseFiles:NO];
    
    if([myPanel runModal] == NSOKButton){
        NSArray *fileArray = [myPanel URLs];
        theFilepath = [[fileArray objectAtIndex:0] path];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theFilepath forKey:@"thefilepath"];
    [defaults synchronize];
    
}

-(IBAction)changePodcastOriginURL:(id)sender{
    NSString *theFilepath;
    NSOpenPanel *myPanel = [NSOpenPanel openPanel];
    [myPanel setAllowsMultipleSelection:NO];
    [myPanel setCanChooseDirectories:YES];
    [myPanel setCanChooseFiles:NO];
    
    if([myPanel runModal] == NSModalResponseOK){
        NSArray *fileArray = [myPanel URLs];
        theFilepath = [[fileArray objectAtIndex:0] path];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theFilepath forKey:@"thepodcastorigin"];
    [defaults synchronize];
    
}

-(IBAction)changePodcastFinalURL:(id)sender{
    NSString *theFilepath;
    NSOpenPanel *myPanel = [NSOpenPanel openPanel];
    [myPanel setAllowsMultipleSelection:NO];
    [myPanel setCanChooseDirectories:YES];
    [myPanel setCanChooseFiles:NO];
    
    if([myPanel runModal] == NSOKButton){
        NSArray *fileArray = [myPanel URLs];
        theFilepath = [[fileArray objectAtIndex:0] path];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theFilepath forKey:@"thepodcastfinal"];
    [defaults synchronize];
    
}

-(IBAction)songLogURL:(id)sender{
    NSString *theFilepath;
    NSOpenPanel *myPanel = [NSOpenPanel openPanel];
    [myPanel setAllowsMultipleSelection:NO];
    [myPanel setCanChooseDirectories:NO];
    [myPanel setCanChooseFiles:YES];
    
    if([myPanel runModal] == NSOKButton){
        NSArray *fileArray = [myPanel URLs];
        theFilepath = [[fileArray objectAtIndex:0] path];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theFilepath forKey:@"thesonglog"];
    [defaults synchronize];
    
}

- (IBAction)submit:(id)sender {
    NSString *showName = [self.textFieldOne stringValue];
    NSString *djOne = [self.textFieldTwo stringValue];
    NSString *djTwo = [self.textFieldThree stringValue];
    NSString *stationStatus = [self.textBoxOne stringValue];
    NSString *podcastName = [self.textFieldFour stringValue];
    
    if ([showName isEqualTo:@""]) {
        showName = @"NULL";
    }
    if ([djOne isEqualTo:@""]) {
        djOne = @"NULL";
    }
    if ([djTwo isEqualTo:@""]) {
        djTwo = @"NULL";
    }
    if ([stationStatus isEqualTo:@""]) {
        stationStatus = @"NULL";
    }
    if ([podcastName isEqualTo:@""]) {
        podcastName = @"NULL";
    }
    
    NSString *csv = [NSString stringWithFormat:@"%@<delim>%@<delim>%@<delim>%@<delim>%@", showName, djOne, djTwo, stationStatus, podcastName];
    //change delimter hu
    [self writeToFile:csv];
    
    if(buttonBOOL == YES){
        [_WCNUWindow orderOut:self];
        [_thirdWindow makeKeyAndOrderFront:self];
    }
    else{
    
    NSString *csv = [NSString stringWithFormat:@"\n\n"];
    [self writeToFile:csv];
        
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Ok"];
    [alert setMessageText:@"Your sign in has been submitted!"];
    [alert setInformativeText:@"Podcasts will be uploaded within 24 hours"];
    [alert setAlertStyle:NSInformationalAlertStyle];
    NSArray *buttonArray = [alert buttons];
    NSButton *myBtn = [buttonArray objectAtIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 200 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [myBtn performClick:alert];
    });
    [alert runModal];
    [self.textBoxOne setStringValue:@""];
    [self.textFieldOne setStringValue:@""];
    [self.textFieldTwo setStringValue:@""];
    [self.textFieldThree setStringValue:@""];
    [self.textFieldFour setStringValue:@""];
    }
    
     }

-(void)submitPodcast{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *podcastName = [self.textFieldFour stringValue];
    
    NSString *podcastOrigin = [defaults objectForKey:@"thepodcastorigin"];
    if(podcastOrigin == nil){
        [self changePodcastOriginURL:nil];
    }
    NSString *podcastFinal = [defaults objectForKey:@"thepodcastfinal"];
    if(podcastFinal == nil){
        [self changePodcastOriginURL:nil];
    }
    
    NSInteger firstSong = [_popup indexOfSelectedItem];
    NSInteger secondSong = [_popupTwo indexOfSelectedItem];
  
    NSArray *songLog = [self readLogFromFile];
    NSString *allSongs = @"";
    for (NSInteger i = firstSong; i >= secondSong; i--) {
        allSongs = [allSongs stringByAppendingString:@"<delim>"]; //Change Delimter
        allSongs = [allSongs stringByAppendingString:[songLog objectAtIndex:i]];
        
    }
    NSString *csv = [NSString stringWithFormat:@"%@\n\n", allSongs];
    [self writeToFile:csv];
    
    NSString *scriptP1 =
    @"set vb2 to POSIX file \"";
    //vb2 is for the folder the podcast is to be found in
    NSString *scriptP2 =
    @"\" \nset vb4 to POSIX file \"";
    //vb4 is for the target folder
    NSString *scriptP3 =
    @"\" \nset vb5 to \"";
    //vb5 set to podcast name
    NSString *scriptP4 =
    @".mp3\"\ntell application \"Finder\"\n"
    @"set the_files to get every file of folder vb2\n"
    @"set latestFile to item 1 of (sort the_files by creation date) as alias\n"
    @"set theDuplicate to duplicate latestFile to vb4\n"
    @"set name of theDuplicate to vb5 \n"
    @"end tell";
    
    NSString *script = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",scriptP1,podcastOrigin,scriptP2,podcastFinal,scriptP3,podcastName,scriptP4];
    
    
    NSAppleScript *myScript = [[NSAppleScript alloc] initWithSource:script];
    [myScript executeAndReturnError:nil];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Ok"];
    [alert setMessageText:@"Your sign in has been submitted!"];
    [alert setInformativeText:@"Podcasts will be uploaded within 24 hours"];
    [alert setAlertStyle:NSInformationalAlertStyle];
    NSArray *buttonArray = [alert buttons];
    NSButton *myBtn = [buttonArray objectAtIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 200 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [myBtn performClick:alert];
    });

    [alert runModal];
    
    [self.textBoxOne setStringValue:@""];
    [self.textFieldOne setStringValue:@""];
    [self.textFieldTwo setStringValue:@""];
    [self.textFieldThree setStringValue:@""];
    [self.textFieldFour setStringValue:@""];
    [self.textFieldFive setStringValue:@""];
    [self.textBoxTwo setStringValue:@""];
    //Reset podcast button and the variable it sets to zero / off
    [self.podcastButton setState:0];
        buttonBOOL = NO;

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
