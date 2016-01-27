//
//  CalenderTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 13/10/14.
//
//

#import <UIKit/UIKit.h>

@class  CalenderTableViewCell;

@protocol CalenderTableViewCellDelegate <NSObject>

//-(void) buttonClick:(CalenderTableViewCell*)cellValue;

@optional

@end

@interface CalenderTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property (nonatomic, unsafe_unretained) id<CalenderTableViewCellDelegate> cellDelegate;

+(CalenderTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnPressed:(id)sender;

@end
