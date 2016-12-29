//
//  BTSimpleSideMenu.m
//  BTSimpleSideMenuDemo
//  Created by Balram on 29/05/14.
//  Copyright (c) 2014 Balram Tiwari. All rights reserved.
//

#define BACKGROUND_COLOR [UIColor colorWithWhite:3 alpha:0.2]
#define GENERIC_IMAGE_FRAME CGRectMake(0, 0, 40, 40)
#define MENU_WIDTH 220
//#define MENU_WIDTH 225

#import "BTSimpleSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "AppDelegate.h"
//#import "CustomerProfileVC.h"

#import "EXPhotoViewer.h"

//#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation BTSimpleSideMenu
{
    NSUserDefaults *PREF;
}
#pragma -mark public methods

-(instancetype) initWithItem:(NSArray *)items addToViewController:(id)sender {
    if ((self = [super init])) {
        // perform the other initialization of items.
        [self commonInit:sender];
        itemsArray = items;
    }
    return self;
}

-(instancetype)initWithItemTitles:(NSArray *)itemsTitle addToViewController:(UIViewController *)sender {
    
    if ((self = [super init]))
    {
        // perform the other initialization of items.
        [self commonInit:sender];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for(int i = 0;i<[itemsTitle count]; i++){
            BTSimpleMenuItem *temp = [[BTSimpleMenuItem alloc]initWithTitle:[itemsTitle objectAtIndex:i]
                                                                      image:nil onCompletion:nil];
            [tempArray addObject:temp];
        }
        itemsArray = tempArray;
    }
    return self;
}

-(instancetype)initWithItemTitles:(NSArray *)itemsTitle andItemImages:(NSArray *)itemsImage addToViewController:(UIViewController *)sender{
    if ((self = [super init])) {
        // perform the other initialization of items.
        
        [self commonInit:sender];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for(int i = 0;i<[itemsTitle count]; i++){
            BTSimpleMenuItem *temp = [[BTSimpleMenuItem alloc]initWithTitle:[itemsTitle objectAtIndex:i]
                                                                      image:[itemsImage objectAtIndex:i]
                                                               onCompletion:nil];
            [tempArray addObject:temp];
        }
        itemsArray = tempArray;
    }
    return self;
}

-(void)toggleMenu
{
    if(!_isOpen)
    {
        [self show];
    }else {
        [self hide];
        
    }
}

//-(void)toggleMenuHide
//{
//    if(isOpen)
//     {
//        [self hide];
//        
//    }
//}

-(void)show{
    if(!_isOpen)
    {
        [UIView animateWithDuration:0.5 animations:^{
            PREF=[NSUserDefaults standardUserDefaults];
           
            self.frame = CGRectMake(0, yAxis-20, width, height+40);
            self.autoresizingMask=(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
            //menuTable.frame = CGRectMake(menuTable.frame.origin.x, 200, width, height-220);
            menuTable.frame = CGRectMake(menuTable.frame.origin.x, 20, width, height-20);
            [menuTable setContentInset:UIEdgeInsetsMake(-40, 0, 0,0)];
            menuTable.alpha = 1;
            menuTable.backgroundColor=[UIColor clearColor];//[UIColor colorWithRed:17.0/255.0 green:62.0/255.0 blue:125.0/255.0 alpha:1.0];
            
            // menuTable.backgroundColor=[UIColor colorWithRed:87.0/255.0 green:33.0/255.0 blue:40.0/255.0 alpha:1.0];
            
            menuTable.separatorColor = [UIColor lightGrayColor];
            [menuTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            
            backGroundImage.frame = CGRectMake(0, 0, width, height+40);
            backGroundImage.alpha = 1;
            
            backGroundImage.backgroundColor=[UIColor whiteColor];
            [backGroundImage setImage:[UIImage imageNamed:@"Slide-Bar-bg.png"]];
            //[UIColor colorWithRed:17.0/255.0 green:62.0/255.0 blue:125.0/255.0 alpha:1.0];
            
           /* UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10,160, width+40, 30)];
            
            if ([[PREF valueForKey:@"pref_UserName"] componentsSeparatedByString:@" "].count>1)
            {
                lbl.text = [[[PREF valueForKey:@"pref_UserName"] componentsSeparatedByString:@" "] objectAtIndex:0] ;
            }
            else
            {
                lbl.text=[NSString stringWithFormat:@"%@",[PREF valueForKey:@"pref_UserName"]];
            }
            
            //lbl.backgroundColor = [UIColor lightGrayColor];
            //lbl.font=[UIFont fontWithName:@"Avenir Next Regular" size:10];
            //lbl.font=[UIFont systemFontOfSize:22.5 ];
            [lbl setFont:[UIFont systemFontOfSize:22.5 weight:1.0]];
            
            lbl.textAlignment = NSTextAlignmentCenter;
            
            lbl.textColor=[UIColor whiteColor];
            
            
            UILabel *lblLINE = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200,1)];
            lblLINE.textColor = [UIColor whiteColor];
            lblLINE.font = [UIFont fontWithName:@"Avenir Next Regular" size:20];
            lblLINE.adjustsFontSizeToFitWidth = YES;
            lblLINE.textAlignment=NSTextAlignmentLeft;
            lblLINE.backgroundColor =[UIColor whiteColor];
           // lblLINE.text = @"................................";
            
            
            
            UIImageView *IV_Top=[[UIImageView alloc]initWithFrame:CGRectMake(70,50, 100, 100)];
            //IV_Top.image=[UIImage imageNamed:@"User_Placeholder.png"];
            IV_Top.contentMode = UIViewContentModeScaleAspectFit;
            IV_Top.layer.cornerRadius = IV_Top.frame.size.width / 2;
            IV_Top.clipsToBounds = YES;
            //IV_Top.layer.borderWidth = 2.0f;
            IV_Top.layer.borderColor = [UIColor clearColor].CGColor;
            
            IV_Top.userInteractionEnabled=YES;
            
            //CALayer *layer13 = IV_Top.layer;
            //layer13.shadowOpacity = 1;
            //layer13.shadowColor = [[UIColor whiteColor] CGColor];
            //layer13.shadowOffset = CGSizeMake(0,0);
            //layer13.shadowRadius = 2;
            
            //lbl_Counter.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_winksAvailable",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_profileImageType"]isEqualToString:@"url"])
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]])
                {
                    UIImageView *IV_Back=[[UIImageView alloc]initWithFrame:CGRectMake(60,40, 120, 120)];
                    
                    IV_Back.image=[UIImage imageNamed:@"test_LOGO TBD.png"];
                    IV_Back.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [self.viewForBaselineLayout addSubview:IV_Back];
                    
                    [IV_Top setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]]]] placeholderImage:[UIImage imageNamed:@"User_Placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                }
                else
                {
                    IV_Top.image=[UIImage imageNamed:@"User_Placeholder12.png"];
                }
                
            }
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_profileImageType"]isEqualToString:@"imagedata"])
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults]objectForKey:@"pref_user_id"]]])
                {
                    UIImageView *IV_Back=[[UIImageView alloc]initWithFrame:CGRectMake(60,40, 120, 120)];
                    
                    //IV_Back.image=[UIImage imageNamed:@"User_Placeholder.png"];
                    IV_Back.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [self.viewForBaselineLayout addSubview:IV_Back];
                    
                    [IV_Top setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pref_%@_profileImage",[[NSUserDefaults standardUserDefaults] objectForKey:@"pref_user_id"]]]]];
                }
                else
                {
                    //IV_Top.image=[UIImage imageNamed:@"User_Placeholder.png"];
                }
            }
            else
            {
                IV_Top.image=[UIImage imageNamed:@"User_Placeholder.png"];
            }
            
            [IV_Top addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(highlightLetter:)]];
            
            IV_Top.backgroundColor = [UIColor whiteColor];
            
            
            [self.viewForBaselineLayout addSubview:IV_Top];
            [self.viewForBaselineLayout addSubview:lbl];
            
            */
            //[self.viewForBaselineLayout addSubview:lblLINE];
            
            //[self.viewForBaselineLayout setBackgroundColor:[UIColor greenColor]];
//            if ([[PREF valueForKey:@"LOGOUT_USER"]isEqualToString:@"LOGIN"])
//            {
//                UIView *PROFILE_BACK=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 200)];
//                PROFILE_BACK.backgroundColor=[UIColor lightGrayColor];
//                [self.viewForBaselineLayout addSubview:PROFILE_BACK];
//                UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(55, 5, 110, 110)];
//                view.userInteractionEnabled=YES;
//                [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(highlightLetter:)]];
//                
//                view.layer.cornerRadius=55;
//                view.layer.borderWidth=1;
//                view.clipsToBounds=YES;
//                view.layer.borderColor=[[UIColor whiteColor] CGColor];
//                view.backgroundColor=[UIColor whiteColor];
//            
//                
//                NSString *str_img_cat_image=[NSString stringWithFormat:@"%@",[PREF valueForKey:@"PROFILE_IMAGE"]];
//                NSLog(@"str_img_cat_image left----%@",str_img_cat_image);
//                NSURL * urldemo_cat_image=[NSURL URLWithString:str_img_cat_image];
//               
////                [view setImageWithURL:urldemo_cat_image placeholderImage:[UIImage imageNamed:@"NoImag.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                   // view.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[PREF valueForKey:@"PROFILE_IMAGE"]]]];
//                 
//                [PROFILE_BACK addSubview:view];
//                UILabel *LBL_NMAE=[[UILabel alloc]initWithFrame:CGRectMake(5, 117, 210, 40)];
//                LBL_NMAE.text=[NSString stringWithFormat:@"%@",[PREF valueForKey:@"NAME"]];
//                LBL_NMAE.textAlignment=NSTextAlignmentCenter;
//                UILabel *LBL_EMAIL=[[UILabel alloc]initWithFrame:CGRectMake(5, 160, 210, 40)];
//                LBL_EMAIL.text=[NSString stringWithFormat:@"%@",[PREF valueForKey:@"EMAIL"]];
//                LBL_EMAIL.textColor=[UIColor redColor];
//                
//                LBL_EMAIL.adjustsFontSizeToFitWidth = YES;
//                LBL_EMAIL.textAlignment=NSTextAlignmentCenter;
//                [PROFILE_BACK addSubview:LBL_EMAIL];
//                [PROFILE_BACK addSubview:LBL_NMAE];
//            }
//            else
//            {
//                UIView *PROFILE_BACK=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 200)];
//                PROFILE_BACK.backgroundColor=[UIColor lightGrayColor];
//                [self.viewForBaselineLayout addSubview:PROFILE_BACK];
//                
//                UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(55,45, 110, 110)];
//                view.userInteractionEnabled=NO;
//                view.layer.cornerRadius=55;
//                view.layer.borderWidth=1;
//                view.clipsToBounds=YES;
//                view.layer.borderColor=[[UIColor whiteColor] CGColor];
//                view.backgroundColor=[UIColor whiteColor];
//                
//                view.image=[UIImage imageNamed:@"drawer_placeholder@2x.png"];
//                [PROFILE_BACK addSubview:view];

                
      //      }
            
        } completion:^(BOOL finished) {
            
        }];
        _isOpen = YES;
        
        //IV_Smiley.hidden = NO;
        //lbl_Counter.hidden = NO;
    }
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender
{
    [self hide];
    
    [self tableView:menuTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    //[EXPhotoViewer showImageFrom:(UIImageView*)sender.view];
}
/*


- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    
    
    [self toggleMenuHide];
    
    UIView *view = sender.view;
    NSLog(@"%ld", (long)view.tag);//By tag, you can find out where you had tapped.
    //TAG_IV=(long)view.tag;
    
    NSLog(@"goto profile edit");
    PREF=[NSUserDefaults standardUserDefaults];
    
    
    NSLog(@"USER TYPE --- %@",[PREF objectForKey:@"user_type"]);
    if ([[PREF objectForKey:@"user_type"] isEqualToString:@"customer"])
    {
        if ([[PREF objectForKey:@"Language"] isEqualToString:@"English"])
        {
        CustNewProVC *myPro1=[[CustNewProVC alloc]initWithNibName:@"CustNewProVC" bundle:nil];
        NSLog(@"I am Item 2  customer profile");
        
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.nc pushViewController:myPro1 animated:YES];
        }
        else
        {
            CustNewProVC *myPro1=[[CustNewProVC alloc]initWithNibName:@"CustNewProVC_A" bundle:nil];
            NSLog(@"I am Item 2  customer profile");
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.nc pushViewController:myPro1 animated:YES];

        }
                //[self.navigationController pushViewController:centerViewController animated:YES];

       // [self.navigationController pushViewController:myPro1 animated:YES];
    }
    else
    {
        if ([[PREF objectForKey:@"Language"] isEqualToString:@"English"])
        {
        CustomerProfileVC *myPro=[[CustomerProfileVC alloc]initWithNibName:@"CustomerProfileVC" bundle:nil];
        NSLog(@"I am Item 2");
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.nc pushViewController:myPro animated:YES];
        
        }
        else
        {
            CustomerProfileVC *myPro=[[CustomerProfileVC alloc]initWithNibName:@"CustomerProfileVC_A" bundle:nil];
            NSLog(@"I am Item 2");
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.nc pushViewController:myPro animated:YES];
        }
        
        
        
    }
    
    
    
//    if ([[PREF valueForKey:@"ROLL"]isEqualToString:@"seller"])
//    {
//
//
//
//        SELLER_PROFILE_ViewController *centerViewController=[[SELLER_PROFILE_ViewController alloc]initWithNibName:@"SELLER_PROFILE_ViewController" bundle:nil];
//        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.nav pushViewController:centerViewController animated:YES];
//        //[self.navigationController pushViewController:centerViewController animated:YES];
//    }
//    else if ([[PREF valueForKey:@"ROLL"]isEqualToString:@"customer"])
//    {
//        CUSTOMER_PROFILE_ViewController *centerViewController=[[CUSTOMER_PROFILE_ViewController alloc]initWithNibName:@"CUSTOMER_PROFILE_ViewController" bundle:nil];
//        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.nav pushViewController:centerViewController animated:YES];
//
//
//    }
    
}


*/


-(void)hide {
    if(_isOpen){
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(-width, yAxis-20, width, height);
            menuTable.frame = CGRectMake(-menuTable.frame.origin.x,0, width, height-20);
            [menuTable setContentInset:UIEdgeInsetsMake(-40, 0, 0,0)];
            menuTable.alpha = 0;
            backGroundImage.alpha = 0;
            backGroundImage.frame = CGRectMake(width, 0, width, height);
        }];
        _isOpen = NO;
        
        //IV_Smiley.hidden = YES;
        //lbl_Counter.hidden = YES;
    }
}

#pragma -mark tableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [itemsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIView *PROFILE_BACK=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 200)];
    //PROFILE_BACK.backgroundColor=[UIColor colorWithRed:17.0/255.0 green:62.0/255.0 blue:125.0/255.0 alpha:1.0];
    //[self.viewForBaselineLayout addSubview:PROFILE_BACK];
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate BTSimpleSideMenu:self didSelectItemAtIndex:indexPath.row];
    
    [self.delegate BTSimpleSideMenu:self selectedItemTitle:[[itemsArray objectAtIndex:indexPath.row] title]];
    //[self.delegate BTSimpleSideMenu:self selectedItemTitle:[titleArray objectAtIndex:indexPath.row]];
    _selectedItem = [itemsArray objectAtIndex:indexPath.row];
    [self hide];
    if (_selectedItem.block) {
        BOOL success= YES;
        _selectedItem.block(success, _selectedItem);
    }
    [menuTable deselectRowAtIndexPath:indexPath animated:YES];
}


#define MAIN_VIEW_TAG 1
#define TITLE_LABLE_TAG 2
#define IMAGE_VIEW_TAG 3

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UIView *circleView;
    UILabel *titleLabel;
    UIImageView *imageView;
    
    [menuTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    menuTable.separatorColor = [UIColor lightGrayColor];
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    BTSimpleMenuItem *item = [itemsArray objectAtIndex:indexPath.row];
    
    if(cell == nil)
    {
        
        //        UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,3)];
        //        additionalSeparator.backgroundColor = [UIColor grayColor];
        //        [cell addSubview:additionalSeparator];
        
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:17.0/255.0 green:62.0/255.0 blue:125.0/255.0 alpha:1.0];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        circleView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        circleView.tag = MAIN_VIEW_TAG;
        circleView.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:58.0/255.0 blue:205.0/255.0 alpha:1.0];
        circleView.layer.borderWidth = 1.0;
        
        
        circleView.layer.borderColor = [UIColor clearColor].CGColor;
        circleView.layer.cornerRadius = circleView.bounds.size.height/2;
        circleView.clipsToBounds = YES;
       // [cell.contentView addSubview:circleView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 165, 30)];
        titleLabel.tag = TITLE_LABLE_TAG;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13.0];//[UIFont systemFontOfSize:14.0 weight:0.3];
        
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.backgroundColor =[UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.center = circleView.center;
        
        imageView.backgroundColor=[UIColor clearColor];
       // [cell.contentView addSubview:imageView];
        
        //
//                UILabel *lblLINE = [[UILabel alloc] initWithFrame:CGRectMake(45, 45, 150,1.25)];
//                lblLINE.textColor = [UIColor whiteColor];
//                lblLINE.font = [UIFont fontWithName:@"Montserrat-Regular" size:20];
//                lblLINE.adjustsFontSizeToFitWidth = YES;
//                lblLINE.textAlignment=NSTextAlignmentLeft;
//                lblLINE.backgroundColor =[UIColor lightGrayColor];
//                //lblLINE.text = @"................................";
//                [cell.contentView addSubview:lblLINE];
    }
    else
    {
        
        circleView = (UIView *)[cell.contentView viewWithTag:MAIN_VIEW_TAG];
        titleLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_LABLE_TAG];
        imageView = (UIImageView *)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
        
    }
    
    titleLabel.text = [NSString stringWithFormat:@"%@",item.title];
    imageView.image = item.imageView.image;
    
    tableView.separatorColor=[UIColor lightGrayColor];
    // [tableView.sep]
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma -mark Private helpers
-(void)commonInit:(UIViewController *)sender{
    
    //viewSender = sender;
    
    CGRect screenSize = [UIScreen mainScreen].bounds;
    xAxis = 0;

    yAxis = 65;
    if (UIScreen.mainScreen.bounds.size.height == 736){
        //yAxis =20;// 60;
        height = screenSize.size.height-yAxis;

    }
    if (UIScreen.mainScreen.bounds.size.height == 667){
        yAxis =76;// 60;
        height = screenSize.size.height-yAxis;
    }
    if (UIScreen.mainScreen.bounds.size.height == 568){
        //yAxis = 20;//60;
        height = screenSize.size.height-yAxis;
    }
    if (UIScreen.mainScreen.bounds.size.height == 480)
    {
        //yAxis = 20;//50;
        height = screenSize.size.height-yAxis;
    }
    //yAxis = 65;
    
    width = MENU_WIDTH;
    
    self.frame = CGRectMake(-width, yAxis, width, height);
    self.backgroundColor = BACKGROUND_COLOR;
    
    if(!sender.navigationController.navigationBarHidden)
    {
        menuTable = [[UITableView alloc]initWithFrame:CGRectMake(xAxis, yAxis+15, width, height) style:UITableViewStyleGrouped];
    }
    else
    {
        menuTable = [[UITableView alloc]initWithFrame:CGRectMake(xAxis, yAxis-15, width, height) style:UITableViewStyleGrouped];
    }
    menuTable.dataSource=self;
    menuTable.delegate=self;
    //[menuTable setBounces:NO];
    menuTable.separatorColor=[UIColor clearColor];
    
    screenShotImage = [sender.view screenshot];
    blurredImage = [screenShotImage blurredImageWithRadius:10.0f iterations:5  tintColor:nil];
    backGroundImage = [[UIImageView alloc]initWithImage:blurredImage];
    backGroundImage.frame = CGRectMake(width,0, width, height);
    backGroundImage.alpha = 0;
    [self addSubview:backGroundImage];
    
    //[menuTable setBackgroundColor:[UIColor clearColor]];
    
    [menuTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [menuTable setShowsVerticalScrollIndicator:NO];
    
    menuTable.delegate = self;
    menuTable.dataSource = self;
    menuTable.alpha = 0;
    _isOpen = NO;
    
    
   /* lbl_Counter=[[UILabel alloc]initWithFrame:CGRectMake(128,10,60, 30)];
    lbl_Counter.text=[NSString stringWithFormat:@"25"];//[PREF valueForKey:@"pref_UserName"]
    lbl_Counter.font=[UIFont systemFontOfSize:17.0 weight:1.0 ];
    lbl_Counter.textAlignment = NSTextAlignmentRight;
    
    lbl_Counter.textColor=[UIColor whiteColor];
    IV_Smiley=[[UIImageView alloc]initWithFrame:CGRectMake(190,10, 30, 30)];
    IV_Smiley.image=[UIImage imageNamed:@"smileYellow.png"];
    IV_Smiley.userInteractionEnabled=NO;
    IV_Smiley.contentMode = UIViewContentModeScaleAspectFit;
    [self.viewForBaselineLayout addSubview:lbl_Counter];
    [self.viewForBaselineLayout addSubview:IV_Smiley];
    
    IV_TopBG=[[UIImageView alloc]initWithFrame:CGRectMake(62.5,42, 114, 114)];
    IV_TopBG.image=[UIImage imageNamed:@"roundWhite.png"];
    IV_TopBG.userInteractionEnabled=NO;
    IV_TopBG.contentMode = UIViewContentModeScaleAspectFit;
    IV_TopBG.layer.cornerRadius = IV_TopBG.frame.size.width / 2;
    IV_TopBG.clipsToBounds = NO;
    [self.viewForBaselineLayout addSubview:IV_TopBG];
    
    
    btn_wink=[[UIButton alloc]initWithFrame:CGRectMake(128,10,100, 30)];
    [btn_wink addTarget:self action:@selector(show_wink_view:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewForBaselineLayout addSubview:btn_wink];
    
*/
    [self addSubview:menuTable];
    
    //gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleMenu)];
    //gesture.numberOfTapsRequired = 1;
    
    leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [sender.view addSubview:self];
    //[sender.view addGestureRecognizer:gesture];
    [sender.view addGestureRecognizer:rightSwipe];
    [sender.view addGestureRecognizer:leftSwipe];
    
    
    //IV_Smiley.hidden = YES;
   //lbl_Counter.hidden = YES;
}
-(IBAction) show_wink_view:(id)sender
{    /*
    NSArray *subviewArray=[[NSBundle mainBundle]loadNibNamed:@"Home_Wink_VC" owner:viewSender options:nil];
    UIView * mainView1 = [subviewArray objectAtIndex:0];
    mainView1.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [viewSender.view addSubview:mainView1];
    */
    
    [self hide];
    
    [self tableView:menuTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
}

-(UIImage *)reducedImage:(UIImage *)srcImage{
    UIImage *image = srcImage;
    UIImage *tempImage = nil;
    CGSize targetSize = CGSizeMake(20,20);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tempImage;

}

@end

@implementation UIView (bt_screenshot)
-(UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(MENU_WIDTH, [UIScreen mainScreen].bounds.size.height), NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIImage (bt_blurrEffect)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    //    UIImage *image = [[UIImage alloc]init];
    return image;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end


