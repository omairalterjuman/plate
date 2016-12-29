//
//  ForgotPassword_VC.h
//  PLATE APP


#import <UIKit/UIKit.h>
#import "PostFunctionHelper.h"

#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface ForgotPassword_VC : UIViewController <PostFunctionDelegate>
{
    PostFunctionHelper *post;
    NSMutableArray *Ary_Parameter;
    NSMutableArray *Ary_Value;
    NSMutableArray *Ary_Img_Parameter;
    NSString *str_email,*str_password;
}

@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;
@end
