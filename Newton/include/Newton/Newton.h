//
//  Newton.h
//  Newton
//
//  Created by Fábio Bernardo on 07/10/15.
//  Copyright © 2015 Subtraction. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Newton.
FOUNDATION_EXPORT double NewtonVersionNumber;

//! Project version string for Newton.
FOUNDATION_EXPORT const unsigned char NewtonVersionString[];

#if __has_include(<Newton/Newton.h>)
#import <Newton/OperationQueue.h>
#import <Newton/Operation.h>
#import <Newton/BlockOperation.h>
#import <Newton/UnorderedGroupOperation.h>
#import <Newton/OrderedGroupOperation.h>
#import <Newton/NSOperation+Newton.h>
#import <Newton/NSOperationQueue+Newton.h>
#import <Newton/URLSessionTaskOperation.h>
#import <Newton/URLRequestTaskOperation.h>
#import <Newton/DownloadTaskOperation.h>
#import <Newton/OperationForSubclass.h>
#else
#import "OperationQueue.h"
#import "Operation.h"
#import "BlockOperation.h"
#import "UnorderedGroupOperation.h"
#import "OrderedGroupOperation.h"
#import "NSOperation+Newton.h"
#import "NSOperationQueue+Newton.h"
#import "URLSessionTaskOperation.h"
#import "URLRequestTaskOperation.h"
#import "DownloadTaskOperation.h"
#import "OperationForSubclass.h"
#endif
