//
//  FormFolderListViewController.h
//  SipDemo
//
//  Created by Shweta Sharma on 16/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetFormListInvocation.h"
#import "GetFormNameInvacation.h"

@class FormListViewController;

@interface FormFolderListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,GetFormNameInvacationDelegate>
{
    IBOutlet UITableView* tblView;

}
@property (strong, nonatomic) FormListViewController *objFormListViewController;

@property (strong, nonatomic) NSMutableArray *arrFolderList;
@property (strong, nonatomic) NSMutableArray *formsArr;
@property (strong, nonatomic) NSMutableArray *formNameArr;
@property (strong, nonatomic) NSMutableArray *arrTotalFormList;

@property(nonatomic,strong)NSString *tagId;

-(void)requestForGetFormList;
@end
