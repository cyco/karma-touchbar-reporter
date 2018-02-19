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
