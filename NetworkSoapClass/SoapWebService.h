//
//  SoapWebService.h
//  NetworkLibrary
//
//  Created by Devang Pandya on 26/04/13.
//  Copyright (c) 2013 Devang Pandya. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface SoapWebService : NSObject

+ (NSString*)embedInSOAPEnvelope:(NSString*)soapBody;
+ (NSString*)embedInSOAPEnvelopeWithUTF8Encode:(NSString*)soapBody;

+ (NSString*)validateUserForUsername:(NSString *)strUserName password:(NSString *)strPassword;
+ (NSString *)getCrewCurrentFlightsForEmpID:(NSString *)strEmpNo;
+ (NSString *)getFlightPlanForFlightDetail:(NSDictionary *)flightDetailDict;
+ (NSString *)getNOTAMPackForFlightDetail:(NSDictionary *)flightDetailDict;
+ (NSString *)checkIsFlightPlanHasModified:(NSDictionary *)flightDetailDict;
+ (NSString *)checkIsNotamPackHasModified:(NSDictionary *)flightDetailDict;

+ (NSString *)getAdditinalFileSoapRequest:(NSDictionary *)flightDetailDict;
+ (NSString *)checkIsAdditinalFileHasModified:(NSDictionary *)flightDetailDict;
@end
