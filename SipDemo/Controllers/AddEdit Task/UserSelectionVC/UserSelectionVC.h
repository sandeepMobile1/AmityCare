//
//  UserSelectionVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 05/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UserSelectionDelegate <NSObject>

-(void)userDidSelected:(NSMutableArray*)arrUser;

@end


@interface UserSelectionVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* tblUsersList;
    
    User *selectedUser;
    NSMutableArray *arrUsersData;
}

@property(nonatomic,unsafe_unretained)id<UserSelectionDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *arrSelectedUser;
@property(nonatomic,strong)NSString *tagId;

-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnDoneAction:(id)sender;

@end
