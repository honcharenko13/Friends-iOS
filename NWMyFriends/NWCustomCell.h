#import <UIKit/UIKit.h>

@class NWCustomCell;

@protocol NWCustomCellDelegate
- (void)friendCellWasTapped:(NWCustomCell *)cell;
@end

@interface NWCustomCell : UITableViewCell

@property (weak, nonatomic) id <NWCustomCellDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *labelFullNameDeleted;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDeleted;


@end
