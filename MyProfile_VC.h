//
//  MyProfile_VC.h
//  PLATE APP


#import <UIKit/UIKit.h>


#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>


@interface MyProfile_VC : UIViewController
{
    NSString *setImage;
    UITapGestureRecognizer *tapImage;
    BOOL createFlag;
    NSMutableArray *arr_allData;
    BOOL DataMatch,profileUpdate;
    NSDictionary *dic;
}

@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;



@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_plateNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_Status;
@property (weak, nonatomic) IBOutlet UIButton *btn_update;

@property(strong,nonatomic)NSMutableArray *arrData;

@end
