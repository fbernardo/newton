//
//  GroupOperation.m
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "UnorderedGroupOperation.h"
#import "OperationQueue.h"
#import "NSOperationQueue+Newton.h"
#import "OperationForSubclass.h"

@interface UnorderedGroupOperation () <OperationQueueDelegate>
@property (nonatomic, strong) OperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray *outputs;
@end

@implementation UnorderedGroupOperation
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
    NSAssert(!self.isFinished, @"GroupOperation is already finished");
    NSAssert(!self.isCancelled, @"GroupOperation is already cancelled");
    NSAssert(!self.isExecuting, @"GroupOperation has already started");
    [self.operationQueue addOperation:operation];
}

#pragma mark - Private Methods

- (void)addOutput:(id)output {
    if (!self.outputs) {
        self.outputs = [NSMutableArray array];
    }
    
    [self.outputs addObject:output];
}

#pragma mark - NSOperation

- (void)cancel {
    [self.operationQueue cancelAllOperations];
    [super cancel];
}

-(void)execute {
    self.operationQueue.suspended = false;
    __weak typeof(self) weakSelf = self;
    [self.operationQueue waitUntilAllOperationsAreFinishedWithCompletion:^{
        [weakSelf finishWithOutput:[self.outputs copy]];
    }];
}

#pragma mark - OperationQueueDelegate

- (void)operationQueue:(OperationQueue *)operationQueue operationDidFinish:(NSOperation *)operation {
    if ([operation isKindOfClass:[Operation class]]) {
        id output = ((Operation *)operation).output;
        if (output) {
            [self addOutput:output];
        }
    }
}

@end
