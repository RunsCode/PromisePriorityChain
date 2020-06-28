//
//  PrioritySessionElement.m
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/10/26.
//  Copyright © 2019 RunsCode. All rights reserved.
//

#import "PrioritySessionElement.h"

@interface PrioritySessionElement ()

@property (nonatomic, strong) ExecutePromiseBlock executePromiseBlock;
@property (nonatomic, strong) PrioritySessionElement *next;

@property (nonatomic, strong) void(^subscribe)(id _Nullable valve);
@property (nonatomic, strong) void(^catch)(NSError *_Nullable error);
@property (nonatomic, strong) dispatch_block_t dispose;

@property (nonatomic, strong) PriorityPromise *promise;

@end

@implementation PrioritySessionElement

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"❤️❤️❤️%s, id : %@ ❤️❤️❤️", __PRETTY_FUNCTION__, self.identifier);
}
#endif

+ (instancetype)elementWithPromiseBlock:(ExecutePromiseBlock)block {
    return [self elementWithPromiseBlock:block identifier:nil];
}

+ (instancetype)elementWithPromiseBlock:(ExecutePromiseBlock)block identifier:(NSString *_Nullable)identifier {
    PrioritySessionElement *ele = [[self.class alloc] initWithIdentifer:identifier];
    ele.executePromiseBlock = block;
    return ele;
}

- (instancetype)initWithIdentifer:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (void)execute {
    [self executeWithData:nil];
}

- (void)executeWithData:(id)data {
    _input = data;
    //
    if (!_promise) {
        _promise = [PriorityPromise promiseWithInput:data element:self identifier:_identifier];
    } else {
        _promise.input = data;
    }
    if (_executePromiseBlock) {
        _executePromiseBlock(_promise);
        return;
    }
}

- (instancetype)subscribe:(void (^)(id _Nullable))subscribe {
    _subscribe = subscribe;
    return self;
}

- (instancetype)catch:(void (^)(NSError * _Nullable))catch {
    _catch = catch;
    return self;
}

- (instancetype)dispose:(dispatch_block_t)dispose {
    _dispose = dispose;
    return self;
}

- (Then)then {
    return ^(PrioritySessionElement *ele) {
        self.next = ele;
        return ele;
    };
}

- (void)breakPromiseLoop {
    [_promise breakLoop];
    _promise = nil;
}

- (void)onCatch:(NSError * _Nullable)error {
    !_catch ?: _catch(error);
    !_dispose ?: _dispose();
}

- (void)onSubscribe:(id _Nullable)data {
    !_subscribe ?: _subscribe(data);
    !_dispose ?: _dispose();
}

#pragma mark -- Private

- (void)tryNextWithValue:(id)value {
    if (!_next) return;
    [self.next executeWithData:value];
}

- (void)releaseChain {
    __auto_type next = self.next;
    while (next) {
        __auto_type obj = next;
        next = obj.next;
        obj = nil;
    }
}

#pragma mark -- JYPriorityElementProtocol

- (void)nextWithValue:(id _Nullable)value {
    _promise = nil;
    //
    [self tryNextWithValue:value];
}

- (void)breakProcess {
    _promise = nil;
}


@end

