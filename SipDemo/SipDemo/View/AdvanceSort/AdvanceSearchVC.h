//
//  AdvanceSearchVC.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 23/09/14.
//
//

#import <UIKit/UIKit.h>

@class AdvanceSearchVC;

@protocol AdvanceSortFeedsVCDelegate <NSObject>

-(void)submitBtnAdvSortFeedAction:(AdvanceSearchVC*)sortFeedsVC;
-(void)cancelBtnAdvSortFeedAction:(AdvanceSearchVC*)sortFeedsVC;


@end
@interface AdvanceSearchVC : UIViewController<UITextFieldDelegate>
{
    // SortFeeds View
    id<AdvanceSortFeedsVCDelegate>_delegate;
}


@property (nonatomic, strong) IBOutlet UIView      * sortFeedsView;
@property (nonatomic, strong) IBOutlet UILabel     * lblHeading;

@property (nonatomic, strong) IBOutlet UITextField * tfStartDate;
@property (nonatomic, strong) IBOutlet UITextField * tfEndDate;
@property (nonatomic, strong) IBOutlet UITextField * tfHashTag;

@property (nonatomic, strong) IBOutlet UIButton    * btnSearch;
@property (nonatomic, strong) IBOutlet UIButton    * btnCancel;



@property(nonatomic,assign)id<AdvanceSortFeedsVCDelegate>delegate;


-(IBAction)submitBtnAdvSortFeedAction:(id)sender;
-(IBAction)cancelBtnAdvSortFeedAction:(id)sender;

@end