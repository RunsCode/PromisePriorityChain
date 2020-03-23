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

/// 正确的使用方式
#define PromisePriority(T,V) PrioritySessionElement<T, V> elementWithPromiseBlock:^(PriorityPromise<T, V> *promise)

/// Input： 入参类型  Output：给下个元素的数据类型
@interface PrioritySessionElement<Input, Output> : NSObject<PriorityElementProtocol>

/// 以下几种初始化方式已被废弃 保留只为做兼容处理
typedef void(^OnNext)(Output _Nullable value);
typedef void(^OnBreak)(NSError *_Nullable err);
//
typedef void(^ExecutePromiseBlock)(PriorityPromise<Input, Output> *promise);
typedef PrioritySessionElement *_Nonnull(^Then)(PrioritySessionElement *session);


/// Element 标识
@property (nonatomic, copy) NSString *identifier;
/// 连接下一个Element
@property (nonatomic, strong, readonly) Then then;


+ (instancetype)elementWithPromiseBlock:(ExecutePromiseBlock)block;
+ (instancetype)elementWithPromiseBlock:(ExecutePromiseBlock)block identifier:(NSString *_Nullable)identifier;

/// 订阅的是正常流程成功处理结果回调
- (instancetype)subscribe:(void (^)(Output _Nullable value))subscribe;
/// 流程打断回调
- (instancetype)catch:(void (^)(NSError *_Nullable error))catch;
/// 该过程处理结束回调 无论成功与否
- (instancetype)dispose:(dispatch_block_t)dispose;

- (void)breakPromiseLoop;

@end


NS_ASSUME_NONNULL_END
