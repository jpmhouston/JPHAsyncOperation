//
//  JPHAsyncOperation.h
//  JPHAsyncOperation
//
//  Created by Pierre Houston on 2015-06-19.
//  Copyright © 2015 Room 1337 Ventures. All rights reserved.
//

@import Foundation;


@class JPHAsyncOperation;
typedef void (^JPHAsyncOperationBlock)(JPHAsyncOperation *op);


@interface JPHAsyncOperation : NSOperation

+ (instancetype)operationWithBlock:(JPHAsyncOperationBlock)block;
+ (instancetype)operationWithStartBlock:(JPHAsyncOperationBlock)startBlock cancelBlock:(JPHAsyncOperationBlock)cancelBlock;

- (instancetype)initWithBlock:(JPHAsyncOperationBlock)block;
- (instancetype)initWithStartBlock:(JPHAsyncOperationBlock)startBlock cancelBlock:(JPHAsyncOperationBlock)cancelBlock;

- (void)finish;

@end


// yes, deliberately import this category header after the declarations above
// it depends on JPHAsyncOpBlock to be defined but when imported by this file,
// its own import of this same header is of course short-circuited.
// could instead have JPHAsyncOperation/JPHAsyncOperation.h be an umbrealla header
// which includes this and then the category header.
#import "NSOperationQueue+JPHAsync.h"
