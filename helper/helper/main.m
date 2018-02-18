//
//  main.m
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "AppDelegate.h"

int main(){
    [NSApplication sharedApplication];
    [NSApp setDelegate: [[AppDelegate alloc] init]];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp run];
    
    return 0;
}

