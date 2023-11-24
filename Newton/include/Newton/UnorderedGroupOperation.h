//
//  UnorderedGroupOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnorderedGroupOperation : Operation

+ (instancetype)newWithOperations:(NSArray<NSOperation *> *)operations;
- (instancetype)initWithOperations:(NSArray<NSOperation *> *)operations;

- (void)addOperation:(NSOperation *)operation;

@property (readonly) NSUInteger operationCount;

@end

NS_ASSUME_NONNULL_END
