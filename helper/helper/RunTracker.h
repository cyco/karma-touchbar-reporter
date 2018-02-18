//
//  SpecCounter.h
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageReaderDelegate.h"

@interface RunTracker : NSObject <MessageReaderDelegate>
@property (readonly) NSString *projectName;
@property (readonly, getter=isRunning) BOOL running;
@property (readonly) NSUInteger runs;
@property (readonly) NSUInteger browsers;
@property (readonly) NSUInteger specs;
@property (readonly) NSUInteger failedSpecs;
@property (readonly) NSUInteger skippedSpecs;
@property (readonly) NSUInteger succeededSpecs;
@property (readonly) NSUInteger expectedTotal;
@end
