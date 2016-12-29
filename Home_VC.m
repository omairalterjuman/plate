//
//  Home_VC.m
//  PLATE APP
//


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
#import "ChatViewController.h"

@interface Home_VC ()<BTSimpleSideMenuDelegate>

@property(nonatomic)BTSimpleSideMenu *sideMenu;

@end

@implementation Home_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    
   // self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
   // self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.01)];
   
    // create a button and add it to the container
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44.01)];
    [button setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ShowHide_SideMenu:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:button];
    
    UILabel* lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width-20, 0, container.frame.size.width-button.frame.size.width-20, 44.01)];
    lbl_title.text=@"My Friends";
    lbl_title.font=[UIFont fontWithName:@"Montserrat-SemiBold" size:14.0];
    lbl_title.textAlignment=NSTextAlignmentCenter;
    [container addSubview:lbl_title];
    
    _searchView.frame=CGRectMake(60, 0, 270, 35);
    _searchView.backgroundColor=[UIColor colorWithRed:68.0/255.0 green:58.0/255.0 blue:205.0/255.0 alpha:1.0];
    _searchView.layer.cornerRadius=20;
    _searchView.clipsToBounds=YES;
    [container addSubview:_searchView];
    // now create a Bar button item
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
    
    // set the nav bar's right button item
    self.navigationItem.leftBarButtonItem = item;
    
    //UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_action:)];
    //tap.numberOfTapsRequired = 1;
    
   // [self.view addGestureRecognizer:tap];
    
    flagGetDetail=NO;
    flaglastMsg=NO;
    dictLastMSG=[[NSMutableDictionary alloc] init];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getAllFriends];
    [self sidebarfunction];
}
-(void)tap_action:(UIGestureRecognizer *)sender
{
   // [_searchbar resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
    [_searchbar resignFirstResponder];
    [self.view endEditing:YES];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=NO;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
 [_searchbar resignFirstResponder];
    [_tblUser reloadData];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(void)sidebarfunction
{
    _sideMenu.delegate = self;
    
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
                                   
                                   NSString *str = @"https://itunes.apple.com/us/app/direct-push-app/id1181391927?ls=1&mt=8";
                                  // str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
                                  // str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
                                   
                                   // Here is the app id from itunesconnect
                                  // str = [NSString stringWithFormat:@"%@yourAppIDHere", str];
                                   
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                   
                                   
                               }];
    
    BTSimpleMenuItem *item7 = [[BTSimpleMenuItem alloc]initWithTitle:@"Share App" image:[UIImage imageNamed:@""] onCompletion:^(BOOL success, BTSimpleMenuItem *item)
                               {
                                   NSString *textToShare = @"Look at this awesome iOS PLATE APP!";
                                   NSURL *myWebsite = [NSURL URLWithString:@"https://itunes.apple.com/us/app/direct-push-app/id1181391927?ls=1&mt=8"];
                                   
                                   NSArray *objectsToShare = @[textToShare, myWebsite];
                                   
                                   UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
                                   
                                   NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                                                  UIActivityTypePrint,
                                                                  UIActivityTypeAssignToContact,
                                                                  UIActivityTypeSaveToCameraRoll,
                                                                  UIActivityTypeAddToReadingList,
                                                                  UIActivityTypePostToFlickr,
                                                                  UIActivityTypePostToVimeo];
                                   
                                   activityVC.excludedActivityTypes = excludeActivities;
                                   
                                   [self presentViewController:activityVC animated:YES completion:nil];
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
                                                                   
//                                                                    ViewController  *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                                                                    [self.navigationController pushViewController:signup animated:YES];
                                                                    
                                                                    [self.navigationController popToRootViewControllerAnimated:YES];;
//                                                                    ViewController *LogIn=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
//                                                                    [self.navigationController pushViewController:LogIn animated:YES];
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

-(IBAction)menu_action:(id)sender
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)getAllFriends
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _FIR_Ref = [[FIRDatabase database] reference];
    [_FIR_Ref keepSynced:YES];
    NSLog(@"FOLDER 2:::: %@",[_FIR_Ref child:@"plateapp-5bc35"]);//[_ref child:@"room-messages"]);
    
    
    createFlag = true;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    // NSTimeInterval is defined as double
    NSString *timeStampObj = [NSString stringWithFormat:@"%.0f",timeStamp*10000];
    NSLog(@"Timestamp : %@",timeStampObj);
    
    tempARR=[[NSMutableArray alloc]init];
    arrAllData=[[NSMutableArray alloc]init];
     arr_SearchData=[[NSMutableArray alloc]init];
    
    createFlag=true;
    [[[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot5)
     {
         
         if (snapshot5.exists)
         {
             NSLog(@"snapshot.value__1111 ::: %@",snapshot5.children);
             //NSMutableArray *MSG=[[NSMutableArray alloc]init];
             
             NSLog(@"Count k___1111 : %d",(int)snapshot5.childrenCount);
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             
             for ( FIRDataSnapshot *child in snapshot5.children)
             {
                 if ([child.key isEqualToString:@"friends"])
                 {
                     [tempARR addObjectsFromArray:child.value];
                 }
             }
             
              /////////// Now 'tempARR' contains my all friend's id's
             for (int ak=0; ak<tempARR.count; ak++)
             {
                 [[[_FIR_Ref child: @"users"] child:[NSString stringWithFormat:@"%@",[tempARR objectAtIndex:ak]]]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
                  {
                      if (snapshot.exists)
                      {
                          NSLog(@"My Friend's snapshot.value__1::: %@",snapshot.children);
                          //NSMutableArray *MSG=[[NSMutableArray alloc]init];
                          
                          NSLog(@"value__1111 : %@",snapshot.value);
                          [arrAllData addObject:snapshot.value];
                          arrTblData =[arrAllData mutableCopy];
                          
                          
                          if ( ak==tempARR.count-1)
                          {
                              flagGetDetail=YES;
                          }
                          
                          if (flaglastMsg==YES && ak==tempARR.count-1)
                          {
                              [_tblUser reloadData];
                          }
                          
                          [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                      }
                      
                  }withCancelBlock:^(NSError * _Nonnull error)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      
                      {
                          flagGetDetail=YES;
                      }
                      
                      if (flaglastMsg==YES )
                      {
                          [_tblUser reloadData];
                      }
                      
                      NSLog(@"%@", error.localizedDescription);
                  }];
                 
                 
                 
                 [[[[_FIR_Ref child: @"messages"]child:[NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],[tempARR objectAtIndex:ak]]] queryLimitedToLast:1]  observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
                  {
                      if (snapshot.exists)
                      {
                          NSLog(@"LAST MSG 1::: %@",snapshot.key);
                          NSLog(@"LAST MSG  value__1111 : %@",snapshot.value);
                          
                          NSLog(@"MESSAGE : %@",[[snapshot.value objectForKey:[[snapshot.value allKeys] lastObject]] valueForKey:@"message"]);
                          
                          [dictLastMSG setObject:[snapshot.value objectForKey:[[snapshot.value allKeys] lastObject]] forKey:[[snapshot.key componentsSeparatedByString:@"___"] objectAtIndex:1]];
                          
                          if ( ak==tempARR.count-1)
                          {
                              flaglastMsg=YES;
                          }
                          
                          if (flagGetDetail==YES && ak==tempARR.count-1)
                          {
                              [_tblUser reloadData];
                          }
                          
                      }
                      else
                      {
                          [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                          
                          {
                              flaglastMsg=YES;
                          }
                          
                          if (flagGetDetail==YES)
                          {
                              [_tblUser reloadData];
                          }
                          
                          NSLog(@"\n\n snapshot5 messages Not Found");
                      }
                  }];
                 
                 
                 
             }
             
            
             
             
             
             
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
             // Configure for text only and offset down
             
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"No user found";
             hud.margin = 10.f;
             hud.yOffset = +180.f;
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:2];
         //    [self performSelector:@selector(back:) withObject:nil afterDelay:2.0];
         }
         
         
     }withCancelBlock:^(NSError * _Nonnull error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSLog(@"%@", error.localizedDescription);
     }];
}










- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   /* if ([arrTblData count])
        return [arrTblData count];
    else
        return 0;*/
    
    NSInteger cou=0;
    
    if(tableView == [[self searchDisplayController] searchResultsTableView])
    {
        NSLog(@"Returning arr_SearchData count******");
        if (arr_SearchData.count==0) {
            arrTblData = arrAllData;
            cou =[arrTblData count];

        }
        else{
        arrTblData = arr_SearchData;
        cou =[arr_SearchData count];
        }
    }
    else
    {
        NSLog(@"Returning arrData count**********");
        arrTblData = arrAllData;
        
        if (arrTblData.count>=arrAllData.count)
            cou =[arrTblData count];
        else
            cou =[arrTblData count];
        
    }
    return cou;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HomeCell";
    
    HomeCell *cell = (HomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        if (![[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"image"] isEqualToString:@""]) {
            NSData *data = [[NSData alloc]initWithBase64EncodedString:[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"image"]
                                                              options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            cell.imgView.image= [UIImage imageWithData:data];
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2;
            cell.imgView.clipsToBounds = YES;
        }
        
        
        cell.lbl_name.text =[NSString stringWithFormat:@"%@", [[arrTblData objectAtIndex:indexPath.row]valueForKey:@"name"]];
        
        if ([dictLastMSG objectForKey:[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"user_id"]])
        {
            cell.lbl_status.text =[NSString stringWithFormat:@"%@", [[dictLastMSG objectForKey:[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"user_id"]] valueForKey:@"message"]];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[dictLastMSG objectForKey:[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"user_id"]] valueForKey:@"timestamp"] doubleValue]/10000000];
            
           // NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_lasttime",[[arr_TblData objectAtIndex:indexPath.row] valueForKey:@"room_id"]]] doubleValue]/1000];
            /*
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale systemLocale]];
            [formatter setDateFormat:@"HH:mm"];
            [formatter stringFromDate:date];
            NSLog(@"DATE FROM TIME STAMP 1:: %@",[formatter stringFromDate:date]);
            cell.lbl_time.text=[formatter stringFromDate:date];
            */
            
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale systemLocale]];
            [formatter setDateFormat:@"dd:MM:yyyy"];
            //        [formatter stringFromDate:date];
            //        NSLog(@"DATE FROM TIME STAMP 1:: %@",[formatter stringFromDate:date]);
            
            NSDate *dateToday =[[NSDate alloc]init];
            NSDateFormatter *formatterToday= [[NSDateFormatter alloc] init];
            [formatterToday setLocale:[NSLocale systemLocale]];
            [formatterToday setDateFormat:@"dd:MM:yyyy"];
            
            //lbl_date.font=[UIFont fontWithName:@"Montserrat-Light" size:10.0];
            
            
            
            
            if ([[formatterToday stringFromDate:dateToday] compare:[formatter stringFromDate:date]] == NSOrderedSame )
            {
                NSLog(@"TODAY");
                NSDateFormatter *formatterDisplayDate= [[NSDateFormatter alloc] init];
                [formatterDisplayDate setLocale:[NSLocale systemLocale]];
                [formatterDisplayDate setDateFormat:@"HH:mm"];
                cell.lbl_time.text = [formatterDisplayDate stringFromDate:date];
            }
            else
            {
                
                NSDateFormatter *formatterDisplayTIME= [[NSDateFormatter alloc] init];
                [formatterDisplayTIME setLocale:[NSLocale systemLocale]];
                [formatterDisplayTIME setDateFormat:@"dd:MM:yy, HH:mm"];
               cell.lbl_time.text = [formatterDisplayTIME stringFromDate:date];
                
            }
            
            
            
            //cell.lbl_time.text=[NSString stringWithFormat:@"%@",date];
        }
        else
        {
          cell.lbl_status.text=@"";
        cell.lbl_time.text=@"";
        }
        
        
        //cell.lbl_name.tag=indexPath.row+10000;
        
        //  [cell.btn_delete addTarget:self action:@selector(Btntap:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    [self performSelector:@selector(GOTO_CHAT:) withObject:[NSString stringWithFormat:@"%d",(int)indexPath.row] afterDelay:0.01];
     
}

-(void)GOTO_CHAT:(NSString*)indexpath
{
    ChatViewController *chatVC =[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[arrTblData objectAtIndex:[indexpath intValue]] valueForKey:@"user_id"] forKey:@"other_user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:[[arrTblData objectAtIndex:[indexpath intValue]] valueForKey:@"name"] forKey:@"other_user_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[[arrTblData objectAtIndex:[indexpath intValue]] valueForKey:@"image"] forKey:@"other_user_image"];
    [[NSUserDefaults standardUserDefaults] setObject:[[arrTblData objectAtIndex:[indexpath intValue]] valueForKey:@"deviceToken"] forKey:@"deviceToken"];
    
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}



////  ************************* SEARCH   **********************

-(void) filterForSearchText:(NSString *) text scope:(NSString *) scope
{
    [arr_SearchData removeAllObjects]; // clearing filter array
    
    /*
     NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[c]%@) OR (SELF.title contains[c]%@)",text,text]; // Creating filter condition
     */
    //  (SELF.name contains[c]%@) OR (SELF.title contains[c]%@)
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF.plateNumber contains[c]%@) OR (SELF.name contains[c]%@)",text,text];
    arr_SearchData = [NSMutableArray arrayWithArray:[arrAllData filteredArrayUsingPredicate:filterPredicate]]; // filtering result
    
}
-(BOOL) searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterForSearchText:searchString scope:[[[[self searchDisplayController] searchBar] scopeButtonTitles] objectAtIndex:[[[self searchDisplayController] searchBar] selectedScopeButtonIndex] ]];
    
    
    
    //    UIImage *patternImage = [UIImage imageNamed:@"1_home_bg.png"];
    //    [controller.searchResultsTableView setBackgroundColor:[UIColor colorWithPatternImage: patternImage]];
    //    controller.searchResultsTableView.bounces=FALSE;
    
    return YES;
}

-(BOOL) searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
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
