//
//  PrioritySessionElement.h
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/10/26.
//  Copyright © 2019 RunsCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriorityPromise.h"
#import "PriorityElementProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// The correct way to use
#define PromisePriority(T,V) PrioritySessionElement<T, V> elementWithPromiseBlock:^(PriorityPromise<T, V> *promise)

/// Input: Input parameter type Output: Data type for the next element
@interface PrioritySessionElement<Input, Output> : NSObject<PriorityElementProtocol>

typedef void(^ExecutePromiseBlock)(PriorityPromise<Input, Output> *promise);
typedef PrioritySessionElement *_Nonnull(^Then)(PrioritySessionElement *session);

@property (nonatomic, weak) Input input;

/// Element id
@property (nonatomic, copy) NSString *identifier;
/// link to the next Element
@property (nonatomic, strong, readonly) Then then;


+ (instancetype)elementWithPromiseBlock:(ExecutePromiseBlock)block;
+ (instancetype)elementWithPromiseBlock:(ExecutePromiseBlock)block identifier:(NSString *_Nullable)identifier;

/// Subscribe to the normal process and successfully process the result callback
- (instancetype)subscribe:(void (^)(Output _Nullable value))subscribe;
/// Process interrupt callback
- (instancetype)catch:(void (^)(NSError *_Nullable error))catch;
/// The process ends with a callback regardless of success
- (instancetype)dispose:(dispatch_block_t)dispose;

- (void)breakPromiseLoop;

@end


NS_ASSUME_NONNULL_END
