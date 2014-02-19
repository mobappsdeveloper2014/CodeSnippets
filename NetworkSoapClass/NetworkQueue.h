//
//  NetworkQueue.h
//  NetworkLibrary
//
//  Created by Devang Pandya on 26/04/13.
//  Copyright (c) 2013 Devang Pandya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkQueue : NSOperationQueue
+ (NetworkQueue*) SharedNetworkQueue;
+ (int)getPendingOperationCount;
+ (void)cancelOperationsNetworkQueue;
@end
