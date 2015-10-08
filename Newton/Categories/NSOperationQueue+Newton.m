//
//  NSOperationQueue+Newton.m
//  ObjectiveCOperations
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "NSOperationQueue+Newton.h"

@implementation NSOperationQueue (Newton)

- (void)addOperations:(NSArray<NSOperation *> *)ops {
    [self addOperations:ops waitUntilFinished:NO];
}

@end
