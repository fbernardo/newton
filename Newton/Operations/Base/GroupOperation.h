//
//  GroupOperation.h
//  ObjectiveCOperations
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Newton/Operation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupOperation : Operation

+ (instancetype)groupWithOperations:(NSArray<NSOperation *> *)operations;
- (instancetype)initWithOperations:(NSArray<NSOperation *> *)operations;

- (void)addOperation:(NSOperation *)operation;

@end

NS_ASSUME_NONNULL_END