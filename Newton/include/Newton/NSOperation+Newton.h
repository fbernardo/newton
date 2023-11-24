//
//  NSOperation+Newton.h
//  Newton
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOperation (Newton)

- (void)addCompletionBlock:(void (^)(void))completionBlock;

- (void)addDependencies:(NSArray<NSOperation *> *)dependencies;

@end

NS_ASSUME_NONNULL_END
