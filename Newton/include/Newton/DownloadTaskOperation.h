//
//  DownloadTaskOperation.h
//  Newton
//
//  Created by Fábio Bernardo on 24/11/2017.
//  Copyright © 2017 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadTaskOperationResult : NSObject
@property (nullable, nonatomic, strong) NSURL *temporaryFileURL;
@property (nullable, nonatomic, strong) NSURLResponse *response;
@end

@interface DownloadTaskOperation : Operation

+ (instancetype)newWithSession:(NSURLSession *)session;
- (instancetype)initWithSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
