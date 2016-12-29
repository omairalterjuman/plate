//
//  ChatViewController.h


#import <UIKit/UIKit.h>

#import "HPGrowingTextView.h"

#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>


#import "PostFunctionHelper.h"



@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate,UIActionSheetDelegate,PostFunctionDelegate>
{
    UITableView * Mychattable;
    
    NSMutableDictionary * Mydictionary;
    NSMutableArray * Myarray, *arrayForImg, *ArrForHeight, *ArrForWidth;
    
    UIView *containerView;
    HPGrowingTextView *textView;
    
    UIImageView * entryImageView,*imageView;
    UIButton * doneBtn;;//, *btn_attach;
    
    NSUserDefaults * pref;
    
    NSTimer * timer;
    //NSTimer * timerForInternet;
    
    
    
    int myflag, staticHeight;
    NSString *strGroupID, *strGroupType, *last_User;
    NSUInteger tChatCount;
    
    NSString *rec;
    UIImagePickerController *ipc;
    UIPopoverController *popover;
    UIImageView *img_attach;
    
    int msgType_flag, serviceFlag, blockbtnFlag;
    CGSize tempSize;
    
    PostFunctionHelper *post;
    NSMutableArray *Ary_Parameter;
    NSMutableArray *Ary_Value;
    NSMutableArray *Ary_Img_Parameter;
    NSString *str_email,*str_password;
    
    
    NSString *mymsgForNOTI;
    
}
@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;


@property(nonatomic,retain)UITableView * Mychattable;

@property(strong,atomic)NSString * str_other_user_id, *str_other_userName;

@property(nonatomic,retain) NSString * str_other_user_ImageURL;

@property (weak, nonatomic) IBOutlet UILabel *lbl_NoMessage1, *lbl_OtherName;

@property (weak, nonatomic) IBOutlet UIView *viewSideBlock;

@property (weak, nonatomic) IBOutlet UIImageView *imgOther;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewNoMessage;

@property (weak, nonatomic) IBOutlet UIButton *btn_blockUser1;

@property (weak, nonatomic) IBOutlet UIButton *btn_OtherPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btn_Sniff1;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Typing;

//- (IBAction)block_User:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblOnlineFlag;

@end
