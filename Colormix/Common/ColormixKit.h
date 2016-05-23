//
//  ColormixKit
//  Colormix
//
//  Created by Christian Hatch on 7/17/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

//imports

#pragma mark - Macros

#ifdef DEBUG
#define DebugLog( s, ... ) NSLog(@"%@:(%d) %@", [NSString stringWithUTF8String:__PRETTY_FUNCTION__], __LINE__, [NSString stringWithFormat:(s), __VA_ARGS__])
#else
#define DebugLog( s, ... )
#endif
