//
//  OrderedGroupOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 09/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Newton/Operation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderedGroupOperation : Operation

+ (instancetype)groupWithOperations:(NSArray<NSOperation *> *)operations;
- (instancetype)initWithOperations:(NSArray<NSOperation *> *)operations;

@property (readonly) NSUInteger operationCount;

@end

NS_ASSUME_NONNULL_END