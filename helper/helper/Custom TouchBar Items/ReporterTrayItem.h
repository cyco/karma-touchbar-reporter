//
//  CustomTouchBarItem.h
//  karma-touchbar-reporter
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RunTracker;
@interface ReporterTrayItem : NSCustomTouchBarItem
- (instancetype)initWithIdentifier:(NSTouchBarItemIdentifier)identifier andTracker:(RunTracker*)tracker;
@property (nonatomic) id target;
@property (nonatomic) SEL action;
@end
