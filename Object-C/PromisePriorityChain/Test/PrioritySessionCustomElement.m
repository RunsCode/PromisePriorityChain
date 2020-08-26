//
//  PrioritySessionCustomElement.m
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/10/28.
//  Copyright © 2019 RunsCode. All rights reserved.
//
#import "AppDelegate.h"

#import "PrioritySessionCustomElement.h"

@implementation PrioritySessionCustomElement

//- (void)dealloc {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}

//- (void)executeWithData:(id)data {
//    NSLog(@"sub Class execute data : %@", data);
////    __weak typeof(self) weakSelf = self;
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        __strong typeof(self) strongSelf = weakSelf;
//        // Custom events are passed down. Two steps are indispensable
////        [self onSubscribe:@-1];
////        [self nextWithValue:@(-1)];
//
//        // Custom event interrupt. Two steps are indispensable
//        [self onCatch:[NSError errorWithDomain:@"自定义Error" code:-1 userInfo:nil]];
//        [self breakProcess];
////    });
//}

- (void)executePromise:(PriorityPromise *)promise {
    promise.next(@(-100000896));
}

- (NSString *)identifier {
    return @"I'm custom subclass";
}

@end
