//
//  RLThread.h
//  RunloopPlayer
//
//  Created by mico on 06/04/2017.
//  Copyright © 2017 partyspy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLThread : NSThread
{
@public
    CFRunLoopSourceRef source;
    CFRunLoopRef runLoop;
}
@end
