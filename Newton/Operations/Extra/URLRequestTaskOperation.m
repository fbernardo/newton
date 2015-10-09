//
//  URLRequestTaskOperation.m
//  Newton
//
//  Created by Fábio Bernardo on 08/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import "URLRequestTaskOperation.h"
#import "OperationForSubclass.h"
@interface URLRequestTaskOperationResult ()
+ (URLRequestTaskOperationResult *)resultWithData:(NSData *)data response:(NSURLResponse *)response;
@end

@implementation URLRequestTaskOperationResult

+ (URLRequestTaskOperationResult *)resultWithData:(NSData *)data response:(NSURLResponse *)response {
    URLRequestTaskOperationResult *result = [[self alloc] init];
    result.data = data;
    result.response = response;
    return result;
}

@end

@interface URLRequestTaskOperation ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation URLRequestTaskOperation

#pragma mark - Properties

-(void)setInput:(id)input {
    NSParameterAssert([input isKindOfClass:[NSURLRequest class]]);
    [super setInput:input];
}

#pragma mark - Init/Dealloc

- (instancetype)initWithSession:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _session = session;
    }
    return self;
}

- (instancetype)init { @throw nil; }

#pragma mark - Operation

-(void)execute {
    NSAssert(self.task == nil, @"Task should be nil when %@ starts executing", [self class]);
    
    if (self.input) {
        __weak typeof(self) weakSelf = self;
        self.task = [self.session dataTaskWithRequest:self.input completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && response) {
                [weakSelf finishWithOutput:[URLRequestTaskOperationResult resultWithData:data response:response]];
            } else {
                [weakSelf cancelWithError:error];
            }
        }];
    } else {
        [self cancelWithError:[NSError errorWithDomain:@"OperationDomain" code:0 userInfo:nil]];
    }
}

@end
