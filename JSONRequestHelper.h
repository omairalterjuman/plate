//
//  JSONRequestHelper.h
//  lesson_Webservice
//
//  Created by mac on 3/13/15.
//  Copyright (c) 2015 youngdecade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WebserviceDelegate<NSObject>

-(void)DidRecieveRequest:(NSDictionary *)Dictionary;
-(void)ConnectionNotEstablish;
@end

@interface JSONRequestHelper : NSObject
{
    UIAlertView *  Myalert;
    NSDictionary *dictionary;
    NSMutableArray * Myarray;
}
@property(nonatomic,strong)NSMutableData *responseData;
@property(nonatomic,retain)id<WebserviceDelegate>delegate;
-(void)RecieveRequestWithURL:(NSString *)URL;

@end
