//
//  NotificationCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 27/11/14.
//
//

#import <UIKit/UIKit.h>
#import "NotificationD.h"

@interface NotificationCell : UITableViewCell

@property(nonatomic,strong) NotificationD *notificationData;
-(void)setNotificationData:(NotificationD *)notificationData;

@end
