//
//  FormButtonTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 03/03/15.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"

@class  FormButtonTableViewCell;

@protocol FormButtonTableViewCellDelegate <NSObject>

-(void) buttonDeleteClick:(FormButtonTableViewCell*)cellValue;

@end

@interface FormButtonTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel *   lblName;
@property(nonatomic,strong)IBOutlet UILabel *   lblIntro;
@property(nonatomic,strong)IBOutlet UILabel *   lbldate;
@property(nonatomic,strong)IBOutlet UILabel *   lblTagName;
@property(nonatomic,strong)IBOutlet UIButton *   btnDelete;

@property(nonatomic,strong)Feeds *feed;
@property(nonatomic,assign) id<FormButtonTableViewCellDelegate>delegate;

+(FormButtonTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnDeletePressed:(id)sender;

@end
