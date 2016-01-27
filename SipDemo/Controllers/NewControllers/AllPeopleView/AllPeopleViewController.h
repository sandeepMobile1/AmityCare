//
//  AllPeopleViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import <UIKit/UIKit.h>
#import "ContactD.h"
#import "AllUserListInvocation.h"

@class ScheduleLocationVC;

@interface AllPeopleViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,AllUserListInvocationDelegate>
{
    

    IBOutlet UISearchBar* searchBar;
    IBOutlet UITableView* tblViewContacts;
    
    BOOL isSearchEnable;
    
    unsigned long int selectedCellIndex;
    
    unsigned long int recordCount,pageIndex;

}
@property (nonatomic,strong) ScheduleLocationVC *objScheduleLocationVC;
@property (nonatomic,strong) NSMutableArray  *arrAppsContacts;
@property (nonatomic,strong) NSMutableArray  *arrSearchContacts;

@end
