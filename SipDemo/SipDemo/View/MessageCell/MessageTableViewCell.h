//
//  MessageTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <UIKit/UIKit.h>

@class  MessageTableViewCell;

@protocol MessageTableViewCellDelegate <NSObject>

@end

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *   lblMessage;
@property(nonatomic,strong)IBOutlet UIButton *  btnDelete;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

@property(nonatomic,assign) id<MessageTableViewCellDelegate>delegate;

+(MessageTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;



@end
