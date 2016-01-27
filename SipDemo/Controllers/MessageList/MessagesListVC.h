//
//  MessagesListVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatListTableViewCell.h"

@class ChatDetailVC;

@interface MessagesListVC : UIViewController<UITableViewDataSource,ChatListTableViewCellDelegate>
{
    ChatListTableViewCell *chatCell;

    IBOutlet UITableView* tblMessageList;
    
    NSString *checkPN;
}
@property(nonatomic,strong)NSMutableArray *arrMessageData;
@property(nonatomic,strong)ChatDetailVC * chatView;


@end
