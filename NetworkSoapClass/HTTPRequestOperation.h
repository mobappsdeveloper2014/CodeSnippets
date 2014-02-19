//
//  HTTPRequestOperation.h
//  NetworkLibrary
//
//  Created by Devang Pandya on 26/04/13.
//  Copyright (c) 2013 Devang Pandya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPRequestOperationDelegate <NSObject>
@optional
-(void)totalNumberOfOperationsQueued:(int)iTotal numOfOperationsFinised:(int)noOfOpsFinished;

@end

// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector


@interface HTTPRequestOperation : NSOperation<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData *dataReceived; // Stores raw data received
    NSString *requestURL;
    NSURLConnection *connection;
    NSInteger _statusCode;       // Response Status Code
    BOOL _isExecuting;
    BOOL _isFinished;
    long long contentLength;     // Response Content Length
}
@property(nonatomic,strong)id <HTTPRequestOperationDelegate> delegate; // Operation Delegate
@property(assign)SEL didFinishSelector; // Selector to call when Request is finished successfully
@property(assign)SEL didFailSelector;   // Selector to call when Request Fails
@property(assign)SEL didProgressSelector; // Selector to notify about download progress

@property(strong)id userData; // Userdata to identify, if different requests are being invoked
@property(strong)NSString *soapMessage; // Soap Message
@property(strong)NSString *soapAction;  // Soap Action
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
@property(nonatomic,weak)UIProgressView *operationProgress; // A Progressview object can be passed directly for tracking and showing download progress

- (id)initWithURL:(NSString*)url requestData:(NSString*)messageBody finishSel:(SEL)didFinishSEL failSEL:(SEL)didFailSEL; // Init method
@end
