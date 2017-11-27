//
//  OperationQueue.m
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "OperationQueue.h"
#import "NSOperation+Newton.h"

static void *KVOOerationQueueContext;

@interface OperationQueue ()
@property (nonatomic, copy) void (^allOperationsFinishedCompletionBlock)(void);
@property (nonatomic) BOOL hasFinished;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;
@end

@implementation OperationQueue

#pragma mark - Init/Dealloc

- (void)dealloc {
    [self removeObserver:self
              forKeyPath:@"operationCount"
                 context:&KVOOerationQueueContext
     ];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dispatchQueue = dispatch_queue_create("ABC", DISPATCH_QUEUE_SERIAL);
        
        [self addObserver:self
               forKeyPath:@"operationCount"
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:&KVOOerationQueueContext
         ];
    }
    return self;
}

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

- (void)waitUntilAllOperationsAreFinishedWithCompletion:(void (^)(void))completionBlock {
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
        }
    }];
}

- (void)addCompletionBlock:(void (^)(void))completionBlock {
    void (^oldCompletionBlock)(void) = self.allOperationsFinishedCompletionBlock;
    
    if (oldCompletionBlock) {
        self.allOperationsFinishedCompletionBlock = ^{
            oldCompletionBlock();
            completionBlock();
        };
    } else {
        self.allOperationsFinishedCompletionBlock = completionBlock;
    }
}

- (void)operationCountDidChange:(BOOL)isGoingToZero isComingFromZero:(BOOL)isComingFromZero {
    BOOL hasFinished = self.hasFinished;
    BOOL hasCompleted = !hasFinished && isGoingToZero;
    BOOL hasStarted = hasFinished && isComingFromZero;
    
    if (hasCompleted) {
        hasFinished = YES;
    } else if (hasStarted) {
        hasFinished = NO;
    }
    
    self.hasFinished = hasFinished;

    if (hasCompleted) {
        void (^block)(void) = self.allOperationsFinishedCompletionBlock;
        if (block) {
            block();
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:@"operationCount"] && object == self && context == &KVOOerationQueueContext) {
        //Call the finishing block if needed
        
        BOOL isGoingToZero = [change[NSKeyValueChangeNewKey] integerValue] == 0;
        BOOL isComingFromZero = [change[NSKeyValueChangeOldKey] integerValue] == 0;

        if (!isComingFromZero && !isGoingToZero) {
            return;
        }
        
        dispatch_async(self.dispatchQueue, ^{
            [self operationCountDidChange:isGoingToZero isComingFromZero:isComingFromZero];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
