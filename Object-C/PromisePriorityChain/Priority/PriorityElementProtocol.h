//
//  PriorityElementProtocol.h
//  PromisePriorityChain
//
//  Created by RunsCode on 2019/12/31.
//  Copyright © 2019 RunsCode. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, JYPriorityErrorEnum) {
    PriorityValidatedError = 100000,
    PriorityLoopValidatedError = 110000,
};


NS_ASSUME_NONNULL_BEGIN

@protocol PriorityElementProtocol <NSObject>

@required
- (void)nextWithValue:(id _Nullable)value;
- (void)breakWithError:(NSError *_Nullable)error;
/// override by subclass
- (void)execute;
- (void)executeWithData:(id _Nullable)data;

@end

NS_ASSUME_NONNULL_END
