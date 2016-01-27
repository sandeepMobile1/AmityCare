//
//  SenderCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageD.h"

@interface SenderCell : UITableViewCell
{
    IBOutlet UIView *mainView;
    IBOutlet UIImageView *imgChatBox;
    IBOutlet UILabel* lblUsername;
    IBOutlet UILabel* lblTime;
    IBOutlet UILabel* lblMessage;
}
@property(nonatomic,strong)MessageD* message;
@property(nonatomic,assign)CGFloat width;
+(CGFloat)senderCellHeight:(MessageD*)message;

@end
