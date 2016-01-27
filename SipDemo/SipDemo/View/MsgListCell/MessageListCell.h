//
//  MessageListCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageD.h"

@interface MessageListCell : UITableViewCell
{
    IBOutlet UIImageView* imgView;
    IBOutlet UILabel* lblUserName;
    IBOutlet UILabel* lblDateTime;
    IBOutlet UILabel* lblMessage;
}
@property(nonatomic,strong) MessageD *message;
@end
