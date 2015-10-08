//
//  ParseOperation.m
//  ObjectiveCOperations
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "ParseOperation.h"
#import "OperationForSubclass.h"

@implementation ParseOperation

#pragma mark - Init/Dealloc

- (instancetype)initWithParseBlock:(id (^)(NSData *inputData))parseBlock {
    return [super initWithBlock:parseBlock];
}

- (instancetype)init { @throw nil; }

#pragma mark - Operation

- (void)execute {
    if (!self.input) {
        [self cancelWithError:[NSError errorWithDomain:@"ParseOperationDomain" code:0 userInfo:nil]];
    } else {
        [super execute];
    }
}

@end
