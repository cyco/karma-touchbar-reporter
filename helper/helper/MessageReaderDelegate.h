//
//  MessageReaderDelegate.h
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageReaderDelegate <NSObject>
- (void)runDidStart;
- (void)runDidStop;
- (void)specDidFail;
- (void)specDidSucceed;
- (void)specWasSkipped;
- (void)browserDidConnect;
- (void)browserDidDisconnect;
@end
