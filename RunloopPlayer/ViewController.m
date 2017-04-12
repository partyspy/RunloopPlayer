//
//  ViewController.m
//  RunloopPlayer
//
//  Created by mico on 06/04/2017.
//  Copyright © 2017 partyspy. All rights reserved.
//

#import "ViewController.h"
#import "RLThread.h"

@interface ViewController () <NSPortDelegate>
@property (nonatomic, strong) RLThread *anotherThread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start2ndThread:(UIButton *)sender {
    RLThread *thread = [[RLThread alloc] init];
    self.anotherThread = thread;
    [thread start];
}

- (IBAction)performOn2ndThread:(id)sender {
    NSThread *theThread = self.anotherThread;
    [self performSelector:@selector(greetingFromMain:) onThread:theThread withObject:@"hello" waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

- (void)greetingFromMain:(NSString *)greeting {
    NSLog(@"greeting from main: %@", greeting);
}

- (IBAction)fireSourceToRunloopOf2ndThread:(id)sender {
    CFRunLoopSourceRef source = self.anotherThread->source;
    CFRunLoopSourceSignal(source);
    CFRunLoopWakeUp(self.anotherThread->runLoop);
}

- (IBAction)stopRunLoop:(id)sender {
    CFRunLoopStop(self.anotherThread->runLoop);
    self.anotherThread = nil;
}


#pragma mark - mach port API is deprecated by Apple, can't be used
- (IBAction)start2ndThreadWithMachPort:(id)sender {
    NSPort *myPort = [NSMachPort port];
    RLThread *thread = [[RLThread alloc] initWithTarget:self selector:@selector(launch2ndThreadWithPort:) object:myPort];
    self.anotherThread = thread;
    [thread start];
}

- (void)launch2ndThreadWithPort:(NSPort *)port {
    [port setDelegate:self];
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    [myRunLoop addPort:port forMode:NSDefaultRunLoopMode];
    [myRunLoop run];
}

- (void)handlePortMessage:(NSPortMessage *)message {
//    NSLog("2nd Thread receive port message (msgid=%d", [message msgid]);
}




#pragma mark - 以下测试屏幕旋转会触发Source1

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (previousTraitCollection.horizontalSizeClass != self.traitCollection.horizontalSizeClass
        || previousTraitCollection.verticalSizeClass != self.traitCollection.verticalSizeClass) {
        NSLog(@"orientation changed");
    }
}




@end
