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

#import "ReporterTrayItem.h"
#import "RunTracker.h"
#import "NSImage+Tint.h"

@interface ReporterTrayItem ()
@property RunTracker *tracker;
@property (nonatomic, readonly) NSButton *button;

@property NSImage *tintedImage;
@property NSDictionary *failedSpecsAttributes;
@property NSDictionary *runningSpecsAttributes;
@end

@implementation ReporterTrayItem

- (instancetype)initWithIdentifier:(NSTouchBarItemIdentifier)identifier andTracker:(RunTracker*)tracker {

    if(self = [super initWithIdentifier:identifier]) {
        self.tracker = tracker;

        NSColor *tint = [NSColor colorWithRed:0.0 green:0.6 blue:0.9 alpha:0.8];
        self.tintedImage = [[NSImage imageNamed:NSImageNameTouchBarUserTemplate] imageTintedWithColor:tint];

        NSButton *button = [NSButton buttonWithTitle:@"" target:nil action:nil];
        button.image = [NSImage imageNamed:NSImageNameTouchBarUserTemplate];
        button.imageHugsTitle = true;
        button.imagePosition = NSImageOnly;

        [tracker addObserver:self forKeyPath:@"failedSpecs" options:0 context:nil];
        [tracker addObserver:self forKeyPath:@"succeededSpecs" options:0 context:nil];
        [tracker addObserver:self forKeyPath:@"running" options:0 context:nil];

        self.runningSpecsAttributes = [[button.attributedTitle attributesAtIndex:0 effectiveRange:nil] copy];
        NSMutableDictionary *attributes = [self.runningSpecsAttributes mutableCopy];
        attributes[NSForegroundColorAttributeName] = [NSColor redColor];
        self.failedSpecsAttributes = attributes;

        button.title = @"";
        self.view = button;
    }

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"running"]) {
        NSImage *image = [NSImage imageNamed:NSImageNameTouchBarUserTemplate];
        if(self.tracker.isRunning) image = self.tintedImage;
        self.button.image = image;
        return;
    }

    if(self.tracker.failedSpecs) {
        NSString *text = [NSString stringWithFormat:@"%-3ld", self.tracker.failedSpecs];
        self.button.imagePosition = NSImageAlignRight;
        self.button.attributedTitle = [[NSAttributedString alloc] initWithString:text attributes:self.failedSpecsAttributes];
    } else if(self.tracker.succeededSpecs) {
        NSString *text = [NSString stringWithFormat:@"%-3ld", self.tracker.succeededSpecs];
        self.button.imagePosition = NSImageAlignRight;
        self.button.attributedTitle = [[NSAttributedString alloc] initWithString:text attributes:self.runningSpecsAttributes];
    } else {
        self.button.imagePosition = NSImageOnly;
        self.button.title = @"";
    }
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
