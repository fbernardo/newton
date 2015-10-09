//
//  URLSessionTaskOperation.m
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "URLSessionTaskOperation.h"
#import "OperationForSubclass.h"

static void * kURLSessionTaskOperationKVOContext;

@implementation URLSessionTaskOperation

#pragma mark - Properties

- (void)setTask:(NSURLSessionTask *)task {
    if (_task != task) {
        _task = task;
        
        NSAssert(!self.isExecuting && !self.isFinished, @"Operation has already started");
        NSAssert(task.state == NSURLSessionTaskStateSuspended, @"Task was resumed by something other than %@", self);
    }
}

#pragma mark - Init/Dealloc

+ (instancetype)newWithTask:(NSURLSessionTask *)task {
    return [[self alloc] initWithTask:task];
}

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    NSAssert(task.state == NSURLSessionTaskStateSuspended, @"Task was resumed by something other than %@", self);
    self = [super init];
    if (self) {
        self.task = task;
    }
    return self;
}

- (instancetype)init { @throw nil; }

#pragma mark - Operation

- (void)execute {
    if (!self.task) {
        [self cancelWithError:nil];
    } else {
        NSAssert(self.task.state == NSURLSessionTaskStateSuspended, @"Task was resumed by something other than %@", self);
        
        [self.task addObserver:self forKeyPath:@"state" options:0 context:&kURLSessionTaskOperationKVOContext];
        
        [self.task resume];
    }
}

- (void)cancel {
    if (self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    [super cancel];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kURLSessionTaskOperationKVOContext) {
        
        if (object == self.task && [keyPath isEqualToString:@"state"] && self.task.state == NSURLSessionTaskStateCompleted) {
            [self.task removeObserver:self forKeyPath:@"state" context:&kURLSessionTaskOperationKVOContext];
            
            NSError *error = self.task.error;
            NSURLResponse *response = self.task.response;
            
            if (error) {
                [self cancelWithError:error];
            } else {
                [self finishWithOutput:response];
            }
            
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
