//
//  SortFeedsVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 09/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortFeedsVC;
@protocol sortFeedsVCDelegate <NSObject>
-(void)searchBtnAction:(SortFeedsVC*)sortFeedsVC;
-(void)cancelBtnAction:(SortFeedsVC*)sortFeedsVC;


@end
@interface SortFeedsVC : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate>
{
    // SortFeeds View
    id<sortFeedsVCDelegate>_delegate;

    @public
    IBOutlet UIView* sortFeedsView;
    IBOutlet UILabel* lblHeading;
    IBOutlet UITextField* tfStartDate;
    IBOutlet UITextField* tfEndDate;
    
    IBOutlet UIButton* btnSearch;
    IBOutlet UIButton* btnCancel;
    UIDatePicker *datePicker;
    UIPopoverController *popoverController;
}
@property(nonatomic,assign)id<sortFeedsVCDelegate>delegate;
-(IBAction)submitBtnSortFeedAction:(id)sender;
-(IBAction)cancelBtnSortFeedAction:(id)sender;

@end
