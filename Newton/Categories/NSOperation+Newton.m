//
//  NSOperation+Newton.m
//  Newton
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "NSOperation+Newton.h"

@implementation NSOperation (Newton)

- (void)addCompletionBlock:(void (^)(void))completionBlock {
    void (^oldBlock)(void) = self.completionBlock;
    if (oldBlock) {
        self.completionBlock = ^{
            oldBlock();
            completionBlock();
        };
    } else {
        self.completionBlock = completionBlock;
    }
}

- (void)addDependencies:(NSArray<NSOperation *> *)dependencies {
    for (NSOperation *op in dependencies) {
        [self addDependency:op];
    }
}

@end
