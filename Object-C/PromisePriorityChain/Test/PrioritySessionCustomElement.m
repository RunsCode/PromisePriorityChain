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

- (void)executeWithData:(id)data {
    NSLog(@"sub Class execute data : %@", data);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self nextWithValue:@(-1)];
//        [self breakWithError:nil];
    });
}

- (NSString *)identifier {
    return @"I'm custom subclass";
}

@end
