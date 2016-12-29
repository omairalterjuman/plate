//
//  ForgotPassword_VC.m
//  PLATE APP
//


#import "ForgotPassword_VC.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#define TextNumberSpace @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789. "
#define TextNOSpace @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "

@interface ForgotPassword_VC ()

@end

@implementation ForgotPassword_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    _btn_submit.clipsToBounds=YES;
    _btn_submit.layer.cornerRadius=10;
     self.title = @"Forgot Password";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit_Action:(id)sender

{
    [_txt_email resignFirstResponder];
    if ([_txt_email.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Please enter plate number";
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
    else
    {
        _FIR_Ref = [[FIRDatabase database] reference];
        [_FIR_Ref keepSynced:YES];
        
        [[[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"u_%@",_txt_email.text]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
         {
             if (snapshot.exists)
             {
                
                     NSLog(@"snapshot.value__1111 ::: %@",snapshot.value);
                 
                     str_email=[snapshot.value valueForKey:@"email"] ;
                    str_password=[snapshot.value valueForKey:@"password"] ;
                     [self performSelector:@selector(sendMailToUser) withObject:nil afterDelay:0.0];
                
             }
             else
             {

                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                 // Configure for text only and offset down
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = @"Plate number not found";
                 hud.margin = 10.f;
                 hud.yOffset = +180.f;
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide:YES afterDelay:2];
                 
                 
             }
         }withCancelBlock:^(NSError * _Nonnull error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSLog(@"%@", error.localizedDescription);
         }];

    }
}



-(void)sendMailToUser
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    [_txt_email resignFirstResponder];
    

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
            
            [self performSelector:@selector(runSimpleForgotPassService) withObject:nil afterDelay:0.01];
        }
    
}


-(void)runSimpleForgotPassService
{
    /* url = login.php
     Method = post
     Parameters =email, password, device_type, device_token,device_id(optional in ios)
     
     */
    
    
    
    // flag_WebService=2;
    Ary_Parameter =[[NSMutableArray alloc]initWithObjects:@"email",@"password",nil];
    Ary_Value =[[NSMutableArray alloc]initWithObjects:str_email,str_password,nil];
    
    NSLog(@"Ary_Parameter ------%@",Ary_Parameter);
    NSLog(@"Ary_Value------%@",Ary_Value);
    
    post=[[PostFunctionHelper alloc]init];
    post.delegate=self;
    
    [post RequestWithURL:@"forgot_password.php" :Ary_Parameter :Ary_Value :Ary_Img_Parameter];
}

-(void)ConnectionNotCreate
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    UIAlertView *Myalert=[[UIAlertView alloc]initWithTitle:@"Slow or no internet connection!" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [Myalert show];
}
- (BOOL) validateEmail: (NSString *)candidate
{
    NSString *emailRegex =  @"[A-Z0-9a-z]+[A-Z0-9a-z_./%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
/////////////////////////////// End All Validation /////////////////////////////////////////

-(BOOL)CheckNetwork
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus NetworkStatus = [reachability currentReachabilityStatus];
    return NetworkStatus;
}
-(void)DidRecieveResponse:(NSDictionary *)Dictionary
{
    NSLog(@"Dictionary---== %@",Dictionary);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    if ([[Dictionary objectForKey:@"success"]isEqualToString:@"true"])
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [Dictionary objectForKey:@"msg"];
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];

        
        /*TeamSetupVC *signUp = [[TeamSetupVC alloc] initWithNibName:@"TeamSetupVC" bundle:nil];
         [self.navigationController pushViewController:signUp animated:YES];*/
    }
    else if (Dictionary==nil)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Server not responding. Please try after some time";
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        
        
    }
    else
    {
        NSLog(@"Error");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [Dictionary objectForKey:@"msg"];
        hud.margin = 10.f;
        hud.yOffset = +180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];

    }
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"PRPErof %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ss"]);
    
    if (textField==_txt_email)
    {
        //txt_email.backgroundColor = [UIColor clearColor];
        
    }
    else  if (textField==_txt_email)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textField==_txt_email)
    {
        //TF_UserName.background=[UIImage imageNamed:@"Rounded Rectangle bg.png"];
        
    }
    else  if (textField==_txt_email)
    {
        // TF_Password.background=[UIImage imageNamed:@"Rounded Rectangle bg.png"];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
///////--------validation---------/////////



-(NSString *)validateAllChecks
{
    NSString *strinvalid=nil;
    
        if ([_txt_email.text rangeOfString:@".."].length>0)
        {
            strinvalid=@"Please enter a valid email ID";
        }
        else if (![self validateEmail:_txt_email.text])
        {
            strinvalid=@"Please enter a valid email address";
        }

    return strinvalid;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *unacceptedInput = nil;
    
    if (textField==_txt_email)  //text email
    {
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextNOSpace stringByAppendingString:@""]] invertedSet];
        
        if(newLength >= 16){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
        
    }

    
    return YES;
}
@end
