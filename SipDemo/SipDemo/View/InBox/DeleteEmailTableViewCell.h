//
//  DeleteEmailTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/03/15.
//
//

#import <UIKit/UIKit.h>

@class  DeleteEmailTableViewCell;

@protocol DeleteEmailTableViewCellDelegate <NSObject>

@optional

-(void) buttonEmailDeleteClick:(DeleteEmailTableViewCell*)cellValue;


@end

@interface DeleteEmailTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblSubject;
@property(nonatomic,strong)IBOutlet UITextView *lblMessage;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UIButton *   btnDelete;

@property(nonatomic,strong)IBOutlet UIButton *btn;

@property (nonatomic, unsafe_unretained) id<DeleteEmailTableViewCellDelegate> cellDelegate;


+(DeleteEmailTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnDeletePressed:(id)sender;

@end
