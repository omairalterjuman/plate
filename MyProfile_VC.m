//
//  MyProfile_VC.m


#import "MyProfile_VC.h"


#import "Home_VC.h"
#import "HomeCell.h"
#import "AllUsers_VC.h"
#import "btSimpleMenuItem.h"
#import "btSimpleSideMenu.h"
#import "ViewController.h"
#import "MyProfile_VC.h"
#import "MyFriends_VC.h"
#import "Setting.h"
#import "MBProgressHUD.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


#define TextNumeric @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$_-+"
#define OnlyText @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define TextNumericspace @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789. "
#define TextSpace @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define OnlyNumber @"0123456789"
#define TextNumericEmail @"[A-Z0-9a-z]+[A-Z0-9a-z_./%-]+@[A-Za-z0-9.-]+@[.]+@[A-Za-z]{2,6}"

@interface MyProfile_VC ()<BTSimpleSideMenuDelegate>

@property(nonatomic)BTSimpleSideMenu *sideMenu;

@end

@implementation MyProfile_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_update.clipsToBounds=YES;
    _btn_update.layer.cornerRadius=10;
    
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    
    // self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    // self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44.01)];
    
    // create a button and add it to the container
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44.01)];
    [button setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ShowHide_SideMenu:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:button];
    
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 270, 44.01)];
    lbl_title.text=@"My Profile";
    lbl_title.textAlignment=NSTextAlignmentCenter;
    [container addSubview:lbl_title];
    
    
    
    // now create a Bar button item
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
    // set the nav bar's right button item
    self.navigationItem.leftBarButtonItem = item;
    
    
    // ADD IMAGE
    
    tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage_action:)];
    tapImage.numberOfTapsRequired=1;
    [_imgUser addGestureRecognizer:tapImage];
    _imgUser.userInteractionEnabled=YES;
    setImage =nil;
    
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.1];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self sidebarfunction];
    
    dic=[[NSDictionary alloc]init];
    profileUpdate=NO;
}

-(void)getData

{
    _FIR_Ref = [[FIRDatabase database] reference];
    [_FIR_Ref keepSynced:YES];
    NSLog(@"FOLDER 2:::: %@",[_FIR_Ref child:@"plateapp-5bc35"]);//[_ref child:@"room-messages"]);
    
    createFlag = true;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    // NSTimeInterval is defined as double
    NSString *timeStampObj = [NSString stringWithFormat:@"%.0f",timeStamp*10000];
    NSLog(@"Timestamp : %@",timeStampObj);
    
    arr_allData=[[NSMutableArray alloc]init];
    
    [[_FIR_Ref child: @"users"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         if (snapshot.exists)
         {
             NSLog(@"snapshot.value__1111 ::: %@",snapshot.children);
             //NSMutableArray *MSG=[[NSMutableArray alloc]init];
             
             
             
             NSLog(@"Count___1111 : %d",(int)snapshot.childrenCount);
             
             arr_allData=[[NSMutableArray alloc]init];
             
             for ( FIRDataSnapshot *child in snapshot.children)
             {
                  //arr_allData=[[NSMutableArray alloc]init];
                 NSLog(@"child___444 ::: %@",child);
                 if ([[child.value valueForKey:@"user_id"]  isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]])
                 {
                     arr_allData=[[NSMutableArray alloc]init];
                     [arr_allData addObject:child.value];
                     if (![[[arr_allData objectAtIndex:0]valueForKey:@"image"] isEqualToString:@""]) {
                         NSData *data = [[NSData alloc]initWithBase64EncodedString:[[arr_allData objectAtIndex:0]valueForKey:@"image"]
                                                                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
                         
                         _imgUser.image= [UIImage imageWithData:data];
                         _imgUser.layer.cornerRadius = _imgUser.frame.size.width / 2;
                         _imgUser.clipsToBounds = YES;
                     }
                     
                     _txt_name.text=[[arr_allData objectAtIndex:0] valueForKey:@"name"];
                     _txt_email.text=[[arr_allData objectAtIndex:0] valueForKey:@"email"];
                     _txt_Status.text=[[arr_allData objectAtIndex:0]valueForKey:@"status"];
                     _txt_plateNumber.text=[[arr_allData objectAtIndex:0] valueForKey:@"phoneNumber"];
                     
                     
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     if (profileUpdate) {
                         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                         // Configure for text only and offset down
                         
                         hud.mode = MBProgressHUDModeText;
                         hud.labelText = @"Profile updated successfully";
                         hud.margin = 10.f;
                         hud.yOffset = +180.f;
                         hud.removeFromSuperViewOnHide = YES;
                         [hud hide:YES afterDelay:2];
                     }
                     
                     
                     
                    // [self setImage_data];
                     
                     
                     
                 }
                 else
                 {
                     
                 }
                 
                 
             }
        
             
             /*
              if (arr_allData.count>0)
              {
              BOOL childChanged = false;
              for (int ii=0; ii<arr_allData.count; ii++)
              {
              if ([[[arr_allData objectAtIndex:ii] valueForKey:@"group-id"] isEqualToString:[NSString stringWithFormat:@"%@",[child.value valueForKey:@"group-id"]]])
              {
              childChanged = true;
              [arr_allData replaceObjectAtIndex:ii withObject:child.value];
              }
              }
              
              if (!childChanged)
              {
              [arr_allData addObject:child.value];
              }
              if (arr_allData.count>0)
              {
              [_tblUser reloadData];
              }
              }
              else
              {
              //NSDictionary *dictf = child;
              //                     dictf = [child mutableCopy];
              [arr_allData addObject:child.value];
              if (arr_allData.count>0)
              {
              [_tblUser reloadData];
              }
              }
              */
             
             
         }
     }withCancelBlock:^(NSError * _Nonnull error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSLog(@"%@", error.localizedDescription);
     }];
    
}



-(void)setImage_data
{
   
  //  NSURL *URL = [NSURL URLWithString:
  //                [[arr_allData objectAtIndex:0]valueForKey:@"image"]];
    
  //  _imgUser.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
    
    if (![[[arr_allData objectAtIndex:0]valueForKey:@"image"] isEqualToString:@""]) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:[[arr_allData objectAtIndex:0]valueForKey:@"image"]
                                                          options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        _imgUser.image= [UIImage imageWithData:data];
        _imgUser.layer.cornerRadius = _imgUser.frame.size.width / 2;
        _imgUser.clipsToBounds = YES;
    }
    
    
    
    
   // [_imgUser setImageWithURL:[NSURL URLWithString:[[arr_allData objectAtIndex:0]valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    _txt_name.text=[[arr_allData objectAtIndex:0] valueForKey:@"name"];
    _txt_email.text=[[arr_allData objectAtIndex:0] valueForKey:@"email"];
    _txt_Status.text=[[arr_allData objectAtIndex:0]valueForKey:@"status"];
    _txt_plateNumber.text=[[arr_allData objectAtIndex:0] valueForKey:@"phoneNumber"];
    
    
}



-(IBAction)update_action:(id)sender
{
    NSString *str;
    str=[self validateAllChecks];
    
    if (str)
    {
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        /*
         
         
         NSString *key = [[_ref child:@"posts"] childByAutoId].key;
         NSDictionary *post = @{@"uid": userID,
         @"author": username,
         @"title": title,
         @"body": body};
         NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
         [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
         [_ref updateChildValues:childUpdates];
         
         */
        
        
        profileUpdate=YES;
        NSData *imgData=[[NSData alloc]init];
        imgData= UIImageJPEGRepresentation(_imgUser.image, 0.001);
        
         FIRDatabaseReference *usersRef = [[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]];
        
        NSString *stringImage = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        
         NSDictionary *users = @{
         @"online": @"yes",
         @"name": _txt_name.text,
         @"email": _txt_email.text,
         @"image" :stringImage,
         @"phoneNumber" : _txt_plateNumber.text,
         @"status":_txt_Status.text
         };
         
         [usersRef updateChildValues: users];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"PRPErof %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ss"]);
    
    if (textField==_txt_name)
    {
        //txt_email.backgroundColor = [UIColor clearColor];
        
    }
    else  if (textField==_txt_plateNumber)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
        [self  animateTextField:_txt_plateNumber up:YES];
    }
    else  if (textField==_txt_email)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
        [self  animateTextField:_txt_email up:YES];
        
    }
    else  if (textField==_txt_Status)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
        [self  animateTextField:_txt_Status up:YES];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textField==_txt_name)
    {
        //txt_email.backgroundColor = [UIColor clearColor];
        
    }
    else  if (textField==_txt_plateNumber)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
        [self  animateTextField:_txt_plateNumber up:NO];
        
    }
    else  if (textField==_txt_email)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
         [self  animateTextField:_txt_email up:NO];
        
    }
    else  if (textField==_txt_Status)
    {
        //TF_Password.backgroundColor = [UIColor clearColor];
         [self  animateTextField:_txt_Status up:NO];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
///////--------validation---------/////////

- (BOOL) validateEmail: (NSString *)candidate
{
    NSString *emailRegex =  @"[A-Z0-9a-z]+[A-Z0-9a-z_./%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(NSString *)validateAllChecks
{
    NSString *strinvalid=nil;
    
    
    if ([_txt_name.text isEqualToString:@""])
    {
        strinvalid=@"Name cannot be blank";
    }
    else if ([_txt_email.text rangeOfString:@".."].length>0)
    {
        strinvalid=@"Please enter a valid email ID";
    }
    else if (![self validateEmail:_txt_email.text])
    {
        strinvalid=@"Please enter a valid email ID";
    }
    
//    else  if ([_txt_plateNumber.text isEqualToString:@""])
//    {
//        strinvalid=@"Phone number cannot be blank";
//    }
//    else if (_txt_plateNumber.text.length<8)
//    {
//        strinvalid=@"Please enter valid phone number";
//    }
//    else  if ([_txt_Status.text isEqualToString:@""])
//    {
//        strinvalid=@"Status cannot be blank";
//    }
    
    return strinvalid;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *unacceptedInput = nil;
    
    if (textField==_txt_name)  //text email
    {
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[OnlyText stringByAppendingString:@""]] invertedSet];
        
        if(newLength >= 41){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
        
    }
    if (textField == _txt_plateNumber)   // text password
    {
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[OnlyNumber stringByAppendingString:@""]] invertedSet];
        
        if(newLength >= 16){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    
    if (textField == _txt_email)   // text password
    {
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        if(newLength >= 41){
            return NO;
        }
        if (range.location == 0 && [string isEqualToString:@" "]) {
            return NO;
        }
    }
    
    if (textField == _txt_Status)   // text password
    {
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[OnlyText stringByAppendingString:@""]] invertedSet];
        
        if(newLength >= 41){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    
    
    
    return YES;
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    // have to set int value for animation
    
    if (self.view.bounds.size.height==480)
    {
        int a;
        a= 580-(textField.frame.origin.y+420);
        
        const int movementDistance = a;
        const float movementDuration = 0.3f;
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    else
    {
        const int movementDistance = -100; // tweak as needed
        const float movementDuration = 0.25f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        
    }
}


/// ADD IMAGE

- (IBAction)addImage_action:(UITapGestureRecognizer *)sender
{
    
    
    UIAlertController *alertController11 = [UIAlertController
                                            alertControllerWithTitle:@"Import image from...?"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *calcelAction11 = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"Cancel action");
                                         [self.view resignFirstResponder];
                                         
                                     }];
    
    [alertController11 addAction:calcelAction11];
    
    UIAlertAction *cameraAction11 = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"Camera", @"Camera action")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"camera action");
                                         
                                         if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                         {
                                             UIAlertController *alertController22 = [UIAlertController
                                                                                     alertControllerWithTitle:@"info"
                                                                                     message:@"Device has no camera"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                             
                                             UIAlertAction *calcelAction22 = [UIAlertAction
                                                                              actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                                                              style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction *action)
                                                                              {
                                                                                  NSLog(@"Cancel action");
                                                                                  [self.view resignFirstResponder];
                                                                              }];
                                             
                                             [alertController22 addAction:calcelAction22];
                                             [self presentViewController:alertController22 animated:YES completion:nil];
                                             
                                             
                                             
                                         }
                                         else
                                         {
                                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                             picker.delegate = self;
                                             picker.allowsEditing = YES;
                                             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                             [self presentViewController:picker animated:YES completion:NULL];
                                         }
                                         
                                     }];
    
    [alertController11 addAction:cameraAction11];
    UIAlertAction *galleryAction11 = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(@"Gallery", @"Gallery action")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          NSLog(@"Gallery action");
                                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                          picker.delegate = self;
                                          picker.allowsEditing = YES;
                                          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                          
                                          [self presentViewController:picker animated:YES completion:NULL];
                                      }];
    
    [alertController11 addAction:galleryAction11];
    
    [self presentViewController:alertController11 animated:YES completion:nil];
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    setImage =@"yes";
    //scrollView.hidden = false;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _imgUser.image = chosenImage;
    
    _imgUser.layer.cornerRadius = _imgUser.frame.size.width / 2;
    _imgUser.clipsToBounds = YES;
    //_imgUser.layer.borderWidth = 2.0f;
   // _imgUser.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)ShowHide_SideMenu:(id)sender
{
    [_sideMenu toggleMenu];
}

-(void)hideSideBar
{
    if ([_sideMenu isOpen])
    {
        [_sideMenu hide];
    }
}
-(void)ShowSideBar
{
    if (![_sideMenu isOpen])
    {
        [_sideMenu show];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_sideMenu hide];
}


-(void)sidebarfunction // Team Leader Menu
{
    _sideMenu.delegate = self;
    
    // PREF=[NSUserDefaults standardUserDefaults];
    
    
    BTSimpleMenuItem *item1 = [[BTSimpleMenuItem alloc]initWithTitle:@"My Profile" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   MyProfile_VC *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile_VC"];
                                   [self.navigationController pushViewController:signup animated:YES];
                                   NSLog(@"I am Item 1");
                                   
                               }];
    
    BTSimpleMenuItem *item2 = [[BTSimpleMenuItem alloc]initWithTitle:@"My Friends" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   
                                   Home_VC *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"Home_VC"];
                                   [self.navigationController pushViewController:signup animated:YES];
                                   NSLog(@"I am Item 2");
                                   // ProvideSpritRetro_VC *ProSprRetro = [[ProvideSpritRetro_VC alloc] initWithNibName:@"ProvideSpritRetro_VC" bundle:nil];
                                   // [self.navigationController pushViewController:ProSprRetro animated:YES];
                                   
                                   
                               }];
    
    BTSimpleMenuItem *item3 = [[BTSimpleMenuItem alloc]initWithTitle:@"All Users" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   
                                   AllUsers_VC *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"AllUsers_VC"];
                                   [self.navigationController pushViewController:signup animated:YES];
                                   NSLog(@"I am Item 3");
                                   //  AllUsers_VC *ProSprRetro = [[AllUsers_VC alloc] initWithNibName:@"AllUsers_VC" bundle:nil];
                                   //  [self.navigationController pushViewController:ProSprRetro animated:YES];
                               }];
    
    BTSimpleMenuItem *item4 = [[BTSimpleMenuItem alloc]initWithTitle:@"Requests" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   
                                   MyFriends_VC  *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"MyFriends_VC"];
                                   [self.navigationController pushViewController:signup animated:YES];
                                   NSLog(@"I am Item 4");
                                   
                               }];
    BTSimpleMenuItem *item5 = [[BTSimpleMenuItem alloc]initWithTitle:@"Settings" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   Setting  *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
                                   [self.navigationController pushViewController:signup animated:YES];
                                   NSLog(@"I am Item 5");
                               }];
    
    BTSimpleMenuItem *item6 = [[BTSimpleMenuItem alloc]initWithTitle:@"Rate App" image:[UIImage imageNamed:@"switch128.png"] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   //   SwitchTeamVC *teamQues = [[SwitchTeamVC alloc] initWithNibName:@"SwitchTeamVC" bundle:nil];
                                   //   [self.navigationController pushViewController:teamQues animated:YES];
                               }];
    
    BTSimpleMenuItem *item7 = [[BTSimpleMenuItem alloc]initWithTitle:@"Share App" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   //   MyProfile_VC *news=[[MyProfile_VC alloc]initWithNibName:@"MyProfile_VC" bundle:nil];
                                   //  NSLog(@"I am Item 1");
                                   // [self.navigationController pushViewController:news animated:YES];
                               }];
    
    
    BTSimpleMenuItem *item12 = [[BTSimpleMenuItem alloc]initWithTitle:@"Logout" image:[UIImage imageNamed:@"logout128.png"] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                                {
                                    NSLog(@"I am item 7");
                                    
                                    /*[MBProgressHUD showHUDAddedTo:self.view animated:NO];
                                     [self performSelector:@selector(show_wink_view) withObject:nil afterDelay:0.01];*/
                                    //[pref removeObjectForKey:@"Pref_UserId"];
                                    
                                    UIAlertController * alert = [UIAlertController
                                                                 alertControllerWithTitle:@"Are you sure?"
                                                                 message:@"Do you want to logout from app?"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction* yesButton = [UIAlertAction
                                                                actionWithTitle:@"Yes"
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"login"];
                                                                    [self.navigationController popToRootViewControllerAnimated:YES];;
                                                                }];
                                    
                                    UIAlertAction* noButton = [UIAlertAction
                                                               actionWithTitle:@"No"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   //Handle no, thanks button
                                                               }];
                                    
                                    [alert addAction:yesButton];
                                    [alert addAction:noButton];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                    // [self.navigationController pushViewController:news animated:YES];
                                }];
    
    
    
    _sideMenu = [[BTSimpleSideMenu alloc]initWithItem:@[item1,item2,item3,item4,item5,item6,item7,item12 ]addToViewController:self];
    _sideMenu.backgroundColor=[UIColor clearColor];
    //[UIColor colorWithRed:17.0/255.0 green:62.0/255.0 blue:125.0/255.0 alpha:1.0];
    
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
