//
//  JSONRequestHelper.m
//  lesson_Webservice
//
//  Created by mac on 3/13/15.
//  Copyright (c) 2015 youngdecade. All rights reserved.
//


#import "JSONRequestHelper.h"
#import "JSON.h"
#import "SBJSON.h"
#import "Reachability.h"
#import "MBProgressHUD.h"


#define kAPIStartingpointHost @"http://youngdecadeprojects.biz/plateapp/webservice/"


@implementation JSONRequestHelper
@synthesize delegate;

-(void)RecieveRequestWithURL:(NSString *)URL
{
    if ([self CheckNetwork] == NotReachable)
    {
        NSLog(@"Not Reachable");
        
        [self.delegate ConnectionNotEstablish];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"No internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
    }
    else
    {
        NSLog(@"Reachable");
        
        _responseData=[NSMutableData data];
        NSString *url1=[[NSString alloc]initWithFormat:@"%@%@",kAPIStartingpointHost,URL];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        NSLog(@"check 1%@",request);
        NSURLConnection * con =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        NSLog(@"%@",con);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
    
    NSLog(@"check 3");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
    
    NSLog(@"check 4");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
//    Myalert=[[UIAlertView alloc]initWithTitle:@"Slow or no internet connection!" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//    [Myalert show];
    [self.delegate ConnectionNotEstablish];
    NSLog(@"check 5");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    // NSLog(@"check kripa_forNull %@",responseString);
    
    
    dictionary = [responseString JSONValue];
        [self.delegate DidRecieveRequest:dictionary];
}

-(BOOL)CheckNetwork
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus NetworkStatus = [reachability currentReachabilityStatus];
    return NetworkStatus;
}

@end
