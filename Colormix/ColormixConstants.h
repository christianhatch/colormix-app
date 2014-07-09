//
//  ColormixConstants.h
//  Colormix
//
//  Created by Christian Hatch on 7/9/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//


#pragma mark - Constants

#define FlurryAppID @"353K59ZD8JXYTKDZPYRQ"





#pragma mark - Macros


#ifdef DEBUG
#define DebugLog( s, ... ) NSLog(@"%@:(%d) %@", [NSString stringWithUTF8String:__PRETTY_FUNCTION__], __LINE__, [NSString stringWithFormat:(s), __VA_ARGS__])
#else
#define DebugLog( s, ... )
#endif
