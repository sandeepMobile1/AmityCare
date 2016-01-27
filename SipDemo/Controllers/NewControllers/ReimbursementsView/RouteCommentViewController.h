//
//  RouteCommentViewController.h
//  SipDemo
//
//  Created by Octal on 14/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouteCommentListInvocation.h"
#import "MileageCommentTableViewCell.h"
#import "DeleteRouteCommentInvocation.h"

@interface RouteCommentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,RouteCommentListInvocationDelegate,MileageCommentTableViewCellDelegate,DeleteRouteCommentInvocationDelegate>
{
    MileageCommentTableViewCell *cell;
    IBOutlet UITableView *tblView;
}
@property(nonatomic,strong)NSMutableArray *arrCommentList;
@property(nonatomic,strong)NSString *rootId;

@property (nonatomic, strong)   NSIndexPath* selectedIndxpath;

-(IBAction)btnBackAction:(id)sender;

@end
