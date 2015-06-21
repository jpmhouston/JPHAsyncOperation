//
//  NSOperationQueue+JPHAsync.m
//  JPHAsyncOperation
//
//  Created by Pierre Houston on 2015-06-19.
//  Copyright © 2015 Room 1337 Ventures. All rights reserved.
//

#import "NSOperationQueue+JPHAsync.h"


@implementation NSOperationQueue (JPHAsync)

- (void)addAyncOperationWithBlock:(JPHAsyncOperationBlock)block;
{
    JPHAsyncOperation *operation = [[JPHAsyncOperation alloc] initWithBlock:block];
    [self addOperation:operation];
}

- (void)addAyncOperationWithDependancies:(NSArray *)dependencies block:(JPHAsyncOperationBlock)block
{
    JPHAsyncOperation *operation = [[JPHAsyncOperation alloc] initWithBlock:block];
    for (NSOperation *dependency in dependencies)
        [operation addDependency:dependency];
    [self addOperation:operation];
}

@end
