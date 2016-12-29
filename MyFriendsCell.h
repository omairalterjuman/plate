//
//  MyFriendsCell.h
//  PLATE APP
//


#import <UIKit/UIKit.h>

@interface MyFriendsCell : UITableViewCell
@property (weak,nonatomic)IBOutlet UIImageView *imgUser;
@property (weak,nonatomic)IBOutlet UILabel *lbl_name;
@property (weak,nonatomic)IBOutlet UIButton *btn_accept,*btn_reject;

@end
