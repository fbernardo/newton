//
//  URLRequestTaskOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Newton/URLSessionTaskOperation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLRequestTaskOperationResult : NSObject
@property (nullable, nonatomic, strong) NSData *data;
@property (nullable, nonatomic, strong) NSURLResponse *response;
@end


@interface URLRequestTaskOperation : Operation

- (instancetype)initWithSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END