//
//  RLThread.m
//  RunloopPlayer
//
//  Created by mico on 06/04/2017.
//  Copyright © 2017 partyspy. All rights reserved.
//

#import "RLThread.h"

@implementation RLThread

- (instancetype)init {
    if (self = [super init]) {
        
        return self;
    }
    return nil;
}


- (void)main {
    
    CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        RunloopSourceScheduleRoutine, RunloopSourceCancelRoutine, RunloopSourcePerformRoutine };
    //set instance variables
    source = CFRunLoopSourceCreate(NULL, 0, &context);
    runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, source, kCFRunLoopDefaultMode);
    
    //give it a fire, and then runloop will not go to sleep but exit right after handling the source
//    CFRunLoopSourceSignal(source);
    
//    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
//    CFRunLoopRef myCFRunloop = (__bridge CFRunLoopRef)(myRunLoop);
    CFRunLoopRef myCFRunLoop = CFRunLoopGetCurrent();
    [[NSThread currentThread] setName:@"MyRunLoopThread"];
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"observer: loop entry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"observer: before timers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"observer: before sources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"observer: before waiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"observer: after waiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"observer: exit");
                break;
            case kCFRunLoopAllActivities:
                NSLog(@"observer: all activities");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(myCFRunLoop, observer, kCFRunLoopDefaultMode);

    
    // Add your sources or timers to the run loop and do any other setup.
//    [myRunLoop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer fired");
//    }];
//    [myRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    BOOL done = NO;
    do
    {
        // Start the run loop but return after each source is handled.
        SInt32   result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 30, YES);
        if (result == kCFRunLoopRunFinished) {
            NSLog(@"====runloop finished(no sources or timers), exit");
            done = YES;
        } else if (result == kCFRunLoopRunStopped) {
            NSLog(@"====runloop stopped, exit");
            done = YES;
        } else if (result == kCFRunLoopRunTimedOut) {
            NSLog(@"====runloop timeout, exit");
            done = NO;
        } else if (result == kCFRunLoopRunHandledSource) {
            NSLog(@"====runloop process a source, exit");
            done = YES;
        }
    }
    while (!done);
    
    // Clean up code here. Be sure to release any allocated autorelease pools.
}


void RunloopSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    NSLog(@"Schedule routine: source is added to runloop");
}

void RunloopSourceCancelRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    NSLog(@"Cancel Routine: source removed from runloop");
}

void RunloopSourcePerformRoutine(void *info) {
    NSLog(@"Perform Routine: source has fired");
}

@end
