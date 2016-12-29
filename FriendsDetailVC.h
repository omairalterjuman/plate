//
//  FriendsDetailVC.h
//  PLATE APP
//
//  Created by mac on 12/28/16.
//  Copyright © 2016 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface FriendsDetailVC : UIViewController
{
    NSString *createFlag;
    NSString *otherUserID,*otherUserDeviceToken;
    UITapGestureRecognizer *tapImage;
    
}
@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_plateNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_Status;
@property (weak, nonatomic) IBOutlet UIButton *btn_AcceptRequest,*btn_RejectRequest;

@property(strong,nonatomic)NSMutableArray *arrData;


@end
