//
//  HomeCell.h
//  PLATE APP


#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell


@property(weak,nonatomic) IBOutlet UIImageView *imgView;
@property(weak,nonatomic) IBOutlet UILabel *lbl_name;
@property(weak,nonatomic) IBOutlet UILabel *lbl_status,*lbl_time;


@end
