//
//  NodeCommunicator.h
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageReaderDelegate.h"

@interface MessageReader : NSObject
+ (instancetype)readerWithHandle:(NSFileHandle*)handle andDelegate:(id<MessageReaderDelegate>)delegate;
@end
