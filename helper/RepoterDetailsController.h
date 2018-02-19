//
//  RepoterDetailsController.h
//  karma-touchbar-reporter
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RunTracker;

@interface RepoterDetailsController : NSObject
+ (instancetype)controllerWithTracker:(RunTracker*)tracker;
@property (readonly) NSTouchBar *touchbar;
@end
