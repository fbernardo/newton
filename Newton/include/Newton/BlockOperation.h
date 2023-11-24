//
//  BlockOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BlockOperationCancelHandler)(NSError * __nullable error);

@interface BlockOperation : Operation

+ (instancetype)newWithBlock:(id __nullable (^)(id __nullable input, BlockOperationCancelHandler cancelHandler))block;
- (instancetype)initWithBlock:(id __nullable (^)(id __nullable input, BlockOperationCancelHandler cancelHandler))block;

@end

NS_ASSUME_NONNULL_END
