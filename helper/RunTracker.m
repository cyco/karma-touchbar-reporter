//
//  SpecCounter.m
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "RunTracker.h"

@interface RunTracker ()
@property (readwrite) NSString *projectName;
@property (readwrite) NSURL *url;
@property (readwrite) BOOL running;
@property (readwrite) NSUInteger runs;
@property (readwrite) NSUInteger browsers;
@property (readwrite) NSUInteger failedSpecs;
@property (readwrite) NSUInteger skippedSpecs;
@property (readwrite) NSUInteger succeededSpecs;
@property (readwrite) NSUInteger expectedTotal;
@end

@implementation RunTracker

- (instancetype)initWithName:(NSString*)name at:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.projectName = name;
        self.url = url;
        
        self.running = false;
        self.browsers = 0;
        self.failedSpecs = 0;
        self.skippedSpecs = 0;
        self.succeededSpecs = 0;
        self.expectedTotal = 0;
    }
    return self;
}

- (void)runDidStart {
    _failedSpecs = 0;
    _succeededSpecs = 0;
    _skippedSpecs = 0;

    self.expectedTotal = self.specs;
    self.running = YES;
}

- (void)runDidStop {
    self.runs++;
    self.running = NO;
}

- (void)specDidFail{
    self.failedSpecs ++;
}

- (void)specDidSucceed {
    self.succeededSpecs ++;
}

- (void)specWasSkipped {
    self.skippedSpecs ++;
}

- (void)browserDidConnect {
    self.browsers++;
}

- (void)browserDidDisconnect {
    if(self.browsers > 0) {
        self.browsers--;
    }
}

- (NSUInteger)specs {
    return self.failedSpecs + self.succeededSpecs + self.skippedSpecs;
}

@end
