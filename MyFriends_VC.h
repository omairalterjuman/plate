//
//  MyFriends_VC.h
//  PLATE APP
//

#import <UIKit/UIKit.h>

#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>


@interface MyFriends_VC : UIViewController
{
    NSMutableArray *arrTblData,*arrAllData;
    NSMutableArray *tempARR;
     BOOL createFlag;
}

@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;
@property (strong, nonatomic) IBOutlet UITableView *tblFriend;

@end
