//
//  HTTPRequestOperation.m
//  NetworkLibrary
//
//  Created by Devang Pandya on 26/04/13.
//  Copyright (c) 2013 Devang Pandya. All rights reserved.
//
#pragma clang diagnostic ignored "-Warc-performSelector-leaks" // added to silent performSelector Warnings


#import "NetworkQueue.h"
#import "HTTPRequestOperation.h"
#import "NSData+Base64.h"

@implementation HTTPRequestOperation
@synthesize delegate;

#pragma mark Initializer

- (id)initWithURL:(NSString*)url requestData:(NSString*)messageBody finishSel:(SEL)didFinishSEL failSEL:(SEL)didFailSEL
{
    self = [super init];
    if (self) {
        requestURL =url;
        _didFinishSelector = didFinishSEL;
        _didFailSelector = didFailSEL;
        _soapMessage = messageBody;
        _isExecuting = NO;
        _isFinished = NO;

        [[NetworkQueue SharedNetworkQueue] addOperation:self];
    }
    return self;
}

- (void)start
{
    if (!self.isCancelled) {
        if (![NSThread isMainThread]){
            [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
            return;
        }
#ifdef DEBUG
        NSLog(@"Operation Started for SOAPACTION:<%@> URL:<%@>.",_soapAction, requestURL);
#endif
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        NSURL* url = [[NSURL alloc] initWithString:requestURL];
        //    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setTimeoutInterval:REQUESTTIMEOUTINTERVAL];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [_soapMessage length]];
        
        /* Setup Request Headers */
        /* Add Basic Authorization */
        NSString *authHeader = [NSString stringWithFormat:@"%@:%@",SERVICEUSERNAME,SERVICEPASSWORD];
        [request setValue:[NSString stringWithFormat:@"Basic %@",[NSData base64DataFromString:authHeader]] forHTTPHeaderField:@"Authorization"];
        
        //    [request addValue: @"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue: @"text/xml" forHTTPHeaderField:@"Content-Type"];
        [request addValue: _soapAction forHTTPHeaderField:@"SOAPAction"];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        /* Add request Body */
        [request setHTTPBody: [_soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
   #ifdef DEBUG
//        NSLog(@"Web Service Request : %@",_soapMessage);
   #endif
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        //    [connection start];
    }
}
- (void)finish
{
#ifdef DEBUG
    NSLog(@"Operation Finished for SOAPACTION :<%@>.\n "@"status code: %d, data size: %u",
          _soapAction, _statusCode, [dataReceived length]);
#endif
    connection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    delegate = nil;//Mitesh
}
- (BOOL)isConcurrent
{
    return YES;
}
//- (void)cancel
//{
//    NSLog(@"%s",__FUNCTION__);
//
//    
//    [self willChangeValueForKey:@"isCancelled"];
//    [self didChangeValueForKey:@"isCancelled"];
//
//}
#pragma mark - AuthenticationChallenge Delegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] > 0) {
        // do something may be alert message
    }
    else
    {
//        NSURLCredential *credential = [NSURLCredential credentialWithUser:SERVICEUSERNAME
//                                                                 password:SERVICEPASSWORD
//                                                              persistence:NSURLCredentialPersistenceForSession];
        NSURLCredential *credential = [NSURLCredential credentialWithUser:SERVICEUSERNAME
                                                                 password:SERVICEPASSWORD
                                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }
}

#pragma mark Connection Delegates

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    if (!self.isCancelled)
    {
        dataReceived = [[NSMutableData alloc] init];
        contentLength = response.expectedContentLength;
    }
    else
    {
        [self finish];
    }
    
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if (!self.isCancelled)
    {
        [dataReceived appendData:data];
        NSNumber *number = [NSNumber numberWithFloat:(float)[dataReceived length]/(float)contentLength];
        _operationProgress.progress =number.floatValue;
        
        /* Used to calculate Download progress and notify delegate with the related data */
        
        if([delegate respondsToSelector:_didProgressSelector]){
            NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
            if(_userData)
                [dataDictionary setObject:_userData forKey:@"UserData"];
            [dataDictionary setObject:number                                              forKey:@"Progress"]; // Progress. Range 0-1
            [dataDictionary setObject:[NSNumber numberWithLongLong:contentLength]         forKey:@"TotalSizeInKB"]; // Total content Length
            [dataDictionary setObject:[NSNumber numberWithLongLong:[dataReceived length]] forKey:@"DownloadedSizeInKB"]; // Downloaded data content Length
            [delegate performSelector:_didProgressSelector withObject:dataDictionary];
        }
    }
    else
    {
        [self finish];
    }
    
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
#ifdef DEBUG
    NSLog(@"Error : %@",[error description]);
#endif
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    if(_userData)
        [dataDictionary setObject:_userData forKey:@"UserData"];
    [dataDictionary setObject:error forKey:@"Error"];

    [delegate performSelector:_didFailSelector withObject:error];
    [self finish];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
//    if (self.isCancelled) {
//        delegate = nil;
//    }
    
    if (!self.isCancelled)
    {
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        if(_userData)
            [dataDictionary setObject:_userData forKey:@"UserData"];
        [dataDictionary setObject:dataReceived forKey:@"DataRecieved"];
        
        [delegate performSelector:_didFinishSelector withObject:dataDictionary];
    }
    
    [self finish];
}

@end
