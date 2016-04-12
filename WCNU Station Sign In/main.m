//
//  main.m
//  WCNU Station Sign In
//
//  Created by Zachary Whitten on 8/29/13.
//  Copyright (c) 2013 WCNURadio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, (const char **)argv);
}
