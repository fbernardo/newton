//
//  BlockOperation.m
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "BlockOperation.h"
#import "OperationForSubclass.h"

@interface BlockOperation ()
@property (nonatomic, copy) id (^block)(id, BlockOperationCancelHandler);
@end

@implementation BlockOperation

#pragma mark - Init/Dealloc

+ (instancetype)newWithBlock:(id (^)(id,BlockOperationCancelHandler))block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(id,BlockOperationCancelHandler))block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

#pragma mark - Operation

-(void)execute {
    __weak typeof(self) weakSelf = self;
    [self finishWithOutput:self.block(self.input, ^(NSError *error){
        [weakSelf cancelWithError:error];
    })];
}

@end
