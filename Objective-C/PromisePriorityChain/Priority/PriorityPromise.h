//
//  JYPriorityPromise.h
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

/// Pipeline data delivery
@property (nonatomic, strong) Input input;
@property (nonatomic, strong) Output output;

/// execute  next element
@property (nonatomic, strong, readonly) PriorityPromiseNext next;

/// Check execution Check by executing the next or interrupting the current process
/// validated(BOOL isValid)
///
/// @parameter isValid Judge conditions for next
/// Similar to if(isValid) next()
/// isValid == false -> will call brake error and call catch block
@property (nonatomic, strong, readonly) PriorityPromiseValidated validated;

/// Cycle check until the check pass (isValid is true) to perform the next interval check interval default 0
/// loopValidated(BOOL isValid, NSTimeInterval interval)
///
/// @parameter isValid Judge conditions for polling
/// if isValid is false，start loop self,
/// if isValid is true, end loop and execute next element
///
/// @parameter interval if interval < 0, will call brake error and call catch block

@property (nonatomic, strong, readonly) PriorityPromiseLoopValidated loopValidated;

/// Check whether the condition needs to delay the next step
///
/// @parameter condition
/// @parameter interval time interval
///
/// (condition == true && interval > 0) -> delay interval execute next element
/// (condition == false || interval <= 0) -> execute next element
///
@property (nonatomic, strong, readonly) PriorityPromiseConditionDelay conditionDelay;

/// Break the current process, release all objects after the list
@property (nonatomic, strong, readonly) PriorityPromiseBreak brake;

+ (instancetype)promiseWithInput:(Input)data element:(id<PriorityElementProtocol>)ele;
+ (instancetype)promiseWithInput:(Input)data element:(id<PriorityElementProtocol>)ele identifier:(NSString *)identidier;
- (void)breakLoop;

@end

NS_ASSUME_NONNULL_END
