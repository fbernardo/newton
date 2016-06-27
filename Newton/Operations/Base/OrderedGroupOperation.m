//
//  OrderedGroupOperation.m
//  Newton
//
//  Created by Fábio Bernardo on 09/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "OrderedGroupOperation.h"
#import "OperationForSubclass.h"
#import "OperationQueue.h"
#import "NSOperationQueue+Newton.h"

@interface OrderedGroupOperation () <OperationQueueDelegate>
@property (nonatomic, strong) OperationQueue *operationQueue;
@property (nonatomic, strong) id lastOutput;
@property (nonatomic, weak) NSOperation *lastAddedOperation;
@end

@implementation OrderedGroupOperation
@dynamic operationCount;

#pragma mark - Static Methods

+ (NSSet *)keyPathsForValuesAffectingOperationCount {
    return [NSSet setWithObject:@"operationQueue.operationCount"];
}

#pragma mark - Properties

- (NSUInteger)operationCount {
    return self.operationQueue.operationCount;
}

#pragma mark - Init/Dealloc

+ (instancetype)newWithOperations:(NSArray<NSOperation *> *)operations {
    return [[self alloc] initWithOperations:operations];
}

- (instancetype)initWithOperations:(NSArray<NSOperation *> *)operations {
    self = [self init];
    if (self) {
        for (NSInteger i = 1; i < [operations count]; i++) {
            NSOperation *firstOperation = operations[i-1];
            NSOperation *secondOperation = operations[i];
            
            //If both operations are of type Operation and the second one has no input, assume it wants the input from the first.
            if ([firstOperation isKindOfClass:[Operation class]] && [secondOperation isKindOfClass:[Operation class]] && !((Operation *)secondOperation).input) {
                [(Operation *)secondOperation addInputDependency:(Operation *)firstOperation];
            } else {
                [secondOperation addDependency:firstOperation];
            }
            
        }
        
        self.lastAddedOperation = [operations lastObject];
        [self.operationQueue addOperations:operations];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        OperationQueue *operationQueue = [OperationQueue new];
        operationQueue.suspended = YES;
        operationQueue.delegate = self;
        _operationQueue = operationQueue;
    }
    return self;
}

#pragma mark - Public Methods

- (void)addOperation:(NSOperation *)operation {
    NSAssert(![self isFinished] && ![self isCancelled], @"Can't add operations to a group that already finished.");
    
    NSOperation *firstOperation = self.lastAddedOperation;
    self.lastAddedOperation = operation;
    
    if (firstOperation) {
        NSOperation *secondOperation = operation;
        
        //If both operations are of type Operation and the second one has no input, assume it wants the input from the first.
        if ([firstOperation isKindOfClass:[Operation class]] && [secondOperation isKindOfClass:[Operation class]] && !((Operation *)secondOperation).input) {
            [(Operation *)secondOperation addInputDependency:(Operation *)firstOperation];
        } else {
            [secondOperation addDependency:firstOperation];
        }
    }
    
    [self.operationQueue addOperation:operation];
}

#pragma mark - NSOperation

- (void)cancel {
    [super cancel];
    [self.operationQueue cancelAllOperations];
}

-(void)execute {
    NSOperation *firstOperation = self.operationQueue.operations.firstObject;
    if ([firstOperation isKindOfClass:[Operation class]] && !((Operation *) firstOperation).input) {
        ((Operation *) firstOperation).input = self.input;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.operationQueue waitUntilAllOperationsAreFinishedWithCompletion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf finishWithOutput:strongSelf.lastOutput];
        }
    }];
    
    self.operationQueue.suspended = NO;
}

#pragma mark - OperationQueueDelegate

- (void)operationQueue:(OperationQueue *)operationQueue operationDidCancel:(NSOperation *)operation {
    NSError *error = [operation isKindOfClass:[Operation class]] ? ((Operation *)operation).error : nil;    
    [self cancelWithError:error];
}

- (void)operationQueue:(OperationQueue *)operationQueue operationDidFinish:(NSOperation *)operation {
    if ([operation isKindOfClass:[Operation class]]) {
        id output = ((Operation *)operation).output;
        self.lastOutput = output;
    }
}

@end
