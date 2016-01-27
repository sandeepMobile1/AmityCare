//
//  AddContactsVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 21/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactD.h"

@interface AddContactsVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    IBOutlet UISearchBar* searchBar;
    IBOutlet UITableView* tblViewContacts;
   
    BOOL isSearchEnable;
    
    unsigned long int selectedCellIndex;
}
@property (nonatomic,strong) NSMutableArray  *arrAppsContacts;
@property (nonatomic,strong) NSMutableArray  *arrSearchContacts;

-(IBAction)btnBackAction:(id)sender;

@end
