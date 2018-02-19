#ifndef NSTouchbar_h
#define NSTouchbar_h

@interface NSTouchBar ()
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;
@end

#endif