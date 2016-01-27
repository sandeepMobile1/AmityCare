//
//  ImageSenderCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import <UIKit/UIKit.h>
#import "MessageD.h"

@class  ImageSenderCell;

@protocol ImageSenderCellDelegate <NSObject>

@optional

-(void) ChatSenderImageButtonClick:(ImageSenderCell*)cellValue;

@end


@interface ImageSenderCell : UITableViewCell

{
    IBOutlet UIView* mainView;
    IBOutlet UIImageView* imgChatBox;
    IBOutlet UILabel* lblUsername;
    IBOutlet UILabel* lblTime;
    IBOutlet UIImageView* imgView;

}
@property(nonatomic,strong)MessageD* message;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,retain)IBOutlet UIButton *btnImage;
@property (nonatomic, unsafe_unretained) id<ImageSenderCellDelegate> cellDelegate;
@property(nonatomic,retain)IBOutlet UIImageView* imgView;

+(CGFloat)recieverCellHeight:(MessageD*)message;

-(IBAction)btnChatMessagePressed:(id)sender;

@end
