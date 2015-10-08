//
//  OperationQueue.m
//  ObjectiveCOperations
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "OperationQueue.h"
#import "NSOperation+Newton.h"

@interface OperationQueue ()
@property (nonatomic, copy) void (^allOperationsFinishedCompletionBlock)();
@end

@implementation OperationQueue

#pragma mark - NSOperationQueue

-(void)addOperation:(NSOperation *)op {
    [self configureOperationBeforeBeingAdded:op];
    if ([self.delegate respondsToSelector:@selector(operationQueue:willAddOperation:)]) {
        [self.delegate operationQueue:self willAddOperation:op];
    }
    [super addOperation:op];
}

-(void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait {
    [ops enumerateObjectsUsingBlock:^(NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self configureOperationBeforeBeingAdded:obj];
    }];
    
    [ops enumerateObjectsUsingBlock:^(NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.delegate respondsToSelector:@selector(operationQueue:willAddOperation:)]) {
            [self.delegate operationQueue:self willAddOperation:obj];
        }
    }];
    
    [super addOperations:ops waitUntilFinished:wait];
}

#pragma mark - Public Methods

- (void)waitUntilAllOperationsAreFinishedWithCompletion:(void (^)())completionBlock {
    [self addCompletionBlock:completionBlock];
}

#pragma mark - Private Methods

- (void)configureOperationBeforeBeingAdded:(NSOperation *)operation {
    __weak typeof(self) weakSelf = self;
    __weak NSOperation *weakOp = operation;
    [operation addCompletionBlock:^{
        __strong NSOperation *strongOp = weakOp;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongOp && strongSelf) {
            //Call the appropriate delegate method
            if ([strongOp isCancelled]) {
                if ([strongSelf.delegate respondsToSelector:@selector(operationQueue:operationDidCancel:)]) {
                    [strongSelf.delegate operationQueue:strongSelf operationDidCancel:strongOp];
                }
            } else {
                if ([strongSelf.delegate respondsToSelector:@selector(operationQueue:operationDidFinish:)]) {
                    [strongSelf.delegate operationQueue:strongSelf operationDidFinish:strongOp];
                }
            }
            
            //Call the finishing block if needed
            if (strongSelf.operationCount == 0) {
                void (^block)() = strongSelf.allOperationsFinishedCompletionBlock;
                if (block) {
                    block();
                }
            }
        }
    }];
}

- (void)addCompletionBlock:(void (^)())completionBlock {
    void (^oldCompletionBlock)() = self.allOperationsFinishedCompletionBlock;
    
    if (oldCompletionBlock) {
        self.allOperationsFinishedCompletionBlock = ^{
            oldCompletionBlock();
            completionBlock();
        };
    } else {
        self.allOperationsFinishedCompletionBlock = completionBlock;
    }
}



@end
