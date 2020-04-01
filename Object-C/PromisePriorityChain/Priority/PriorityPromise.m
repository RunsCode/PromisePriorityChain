//
//  PriorityPromise.m
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/12/31.
//  Copyright © 2019 RunsCode. All rights reserved.
//

#import "PriorityPromise.h"
#import "PriorityElementProtocol.h"

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

- (PriorityPromiseNext)next {
    return ^(id _Nullable data) {
        [self.element nextWithValue:data];
    };
}

- (PriorityPromiseValidated)validated {
    return ^(BOOL bValue) {
        if (bValue) {
            [self.element nextWithValue:self.output];
            return;
        }
        NSError *err = [NSError errorWithDomain:@"validated failure" code:PriorityValidatedError userInfo:nil];
        [self.element breakWithError:err];
    };
}

- (PriorityPromiseLoopValidated)loopValidated {
    return ^(BOOL bValue, NSTimeInterval interval) {
        if (bValue) {
            [self.element nextWithValue:self.output];
            return;
        }
        if (interval < 0) {
            NSError *err = [NSError errorWithDomain:@"interval must bigger than 0" code:PriorityLoopValidatedError userInfo:nil];
            [self.element breakWithError:err];
            return;
        }

        [(NSObject *)(self.element) performSelector:@selector(executeWithData:) withObject:self.input afterDelay:interval];
    };
}

- (PriorityPromiseConditionDelay)conditionDelay {
    return ^(BOOL condition, NSTimeInterval interval) {
        if (!condition || interval <= 0) {
            [self.element nextWithValue:self.input];
            return;
        }
        [(NSObject *)(self.element) performSelector:@selector(nextWithValue:) withObject:self.output afterDelay:interval];
    };
}

- (PriorityPromiseBreak)brake {
    return ^(NSError *_Nullable err) {
        [self.element breakWithError:err];
    };
}

- (void)breakLoop {
    [NSObject cancelPreviousPerformRequestsWithTarget:_element selector:@selector(executeWithData:) object:_input];
    [NSObject cancelPreviousPerformRequestsWithTarget:_element selector:@selector(nextWithValue:) object:_input];
}

@end
