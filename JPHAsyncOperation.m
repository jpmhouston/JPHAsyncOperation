//
//  JPHAsyncOperation.m
//  JPHAsyncOperation
//
//  Created by Pierre Houston on 2015-06-19.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//
//  Inspired by AFURLConnectionOperation in AFNetworking, though no code was used as-is from it.
//

#import "JPHAsyncOperation.h"


typedef NS_ENUM(NSInteger, JPHAsyncOperationState) {
    JPHAsyncOperationReadyState       = 1,
    JPHAsyncOperationExecutingState   = 2,
    JPHAsyncOperationFinishedState    = 3,
    //JPHAsyncOperationPausedState    = -1, maybe a paused state, also like AFURLConnectionOperation?
};

@interface JPHAsyncOperation ()
@property (nonatomic, assign) JPHAsyncOperationState state;
@property (nonatomic, strong) JPHAsyncOperationBlock startBlock;
@property (nonatomic, strong) JPHAsyncOperationBlock cancelBlock;
@end


@implementation JPHAsyncOperation

+ (instancetype)operationWithBlock:(JPHAsyncOperationBlock)block
{
    return [[self alloc] initWithStartBlock:block cancelBlock:nil];
}

+ (instancetype)operationWithStartBlock:(JPHAsyncOperationBlock)startBlock cancelBlock:(JPHAsyncOperationBlock)cancelBlock
{
    return [[self alloc] initWithStartBlock:startBlock cancelBlock:cancelBlock];
}

- (instancetype)initWithBlock:(JPHAsyncOperationBlock)block
{
    return [self initWithStartBlock:block cancelBlock:nil];
}

- (instancetype)initWithStartBlock:(JPHAsyncOperationBlock)startBlock cancelBlock:(JPHAsyncOperationBlock)cancelBlock
{
    if (startBlock == nil) {
        [NSException raise:NSInvalidArgumentException format:@"%s startBlock must not be nil", __PRETTY_FUNCTION__];
    }
    
    self = [super init];
    if (self) {
        _startBlock = startBlock;
        _cancelBlock = cancelBlock;
        _state = JPHAsyncOperationReadyState;
    }
    return self;
}

static inline BOOL validStateTransition(JPHAsyncOperationState fromState, JPHAsyncOperationState toState, BOOL isCancelled)
{
    if ((int)toState == (int)fromState + 1)
        return YES;
    if (isCancelled && fromState == JPHAsyncOperationReadyState && toState == JPHAsyncOperationFinishedState)
        return YES;
    return NO;
}

static inline NSString *keypathForState(JPHAsyncOperationState state)
{
    switch (state) {
        case JPHAsyncOperationReadyState:
            return @"isReady";
        case JPHAsyncOperationExecutingState:
            return @"isExecuting";
        case JPHAsyncOperationFinishedState:
            return @"isFinished";
        //case JPHAsyncOperationPausedState:
        //    return @"isPaused";
        default:
            return @"state"; // returning nil would surely crash in will/didChangeValueForKey:
    }
}

- (void)setState:(JPHAsyncOperationState)newState
{
    if (validStateTransition(self.state, newState, [self isCancelled])) {
        NSString *oldStateKey = keypathForState(self.state);
        NSString *newStateKey = keypathForState(newState);
        
        [self willChangeValueForKey:newStateKey];
        [self willChangeValueForKey:oldStateKey];
        _state = newState;
        [self didChangeValueForKey:oldStateKey];
        [self didChangeValueForKey:newStateKey];
    }
}

- (void)finish
{
    self.state = JPHAsyncOperationFinishedState;
}

- (void)performStart
{
    if (self.startBlock) self.startBlock(self);
}

- (void)performCancel
{
    if (self.cancelBlock) self.cancelBlock(self);
}


#pragma mark -
// required overrides for an async NSOperation subclass

- (BOOL)isAsynchronous // perhaps implement isConcurrent instead to support older os versions
{
    return YES;
}

- (BOOL)isReady {
    return self.state == JPHAsyncOperationReadyState && [super isReady];
}

- (BOOL)isExecuting
{
    return self.state == JPHAsyncOperationExecutingState;
}

- (BOOL)isFinished
{
    return self.state == JPHAsyncOperationFinishedState;
}

- (void)start
{
    if ([self isCancelled]) {
        self.state = JPHAsyncOperationFinishedState;
    }
    else if ([self isReady]) {
        self.state = JPHAsyncOperationExecutingState;
    }
    
    if (self.state == JPHAsyncOperationExecutingState) {
        [self performStart];
    }
}

- (void)cancel
{
    BOOL alreadyCancelled = [self isCancelled];
    // multiple calls to this method should avoid running cancelBlock on all but the first
    
    [super cancel];
    
    if (!alreadyCancelled && [self isExecuting] && self.cancelBlock != nil) {
        [self performCancel];
    }
}

@end
