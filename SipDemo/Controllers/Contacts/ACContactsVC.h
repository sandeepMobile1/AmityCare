//
//  ACContactsVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import "NormalActionSheetDelegate.h"
#import <MessageUI/MessageUI.h>
#import "OptionsPopOverVC.h"
#import "CallingView.h"
#import "PhoneCallDelegate.h"
#import "AcceptanceInvocation.h"
#import "UpdateContactNotificationInvocation.h"
#import "OfflineMessageInvocation.h"

@class ChatDetailVC;
@class ProfileDetailVC;


@interface ACContactsVC : UIViewController<LTKPopoverActionSheetDelegate,NormalActionDeledate,UITableViewDataSource,
UITableViewDelegate,UISearchBarDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,AcceptanceInvocationDelegate,UpdateContactNotificationInvocationDelegate,OfflineMessageInvocationDelegate>
{
    IBOutlet UISearchBar* searchBar;
    IBOutlet UITableView* tblViewContacts;
   
    NSRange range;
    MFMessageComposeViewController *msgComposer;
    NSMutableArray* arrEmail;
    UIPopoverController* popover;
    NSIndexPath* selectedIndxpath;
    BOOL isSearchEnable;
    id<PhoneCallDelegate> phoneCallDelegate;

    UIAlertView *offlineAlert;
    

    
    
    
}


@property (nonatomic,strong) ChatDetailVC * chatView;
@property(nonatomic,strong)ProfileDetailVC *objProfileDetailVC;

@property (nonatomic,strong) CallingView *callingView;
@property (nonatomic,strong) NSMutableArray* arrContactsList;
@property (nonatomic,strong) NSMutableArray* arrSearchList;
@property (nonatomic,strong) NSString* memberId;


@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;
@end
