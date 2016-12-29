//
//  Home_VC.h
/

#import <UIKit/UIKit.h>


#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>


@interface Home_VC : UIViewController<UISearchBarDelegate>
{
     
    
    NSMutableArray *arrTblData,*arrAllData,*arr_SearchData;;
    NSMutableArray *tempARR;
    BOOL createFlag,flagGetDetail,flaglastMsg;
    
    
   

    NSMutableDictionary *dictLastMSG;
    
    
}

@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;


@property (weak,nonatomic)IBOutlet UIView *searchView;
@property(weak,nonatomic)IBOutlet UISearchBar *searchbar;

@property(weak,nonatomic)IBOutlet UITableView *tblUser;
@end
