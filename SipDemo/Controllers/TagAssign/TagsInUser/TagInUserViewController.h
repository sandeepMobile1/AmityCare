//
//  TagInUserViewController.h
//  Amity-Care
//
//  Created by Om Prakash on 06/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagInUserViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITableView *tblUsersList;
    NSMutableArray *arrUsersData,*arrSearchList;
    IBOutlet UISearchBar* searchBar;
    BOOL isSearchEnable;
    
}
@property(nonatomic, strong)NSString *tag_id;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnDonePressed:(id)sender;
@end
