//
//  ChatListTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 06/01/15.
//
//

#import <UIKit/UIKit.h>

@class  ChatListTableViewCell;

@protocol ChatListTableViewCellDelegate <NSObject>

@end

@interface ChatListTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel *   lblUserName;
@property(nonatomic,strong)IBOutlet UILabel *   lblDateTime;
@property(nonatomic,strong)IBOutlet UILabel *   lblMessage;
@property(nonatomic,assign) id<ChatListTableViewCellDelegate>delegate;

+(ChatListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


@end
