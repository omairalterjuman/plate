//
//  ChatViewController.m
//  Mobeen_chatcontroller
//
//  Created by mac on 9/11/15.


#import "ChatViewController.h"
//#import "map_ViewController.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"

#import "MBProgressHUD.h"
#import "EXPhotoViewer.h"
#import "Reachability.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize Mychattable,str_other_user_id;



- (void)viewDidLoad
{
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 44.00)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:86.0/255.0 green:86.0/255.0 blue:214.0/255.0 alpha:1.0];
    
    [container addSubview:_viewTop];
   // UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
    self.navigationItem.titleView = container;
    container.center = self.navigationItem.titleView.center;
    
    _FIR_Ref = [[FIRDatabase database] reference];
    [_FIR_Ref keepSynced:YES];
    
    Myarray = [[NSMutableArray alloc] init];
    
    
    //u_testing-yd1@gmail-com___u_project-youngdecade@gmail-com
   /* str_other_user_id = @"u_project-youngdecade@gmail-com";
    [[NSUserDefaults standardUserDefaults]setObject:@"u_testing-yd1@gmail-com" forKey:@"user_id"];*/
    
    tChatCount = 0;
    //last_User = 3;
    staticHeight = 80;
    
    _viewSideBlock.hidden = true;
    tempSize = _viewSideBlock.frame.size;
    
    _lblOnlineFlag.hidden = true;
    _lbl_Typing.hidden  = true;
    
    _str_other_userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"other_user_name"];
    str_other_user_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"other_user_id"];
    
    if ([_str_other_userName componentsSeparatedByString:@" "].count>1)
    {
        _lbl_OtherName.text = [NSString stringWithFormat:@"%@",[[_str_other_userName componentsSeparatedByString:@" "] objectAtIndex:0]] ;
    }
    else
    {
        _lbl_OtherName.text = [NSString stringWithFormat:@"%@",[_str_other_userName capitalizedString]];
    }
    
    //_lbl_NoMessage1.text = [NSString stringWithFormat:@"Great! %@ and you matched!",_lbl_OtherName.text];
    
    arrayForImg = [[NSMutableArray alloc]init];
    
    ArrForHeight = [[NSMutableArray alloc]init];
    ArrForWidth = [[NSMutableArray alloc]init];
    
    //[NSThread detachNewThreadSelector:@selector(hud1) toTarget:self withObject:nil];

   // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:17.0/255 green:62.0/255 blue:100.0/255 alpha:1.0]];
   // [[UINavigationBar appearance] setTranslucent:NO];
    
    
    [super viewDidLoad];
    pref = [NSUserDefaults standardUserDefaults];
    
    //[MBProgressHUD showHUDAddedTo: self.view animated:NO];
    
    //btn_blockUser.hidden = true;
    
    _viewNoMessage.hidden = true;
    //btn_Sniff.hidden = true;
    
    //btn_Sniff.tag = str_other_user_id.integerValue;
    NSLog(@"Other's ID: %@",str_other_user_id);
    [pref setObject:str_other_user_id forKey:@"OTHER_USER_ID"];

    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height == 480)
    {
        Mychattable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    }
    else
    {
        Mychattable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    }
    Mychattable.delegate=self;
    Mychattable.dataSource=self;
    Mychattable.separatorColor=[UIColor clearColor];//
    Mychattable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:Mychattable];
    [self.view bringSubviewToFront:_viewNoMessage];
    //btn_blockUser.layer.cornerRadius = 5.0f;
    //btn_blockUser.clipsToBounds = YES;
 
    //[_btn_OtherPhoto.imageView setImageWithURL:[NSURL URLWithString:_str_other_user_ImageURL] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _btn_OtherPhoto.layer.cornerRadius = _btn_OtherPhoto.frame.size.height/2;
    _btn_OtherPhoto.clipsToBounds = YES;
    

    
    [_btn_OtherPhoto sd_setImageWithURL:[NSURL URLWithString:_str_other_user_ImageURL] forState:UIControlStateNormal];
    
    [_btn_OtherPhoto setBackgroundImage:[UIImage imageNamed:@"User_Placeholder.png"] forState:UIControlStateNormal];
   
    [_btn_OtherPhoto addTarget:self action:@selector(showAvatar1:) forControlEvents:UIControlEventTouchUpInside];
    
  
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"other_user_image"] isEqualToString:@""]) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"other_user_image"]
                                                          options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        
        [_btn_OtherPhoto setImage:[UIImage imageWithData:data] forState:UIControlStateNormal ] ;
        
        
        
    }
    
    
    [[_btn_blockUser1 imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[_btn_OtherPhoto imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [_imgOther setImageWithURL:[NSURL URLWithString:_str_other_user_ImageURL] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _imgOther.layer.cornerRadius = _imgOther.frame.size.height/2;
    _imgOther.clipsToBounds = YES;
    
    
    [self ViewContainer];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(hide_KeyBoard:)] ;
    
    UISwipeGestureRecognizer *gesture2 = [[UISwipeGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(hide_KeyBoard:)] ;
    
    gesture2.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *gesture1 = [[UISwipeGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(hide_KeyBoard:)] ;
    
    gesture2.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    [self.view addGestureRecognizer:gesture];
    [_viewNoMessage addGestureRecognizer:gesture];
    
    
    [self.view addGestureRecognizer:gesture2];
    [_viewNoMessage addGestureRecognizer:gesture2];
    
    [self.view addGestureRecognizer:gesture1];
    [_viewNoMessage addGestureRecognizer:gesture1];
    
    
    [_viewNoMessage addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(hide_KeyBoard:)]];
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(hide_KeyBoard:)]];

    
    _viewTop.userInteractionEnabled = true;
    [_viewTop addGestureRecognizer:gesture];
    
    /*UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(showAvatar:)] ;
     
     [myLabel addGestureRecognizer:gesture];*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    [self.Mychattable addGestureRecognizer:tap];
    
    
    
    {
        NSLog(@"user_id %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]);
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
        // NSTimeInterval is defined as double
        //NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp*10000];
        NSString *timeStampObj = [NSString stringWithFormat:@"%.0f",timeStamp*10000];
        NSLog(@"Timestamp : %@",timeStampObj);
        
        NSLog(@"user_id %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]);
        NSLog(@"pref_fir_myname %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_fir_myname"]);
        
        
        
        
        [[[_FIR_Ref child: @"groups"]child:[NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],str_other_user_id]]  observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
         {
             if (snapshot.exists)
             {
                 if (!strGroupID)
                 {
                     NSLog(@"snapshot.value__5555 ::: %@",snapshot.children);
                     
                     NSLog(@"Count___5555 : %d",(int)snapshot.childrenCount);
                     
                     
                     for ( FIRDataSnapshot *child in snapshot.children)
                     {
                         if ([child.key isEqualToString:@"group-id"])
                         {
                             strGroupID=[NSString stringWithFormat:@"%@",child.value];
                             
                             //14822453240963870
                             //[[[[_FIR_Ref child: @"messages"]child:[NSString stringWithFormat:@"%@",strGroupID]] queryOrderedByChild:@"timestamp"] queryStartingAtValue:@"14822453240963870"]
                             
                             [[[_FIR_Ref child: @"messages"]child:[NSString stringWithFormat:@"%@",strGroupID]]  observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot2)
                              {
                                  if (snapshot2.exists)
                                  {
                                      for ( FIRDataSnapshot *child2 in snapshot2.children)
                                      {
                                          bool check1=false;
                                          for (int aaa=0; aaa<Myarray.count; aaa++)
                                          {
                                              if ([[[Myarray objectAtIndex:aaa] valueForKey:@"timestamp"]isEqualToString:[child2.value objectForKey:@"timestamp"]])
                                              {
                                                  check1 = true;
                                              }
                                          }
                                          if (!check1)
                                          {
                                              [Myarray addObject:child2.value];
                                              NSLog(@"Myarray: : : %@",Myarray);
                                              
                                              [Mychattable reloadData];
                                              
                                              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:Myarray.count-1 inSection:0];
                                              [Mychattable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                          }
                                          
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                      }
                                  }
                                  else
                                  {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                      NSLog(@"\n\n chat messages Not Found");
                                  }
                              }];
                             
                         }
                         NSLog(@"child___5555 ::: %@",child);
                     }
                 }
                 [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             }
             else
             {
                 NSLog(@"\n\n group Not Found");
                 
                 /*if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"g_%@_delete",timeStampObj]])*/
                 if (str_other_user_id && !strGroupID)
                 {
                     ////// update newly created group info in user1's detail
                     FIRDatabaseReference *usersRef1 = [[[[_FIR_Ref child: @"users"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]] child:@"groups"] child:[NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],str_other_user_id]];
                     
                     NSDictionary *users1 = @{
                                              @"begintime": [NSString stringWithFormat:@"%@",timeStampObj],
                                              @"value": @"true"
                                              };
                     
                     [usersRef1 setValue: users1];
                     
                     ////// update newly created group info in user2's detail
                     FIRDatabaseReference *usersRef2 = [[[[_FIR_Ref child: @"users"] child:str_other_user_id] child:@"groups"] child:[NSString stringWithFormat:@"%@___%@",str_other_user_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]];
                     
                     [usersRef2 setValue: users1];
                     
                     ///// add group for new chat
                     FIRDatabaseReference *usersRef = [[_FIR_Ref child: @"groups"]child:[NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],str_other_user_id]];
                     
                     NSDictionary *users = @{
                                             @"name": @"1-1",
                                             @"group-id": [NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],str_other_user_id],
                                             @"members":@{},
                                             @"owner":@{},
                                             @"type":@"1-1",
                                             @"typing":@"false"
                                             };
                     [usersRef setValue: users];
                
                 }
                 
             }
         }];
        
    }
    
    

}

//.........

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
    /*CGPoint location = [tap locationInView:self.Mychattable];
    NSIndexPath *path = [self.Mychattable indexPathForRowAtPoint:location];
    if(path)
    {// tap was on existing row, so pass it to the delegate method
        [self tableView:self.Mychattable didSelectRowAtIndexPath:path];
    }
    else{
        // handle tap on empty space below existing rows however you want
    }*/
    
    //[self hideSideBar];
    [textView resignFirstResponder];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self hideSideBar];
}



-(void)viewWillAppear:(BOOL)animated
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //[self startTimer];
    Mychattable.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40);
    
   // [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.0005];
}

/*- (void)stopTimer {
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}
- (void)startTimer
{
    timer =
    [NSTimer scheduledTimerWithTimeInterval:1.7
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
}*/

//- (void)stopTimerForInternet {
//    if ([timerForInternet isValid]) {
//        [timerForInternet invalidate];
//    }
//    timerForInternet = nil;
//}
//- (void)startTimerForInternet
//{
//    timerForInternet =
//    [NSTimer scheduledTimerWithTimeInterval:1.7
//                                     target:self
//                                   selector:@selector(targetMethod:)
//                                   userInfo:nil
//                                    repeats:YES];
//}

/*-(IBAction)targetMethod:(id)sender
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if ([self CheckNetwork] == NotReachable)
    {
        //[self stopTimer];
        NSLog(@"Not Reachable");
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Info" message:@"Slow or no internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self webservicecalling];
    }
    
}*/


-(void)webservicecalling
{
    serviceFlag = 1;
    
}
-(void)DidRecieveRequest:(NSDictionary *)Dictionary
{
    //NSLog(@"%@",Dictionary);
    
    if (serviceFlag == 1) // get chat messages
    {
        NSArray *arrr=[Dictionary objectForKey:@"chat"];
    
        if ([Dictionary objectForKey:@"active_status"])
        {
            if ([[Dictionary objectForKey:@"active_status"] isEqualToString:@"yes"])
            {
                [_lblOnlineFlag.layer setCornerRadius:_lblOnlineFlag.frame.size.width/2];
                [_lblOnlineFlag setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:205.0/255.0 blue:100.0/255.0 alpha:1.0]];
                
                [_lblOnlineFlag setClipsToBounds:YES];
                
                _lblOnlineFlag.hidden = false;
            }
            else
            {
                _lblOnlineFlag.hidden = true;
            }
        }
        else
        {
            _lblOnlineFlag.hidden = true;
        }
        
        
        
        
        
        
        if ([[NSString stringWithFormat:@"%@",[Dictionary objectForKey:@"chat"]]isEqualToString:@"NA"])
        {
            NSLog(@"%@",Dictionary);
            if (tChatCount==0)
            {
                _viewNoMessage.hidden = false;
            }
        }
        else if (tChatCount<arrr.count)
        {
            NSLog(@"%@",Dictionary);
            
            if ([[Dictionary objectForKey:@"success"]isEqualToString:@"true"])
            {
                _viewNoMessage.hidden = true;
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                //[btn_blockUser setTitle:@"Block" forState:UIControlStateNormal];
                blockbtnFlag = 1; ///// button TEXT is BLOCK
                
                Mydictionary =[[NSMutableDictionary alloc]init];
                Myarray =[[NSMutableArray alloc]init];
    
                [ArrForHeight removeAllObjects];
                [ArrForWidth removeAllObjects];
                
                for (int i=0; i<arrr.count; i++)
                {
                    Dictionary=[arrr objectAtIndex:i];
                    [Myarray addObject:Dictionary];
                }
                [Mychattable reloadData];
                
                NSIndexPath* ip =  [NSIndexPath indexPathForRow:[Mychattable numberOfRowsInSection:0] - 1 inSection:0];
                [Mychattable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
                tChatCount=arrr.count;
            }
            else if ([[Dictionary objectForKey:@"block"]isEqualToString:@"yes"])
            {
                if ([[Dictionary objectForKey:@"blockby"]isEqualToString:[NSString stringWithFormat:@"%@",str_other_user_id]])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    
                    /////// you are blocked by this user
                    //btn_blockUser.enabled = false;
                    //[btn_blockUser setTitle:@" " forState:UIControlStateNormal];
                    
                   // btn_attach.enabled = false;
                    
                    doneBtn.enabled = false;
                    textView.userInteractionEnabled =false;
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"You are blocked by this user" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    
                    /////// you blocked this user
                    //[btn_blockUser setTitle:@"Unblock" forState:UIControlStateNormal];
                    //[self stopTimer];
                    blockbtnFlag = 2;//////button text is Unblock
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"This user is blcked by you" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                _viewNoMessage.hidden = false;
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            if (tChatCount==0)
            {
                _viewNoMessage.hidden = false;
            }
            
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    }
    else if (serviceFlag ==2) /////    block user webservice
    {
        if ([[Dictionary objectForKey:@"success"] isEqualToString:@"true"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information Message" message:[Dictionary objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (Dictionary==nil)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Server not responding. Please try after some time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            _viewNoMessage.hidden = false;
        }
        
    }
    
}





////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Myarray count];    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [textView resignFirstResponder];

    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        Mydictionary=[Myarray objectAtIndex:indexPath.row];
        NSLog(@"dict---%@",Mydictionary);
        
        //label username
        
        UILabel * lbl_username =[[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 20)];
        lbl_username.backgroundColor=[UIColor clearColor];
        lbl_username.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        lbl_username.text =[Mydictionary objectForKey:@"from_user_name"];
        
        
        //image user
        
        UIImageView * userimageview =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        userimageview.layer.cornerRadius = userimageview.frame.size.height/2.0;
        userimageview.clipsToBounds = YES;
        userimageview.backgroundColor=[UIColor clearColor];
       
        //lbl date
        UILabel * lbl_date=[[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 20)];
        lbl_date.backgroundColor=[UIColor clearColor];
        
        /*
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *yourDate = [dateFormatter dateFromString:[Mydictionary objectForKey:@"time"]];
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
        
        lbl_date.text =[dateFormatter stringFromDate:yourDate];
        */
        
        
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[Mydictionary objectForKey:@"timestamp"] doubleValue]/10000000];
        
        // NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_lasttime",[[arr_TblData objectAtIndex:indexPath.row] valueForKey:@"room_id"]]] doubleValue]/1000];
        
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale systemLocale]];
        [formatter setDateFormat:@"dd:MM:yyyy"];
//        [formatter stringFromDate:date];
//        NSLog(@"DATE FROM TIME STAMP 1:: %@",[formatter stringFromDate:date]);
        
        NSDate *dateToday =[[NSDate alloc]init];
         NSDateFormatter *formatterToday= [[NSDateFormatter alloc] init];
        [formatterToday setLocale:[NSLocale systemLocale]];
        [formatterToday setDateFormat:@"dd:MM:yyyy"];
        
        lbl_date.font=[UIFont fontWithName:@"Montserrat-Light" size:10.0];
        

        
        
        if ([[formatterToday stringFromDate:dateToday] compare:[formatter stringFromDate:date]] == NSOrderedSame )
        {
            NSLog(@"TODAY");
            NSDateFormatter *formatterDisplayDate= [[NSDateFormatter alloc] init];
            [formatterDisplayDate setLocale:[NSLocale systemLocale]];
            [formatterDisplayDate setDateFormat:@"HH:mm"];
            lbl_date.text = [formatterDisplayDate stringFromDate:date];
        }
        else
        {
           
            NSDateFormatter *formatterDisplayTIME= [[NSDateFormatter alloc] init];
            [formatterDisplayTIME setLocale:[NSLocale systemLocale]];
            [formatterDisplayTIME setDateFormat:@"dd:MM:yyyy  HH:mm"];
             lbl_date.text = [formatterDisplayTIME stringFromDate:date];
            
        }
        
        /*if ([[Mydictionary objectForKey:@"today"]isEqualToString:@"yes"])
        {
            lbl_date.text = [Mydictionary objectForKey:@"time"];
        }
        else
        {
            lbl_date.text = [Mydictionary objectForKey:@"date"];
        }*/
        
        UIImageView *bubbleImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        UIImageView *bubbleImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        UIImageView *bubbleImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        
        
        
        //UILabel * lbl_message;
        UITextView * lbl_message;
        UIImageView * imageMessage;
        if([[Mydictionary objectForKey:@"flag"] integerValue] == 2)  // has image message
        {
            
            if ([[Mydictionary objectForKey:@"send"]isEqualToString:@"from"])//other user// other's messages
            {
                imageMessage =[[UIImageView alloc]initWithFrame:CGRectMake(100, 24,250, 113)];
                imageMessage.backgroundColor=[UIColor clearColor];
                [imageMessage setImageWithURL:[Mydictionary objectForKey:@"message"] placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            }
            else  // my messages
            {
                imageMessage =[[UIImageView alloc]initWithFrame:CGRectMake(20, 24,250, 113)];
                imageMessage.backgroundColor=[UIColor clearColor];
                [imageMessage setImageWithURL:[Mydictionary objectForKey:@"message"] placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            }
            
            [arrayForImg addObject:imageMessage];
            imageMessage.userInteractionEnabled=YES;
            for (UILabel *myLabel in arrayForImg) {
                
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(showAvatar:)] ;
                
                [myLabel addGestureRecognizer:gesture];
            }
        }
        else   // has Text message //lbl message
        {
            //lbl_message =[[UILabel alloc]initWithFrame:CGRectMake(90, 25, 220, 55)];
            lbl_message = [[UITextView alloc]initWithFrame:CGRectMake(90, 24, 220, 54)];
            lbl_message.editable= false;
            lbl_message.selectable = false;
            lbl_message.backgroundColor=[UIColor clearColor];
           
            lbl_message.text =[Mydictionary objectForKey:@"message"];
            lbl_message.font=[UIFont fontWithName:@"Helvetica Neue" size:14.0];//[UIFont systemFontOfSize:13];
            //lbl_message.numberOfLines=10;
        }

    
        
        if (![[Mydictionary objectForKey:@"sender"] isEqualToString:str_other_user_id]) // MY MESSAGE
        {
            //Right side
            userimageview.frame=CGRectMake(Mychattable.frame.size.width-33, 3, 30, 30);
            
            bubbleImage.frame =CGRectMake(4, 2, Mychattable.frame.size.width-userimageview.frame.size.width-8, 18);//78
            bubbleImage1.frame =CGRectMake(4, 20, Mychattable.frame.size.width-userimageview.frame.size.width-8, [[ArrForHeight objectAtIndex:indexPath.row] intValue]-48);//78
            bubbleImage2.frame =CGRectMake(4, bubbleImage1.frame.origin.y+bubbleImage1.frame.size.height, Mychattable.frame.size.width-userimageview.frame.size.width-8, 19);//78
            
            
            lbl_username.frame =CGRectMake(127, 3, 100, 20);
            lbl_username.textAlignment =NSTextAlignmentRight;
            
            lbl_date.frame =CGRectMake(5, 3, 90, 20); // CGRectMake(Mychattable.frame.size.width-99, 3, 90, 20);
            lbl_date.textAlignment =NSTextAlignmentRight;
            lbl_message.textAlignment =NSTextAlignmentLeft;
            lbl_message.frame =CGRectMake(15, 19, userimageview.frame.origin.x-25, [[ArrForHeight objectAtIndex:indexPath.row] intValue]-31);
            lbl_message.textColor = [UIColor blackColor];
            lbl_date.textColor = [UIColor grayColor];
            
            
            
            [bubbleImage setImage:[UIImage imageNamed:@"bubble00.png"]];
            [bubbleImage1 setImage:[UIImage imageNamed:@"bubble02.png"]];
            [bubbleImage2 setImage:[UIImage imageNamed:@"bubble01.png"]];
            
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"] isEqualToString:@""]) {
                NSData *data = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"]
                                                                  options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                
                [userimageview setImage:[UIImage imageWithData:data]  ] ;
                
                
                
            }
            else
            {
                userimageview.image=[UIImage imageNamed:@"User_Placeholder.png"];
            }
            /*
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_profileImageType"]isEqualToString:@"url"])
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]])
                {
                    [userimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]]]] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                }
                else
                {
                    userimageview.image=[UIImage imageNamed:@"User_Placeholder.png.png"];
                }
            }
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_profileImageType"]isEqualToString:@"imagedata"])
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]])
                {
                    [userimageview setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_user_id"]]]]];
                }
                else
                {
                    userimageview.image=[UIImage imageNamed:@"User_Placeholder.png.png"];
                }
            }
            else
            {
                userimageview.image=[UIImage imageNamed:@"User_Placeholder.png.png"];
            }*/
            
        }
        else //OTHER USER MSG
        {
            //left side
            userimageview.frame =CGRectMake(5, 3, 30, 30);
            
            bubbleImage.frame =CGRectMake(userimageview.frame.size.width+8, 2, Mychattable.frame.size.width-userimageview.frame.size.width-13, 18);
            bubbleImage1.frame =CGRectMake(userimageview.frame.size.width+8, 20, Mychattable.frame.size.width-userimageview.frame.size.width-13, [[ArrForHeight objectAtIndex:indexPath.row] intValue]-48);
            bubbleImage2.frame =CGRectMake(userimageview.frame.size.width+8, bubbleImage1.frame.origin.y+bubbleImage1.frame.size.height, Mychattable.frame.size.width-userimageview.frame.size.width-13, 19);
            
            
            lbl_username.frame =CGRectMake(90, 3, 100, 20);
            lbl_username.textAlignment =NSTextAlignmentLeft;
            
            lbl_date.frame =CGRectMake(Mychattable.frame.size.width-99, 3, 90, 20);
            lbl_date.textAlignment =NSTextAlignmentLeft;
            lbl_message.textAlignment =NSTextAlignmentLeft;
            lbl_message.frame =CGRectMake(bubbleImage.frame.origin.x, 19, Mychattable.frame.size.width-bubbleImage.frame.origin.x-28, [[ArrForHeight objectAtIndex:indexPath.row] intValue]-31);
            
           lbl_message.textColor = [UIColor blackColor];
            lbl_date.textColor = [UIColor grayColor];
            
            [bubbleImage setImage:[UIImage imageNamed:@"bubble110.png"]];
            [bubbleImage1 setImage:[UIImage imageNamed:@"bubble112.png"]];
            [bubbleImage2 setImage:[UIImage imageNamed:@"bubble111.png"]];
            
            
            
            //[userimageview setImageWithURL:[NSURL URLWithString:_str_other_user_ImageURL] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"other_user_image"] isEqualToString:@""]) {
                NSData *data = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"other_user_image"]
                                                                  options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                
                [userimageview setImage:[UIImage imageWithData:data]  ] ;
                
                
                
            }
            else
            {
                userimageview.image=[UIImage imageNamed:@"User_Placeholder.png"];
            }
            
            
            
        }

        
        NSLog(@"flag : %ld",(long)[[Mydictionary objectForKey:@"flag"] integerValue]);
        NSLog(@"last user : %@",last_User);
        
        //[cell.contentView addSubview:bubbleImage];
        //[cell.contentView addSubview:bubbleImage1];
        //[cell.contentView addSubview:bubbleImage2];
        
        UILabel *lbl_Back = [[UILabel alloc]initWithFrame:CGRectMake(bubbleImage.frame.origin.x, bubbleImage.frame.origin.y,[[ArrForWidth objectAtIndex:indexPath.row] intValue]+10, bubbleImage.frame.size.height+bubbleImage1.frame.size.height+bubbleImage2.frame.size.height)];
        [lbl_Back setText:@""];
        
        if (![[Mydictionary objectForKey:@"sender"] isEqualToString:str_other_user_id]) // MY MSG
        {
            [lbl_Back setBackgroundColor:[UIColor colorWithRed:210.0/255.0 green:229.0/255.0 blue:184.0/255.0 alpha:1.0]];
            lbl_Back.frame =CGRectMake(bubbleImage.frame.origin.x+bubbleImage.frame.size.width-[[ArrForWidth objectAtIndex:indexPath.row] intValue]-15, lbl_Back.frame.origin.y , lbl_Back.frame.size.width, lbl_Back.frame.size.height);
            
            if (lbl_Back.frame.size.width <80 )
            {
                lbl_message.frame = CGRectMake(lbl_Back.frame.origin.x, lbl_message.frame.origin.y, lbl_Back.frame.size.width, lbl_message.frame.size.height);
                lbl_Back.frame =CGRectMake(bubbleImage.frame.origin.x+bubbleImage.frame.size.width-80, lbl_Back.frame.origin.y , 80, lbl_Back.frame.size.height);
            }
            else
            {
                
            }
            
            
        }
        else //OTHER USER MSG
        {
            [lbl_Back setBackgroundColor:[UIColor colorWithRed:194.0/255.0 green:180.0/255.0 blue:224.0/255.0 alpha:1.0]];
            
            if (lbl_Back.frame.size.width <80 )
            {
                //lbl_message.frame = CGRectMake(lbl_Back.frame.origin.x, lbl_message.frame.origin.y, lbl_Back.frame.size.width, lbl_message.frame.size.height);
                lbl_Back.frame =CGRectMake(lbl_Back.frame.origin.x, lbl_Back.frame.origin.y, 80, lbl_Back.frame.size.height);
            }
            else
            {
                
            }
            
        }
       
        
        lbl_message.frame = CGRectMake(lbl_Back.frame.origin.x, lbl_message.frame.origin.y, lbl_Back.frame.size.width, lbl_message.frame.size.height);
        lbl_date.frame = CGRectMake(lbl_Back.frame.origin.x, lbl_Back.frame.origin.y, lbl_Back.frame.size.width, lbl_date.frame.size.height);
        
        lbl_Back.layer.cornerRadius = 8.0;
        lbl_Back.clipsToBounds=YES;
        [cell.contentView addSubview:lbl_Back];
        
        
        
        
        if (![[Mydictionary objectForKey:@"sender"] isEqualToString:last_User]) //sender of last msg & this msg are Different
        {
            userimageview.layer.borderColor = [[UIColor grayColor] CGColor];
            userimageview.layer.borderWidth = 1.0;
            [cell.contentView addSubview:userimageview];
            [cell.contentView addSubview:lbl_username];
        }
        
        
        last_User=[Mydictionary objectForKey:@"sender"];

        lbl_message.backgroundColor = [UIColor clearColor];
        
        imageMessage.contentMode = UIViewContentModeScaleAspectFit;
        lbl_message.font=[UIFont fontWithName:@"Helvetica Neue" size:14.0];
        lbl_message.userInteractionEnabled = false;
        [cell.contentView addSubview:lbl_date];
        [cell.contentView addSubview:lbl_message];
        
        imageMessage.center =  bubbleImage1.center;
        
        [cell.contentView addSubview:imageMessage];
        
        


        if (myflag==2)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            myflag=1;
        }
    
       // cell.textLabel.text = [Mydictionary objectForKey:@"chat_id"];
    }
    
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return staticHeight;//+indexPath.row*100
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int heightValue;
    int widthValue=40;
    
    Mydictionary=[Myarray objectAtIndex:indexPath.row];
    if([[Mydictionary objectForKey:@"flag"] integerValue] == 2)  // has image message
    {
        //return staticHeight;
        heightValue = staticHeight+60;
    }
    else   // has Text message //lbl message
    {
        UILabel * yourLabel = [[UILabel alloc]init];
        yourLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        yourLabel.text =[Mydictionary objectForKey:@"message"];
        yourLabel.text = [yourLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        CGSize labelHeight = [self heigtForCellwithString:yourLabel.text    withFont:yourLabel.font];
        //return labelHeight.height+40; // the return height + your other view height
        heightValue = labelHeight.height+45;
        widthValue = labelHeight.width;
    }
    if (ArrForHeight.count<indexPath.row+1)
    {
        [ArrForHeight addObject:[NSString stringWithFormat:@"%d",heightValue]];
        [ArrForWidth addObject:[NSString stringWithFormat:@"%d",widthValue]];
    }
    else if (indexPath.row==0 && ArrForHeight.count==0)
    {
        [ArrForHeight addObject:[NSString stringWithFormat:@"%d",heightValue]];
        [ArrForWidth addObject:[NSString stringWithFormat:@"%d",widthValue]];
    }
    else //if (ArrForHeight.count==indexPath.row)
    {
        [ArrForHeight replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%d",heightValue]];
        [ArrForWidth replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%d",widthValue]];
    }
    
    return heightValue;
}

-(CGSize)heigtForCellwithString:(NSString *)stringValue withFont:(UIFont*)font{
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width-33,9999); // Replace 300 with your label width
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [stringValue boundingRectWithSize:constraint
                                            options:         (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    return rect.size;
    
}

- (IBAction)showAvatar1:(UIButton*)sender
{
    //[self hideSideBar];
    [EXPhotoViewer showImageFrom:(UIImageView*)sender.imageView];
}


- (IBAction)showAvatar:(UITapGestureRecognizer*)sender
{
    //[self hideSideBar];
    [EXPhotoViewer showImageFrom:(UIImageView*)sender.view];
}
- (IBAction)hide_KeyBoard:(UITapGestureRecognizer*)sender
{
    //[self hideSideBar];
    [textView resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


//////////////////////////////////////////////////////////////


- (void)ViewContainer
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40)];
    
    containerView.backgroundColor=[UIColor colorWithRed:157.0/255 green:162.0/255 blue:177.0/255 alpha:1.0];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(12, 3, [UIScreen mainScreen].bounds.size.width-85, 40)];
    
    textView.isScrollable = NO;
    //textView.layer.cornerRadius = 20.0;

    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    
    textView.maxNumberOfLines = 60;
    
    // you can also set the maximum height in points with maxHeight
    
    // textView.maxHeight = 200.0f;
    
    textView.returnKeyType = UIReturnKeyDefault; //just as an example

    textView.font = [UIFont fontWithName:@"Helvetica" size:15.0f];//[UIFont systemFontOfSize:15.0f];
    
    textView.delegate = textView.delegate;
    
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
    textView.backgroundColor = [UIColor clearColor];
    
    textView.placeholder = @"write message...";

    textView.keyboardType = UIKeyboardAppearanceDark;
    
    
    [self.view addSubview:containerView];
    
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 3, [UIScreen mainScreen].bounds.size.width-80, 34);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [entryImageView setBackgroundColor:[UIColor whiteColor]];
    entryImageView.layer.cornerRadius = 21.0;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    
    imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame=CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textView.delegate = self;
    
    
    
   /* btn_attach = [[UIButton alloc]initWithFrame:CGRectMake(entryImageView.frame.size.width-33, 5,28, 28)];
    btn_attach.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin;
    //btn_attach.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //camera.png
    [btn_attach setImage:[UIImage imageNamed:@"attch-icon.png"] forState:UIControlStateNormal];
    [btn_attach addTarget:self action:@selector(attach_touch) forControlEvents:UIControlEventTouchUpInside];
    [[btn_attach imageView]setContentMode:UIViewContentModeScaleAspectFit];
    
    btn_attach.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    */
    [containerView addSubview:entryImageView];
    
    /*[containerView addSubview:btn_attach];*/
    
    // view hierachy
    
    [containerView addSubview:imageView];
    
    [containerView addSubview:textView];
    
    
    
    
    
    //UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    //UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    doneBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, containerView.frame.size.height-27-7, 50, 27);
    
    //doneBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    //doneBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    
    //[UIColor colorWithWhite:0 alpha:0.4]
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setImage:[UIImage imageNamed:@"send-icon.png"] forState:UIControlStateNormal];
    [[doneBtn imageView]setContentMode:UIViewContentModeScaleAspectFit];
    
    [doneBtn setTitleColor:[UIColor colorWithRed:47.0/255.0 green:167.0/255.0 blue:217.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [doneBtn addTarget:self action:@selector(Action_Done:) forControlEvents:UIControlEventTouchUpInside];
    
    doneBtn.backgroundColor=[UIColor whiteColor];
    
    doneBtn.layer.cornerRadius = 10.0f;
    doneBtn.clipsToBounds = YES;
    
    //    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    //
    //    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [containerView addSubview:doneBtn];
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}

- (IBAction)Action_Done:(UIButton *)sender
{
    mymsgForNOTI =textView.text;
    
    //[self stopTimer];
    
    //[NSThread detachNewThreadSelector:@selector(hud1) toTarget:self withObject:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    [textView resignFirstResponder];
    
    NSString *string = textView.text;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"Textview length   : %lu",(unsigned long)textView.text.length);
    textView.text = trimmedString;
    NSLog(@"Textview length 1 : %lu",(unsigned long)textView.text.length);
    
    
    
    if (trimmedString.length == 0)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        textView.text = @"";
    }
    else if ([textView.text length ]== 0)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        textView.text = @"";
    }
    ///////////////
    else //if([textView.text isEqualToString:@"kripa"])
    {
        msgType_flag = 1;
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
        NSString *timeStampObj = [NSString stringWithFormat:@"%.0f",timeStamp*10000];
        NSLog(@"Timestamp : %@",timeStampObj);
        
        FIRDatabaseReference *usersRef1 = [[[_FIR_Ref child: @"messages"] child:[NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],str_other_user_id]] child:timeStampObj];
        
        FIRDatabaseReference *usersRef2 = [[[_FIR_Ref child: @"messages"] child:[NSString stringWithFormat:@"%@___%@",str_other_user_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]] child:timeStampObj];
        
        
        NSDictionary *messageD = @{
                                 @"sender": [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                 @"timestamp": timeStampObj,
                                 @"message": textView.text
                                 };
        
        [usersRef1 setValue: messageD];
        [usersRef2 setValue: messageD];
        
        textView.text=@"";
        
       if ([self CheckNetwork] == NotReachable)
        {
            NSLog(@"Not Reachable");
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
           // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Info" message:@"Slow or no internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[alert show];
        }
        else
        {
            //[[NSUserDefaults standardUserDefaults]setObject:@"1212" forKey:@"deviceToken"];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
            {
                [self sendmessage];
            }
            else
            {
             [self sendmessage];
            }
           
        }
        
    }
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}



//Code from Brett Schumann

-(void) keyboardWillShow:(NSNotification *)note{
    
    // get keyboard size and loctaion
    
    
    CGRect keyboardBounds;
    
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    
    // Need to translate the bounds to account for rotation.
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    
    // get a rect for the textView frame
    
    CGRect containerFrame = containerView.frame;
    
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height-self.tabBarController.tabBar.frame.size.height);
    
    // animations settings
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationDuration:[duration doubleValue]];
    
    [UIView setAnimationCurve:[curve intValue]];
    

    // set views with new info
    
    containerView.frame = containerFrame;
    

    // commit animations
    
    [UIView commitAnimations];
    
}



-(void) keyboardWillHide:(NSNotification *)note{
    

    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    
    CGRect containerFrame = containerView.frame;
    
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationDuration:[duration doubleValue]];
    
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    
    containerView.frame = containerFrame;
    
    
    // commit animations
    
    [UIView commitAnimations];
    
}



- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    
    r.size.height -= diff;
    
    r.origin.y += diff;
    
    containerView.frame = r;
    
}
-(BOOL)growingTextView:(HPGrowingTextView *)textView2 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSInteger oldLength = [textView2.text length];
    NSInteger newLength = oldLength + [text length] - range.length;
    
    if(newLength >= 450){
        return NO;
    }
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    
    
    if([text isEqualToString:@"\n"]) {
        
        [textView2 resignFirstResponder];
        //  [scview setContentOffset:CGPointMake(0, var+50-(540)) animated:YES];
        return NO;
    }
    /*else if([[textView2 text] length] >=500)
    {
        NSLog(@"here comes");
        [self stopTimer];
        //kripakripa
        return NO;
    }*/
    return YES;
}
-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    NSLog(@"Editing Begin");
    return YES;
}

- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"]) {
        
        [textView1 resignFirstResponder];
      //  [scview setContentOffset:CGPointMake(0, var+50-(540)) animated:YES];
        return NO;
    }
    
    else if([[textView1 text] length] >=50)
    {
        NSLog(@"here comes");
        
        return NO;
    }
    return YES;
}


//------------ Webservice chat---------/////////////
-(void)sendmessage
{
    //[NSThread detachNewThreadSelector:@selector(hud1) toTarget:self withObject:nil];
    
    //[self stopTimer];
    
    /*url = http://clubrmate.com/webservice/chat_insert.php
     Method = post
     Parameters = user_id, other_user_id, message, flag(1 means text, 2 means image (image parameter  = file))
     */
    /////////-----------Url Pass-------------------///////////////////
    
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
    
    pref=[NSUserDefaults standardUserDefaults];
    
    NSString *device_token;
    
    device_token=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    // 81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f
    
    //device_token=@"81c22190c271462a1a54a0df70c9b98c29bbe96de3bb272bfe2ab02ce30db51f";
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[device_token dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[mymsgForNOTI dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    NSLog(@"TEXT MSG %@",mymsgForNOTI);
    NSLog(@"token %@",device_token);
    
    //    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"RESPONSE :: %@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
    
    
    if ([[dict objectForKey:@"success"] isEqualToString:@"true"])
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
         //[self startTimer];
        
       // msgType_flag = 1;
        
        //textView.text=@"";
       
              // [scview setContentOffset:CGPointMake(0, var+50-(550)) animated:YES];
        //myflag=2;
  
    }
    else if (dict==nil)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Server not responding. Please try after some time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //[alert show];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //[alert show];
        //NSString *str =[dict objectForKey:@"msg"];
        
        //        Alert *alert = [[Alert alloc] initWithTitle:str duration:1.0 completion:^{
        //            //Custom code here after Alert disappears
        //        }];
        //        [alert setDelegate:self]; //Optional - if you want delegate methods
        //        [alert setIncomingTransition:AlertIncomingTransitionTypeInYoFace];
        //        [alert setOutgoingTransition:AlertOutgoingTransitionTypeOutYoFace];
        //        [alert setAlertType:AlertTypeError]; //Red
        //        [alert setBounces:YES];
        //        [alert showAlert];
        //        
       
        // [self startTimer];
        
    }
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}





-(void)attach_touch
{
    
    //[self stopTimer];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"CANCEL" destructiveButtonTitle:@"Import image from...." otherButtonTitles:@"Camera",@"Photo Gallery", nil];
    //actionSheet.actionSheetStyle = UIBarStyleBlack;
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                //[self startTimer];
                break;
            }
            case 1:
            {
                NSLog(@"Camera");
                
                ipc= [[UIImagePickerController alloc]init];
                ipc.delegate = self;
                //ipc.navigationBar.barStyle = UIBarStyle;
                ipc.navigationController.navigationBar.translucent = NO;
                
                ipc.navigationBar.barTintColor = [UIColor colorWithRed:17.0/255 green:62.0/255 blue:100.0/255 alpha:1.0]; // Background color
                ipc.navigationBar.tintColor = [UIColor whiteColor]; // Cancel button ~ any UITabBarButton items
                
                [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:17.0/255 green:62.0/255 blue:100.0/255 alpha:1.0]];
                [[UINavigationBar appearance] setTranslucent:NO];
                
                //self.navigationController.
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ])
                {
                    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                else
                {
                    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                }
                
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    [self presentViewController:ipc animated:YES completion:nil];
                else
                {
                    popover = [[UIPopoverController alloc]initWithContentViewController:ipc];
                    [popover presentPopoverFromRect:imageView.frame inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }

                break;
            }
            case 2:
            {
                NSLog(@"Gallery");
                ipc= [[UIImagePickerController alloc]init];
                ipc.delegate = self;
                //ipc.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                
                ipc.navigationController.navigationBar.translucent = NO;
                
                ipc.navigationBar.barTintColor = [UIColor colorWithRed:17.0/255 green:62.0/255 blue:100.0/255 alpha:1.0]; // Background color
                ipc.navigationBar.tintColor = [UIColor whiteColor]; // Cancel button ~ any UITabBarButton items
                
                ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                
                
                [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:17.0/255 green:62.0/255 blue:100.0/255 alpha:1.0]];
                [[UINavigationBar appearance] setTranslucent:NO];
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    [self presentViewController:ipc animated:YES completion:nil];
                else
                {
                    popover = [[UIPopoverController alloc]initWithContentViewController:ipc];
                    [popover presentPopoverFromRect:imageView.frame inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                break;
            }
            default:
            {
                //[self startTimer];
                break;
            }
        }
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [popover dismissPopoverAnimated:YES];
    }
    self.navigationController.navigationBarHidden=YES;
    
    NSLog(@"INFO %@",info);
    img_attach = [[UIImageView alloc]init];
    
    
    
    UIImage * imageTemp = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"image orientation value : %d",(int)[[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation]);
    
    
    if ([[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation]==UIImageOrientationLeft || [[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation] == UIImageOrientationLeftMirrored)
    {
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, imageTemp.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        
        
        CGContextRef ctx = CGBitmapContextCreate(NULL, imageTemp.size.width, imageTemp.size.height,
                                                 CGImageGetBitsPerComponent(imageTemp.CGImage), 0,
                                                 CGImageGetColorSpace(imageTemp.CGImage),
                                                 CGImageGetBitmapInfo(imageTemp.CGImage));
        CGContextConcatCTM(ctx, transform);
        CGContextDrawImage(ctx, CGRectMake(0,0,imageTemp.size.height,imageTemp.size.width), imageTemp.CGImage);
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        UIImage *img = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
        
        img_attach.image =img;
    }
    else
    {
        img_attach.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSLog(@"image orientation value : %ld",(long)img_attach.image.imageOrientation);
    

   
    
    
    
    
    msgType_flag = 2;
    if ([self CheckNetwork] == NotReachable)
    {
        NSLog(@"Not Reachable");
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Info" message:@"Slow or no internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
//        {
//           // [self performSelector:@selector(sendmessage) withObject:nil afterDelay:0.01];
//        }
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[self startTimer];
    
    [ipc dismissViewControllerAnimated:NO completion:nil];
    self.navigationController.navigationBarHidden=YES;
}
-(void)hud1
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[self stopTimer];
    //self.navigationController.navigationBarHidden=NO;
    
    
    [super viewWillDisappear:YES];
}




- (IBAction)SideDots_Touch1:(id)sender
{
    if (![_btn_blockUser1 isSelected])
    {
        _btn_blockUser1.selected = true;
        
//        _viewSideBlock.frame = CGRectMake(_viewSideBlock.frame.origin.x, _viewSideBlock.frame.origin.y, _viewSideBlock.frame.size.width, 5);
//        [UIView beginAnimations: @"animateMenu" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: 0.5];
        _viewSideBlock.hidden = false;
//        _viewSideBlock.frame = CGRectMake(_viewSideBlock.frame.origin.x, _viewSideBlock.frame.origin.y, tempSize.width, tempSize.height);
//        [UIView commitAnimations];
        [self.view bringSubviewToFront:_viewSideBlock];
    }
    else
    {
        _btn_blockUser1.selected = false;
        
//        [UIView beginAnimations: @"animateMenu" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: 0.5];
//        _viewSideBlock.frame = CGRectMake(_viewSideBlock.frame.origin.x, _viewSideBlock.frame.origin.y, _viewSideBlock.frame.size.width, 5);
        _viewSideBlock.hidden = true;
//        [UIView commitAnimations];
        [self.view bringSubviewToFront:_viewSideBlock];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///-----------------

-(BOOL)CheckNetwork
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus NetworkStatus = [reachability currentReachabilityStatus];
    return NetworkStatus;
}


-(void)ConnectionNotEstablish
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
};


- (IBAction)Back_Button:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
