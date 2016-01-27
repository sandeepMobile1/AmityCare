//
//  FormButtonEmailTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import <UIKit/UIKit.h>

@class  FormButtonEmailTableViewCell;

@protocol FormButtonEmailTableViewCellDelegate <NSObject>


@optional



@end

@interface FormButtonEmailTableViewCell :UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblSubject;
@property(nonatomic,strong)IBOutlet UITextView *lblMessage;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;

@property (nonatomic, unsafe_unretained) id<FormButtonEmailTableViewCellDelegate> cellDelegate;


+(FormButtonEmailTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnDeletePressed:(id)sender;

@end
