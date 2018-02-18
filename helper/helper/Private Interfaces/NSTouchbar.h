//
//  NSTouchbar.h
//  helper
//
//  Created by Christoph Leimbrock on 18.02.18.
//  Copyright © 2018 Christoph Leimbrock. All rights reserved.
//

#ifndef NSTouchbar_h
#define NSTouchbar_h

@interface NSTouchBar ()
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;
@end

#endif /* NSTouchbar_h */
