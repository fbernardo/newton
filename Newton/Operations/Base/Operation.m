//
//  Operation.m
//  Newton
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "Operation.h"
#import "NSOperation+Newton.h"

typedef NS_ENUM(NSUInteger, OperationState) {
    OperationStateInitialized = 0,
    OperationStateExecuting,
    OperationStateFinished
};

@interface Operation ()
@property(nonatomic) OperationState state;
@property(nonatomic, strong, readwrite) id output;
@property(nonatomic, strong, readwrite) NSError *error;
@end

@implementation Operation

#pragma mark - Static Methods

+ (NSSet *)keyPathsForValuesAffectingIsExecuting {
    return [NSSet setWithObject:@"state"];
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished {
    return [NSSet setWithObject:@"state"];
}

#pragma mark - NSOperation

- (BOOL)isFinished {
    return self.state == OperationStateFinished;
}

- (BOOL)isExecuting {
    return self.state == OperationStateExecuting;
}

- (void)start {
    NSArray *dependencies = [self.dependencies copy];
    for (NSOperation *dependency in dependencies) {
        [self removeDependency:dependency];
        if ([dependency isCancelled] && ![self isCancelled]) {
            [self cancelWithError:[dependency isKindOfClass:[Operation class]] ? ((Operation *)dependency).error : nil];
        }
    }
    
    if ([self isCancelled]) {
        [self finishWithOutput:nil];
    } else {
        self.state = OperationStateExecuting;
        [self execute];
    }
    
}

- (void)cancel {
    [super cancel];
    
    if ([self isExecuting]) {
        [self cancelExecution];
    }
}

#pragma mark - Public Methods

- (void)cancelWithError:(NSError *)error  {
    if ([self isCancelled]) {
        return;
    }
    self.error = error;
    [self cancel];
    
    NSAssert([self isCancelled], @"right after calling cancel this should be true");
}

- (void)addInputDependency:(Operation *)operation {
    __weak typeof(operation) weakOperation = operation;
    __weak typeof(self) weakSelf = self;
    [operation addCompletionBlock:^{
        __strong typeof(weakOperation) strongOperation = weakOperation;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongOperation && strongSelf && ![strongOperation isCancelled] && [strongSelf.dependencies containsObject:strongOperation]) {
            strongSelf.input = strongOperation.output;
        }
    }];
    [self addDependency:operation];
}

#pragma mark - Private Methods

- (void)execute {
    [self finishWithOutput:nil];
}

- (void)cancelExecution {
    [self finishWithOutput:nil];
}

- (void)finishWithOutput:(id)output {
    self.output = output;
    
    //Execute the completion block *BEFORE* notifying observers that the task has finished, which makes the queue move along.
    
    [self willChangeValueForKey:@"state"];
    
    _state = OperationStateFinished;
    
    void (^completionBlock)() = self.completionBlock;
    self.completionBlock = nil;
    if (completionBlock) {
        completionBlock();
    }
    
    [self didChangeValueForKey:@"state"];
}

@end
