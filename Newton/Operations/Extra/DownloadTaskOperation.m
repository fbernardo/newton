//
//  DownloadTaskOperation.m
//  Newton
//
//  Created by Fábio Bernardo on 24/11/2017.
//  Copyright © 2017 Subtraction. All rights reserved.
//

#import "DownloadTaskOperation.h"
#import "OperationForSubclass.h"

@interface DownloadTaskOperationResult ()
+ (DownloadTaskOperationResult *)resultWithURL:(NSURL *)fileURL response:(NSURLResponse *)response;
@end

@implementation DownloadTaskOperationResult

+ (DownloadTaskOperationResult *)resultWithURL:(NSURL *)fileURL response:(NSURLResponse *)response {
    DownloadTaskOperationResult *result = [self new];
    result.temporaryFileURL = fileURL;
    result.response = response;
    return result;
}

@end

@interface DownloadTaskOperation ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation DownloadTaskOperation

#pragma mark - Properties

-(void)setInput:(id)input {
    NSParameterAssert([input isKindOfClass:[NSURLRequest class]]);
    [super setInput:input];
}

#pragma mark - Init/Dealloc

+ (instancetype)newWithSession:(NSURLSession *)session {
    return [[self alloc] initWithSession:session];
}

- (instancetype)initWithSession:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _session = session;
    }
    return self;
}

- (instancetype)init { @throw nil; }

#pragma mark - Operation

- (void)cancel {
    if (self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    [super cancel];
}

-(void)execute {
    NSAssert(self.task == nil, @"Task should be nil when %@ starts executing", [self class]);
    
    if (self.input) {
        __weak typeof(self) weakSelf = self;
        self.task = [self.session downloadTaskWithRequest:self.input completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (location && response) {
                [weakSelf finishWithOutput:[DownloadTaskOperationResult resultWithURL:location response:response]];
            } else {
                [weakSelf cancelWithError:error];
            }
        }];
        
        [self.task resume];
    } else {
        [self cancelWithError:nil];
    }
}


@end
