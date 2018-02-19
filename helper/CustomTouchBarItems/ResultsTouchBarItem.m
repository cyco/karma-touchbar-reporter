//
//  ResultsTouchBarItem.m
//  karma-touchbar-reporter
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "ResultsTouchBarItem.h"
#import "RunTracker.h"

@interface ResultsTouchBarItem ()
@property (strong) RunTracker *tracker;
@property (strong) NSTextField *field;

@property NSUInteger failed;
@property NSUInteger skipped;
@property NSUInteger succeeded;
@end

@implementation ResultsTouchBarItem
- (instancetype)initWithIdentifier:(NSTouchBarItemIdentifier)identifier andTracker:(RunTracker*)tracker {
    
    if(self = [super initWithIdentifier:identifier]) {
        self.failed = 0;
        self.skipped = 0;
        self.succeeded = 0;
        
        self.tracker = tracker;
        
        [self.tracker addObserver:self forKeyPath:@"failedSpecs" options:0 context:nil];
        [self.tracker addObserver:self forKeyPath:@"skippedSpecs" options:0 context:nil];
        [self.tracker addObserver:self forKeyPath:@"succeededSpecs" options:0 context:nil];
        [self.tracker addObserver:self forKeyPath:@"running" options:0 context:nil];
        [self.tracker addObserver:self forKeyPath:@"runs" options:0 context:nil];
        
        self.field = [NSTextField textFieldWithString:@""];
        [self.field setLineBreakMode:NSLineBreakByClipping];
        
        [self.field setMaximumNumberOfLines:2];

        self.view = self.field;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"running"]) {
        if(self.tracker.isRunning) {
            self.failed = 0;
            self.skipped = 0;
            self.succeeded = 0;
            [self.field setStringValue:@""];
        }
        
        return;
    }
    
    NSInteger failedDifference = self.tracker.failedSpecs - self.failed;
    NSInteger skippedDifference = self.tracker.skippedSpecs - self.skipped;
    NSInteger succeededDifference = self.tracker.succeededSpecs - self.succeeded;
    NSMutableAttributedString *value = [[self.field attributedStringValue] mutableCopy];
    NSDictionary *skipAttributes = @{NSForegroundColorAttributeName: [NSColor secondaryLabelColor]};
    NSDictionary *failAttributes = @{NSForegroundColorAttributeName: [NSColor systemRedColor]};
    NSDictionary *successAttributes = @{NSForegroundColorAttributeName: [NSColor systemGreenColor]};
    
    NSAttributedString *failedString  = [[NSAttributedString alloc] initWithString:@"𐄂" attributes:failAttributes];
    NSAttributedString *successString = [[NSAttributedString alloc] initWithString:@"✓" attributes:successAttributes];
    NSAttributedString *skipString    = [[NSAttributedString alloc] initWithString:@"-" attributes:skipAttributes];
    
    for(NSInteger i=0; i < failedDifference; i++) {
        [value appendAttributedString:failedString];
    }
    for(NSInteger i=0; i < skippedDifference; i++) {
        [value appendAttributedString:skipString];
    }
    for(NSInteger i=0; i < succeededDifference; i++) {
        [value appendAttributedString:successString];
    }
    
    [self.field setAttributedStringValue:value];
    
    self.failed = self.tracker.failedSpecs;
    self.skipped = self.tracker.skippedSpecs;
    self.succeeded = self.tracker.succeededSpecs;
}
@end
