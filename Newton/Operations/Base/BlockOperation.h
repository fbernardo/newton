//
//  BlockOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Newton/Operation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockOperation : Operation

+ (instancetype)newWithBlock:(id __nullable (^)(id __nullable input))block;
- (instancetype)initWithBlock:(id __nullable (^)(id __nullable input))block;

@end

NS_ASSUME_NONNULL_END
