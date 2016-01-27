//
//  TaskViewController.h
//  Amity-Care
//
//  Created by Vijay Kumar on 31/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView* tblViewTaskLst;
    
}

@end
