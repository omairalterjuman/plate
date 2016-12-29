//
//  FriendsDetailVC.m
//  PLATE APP
//
//  Created by mac on 12/28/16.
//  Copyright © 2016 yd. All rights reserved.
//

#import "FriendsDetailVC.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface FriendsDetailVC ()

@end

@implementation FriendsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btn_AcceptRequest.clipsToBounds=YES;
    _btn_AcceptRequest.layer.cornerRadius=10;
    _btn_RejectRequest.clipsToBounds=YES;
    _btn_RejectRequest.layer.cornerRadius=10;
    NSLog(@"DATA USER :: %@",_arrData);
    
    // [_imgUser setImageWithURL:[NSURL URLWithString:[_arrData valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    if (![[_arrData valueForKey:@"image"] isEqualToString:@""])
    {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:[_arrData valueForKey:@"image"]
                                                          options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        _imgUser.image= [UIImage imageWithData:data];
        _imgUser.layer.cornerRadius = _imgUser.frame.size.width / 2;
        _imgUser.clipsToBounds = YES;
    }
    
    
    _txt_name.text=[_arrData valueForKey:@"name"];
    _txt_email.text=[_arrData valueForKey:@"email"];
    _txt_Status.text=[_arrData valueForKey:@"status"];
    _txt_plateNumber.text=[_arrData valueForKey:@"phoneNumber"];
    otherUserID=[_arrData valueForKey:@"user_id"];
    otherUserDeviceToken=[_arrData valueForKey:@"deviceToken"];
    
    _FIR_Ref = [[FIRDatabase database] reference];
    [_FIR_Ref keepSynced:YES];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)CheckNetwork
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus NetworkStatus = [reachability currentReachabilityStatus];
    return NetworkStatus;
}



-(IBAction)accept_action:(UIButton *)sender
{
    
    
    if ([self CheckNetwork] == NotReachable)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"No internet connection";
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
    else
    {
        
        
        NSInteger TAG=sender.tag-100000;
        
        
        FIRDatabaseReference *usersRef = [[[_FIR_Ref child: @"receive"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ] child:[NSString stringWithFormat:@"%@",[_arrData valueForKey:@"user_id"]]];
        NSDictionary *dict=@{};
        [usersRef setValue: dict];
        FIRDatabaseReference *usersRef11 = [[[_FIR_Ref child: @"sent"] child: [NSString stringWithFormat:@"%@",[_arrData valueForKey:@"user_id"]]] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
        [usersRef11 setValue: dict];
        
        
        FIRDatabaseReference *usersRef1 = [[[[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"%@",[_arrData valueForKey:@"user_id"]] ] child:@"friends"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
        
        [usersRef1 setValue: @"yes"];
        
        FIRDatabaseReference *usersRef2 = [[[[_FIR_Ref child: @"users"] child: [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]  ] child:@"friends"] child:[NSString stringWithFormat:@"%@",[_arrData valueForKey:@"user_id"]]];
        
        [usersRef2 setValue: @"yes"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Friend request accepted!";
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
        
        
        
        
        
        NSString *str1=[NSString stringWithFormat:@"http://youngdecadeprojects.biz/plateapp/webservice/"];
        
        // http://youngdecadeprojects.biz/plateapp/webservice/
        
        NSString *urlString = [NSString stringWithFormat:@"%@send_notification.php",str1];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //////------------parameter user_id ----------------/////////////
        
        // pref=[NSUserDefaults standardUserDefaults];
        
        NSString *device_token;
        if ([_arrData valueForKey:@"deviceToken"])
        {
            
            device_token=[_arrData valueForKey:@"deviceToken"];
        }
        else
        {
            device_token=@"";
        }
        
        // 81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f
        
        //device_token=@"81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f";
        NSString *msg=[NSString stringWithFormat:@"%@ accept your friend request",[_arrData valueForKey:@"name"]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[device_token dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        // NSLog(@"TEXT MSG %@",mymsgForNOTI);
        NSLog(@"token %@",device_token);
        
        //    // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *dictRES=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"RESPONSE :: %@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
        if ([[dictRES objectForKey:@"success"] isEqualToString:@"true"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            NSLog(@"SUCCESS");
        }
        else if (dictRES==nil)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
        }
        
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)reject_action:(UIButton *)sender
{
    if ([self CheckNetwork] == NotReachable)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"No internet connection";
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
    else
    {
        NSInteger TAG=sender.tag-1000000;
        
        FIRDatabaseReference *usersRef = [[[_FIR_Ref child: @"receive"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ] child:[NSString stringWithFormat:@"%@",[_arrData valueForKey:@"user_id"]]];
        NSDictionary *dict=@{};
        [usersRef setValue: dict];
        FIRDatabaseReference *usersRef11 = [[[_FIR_Ref child: @"sent"] child: [NSString stringWithFormat:@"%@",[_arrData valueForKey:@"user_id"]]] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
        [usersRef11 setValue: dict];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        NSString *str1=[NSString stringWithFormat:@"http://youngdecadeprojects.biz/plateapp/webservice/"];
        
        // http://youngdecadeprojects.biz/plateapp/webservice/
        
        NSString *urlString = [NSString stringWithFormat:@"%@send_notification.php",str1];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //////------------parameter user_id ----------------/////////////
        
        // pref=[NSUserDefaults standardUserDefaults];
        
        NSString *device_token;
        if ([_arrData valueForKey:@"deviceToken"])
        {
            
            device_token=[_arrData valueForKey:@"deviceToken"];
        }
        else
        {
            device_token=@"";
        }
        
        // 81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f
        
        //device_token=@"81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f";
        NSString *msg=[NSString stringWithFormat:@"%@ rejected your friend request",[_arrData valueForKey:@"name"]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[device_token dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        // NSLog(@"TEXT MSG %@",mymsgForNOTI);
        NSLog(@"token %@",device_token);
        
        //    // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *dictRES=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"RESPONSE :: %@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
        if ([[dictRES objectForKey:@"success"] isEqualToString:@"true"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            NSLog(@"SUCCESS");
        }
        else if (dictRES==nil)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
