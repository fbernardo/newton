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
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
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
        self.task = [self.session downloadTaskWithRequest:self.input completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (location && response) {
                NSFileManager *manager = [NSFileManager defaultManager];
                NSURL *tempDirectory = [manager.temporaryDirectory URLByAppendingPathComponent:[NSUUID UUID].UUIDString isDirectory:YES];
                [manager createDirectoryAtURL:tempDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                NSURL *newLocation = [tempDirectory URLByAppendingPathComponent:response.suggestedFilename ?: [NSUUID UUID].UUIDString];
                
                if ([manager moveItemAtURL:location
                                     toURL:newLocation
                                     error:nil]) {
                    [weakSelf finishWithOutput:[DownloadTaskOperationResult resultWithURL:newLocation response:response]];
                } else {
                    [weakSelf cancelWithError:[NSError errorWithDomain:@"DownloadTaskOperationResultErrorDomain" code:0 userInfo:nil]];
                }
                
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
