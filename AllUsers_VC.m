//
//  AllUsers_VC.m
//  PLATE APP
//

#import "AllUserCell.h"


#import "Home_VC.h"
#import "HomeCell.h"
#import "AllUsers_VC.h"
#import "btSimpleMenuItem.h"
#import "btSimpleSideMenu.h"
#import "ViewController.h"
#import "MyProfile_VC.h"
#import "MyFriends_VC.h"
#import "Setting.h"
#import "OtherUser_VC.h"
#import "MBProgressHUD.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@interface AllUsers_VC ()<BTSimpleSideMenuDelegate>

@property(nonatomic)BTSimpleSideMenu *sideMenu;

@end

@implementation AllUsers_VC

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
    lbl_title.text=@"All Users";
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
    
    //[self.view addGestureRecognizer:tap];
    
    //[self performSelector:@selector(getData) withObject:nil afterDelay:0.1];
    
}

-(void)getData

{
    request=NO;
    frnd=NO;
    _FIR_Ref = [[FIRDatabase database] reference];
    [_FIR_Ref keepSynced:YES];
    NSLog(@"FOLDER 2:::: %@",[_FIR_Ref child:@"plateapp-5bc35"]);//[_ref child:@"room-messages"]);
    
    createFlag = true;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    // NSTimeInterval is defined as double
    NSString *timeStampObj = [NSString stringWithFormat:@"%.0f",timeStamp*10000];
    NSLog(@"Timestamp : %@",timeStampObj);
    
    arr_allData=[[NSMutableArray alloc]init];
    arrTblData=[[NSMutableArray alloc]init];
    arr_SearchData=[[NSMutableArray alloc]init];
    arrDataFromSnapshot=[[NSMutableArray alloc]init];
    
    dictYesFriends=[[NSMutableDictionary alloc]init];
    //// GET FRIENDS ID IF ANY FRIENDS REQUEST IN MY ID(FRIENDS FOLDER)
    
     dictMyFriends=[[NSMutableDictionary alloc]init];
    [[[_FIR_Ref child: @"receive"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         if (snapshot.exists)
         {
             NSLog(@"FRIENDS snapshot.value ::: %@",snapshot.value);
             NSLog(@"FRIENDS snapshot.value ::: %@",snapshot.key);
             
             dictMyFriends = [snapshot.value mutableCopy];
           
             
             /*{
              "u_121212" = pending;
              }
              */
             
             request=YES;
         }
         else
         {
             request=YES;
         }
         
         if (frnd==YES)
         {
             [self getALLdataFilter];
         }
         
         
     }withCancelBlock:^(NSError * _Nonnull error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSLog(@"%@", error.localizedDescription);
     }];
    
    
    
    
    
    
    [[[[_FIR_Ref child: @"users"]child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]] child:@"friends"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         if (snapshot.exists)
         {
             NSLog(@"My FRIENDS snap .value ::: %@",snapshot.value);
             NSLog(@"My FRIENDS snaps .value ::: %@",snapshot.key);
             
             dictYesFriends = [snapshot.value mutableCopy];
             /*
             NSMutableArray *ar=[[NSMutableArray alloc]init];
             ar=snapshot.value;
             NSLog(@"DATA :: %@",ar);
             
             if (ar.count>0)
             {
                 [arrYesFriends addObjectsFromArray:ar];
                 
             }*/
             
             frnd=YES;
             
             
         }
         else
         {
             frnd=YES;
             
         }
         
         if (request==YES)
         {
             [self getALLdataFilter];
         }
         
         
     }];
}

-(void)getALLdataFilter
{
    [[_FIR_Ref child: @"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         if (snapshot.exists)
         {
             NSLog(@"snapshot.value__1111 ::: %@",snapshot.children);
             //NSMutableArray *MSG=[[NSMutableArray alloc]init];
             if (createFlag)
             {
                 NSLog(@"Count___1111 : %d",(int)snapshot.childrenCount);
                 
                 int countChild=(int)snapshot.childrenCount;
                 int counter=0;
                 
                 for ( FIRDataSnapshot *child in snapshot.children)
                 {
                     NSLog(@"child___444 ::: %@",child);
                     counter++;
                     if (![[child.value valueForKey:@"user_id"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]])
                     {
                         [arrDataFromSnapshot addObject:child.value];
                     }
                     
                 }
                 if (countChild==counter)
                 {
                     createFlag=false;
                     
                     if (![dictMyFriends count])
                     {
                         [arr_allData addObjectsFromArray:arrDataFromSnapshot];
                     }
                     else
                     {
                         NSMutableDictionary *temp1=[[NSMutableDictionary alloc]init];
                         for (int k=0; k<arrDataFromSnapshot.count; k++)
                         {
                             if (![dictMyFriends objectForKey:[[arrDataFromSnapshot objectAtIndex:k]valueForKey:@"user_id"]])
                             {
                                 //[arr_allData addObject:[arrDataFromSnapshot objectAtIndex:k]];
                                 [temp1 setObject:[arrDataFromSnapshot objectAtIndex:k] forKey:[[arrDataFromSnapshot objectAtIndex:k]valueForKey:@"user_id"]];
                             }
                             else
                             {
                                 //[temp1 setObject:@{} forKey:[[arrDataFromSnapshot objectAtIndex:k]valueForKey:@"user_id"]];
                                 if ([temp1 objectForKey:[[arrDataFromSnapshot objectAtIndex:k]valueForKey:@"user_id"]])
                                 {
                                 [temp1 removeObjectForKey:[[arrDataFromSnapshot objectAtIndex:k]valueForKey:@"user_id"]];
                                 }
                             }
                         }
                         
                         if (temp1)
                         {
                             arr_allData = [[temp1 allValues]mutableCopy];
                         }
                     }
                     
                     NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
                     
                     for (int k=0; k<arr_allData.count; k++)
                     {
                         
                         if (![dictYesFriends count])
                         {
                             //[temp addObjectsFromArray:arr_allData];
                         }
                         else
                         {
                             NSLog(@"DEVENDRA u_1111 :: %@",[[arr_allData objectAtIndex:k]valueForKey:@"user_id"]);
                             
                             // NSLog(@"DEVENDRA u_2222 :: %@",[dictYesFriends objectAtIndex:l]);
                             
                             if (![dictYesFriends objectForKey:[[arr_allData objectAtIndex:k]valueForKey:@"user_id"]])
                             {
                                 //[temp addObject:[arr_allData objectAtIndex:k]];
                                 [temp setObject:[arr_allData objectAtIndex:k] forKey:[[arr_allData objectAtIndex:k]valueForKey:@"user_id"]];
                             }
                             else
                             {
                                 NSLog(@"--------------------------------checking----------");
                             }
                             
                         }
                         
                     }
                     if (temp.count>0) {
                         arr_allData=[[temp allValues] mutableCopy];
                     }
                     
                     
                     //arrTblData=[arr_allData mutableCopy];
                     
                     if (arr_allData.count>0)
                     {
                         NSSortDescriptor *priceDescriptor = [NSSortDescriptor
                                                              sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                              selector:@selector(caseInsensitiveCompare:)];
                         
                         
                         NSArray *descriptors = @[priceDescriptor];
                         [arr_allData sortUsingDescriptors:descriptors];
                         
                         [_tblUser reloadData];
                     }
                     
                 }
             }
             
         }
     }withCancelBlock:^(NSError * _Nonnull error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSLog(@"%@", error.localizedDescription);
     }];
}




-(void)tap_action:(UIGestureRecognizer *)sender
{
    [_searchBar resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
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
    [_searchBar resignFirstResponder];
    NSSortDescriptor *priceDescriptor = [NSSortDescriptor
                                         sortDescriptorWithKey:@"name"
                                         ascending:YES
                                         selector:@selector(caseInsensitiveCompare:)];
    NSArray *descriptors = @[priceDescriptor];
    [arr_allData sortUsingDescriptors:descriptors];
    
    [_tblUser reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
     [self getData];
    [self sidebarfunction];
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
-(IBAction)menu_action:(id)sender
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger cou=0;

    if(tableView == [[self searchDisplayController] searchResultsTableView])
    {
        NSLog(@"Returning arr_SearchData count******");
        if (arr_SearchData.count==0) {
            arrTblData = arr_allData;
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
        arrTblData = arr_allData;
        
        if (arrTblData.count>=arr_allData.count)
            cou =[arrTblData count];
        else
            cou =[arrTblData count];
        
    }
    
    return cou;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AllUserCell";
    
    AllUserCell *cell = (AllUserCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllUserCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        if (![[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"image"] isEqualToString:@""]) {
            NSData *data = [[NSData alloc]initWithBase64EncodedString:[[arrTblData objectAtIndex:indexPath.row]valueForKey:@"image"]
                                                              options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            cell.imgView.image= [UIImage imageWithData:data];
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2;
            cell.imgView.clipsToBounds = YES;
        }
        
        
        cell.lbl_name.text =[NSString stringWithFormat:@"%@", [[arrTblData objectAtIndex:indexPath.row]valueForKey:@"name"]];
        cell.lbl_status.text =[NSString stringWithFormat:@"%@", [[arrTblData objectAtIndex:indexPath.row]valueForKey:@"status"]];
        
        //cell.lbl_name.tag=indexPath.row+10000;
        
        //  [cell.btn_delete addTarget:self action:@selector(Btntap:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    // [cell.imgView setImageWithURL:[NSURL URLWithString:[[arr_allData objectAtIndex:indexPath.row]valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OtherUser_VC *signup =[self.storyboard instantiateViewControllerWithIdentifier:@"OtherUser_VC"];
    signup.arrData=[[NSMutableArray alloc]init];
    
    signup.arrData=[[arrTblData objectAtIndex:indexPath.row] mutableCopy];
    [self.navigationController pushViewController:signup animated:YES];
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
   NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF.plateNumber contains[c]%@) OR (SELF.name contains[c]%@)",text,text];
    
    arr_SearchData = [NSMutableArray arrayWithArray:[arr_allData filteredArrayUsingPredicate:filterPredicate]]; // filtering result
    
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
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [_tblview reloadData];
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
