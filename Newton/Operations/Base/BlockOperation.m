//
//  BlockOperation.m
//  ObjectiveCOperations
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "BlockOperation.h"
#import "OperationForSubclass.h"

@interface BlockOperation ()
@property (nonatomic, copy) id (^block)();
@end

@implementation BlockOperation

#pragma mark - Init/Dealloc

+ (instancetype)newWithBlock:(id (^)(id))block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(id))block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

#pragma mark - Operation

-(void)execute {
    [self finishWithOutput:self.block(self.input)];
}

@end
