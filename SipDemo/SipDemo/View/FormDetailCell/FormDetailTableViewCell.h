//
//  FormDetailTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"

@protocol FormDetailTableViewCellDelegate <NSObject>

-(void)ButtonDidClick:(UIButton*)sender;


@end

@interface FormDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel  * lblUname;
@property(nonatomic,strong)IBOutlet UILabel  * lblTagName;
@property(nonatomic,strong)IBOutlet UILabel  * lblCompletionTime;
@property(nonatomic,strong)IBOutlet UILabel  * lblFormName;
@property(nonatomic,strong)IBOutlet UILabel  * lblBadges;

@property(nonatomic,strong)IBOutlet UIImageView*profileImage;

@property(nonatomic,strong)Feeds *form;
@property(nonatomic,assign) id<FormDetailTableViewCellDelegate>delegate;

-(IBAction)buttonAction:(id)sender;


@end
