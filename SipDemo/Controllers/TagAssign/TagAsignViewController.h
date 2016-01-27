//
//  TagAsignViewController.h
//  Amity-Care
//
//  Created by Om Prakash on 06/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagInUserViewController;

@interface TagAsignViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    IBOutlet UITableView *tblData;
    IBOutlet UISearchBar* searchBar;

    
    BOOL isSearchEnable;

}
@property(nonatomic,strong) TagInUserViewController *tagUser;

@property(nonatomic,strong) NSMutableArray *arrayTags,*arrSearchList;
@property(nonatomic,assign) BOOL checkView;

-(IBAction)btnBackAction:(id)sender;

@end
