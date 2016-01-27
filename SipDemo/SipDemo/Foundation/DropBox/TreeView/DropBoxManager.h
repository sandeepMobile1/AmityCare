//
//  ViewController.h
//  DropBoxDemo
//
//  Created by Vinod Shau on 19/07/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "TreeViewNode.h"
#import "PathManager.h"
#import "MBProgressHUD.h"
#import "TopNavigationView.h"

@class UploadMediaFilesVc;


@interface DropBoxManager : UIViewController<DBSessionDelegate, DBNetworkRequestDelegate,DBRestClientDelegate>{
    
    NSString *relinkUserId;
    DBRestClient* restClient;
    NSUInteger indentation;
    UIAlertView *articalSendAlert;
    NSString *selectedFile;
    NSString *selectedlink;
    NSString* dbPath;
    TopNavigationView* navigation;
}

-(void)createSessionAndLinkWithDropBox;
-(void)loginNotificationDidRecieve;

@property (nonatomic, strong)UploadMediaFilesVc *uploadVc;
@property (nonatomic, readonly) DBRestClient* restClient;
@property (nonatomic, strong) NSString *metaDataHash;
@property (nonatomic, strong) NSString *checkSession;

@property (nonatomic, strong) NSMutableArray *nodeList;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic, strong)IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allPathManager;
@property (nonatomic, strong) NSString *checkView;

-(void)createBackButtton;
-(void)backButtonClickDidClick:(UIButton*)sender;
- (void)expandCollapseNode:(NSNotification *)notification;
- (void)fillDisplayArray;
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray;
- (IBAction)collapseAll:(id)sender;
-(IBAction)btnBackAction:(id)sender;


@end
