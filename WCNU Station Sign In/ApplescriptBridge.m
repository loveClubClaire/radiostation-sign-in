//
//  ApplescriptBridge.m
//  Now Playing in iTunes
//
//  Created by Zachary Whitten on 4/11/16.
//  Copyright © 2016 WCNURadio. All rights reserved.
//

#import "ApplescriptBridge.h"


@implementation ApplescriptBridge



-(id)init{
    Class myClass = NSClassFromString(@"MyApplescript");
    _myInstance = [[myClass alloc] init];
    return self;
}

//Executes an applescript that moves a podcast from one folder to another
- (void)moveFileFrom:(NSString*)OriginFilepath To:(NSString *)DestinationFilepath WithName:(NSString *)fileName{
    NSString *origin = [self convertToApplescriptFilepath:OriginFilepath];
    NSString *destination = [self convertToApplescriptFilepath:DestinationFilepath];
    [_myInstance moveFile:origin :destination :fileName];
}

-(NSString*)convertToApplescriptFilepath:(NSString *)aFilepath{
    //Get the volumeName of the filepath because it is not a part of a POSIX filepath but it is a part of an Applescript filepath
    NSURL *url = [NSURL fileURLWithPath:aFilepath];
    NSString *volumeName;
    [url getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:nil];
    //If for some reason the volumeName can't be found, just assume its the default Macintosh HD
    if (volumeName == nil) {
        volumeName = @"Macintosh HD";
    }
    
    //Split the POSIX filepath into a string array using / as the delimiter. Because all filepaths begin with a /, the first element of the array will be an empty string so we start itterating over the array at position 1 and initalize myString to the volumeName.
    NSArray<NSString *> *myStringArray = [aFilepath componentsSeparatedByString:@"/"];
    NSString *myString = volumeName;
    for (int i = 1; i < myStringArray.count; i++) {
         myString = [NSString stringWithFormat:@"%@:%@",myString,[myStringArray objectAtIndex:i]];
    }
    
    return myString;
}

@end
