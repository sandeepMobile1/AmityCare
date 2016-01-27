//
//  ManagerTaskVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 10/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerTaskVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *containerView;
    IBOutlet UITableView* tblViewTaskList;
    IBOutlet UISegmentedControl *segmentCtrl;
    
    NSUInteger selectedCellIndex;
}

@property(nonatomic,strong) NSMutableArray *arrMyTask, *arrAssignedTask;
-(IBAction)segmentAction:(id)sender;
@end
