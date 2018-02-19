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

#import "MessageReader.h"

@interface MessageReader ()
@property (strong) NSFileHandle *handle;
- (void)parseCommunique:(NSString*)string;
@property (weak) id<MessageReaderDelegate> delegate;
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
    for(NSUInteger i=0; i < string.length; i++) {
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
