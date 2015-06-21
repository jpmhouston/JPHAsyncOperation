//
//  NSOperationQueue+JPHAsync.h
//  JPHAsyncOperation
//
//  Created by Pierre Houston on 2015-06-19.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

@import Foundation;

#import "JPHAsyncOperation.h"


@interface NSOperationQueue (JPHAsync)

// addAyncOperationWithBlock starts an async operation on the receiver queue.
// The block takes a parameter, the operation itself, and when the block's
// asynchronous work is done, the operation's finish method must be called.
//
// example:
//   [queue addAyncOperationWithBlock:^(JPHAsyncOperation *op) {
//       [something asyncWithCompletion:^{
//           [op finish]
//       }];
//   }];
//
- (void)addAyncOperationWithBlock:(JPHAsyncOperationBlock)block;

- (void)addAyncOperationWithDependancies:(NSArray *)dependencies block:(JPHAsyncOperationBlock)block;

@end
