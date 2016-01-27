//
//  TaskDetailVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskDetailVC : UIViewController
{
    IBOutlet UILabel* lblTaskTitle;
    IBOutlet UILabel* lblPostedBy;
    IBOutlet UILabel* lblPostedOn;
    IBOutlet UILabel* lblTaskDesc;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIButton *btnTaskComplete;
}
@property(nonatomic,strong) Task* taskObj;
@property(nonatomic,strong) NSString *checkView;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnCompleteAction:(id)sender;

@end
