//
//  URLSessionTaskOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Newton/Operation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLSessionTaskOperation : Operation

@property(nonatomic, strong, nullable) NSURLSessionTask *task;

+ (instancetype)newWithTask:(NSURLSessionTask *)task;
- (instancetype)initWithTask:(NSURLSessionTask *)task NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
