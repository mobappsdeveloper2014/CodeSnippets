//
//  SoapWebService.m
//  NetworkLibrary
//
//  Created by Devang Pandya on 26/04/13.
//  Copyright (c) 2013 Devang Pandya. All rights reserved.
//

#import "SoapWebService.h"

@implementation SoapWebService

#pragma mark - Create a Soap Envelope


+ (NSString*)embedInSOAPEnvelope:(NSString*)soapBody
{
    /*
     <?xml version="1.0"?>
     <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
     <soap12:Body>
     <GetCrewCurrentFlights xmlns="http://tempuri.org/">
     <psEmpNo>string</psEmpNo>
     </GetCrewCurrentFlights>
     </soap12:Body>
     </soap12:Envelope>
     
     */
    
    
    NSString *strMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\"?>"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://tempuri.org/\">"
                            "<soap:Body>"
                            "%@"
                            "</soap:Body>"
                            "</soap:Envelope>",soapBody];
    return strMessage;
}
+ (NSString*)embedInSOAPEnvelopeWithUTF8Encode:(NSString*)soapBody
{
    /*
     <?xml version="1.0" encoding="utf-8"?>
     <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
     <soap12:Body>
     <GetCrewCurrentFlights xmlns="http://tempuri.org/">
     <psEmpNo>string</psEmpNo>
     </GetCrewCurrentFlights>
     </soap12:Body>
     </soap12:Envelope>
     */
    
    
    NSString *strMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://tempuri.org/\">"
                            "<soap:Body>"
                            "%@"
                            "</soap:Body>"
                            "</soap:Envelope>",soapBody];
    return strMessage;
    
}

#pragma mark - Create Soap body for services

+ (NSString*)validateUserForUsername:(NSString *)strUserName password:(NSString *)strPassword
{
    /*
     
     <ValidateFlightPlanAppUserResponse xmlns="http://tempuri.org/">
     <ValidateFlightPlanAppUserResult>
     <xsd:schema>schema</xsd:schema>xml</ValidateFlightPlanAppUserResult>
     </ValidateFlightPlanAppUserResponse>
     
     */
    NSString *strBody =  [NSString stringWithFormat:@"<ValidateFlightPlanAppUser xmlns=\"http://tempuri.org/\">"
                          "<psEmpNo>%@</psEmpNo>"
                          "<psPwd>%@</psPwd>"
                          "<pbSendCrewCurrentFlights>false</pbSendCrewCurrentFlights>"
                          "<pbSendCrewData>true</pbSendCrewData>"
                          "</ValidateFlightPlanAppUser>",strUserName,strPassword];
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
}

+ (NSString *)getCrewCurrentFlightsForEmpID:(NSString *)strEmpNo
{
    /*
     
     <GetCrewCurrentFlights xmlns="http://tempuri.org/">
     <psEmpNo>string</psEmpNo>
     </GetCrewCurrentFlights>
     
     */
    
    NSString *strBody =  [NSString stringWithFormat:@"<GetCrewCurrentFlights xmlns=\"http://tempuri.org/\">"
                          "<psEmpNo>%@</psEmpNo>"
                          "</GetCrewCurrentFlights>",strEmpNo];
//    NSLog(@"GetCrewCurrentFlights:Body:%@",strBody);
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
    
}

+ (NSString *)getFlightPlanForFlightDetail:(NSDictionary *)flightDetailDict
{
    /*
    <?xml version="1.0" encoding="utf-8"?>
    <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
     <soap12:Body>
        <GetFlightPlan xmlns="http://tempuri.org/">
            <psFlightNo>string</psFlightNo>
            <psSTDUTC>string</psSTDUTC>
            <psDep>string</psDep>
            <psArr>string</psArr>
            <psAirlineCode>string</psAirlineCode>
            <psRego>string</psRego>
            <psFlightPlanDocumentFullName>string</psFlightPlanDocumentFullName>
        </GetFlightPlan>
     </soap12:Body>
    </soap12:Envelope>
     
     */
    
    NSString *strBody =  [NSString stringWithFormat:@"<GetFlightPlan xmlns=\"http://tempuri.org/\">"
                          "<psFlightNo>%@</psFlightNo>"
                          "<psSTDUTC>%@</psSTDUTC>"
                          "<psDep>%@</psDep>"
                          "<psArr>%@</psArr>"
                          "<psAirlineCode>%@</psAirlineCode>"
                          "<psRego>%@</psRego>"
                          "<psFlightPlanDocumentFullName>%@</psFlightPlanDocumentFullName>"
                          "</GetFlightPlan>",[flightDetailDict valueForKey:@"FLTNBR"]
                                            ,[SharedData getUTCStartTImeFromStartTime:[flightDetailDict valueForKey:@"STARTTIME"]]
                                            ,[flightDetailDict valueForKey:@"DEP"]
                                            ,[flightDetailDict valueForKey:@"ARR"]
                                            ,[flightDetailDict valueForKey:@"AIRLINE"]
                                            ,[flightDetailDict valueForKey:@"ACREGID"]
                                            ,[flightDetailDict valueForKey:@"FlightPlanDocumentFullName"]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
    
}
+ (NSString *)getNOTAMPackForFlightDetail:(NSDictionary *)flightDetailDict
{
    /*
     <GetNotamPackDocument xmlns="http://tempuri.org/">
     <psNotamPackDocumentFullName>string</psNotamPackDocumentFullName>
     </GetNotamPackDocument>
     
     */
    
    NSString *strBody =  [NSString stringWithFormat:@"<GetNotamPackDocument xmlns=\"http://tempuri.org/\">"
                          "<psNotamPackDocumentFullName>%@</psNotamPackDocumentFullName>"
                          "</GetNotamPackDocument>",[flightDetailDict valueForKey:@"NotamPackFileFullName"]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
    
}
+ (NSString *)checkIsFlightPlanHasModified:(NSDictionary *)flightDetailDict
{
    /*
     <soap:Body>
     <IsFlightPlanHasModified xmlns="http://tempuri.org/">
     <psFlightNo>string</psFlightNo>
     <psSTDUTC>string</psSTDUTC>
     <psDep>string</psDep>
     <psArr>string</psArr>
     <psAirlineCode>string</psAirlineCode>
     <psRego>string</psRego>
     <psFlightPlanPublishedDateInUtc>string</psFlightPlanPublishedDateInUtc>
     </IsFlightPlanHasModified>
     </soap:Body>
     */
    
    NSString *strBody =  [NSString stringWithFormat:@"<IsFlightPlanHasModified xmlns=\"http://tempuri.org/\">"
                          "<psFlightNo>%@</psFlightNo>"
                          "<psSTDUTC>%@</psSTDUTC>"
                          "<psDep>%@</psDep>"
                          "<psArr>%@</psArr>"
                          "<psAirlineCode>%@</psAirlineCode>"
                          "<psRego>%@</psRego>"
                          "<psFlightPlanPublishedDateInUtc>%@</psFlightPlanPublishedDateInUtc>"
                          "</IsFlightPlanHasModified>",[flightDetailDict valueForKey:@"FLTNBR"]
                          ,[SharedData getUTCStartTImeFromStartTime:[flightDetailDict valueForKey:@"STARTTIME"]]
                          ,[flightDetailDict valueForKey:@"DEP"]
                          ,[flightDetailDict valueForKey:@"ARR"]
                          ,[flightDetailDict valueForKey:@"AIRLINE"]
                          ,[flightDetailDict valueForKey:@"ACREGID"]
                          ,[flightDetailDict valueForKey:@"FlightPlanPublishedDate"]];//[SharedData getUTCTImeFromPublishedDate:[flightDetailDict valueForKey:@"FlightPlanPublishedDate"]]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
    
}
+ (NSString *)checkIsNotamPackHasModified:(NSDictionary *)flightDetailDict
{
    /*
     
     
     <soap:Body>
     <IsNotamPackHasModified xmlns="http://tempuri.org/">
     <psNotamPackDocumentFullName>string</psNotamPackDocumentFullName>
     <psNotamPackPublishedDateInUtc>string</psNotamPackPublishedDateInUtc>
     </IsNotamPackHasModified>
     </soap:Body>
     
     */
    NSString *strBody =  [NSString stringWithFormat:@"<IsNotamPackHasModified xmlns=\"http://tempuri.org/\">"
                          "<psNotamPackDocumentFullName>%@</psNotamPackDocumentFullName>"
                          "<psNotamPackPublishedDateInUtc>%@</psNotamPackPublishedDateInUtc>"
                          "</IsNotamPackHasModified>",[flightDetailDict valueForKey:@"NotamPackFileFullName"]
                          ,[flightDetailDict valueForKey:@"NotamPackFilePublishedDate"]];//[SharedData getUTCTImeFromNotamPackFilePublishedDate:[flightDetailDict valueForKey:@"NotamPackFilePublishedDate"]]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
}

+ (NSString *)getAdditinalFileSoapRequest:(NSDictionary *)flightDetailDict
{
    
  /*  NSString *strBody =  [NSString stringWithFormat:@"<GetNotamPackDocument xmlns=\"http://tempuri.org/\">"
                          "<psNotamPackDocumentFullName>%@</psNotamPackDocumentFullName>"
                          "</GetNotamPackDocument>",[flightDetailDict valueForKey:@"DocumentName"]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];*/
    
    NSString *strBody =  [NSString stringWithFormat:@"<GetNotamPackDocument xmlns=\"http://tempuri.org/\">"
                          "<psNotamPackDocumentFullName>%@</psNotamPackDocumentFullName>"
                          "</GetNotamPackDocument>",[flightDetailDict valueForKey:@"DocumentFullName"]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
    
}

+ (NSString *)checkIsAdditinalFileHasModified:(NSDictionary *)flightDetailDict
{
    /*
     
     
     <soap:Body>
     <IsNotamPackHasModified xmlns="http://tempuri.org/">
     <psNotamPackDocumentFullName>string</psNotamPackDocumentFullName>
     <psNotamPackPublishedDateInUtc>string</psNotamPackPublishedDateInUtc>
     </IsNotamPackHasModified>
     </soap:Body>
     
     */
    NSString *strBody =  [NSString stringWithFormat:@"<IsNotamPackHasModified xmlns=\"http://tempuri.org/\">"
                          "<psNotamPackDocumentFullName>%@</psNotamPackDocumentFullName>"
                          "<psNotamPackPublishedDateInUtc>%@</psNotamPackPublishedDateInUtc>"
                          "</IsNotamPackHasModified>",[flightDetailDict valueForKey:@"DocumentFullName"]
                          ,[flightDetailDict valueForKey:@"DocumentPublishedDate"]];//[SharedData getUTCTImeFromNotamPackFilePublishedDate:[flightDetailDict valueForKey:@"NotamPackFilePublishedDate"]]];
    
    return [SoapWebService embedInSOAPEnvelopeWithUTF8Encode:strBody];
}

@end
