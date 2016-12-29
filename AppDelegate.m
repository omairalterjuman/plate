//
//  AppDelegate.m
//  PLATE APP
//
//  Created by mac on 12/16/16.
//  Copyright (c) 2016 yd. All rights reserved.
//

#import "AppDelegate.h"
#import <Firebase.h>


@interface AppDelegate ()
{
    NSUserDefaults *pref;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    NSLog(@"DEVICE TYPE  %@",deviceType);
    
    pref=[NSUserDefaults standardUserDefaults];
    [pref setObject:deviceType forKey:@"pref_device"];
    
    if([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:  [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |    UIUserNotificationTypeSound)];
#endif
    }

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    pref=[NSUserDefaults standardUserDefaults];
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"DEVICE TOKEN :: %@",token);
    NSString *str_token=[NSString stringWithFormat:@"%@",token];
    [pref setObject:str_token forKey:@"pref_token"];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"all notification==%@",userInfo);
    if (application.applicationState == UIApplicationStateActive )
    {
       // [self showlocalview:userInfo];
        
        //[[UIApplication sharedApplication]cancelAllLocalNotifications];
        
        NSLog(@"%@",userInfo.description);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Notification Recieved!" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
       // [alert show];
    }
    else if (application.applicationState == UIApplicationStateBackground)
    {
        //[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"pref_dp_openfromNotification"];
        
        
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notification Alert" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         [alert show];
    }
    
    //application.applicationIconBadgeNumber = 0;
    
    //[[UIApplication sharedApplication]setApplicationIconBadgeNumber: [[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_club_unreadMsgCount"] intValue]];
    
    //NSLog(@"Notification By Server : %@",userInfo);
}


@end
