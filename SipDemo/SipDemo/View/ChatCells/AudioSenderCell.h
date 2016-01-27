//
//  AudioSenderCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import <UIKit/UIKit.h>
#import "MessageD.h"

@class  AudioSenderCell;

@protocol AudioSenderCellDelegate <NSObject>

@optional

-(void) ChatSenderAudioButtonClick:(AudioSenderCell*)cellValue;
-(void) ChatSenderAudioSliderMovedClick:(AudioSenderCell*)cellValue;


@end

@interface AudioSenderCell : UITableViewCell
{
IBOutlet UIView* mainView;
IBOutlet UIImageView* imgChatBox;
IBOutlet UILabel* lblUsername;
IBOutlet UILabel* lblTime;

}
@property(nonatomic,strong)MessageD* message;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,retain)IBOutlet UIButton *btnPlay;
@property(nonatomic,retain)IBOutlet UISlider *audioSlider;
@property (nonatomic, unsafe_unretained) id<AudioSenderCellDelegate> cellDelegate;

+(CGFloat)senderCellHeight:(MessageD*)message;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)sliderMoved:(id)sender;

@end
