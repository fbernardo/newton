//
//  OperationQueue.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OperationQueue;

@protocol OperationQueueDelegate <NSObject>

@optional
- (void)operationQueue:(OperationQueue *)operationQueue willAddOperation:(NSOperation *)operation;
- (void)operationQueue:(OperationQueue *)operationQueue operationDidCancel:(NSOperation *)operation;
- (void)operationQueue:(OperationQueue *)operationQueue operationDidFinish:(NSOperation *)operation;

@end

@interface OperationQueue : NSOperationQueue

@property (nullable, nonatomic, weak) id<OperationQueueDelegate> delegate;

- (void)waitUntilAllOperationsAreFinishedWithCompletion:(void (^)())completionBlock;

@end

NS_ASSUME_NONNULL_END
