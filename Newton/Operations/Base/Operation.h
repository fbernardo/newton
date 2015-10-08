//
//  Operation.h
//  ObjectiveCOperations
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Operation : NSOperation

@property (nullable, nonatomic, readonly, strong) NSError *error;
@property (nullable, nonatomic, readonly, strong) id output;
@property (nullable, nonatomic, strong) id input;

- (void)cancelWithError:(NSError *)error;
- (void)addInputDependency:(Operation *)operation;

@end

NS_ASSUME_NONNULL_END
