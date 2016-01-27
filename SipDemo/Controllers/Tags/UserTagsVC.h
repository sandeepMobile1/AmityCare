//
//  UserTagsVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 31/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmityCareServices.h"

@interface UserTagsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblViewTagsList;
    NSUInteger selectedIndex;
    
    
}

@property(nonatomic,strong)AmityCareServices *service;
@end
