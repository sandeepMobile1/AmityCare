//
//  ImageReciverCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import <UIKit/UIKit.h>
#import "MessageD.h"

@class  ImageReciverCell;

@protocol ImageReciverCellDelegate <NSObject>

@optional

-(void) ChatRecieverImageButtonClick:(ImageReciverCell*)cellValue;

@end

@interface ImageReciverCell : UITableViewCell
{
    IBOutlet UIView* mainView;
    IBOutlet UIImageView* imgChatBox;
    IBOutlet UILabel* lblUsername;
    IBOutlet UILabel* lblTime;

}
@property(nonatomic,strong)MessageD* message;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,retain)IBOutlet UIButton *btnImage;
@property(nonatomic,retain)IBOutlet UIImageView* imgView;

@property (nonatomic, unsafe_unretained) id<ImageReciverCellDelegate> cellDelegate;

+(CGFloat)recieverCellHeight:(MessageD*)message;

-(IBAction)btnChatMessagePressed:(id)sender;

@end
