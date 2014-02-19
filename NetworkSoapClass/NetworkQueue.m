//
//  NetworkQueue.m
//  NetworkLibrary
//
//  Created by Devang Pandya on 26/04/13.
//  Copyright (c) 2013 Devang Pandya. All rights reserved.
//

#import "NetworkQueue.h"
#import "HTTPRequestOperation.h"
@implementation NetworkQueue
+ (NetworkQueue*) SharedNetworkQueue {
    static NetworkQueue* _one = nil;
    
    @synchronized( self ) {
        if( _one == nil ) {
            _one = [[ NetworkQueue alloc ] init];
            [_one setMaxConcurrentOperationCount:3];
        }
    }
    
    return _one;
}
+(int)getPendingOperationCount{
    return [[[NetworkQueue SharedNetworkQueue] operations] count];
}

+ (void)cancelOperationsNetworkQueue
{
//     NSLog(@"%s\nNSOperationQueue objects in queue:%d",__FUNCTION__,[[NetworkQueue SharedNetworkQueue] operationCount]);
    for (HTTPRequestOperation *operation in [[NetworkQueue SharedNetworkQueue] operations]) {
        [operation cancel];
    }
}
@end
