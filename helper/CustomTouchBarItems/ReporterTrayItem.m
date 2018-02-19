//
//  CustomTouchBarItem.m
//  karma-touchbar-reporter
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "ReporterTrayItem.h"
#import "RunTracker.h"

@interface ReporterTrayItem ()
@property RunTracker *tracker;
@property (readonly, nonatomic) NSButton *button;
@end

@implementation ReporterTrayItem

- (instancetype)initWithIdentifier:(NSTouchBarItemIdentifier)identifier andTracker:(RunTracker*)tracker {
    
    if(self = [super initWithIdentifier:identifier]) {
        self.tracker = tracker;
        
        self.view = [NSButton buttonWithImage:[NSImage imageNamed:NSImageNameTouchBarUserTemplate] target:nil action:nil];
    }
    
    return self;
}

- (void)setAction:(SEL)action {
    self.button.action = action;
}

- (SEL)action {
    return self.button.action;
}

- (void)setTarget:(id)target {
    self.button.target = target;
}

- (id)target {
    return self.button.target;
}

- (NSButton*)button {
    return (NSButton*)self.view;
}

@end
