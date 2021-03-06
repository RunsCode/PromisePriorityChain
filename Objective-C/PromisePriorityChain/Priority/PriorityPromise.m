//
//  PriorityPromise.m
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/12/31.
//  Copyright © 2019 RunsCode. All rights reserved.
//

#import "PriorityPromise.h"
#import "PriorityElementProtocol.h"
#ifndef weakify
#if DEBUG
    #if __has_feature(objc_arc)
    #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
    #else
    #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
    #endif
#else
    #if __has_feature(objc_arc)
    #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
    #else
    #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
    #endif
#endif
#endif

#ifndef strongify
#if DEBUG
    #if __has_feature(objc_arc)
    #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
    #else
    #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
    #endif
#else
    #if __has_feature(objc_arc)
    #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
    #else
    #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
    #endif
#endif
#endif

@interface PriorityPromise ()

@end

@implementation PriorityPromise

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"❤️❤️%s , id : %@❤️❤️", __PRETTY_FUNCTION__, _identifier);
}
#endif

+ (instancetype)promiseWithInput:(id)data element:(id<PriorityElementProtocol>)ele {
    PriorityPromise *p = [[PriorityPromise alloc] init];
    p.input = data;
    p.element = ele;
    return p;
}

+ (instancetype)promiseWithInput:(id)data element:(id<PriorityElementProtocol>)ele identifier:(NSString *)identidier {
    PriorityPromise *p = [PriorityPromise promiseWithInput:data element:ele];
    p.identifier = identidier;
    return p;
}

- (PriorityPromiseBreak)brake {
    @weakify(self)
    return ^(NSError *_Nullable err) {
        @strongify(self)
        [self.element onCatch:err];
    };
}

- (PriorityPromiseNext)next {
    @weakify(self)
    return ^(id _Nullable data) {
        @strongify(self)
        [self.element onSubscribe:!self.output ? data : self.output];
        [self.element nextWithValue:data];
    };
}

- (PriorityPromiseValidated)validated {
    @weakify(self)
    return ^(BOOL bValue) {
        @strongify(self)
        if (bValue) {
            [self.element onSubscribe:self.output];
            [self.element nextWithValue:self.output];
            return;
        }
        NSError *err = [NSError errorWithDomain:@"validated failure" code:PriorityValidatedError userInfo:nil];
        [self.element onCatch:err];
    };
}

- (PriorityPromiseLoopValidated)loopValidated {
    @weakify(self)
    return ^(BOOL bValue, NSTimeInterval interval) {
        @strongify(self)
        if (bValue) {
            [self.element onSubscribe:self.output];
            [self.element nextWithValue:self.output];
#ifdef DEBUG
            NSLog(@"2.priority promise %@ loop validates succed", self.identifier);
#endif
            return;
        }
        if (interval < 0) {
            NSError *err = [NSError errorWithDomain:@"interval must bigger than 0" code:PriorityLoopValidatedError userInfo:nil];
            [self.element onCatch:err];
#ifdef DEBUG
            NSLog(@"1.priority promise %@ loop validates failure", self.identifier);
#endif
            return;
        }

        [(NSObject *)(self.element) performSelector:@selector(executeWithData:) withObject:self.input afterDelay:interval];
#ifdef DEBUG
        NSLog(@"0. priority promise %@ loop validates", self.identifier);
#endif
    };
}

- (PriorityPromiseConditionDelay)conditionDelay {
    @weakify(self)
    return ^(BOOL condition, NSTimeInterval interval) {
        @strongify(self)
        if (!condition || interval <= 0) {
            [self.element onSubscribe:self.input];
            [self.element nextWithValue:self.input];
            return;
        }
        [(NSObject *)(self.element) performSelector:@selector(nextWithValue:) withObject:self.output afterDelay:interval];
    };
}

- (void)breakLoop {
    [NSObject cancelPreviousPerformRequestsWithTarget:_element selector:@selector(executeWithData:) object:_input];
    [NSObject cancelPreviousPerformRequestsWithTarget:_element selector:@selector(nextWithValue:) object:_input];
}

@end
