/*
 Copyright 2018 Christoph Leimbrock
 
 Permission is hereby granted, free of charge, to any person obtaining a
 copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be included
 in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
