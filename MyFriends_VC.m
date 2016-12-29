//
//  MyFriends_VC.m
//  PLATE APP


#import "MyFriends_VC.h"
#import "MyFriendsCell.h"


#import "Home_VC.h"
#import "HomeCell.h"
#import "AllUsers_VC.h"
#import "btSimpleMenuItem.h"
#import "btSimpleSideMenu.h"
#import "ViewController.h"
#import "MyProfile_VC.h"
#import "MyFriends_VC.h"
#import "Setting.h"
#import "Reachability.h"
#import "FriendsDetailVC.h"
#import "MBProgressHUD.h"

@interface MyFriends_VC ()<BTSimpleSideMenuDelegate>

@property(nonatomic)BTSimpleSideMenu *sideMenu;

@end

@implementation MyFriends_VC

- (void)viewDidLoad {
    [super viewDidLoad];
   
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
    lbl_title.text=@"Requests";
    lbl_title.textAlignment=NSTextAlignmentCenter;
    [container addSubview:lbl_title];
    
    
    // now create a Bar button item
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
    // set the nav bar's right button item
    self.navigationItem.leftBarButtonItem = item;
    
    
//

    
    _FIR_Ref = [[FIRDatabase database] reference];
    [_FIR_Ref keepSynced:YES];
    
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_tblFriend reloadData];
    [self sidebarfunction];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(getAllFriends) withObject:nil afterDelay:0.01];
}
-(void)getAllFriends
{
    NSLog(@"FOLDER 2:::: %@",[_FIR_Ref child:@"plateapp-5bc35"]);//[_ref child:@"room-messages"]);
    
    
    createFlag = true;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    // NSTimeInterval is defined as double
    NSString *timeStampObj = [NSString stringWithFormat:@"%.0f",timeStamp*10000];
    NSLog(@"Timestamp : %@",timeStampObj);
    
    tempARR=[[NSMutableArray alloc]init];
    arrAllData=[[NSMutableArray alloc]init];
    createFlag=true;
    [[[_FIR_Ref child: @"receive"] child:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         if (snapshot.exists)
         {
             NSLog(@"children__1111 ::: %@",snapshot.children);
             //NSMutableArray *MSG=[[NSMutableArray alloc]init];
             
             NSLog(@"Count___1111 : %d",(int)snapshot.childrenCount);
             NSLog(@"snapshot.value__1111 : %@",snapshot.value);
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             for ( FIRDataSnapshot *child in snapshot.children)
             {
                 [tempARR addObject:child];
                 
                // NSArray *ARR_check=[[tempARR objectAtIndex:tempARR.count-1] componentsSeparatedByString:@"="];
                 
                 if ([child.value isEqualToString:@"pending"])
                 {
                     createFlag = true;
                     [[[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"%@",child.key]]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
                      {
                          
                          if (snapshot.exists)
                          {
                              NSLog(@"snapshot.value__1234 ::: %@",snapshot.children);
                              //NSMutableArray *MSG=[[NSMutableArray alloc]init];
                              
                              if (createFlag)
                              {
                                  //createFlag = false;
                                  
                                  NSLog(@"value__1234 : %d",(int)snapshot.value);
                                  [arrAllData addObject:snapshot.value];
                                  
                                  arrTblData=[arrAllData mutableCopy];
                                  
                                 
                                  NSSortDescriptor *priceDescriptor = [NSSortDescriptor
                                                                       sortDescriptorWithKey:@"name"
                                                                       ascending:YES
                                                                       selector:@selector(caseInsensitiveCompare:)];
                                  NSArray *descriptors = @[priceDescriptor];
                                  [arrTblData sortUsingDescriptors:descriptors];
                                  
                                
                                  
                                  [_tblFriend reloadData];
                                  NSLog(@"ALL FRIENDS Request:: %@",arrAllData);
                                  
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  
                                  // [tempARR addObject:snapshot.value];
                              }
                              
                          }
                          
                      }withCancelBlock:^(NSError * _Nonnull error)
                      {
                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                          NSLog(@"%@", error.localizedDescription);
                      }];
                 }
             }
         }
         else
         {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
             // Configure for text only and offset down
             [_tblFriend reloadData];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"No user found";
             hud.margin = 10.f;
             hud.yOffset = +180.f;
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:2];
             
             [self performSelector:@selector(back:) withObject:nil afterDelay:2.0];
         }
         
         
     }withCancelBlock:^(NSError * _Nonnull error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSLog(@"%@", error.localizedDescription);
     }];
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

    




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([arrTblData count])
        return [arrTblData count];
    else
        return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyFriendsCell";
    
    MyFriendsCell *cell = (MyFriendsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (![[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"image"] isEqualToString:@""]) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"image"]
                                                          options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        cell.imgUser.image= [UIImage imageWithData:data];
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2;
        cell.imgUser.clipsToBounds = YES;
    }
    
    
    cell.lbl_name.text =[NSString stringWithFormat:@"%@", [[arrTblData objectAtIndex:indexPath.row]valueForKey:@"name"]];
    
    cell.btn_accept.tag=indexPath.row+100000;
    cell.btn_reject.tag=indexPath.row+1000000;
    
    [cell.btn_accept addTarget:self action:@selector(accept_action:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btn_reject addTarget:self action:@selector(reject_action:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    /*
     [cell.imgUser setImageWithURL:[NSURL URLWithString:[[arrTeamUsers objectAtIndex:indexPath.row]valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2;
     cell.imgUser.clipsToBounds = YES;
     
     cell.lblName.text =[NSString stringWithFormat:@"%@ %@", [[arrTeamUsers objectAtIndex:indexPath.row]valueForKey:@"fname"],[[arrTeamUsers objectAtIndex:indexPath.row]valueForKey:@"lname"]];
     cell.btn_delete.tag=indexPath.row+10000;
     [cell.btn_delete addTarget:self action:@selector(Btntap:) forControlEvents:UIControlEventTouchUpInside];
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsDetailVC *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"FriendsDetailVC"];
    signup.arrData=[[NSMutableArray alloc]init];
    
    signup.arrData=[[arrTblData objectAtIndex:indexPath.row] mutableCopy];
    [self.navigationController pushViewController:signup animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
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
        
        
        FIRDatabaseReference *usersRef = [[[_FIR_Ref child: @"receive"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ] child:[NSString stringWithFormat:@"%@",[[arrTblData objectAtIndex:TAG] valueForKey:@"user_id"]]];
        NSDictionary *dict=@{};
        [usersRef setValue: dict];
        FIRDatabaseReference *usersRef11 = [[[_FIR_Ref child: @"sent"] child: [NSString stringWithFormat:@"%@",[[arrTblData objectAtIndex:TAG] valueForKey:@"user_id"]]] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
        [usersRef11 setValue: dict];
        
        
        FIRDatabaseReference *usersRef1 = [[[[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"%@",[[arrTblData objectAtIndex:TAG] valueForKey:@"user_id"]] ] child:@"friends"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
        
        [usersRef1 setValue: @"yes"];
        
        FIRDatabaseReference *usersRef2 = [[[[_FIR_Ref child: @"users"] child: [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]  ] child:@"friends"] child:[NSString stringWithFormat:@"%@",[[arrTblData objectAtIndex:TAG] valueForKey:@"user_id"]]];
        
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
        if ([[arrTblData objectAtIndex:TAG] valueForKey:@"deviceToken"])
        {
            
            device_token=[[arrTblData objectAtIndex:TAG] valueForKey:@"deviceToken"];
        }
        else
        {
            device_token=@"";
        }
        
        // 81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f
        
        //device_token=@"81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f";
        NSString *msg=[NSString stringWithFormat:@"%@ accept your friend request",[[arrTblData objectAtIndex:TAG] valueForKey:@"name"]];
        
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
        
        
        
        
        [self performSelector:@selector(getAllFriends) withObject:nil afterDelay:1.0];
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
    
    FIRDatabaseReference *usersRef = [[[_FIR_Ref child: @"receive"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ] child:[NSString stringWithFormat:@"%@",[[arrTblData objectAtIndex:TAG] valueForKey:@"user_id"]]];
    NSDictionary *dict=@{};
    [usersRef setValue: dict];
    FIRDatabaseReference *usersRef11 = [[[_FIR_Ref child: @"sent"] child: [NSString stringWithFormat:@"%@",[[arrTblData objectAtIndex:TAG] valueForKey:@"user_id"]]] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
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
    if ([[arrTblData objectAtIndex:TAG] valueForKey:@"deviceToken"])
    {
        
        device_token=[[arrTblData objectAtIndex:TAG] valueForKey:@"deviceToken"];
    }
    else
    {
        device_token=@"";
    }
    
    // 81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f
    
    //device_token=@"81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f";
    NSString *msg=[NSString stringWithFormat:@"%@ rejected your friend request",[[arrTblData objectAtIndex:TAG] valueForKey:@"name"]];
    
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

    
    
    
    [self getAllFriends];
}
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
