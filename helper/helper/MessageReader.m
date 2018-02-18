//
//  NodeCommunicator.m
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#import "MessageReader.h"

@interface MessageReader ()
@property (strong) NSFileHandle *handle;
@property (weak) id<MessageReaderDelegate> delegate;
- (void)parseCommunique:(NSString*)string;
@end

typedef unichar Message;
@implementation MessageReader
+ (instancetype)readerWithHandle:(NSFileHandle*)handle andDelegate:(id<MessageReaderDelegate>)delegate {
    MessageReader *instance = [[self alloc] init];
    instance.delegate = delegate;
    
    handle.readabilityHandler = ^(NSFileHandle * _Nonnull handle) {
        NSData *data = [handle availableData];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [instance parseCommunique: string];
    };
    instance.handle = handle;
    [handle waitForDataInBackgroundAndNotify];

    return instance;
}

- (void)parseCommunique:(NSString*)string {
    for(int i=0; i < string.length; i++) {
        Message c = [string characterAtIndex:i];
        [self handleMessage:c];
    }
}

- (void)handleMessage:(Message)m {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(m == 'b') {
            [self.delegate browserDidConnect];
        }
        
        if(m == 'B') {
            [self.delegate browserDidDisconnect];
        }
        
        if(m == 'r') {
            [self.delegate runDidStart];
        }
        
        if(m == 'R') {
            [self.delegate runDidStop];
        }
        
        if(m == 's') {
            [self.delegate specDidSucceed];
        }
        
        if(m == 'x') {
            [self.delegate specWasSkipped];
        }
        
        if(m == 'f') {
            [self.delegate specDidFail];
        }
    });
}
@end
