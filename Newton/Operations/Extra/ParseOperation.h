//
//  ParseOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Newton/BlockOperation.h>

NS_ASSUME_NONNULL_BEGIN

typedef __nullable id (^ParseOperationBlock)(NSData * __nonnull inputData);

@interface ParseOperation : BlockOperation

- (instancetype)initWithParseBlock:(ParseOperationBlock)parseBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END