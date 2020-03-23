//
//  PriorityPromise.h
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/12/31.
//  Copyright © 2019 RunsCode. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol PriorityElementProtocol;

@interface PriorityPromise<Input, Output> : NSObject

typedef void(^PriorityPromiseNext)(Output _Nullable value);
typedef void(^PriorityPromiseBreak)(NSError *_Nullable err);
typedef void(^PriorityPromiseValidated)(BOOL isValid);
typedef void(^PriorityPromiseLoopValidated)(BOOL isValid, NSTimeInterval interval);
typedef void(^PriorityPromiseConditionDelay)(BOOL condition, NSTimeInterval interval);

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) id<PriorityElementProtocol> element;

/// 外部入参
@property (nonatomic, strong) Input input;
@property (nonatomic, strong) Output output;
/// 执行下一个
@property (nonatomic, strong, readonly) PriorityPromiseNext next;
/// 校验执行 校验通过执行下一个 否则打断当前流程
@property (nonatomic, strong, readonly) PriorityPromiseValidated validated;
/// 循环校验 直至到校验通过执行下一个 interval 校验的时间间隔 默认0
@property (nonatomic, strong, readonly) PriorityPromiseLoopValidated loopValidated;
/// condition == true 延迟interval执行
@property (nonatomic, strong, readonly) PriorityPromiseConditionDelay conditionDelay;

/// 打断当前流程 释放该链表之后的所有对象
@property (nonatomic, strong, readonly) PriorityPromiseBreak brake;

+ (instancetype)promiseWithInput:(Input)data element:(id<PriorityElementProtocol>)ele;
+ (instancetype)promiseWithInput:(Input)data element:(id<PriorityElementProtocol>)ele identifier:(NSString *)identidier;
- (void)breakLoop;
@end

NS_ASSUME_NONNULL_END
