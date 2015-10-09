//
//  OperationForSubclass.h
//  Newton
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Newton/Operation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Operation (ForSubclassesOnly)

- (void)execute;

//Don't override any of these methods
- (void)finishWithOutput:(nullable id)output;

@end

NS_ASSUME_NONNULL_END