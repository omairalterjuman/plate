//
//  AllUsers_VC.h
//  PLATE APP


#import <UIKit/UIKit.h>


#import <Firebase/Firebase.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>


@interface AllUsers_VC : UIViewController<UISearchBarDelegate>
{
    NSMutableArray *arrTblData,*arr_SearchData;
    NSMutableArray *arrDataFromSnapshot;
    NSMutableDictionary *dictMyFriends, *dictYesFriends;
    
    BOOL createFlag;
    NSMutableArray *arr_allData;
    BOOL DataMatch;
    BOOL request,frnd;
}

@property (strong, nonatomic) FIRDatabaseReference *FIR_Ref;
@property (weak,nonatomic)IBOutlet UIView *searchView;
@property(weak,nonatomic)IBOutlet UISearchBar *searchBar;
@property(weak,nonatomic)IBOutlet UITableView *tblUser;
@end
