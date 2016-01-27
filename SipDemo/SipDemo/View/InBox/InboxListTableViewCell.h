//
//  InboxListTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <UIKit/UIKit.h>

@class  InboxListTableViewCell;

@protocol InboxListTableViewCellDelegate <NSObject>

@optional

-(void) buttonClick:(InboxListTableViewCell*)cellValue;


@end

@interface InboxListTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblSubject;
@property(nonatomic,strong)IBOutlet UITextView *lblMessage;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;

@property(nonatomic,strong)IBOutlet UIButton *btn;

@property (nonatomic, unsafe_unretained) id<InboxListTableViewCellDelegate> cellDelegate;


+(InboxListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnPressed:(id)sender;

@end
