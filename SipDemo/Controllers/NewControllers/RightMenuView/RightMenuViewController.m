//
//  RightMenuViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/01/15.
//
//

#import "RightMenuViewController.h"
#import "ConfigManager.h"
#import "UIImageExtras.h"
#import "UIImageExtras.h"
#import "UpdateStatusView.h"
#import "UploadDocVC.h"
#import "Status.h"
#import "ProfileDetailVC.h"
#import "ZoomInOutView.h"
#import "DocZoomVC.h"
#import "UserLocationVC.h"
#import "ActionSheetPicker.h"
#import "Form.h"
#import "FormsField.h"
#import "FormListVC.h"
#import "UIImageView+WebCache.h"
#import "FormValues.h"
#import "UpdateStatusView_iphone.h"
#import "PasswordViewIphone.h"
#import "NSString+urlDecode.h"
#import "Task.h"
#import <QuartzCore/QuartzCore.h>
#import "FormListViewController.h"
#import "SadSmileViewController.h"
#import "SmileViewController.h"
#import "FavoriteViewController.h"
#import "SettingViewController.h"
#import "MessagesListVC.h"
#import "AddNewTaskVC.h"
#import "TaskCalenderViewController.h"
#import "ChatDetailVC.h"
#import "ReimbursementsViewController.h"
#import "FormButtonViewController.h"
#import "SchedulButtonViewController.h"
#import "AllPeopleViewController.h"
#import "AllTagsViewController.h"
#import "ACContactsVC.h"
#import "ActionSheetPicker.h"
#import "AddContactsVC.h"
#import "AddScheduleViewController.h"
#import "AllHappyFacePostViewController.h"
#import "AllSadFacePostViewController.h"
#import "MadFormViewController.h"

#import "ManagerAssignedTagViewController.h"
#import "ManagerReimbursementViewController.h"
#import "UserCompletedFormViewController.h"
#import "CompletedTagFormViewController.h"
#import "UpdateSharePostViewController.h"
#import "DeletePostViewController.h"
#import "UploadDropBoxFileViewController.h"
#import "BackPackViewController.h"
#import "FormFolderListViewController.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController

@synthesize normalActionSheetDelegate,activeSheet;

@synthesize objBackPackViewCOntroller,objAddScheduleViewController,objTaskCalenderViewController,objAddContactsVC,objAddNewTaskVC,objAllHappyFacePostViewController,objAllPeopleViewController,objAllSadFacePostViewController,objAllTagsViewController,objChatDetailVC,objCompletedTagFormViewController,objDeletePostViewController,objFavoriteViewController,objFormButtonViewController,objFormListViewController,objMadFormViewController,objManagerAssignedTagViewController,objManagerReimbursementViewController,objMessagesListVC,objReimbursementsViewController,objSadSmileViewController,objSchedulButtonViewController,objSettingViewController,objSmileViewController,objUpdateSharePostViewController,objUpdateStatusView,objUploadDocVC,objUploadDropBoxFileViewController,objUserCompletedFormViewController,msgComposer,objFormFolderListViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!IS_IPHONE_5) {
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
        
        [rightInnerView setFrame:CGRectMake(rightInnerView.frame.origin.x, rightInnerView.frame.origin.y, rightInnerView.frame.size.width, rightInnerView.frame.size.height-IPHONE_FIVE_FACTOR)];
        
    }
    
    [segmentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //[self showCalenderView];
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        NSArray *itemArray;
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        itemArray= [NSArray arrayWithObjects: @"",@"",@"",@"",@"",@"",@"",@"",nil];
        
        rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
        rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
        [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
        
        [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
        
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:7];
            
            [rightMainSegment addTarget:self action:@selector(familyTopUserRightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            
        }
        else
        {
            itemArray= [NSArray arrayWithObjects: @"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            
            
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:8];
            
            [rightMainSegment addTarget:self action:@selector(TopUserRightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];

        }
        
        
        rightMainSegment.selectedSegmentIndex=0;
        
        [segmentScroll addSubview:rightMainSegment];
        
        [segmentScroll setContentSize:CGSizeMake(350, segmentScroll.frame.size.height)];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 456.4, 30);
            //rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(rightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"star.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"document_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:8];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:9];
            [rightMainSegment setImage:[UIImage imageNamed:@"madform.png"] forSegmentAtIndex:10];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"tag_icon"] forSegmentAtIndex:11];
            [rightMainSegment setImage:[UIImage imageNamed:@"form_icon"] forSegmentAtIndex:12];
            [rightMainSegment setImage:[UIImage imageNamed:@"schedule_icon"] forSegmentAtIndex:13];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon"] forSegmentAtIndex:14];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:15];

            [segmentScroll setContentSize:CGSizeMake(480, segmentScroll.frame.size.height)];
            
            
        }
        else if([sharedAppDelegate.userObj.role isEqualToString:@"3"])
        {
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 652, 30);
            [rightMainSegment addTarget:self action:@selector(rightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"star.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"document_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:8];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:9];
            [rightMainSegment setImage:[UIImage imageNamed:@"madform.png"] forSegmentAtIndex:10];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"tag_icon"] forSegmentAtIndex:11];
            [rightMainSegment setImage:[UIImage imageNamed:@"form_icon"] forSegmentAtIndex:12];
            [rightMainSegment setImage:[UIImage imageNamed:@"schedule_icon"] forSegmentAtIndex:13];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon"] forSegmentAtIndex:14];
            
            //[rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:15];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_form"] forSegmentAtIndex:15];
            [rightMainSegment setImage:[UIImage imageNamed:@"tag"] forSegmentAtIndex:16];
           // [rightMainSegment setImage:[UIImage imageNamed:@"manager_share"] forSegmentAtIndex:18];
            [rightMainSegment setImage:[UIImage imageNamed:@"delete"] forSegmentAtIndex:17];
            [rightMainSegment setImage:[UIImage imageNamed:@"manager_upload"] forSegmentAtIndex:18];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:19];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:20];

            [segmentScroll setContentSize:CGSizeMake(670, segmentScroll.frame.size.height)];

        }
        else if([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"])
        {
            NSArray *itemArray = [NSArray arrayWithObjects: @"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            //rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(familyTopRightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_form"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:8];

            [segmentScroll setContentSize:CGSizeMake(350, segmentScroll.frame.size.height)];
            
        }
        else
        {
            NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            //rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(rightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"star.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"document_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:8];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:9];
            [rightMainSegment setImage:[UIImage imageNamed:@"madform.png"] forSegmentAtIndex:10];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:11];

            [segmentScroll setContentSize:CGSizeMake(350, segmentScroll.frame.size.height)];
            
            
        }
        rightMainSegment.selectedSegmentIndex=0;
        
        [segmentScroll addSubview:rightMainSegment];
        
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRightMenuView) name:AC_RIGHT_MENU_NOTIFICATION_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name: AC_USER_UNREAD_BADGE_UPDATE object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadMessage) name:@"updateUnreadMessage" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadRightMenuView
{
    [rightMainSegment removeFromSuperview];
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        NSArray *itemArray;
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            itemArray= [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil];
            
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:7];
            
            [rightMainSegment addTarget:self action:@selector(familyTopUserRightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];

        }
        else
        {
            itemArray= [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:8];
            
            [rightMainSegment addTarget:self action:@selector(TopUserRightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
        }
       
        
        rightMainSegment.selectedSegmentIndex=0;
        
        [segmentScroll addSubview:rightMainSegment];
        
        [segmentScroll setContentSize:CGSizeMake(350, segmentScroll.frame.size.height)];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 456.4, 30);
            //rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(rightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"star.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"document_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:8];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:9];
            [rightMainSegment setImage:[UIImage imageNamed:@"madform.png"] forSegmentAtIndex:10];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"tag_icon"] forSegmentAtIndex:11];
            [rightMainSegment setImage:[UIImage imageNamed:@"form_icon"] forSegmentAtIndex:12];
            [rightMainSegment setImage:[UIImage imageNamed:@"schedule_icon"] forSegmentAtIndex:13];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon"] forSegmentAtIndex:14];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:15];

            [segmentScroll setContentSize:CGSizeMake(480, segmentScroll.frame.size.height)];

        }
        else if([sharedAppDelegate.userObj.role isEqualToString:@"3"])
        {
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 652, 30);
           // rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(rightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"star.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"document_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:8];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:9];
            [rightMainSegment setImage:[UIImage imageNamed:@"madform.png"] forSegmentAtIndex:10];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"tag_icon"] forSegmentAtIndex:11];
            [rightMainSegment setImage:[UIImage imageNamed:@"form_icon"] forSegmentAtIndex:12];
            [rightMainSegment setImage:[UIImage imageNamed:@"schedule_icon"] forSegmentAtIndex:13];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon"] forSegmentAtIndex:14];
            
            //[rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:15];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_form"] forSegmentAtIndex:15];
            [rightMainSegment setImage:[UIImage imageNamed:@"tag"] forSegmentAtIndex:16];
            //[rightMainSegment setImage:[UIImage imageNamed:@"manager_share"] forSegmentAtIndex:18];
            [rightMainSegment setImage:[UIImage imageNamed:@"delete"] forSegmentAtIndex:17];
            [rightMainSegment setImage:[UIImage imageNamed:@"manager_upload"] forSegmentAtIndex:18];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:19];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:20];

            [segmentScroll setContentSize:CGSizeMake(670, segmentScroll.frame.size.height)];

        }
        else if([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"])
        {
            NSArray *itemArray = [NSArray arrayWithObjects: @"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            //rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(familyTopRightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_form"] forSegmentAtIndex:7];

            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:8];

            [segmentScroll setContentSize:CGSizeMake(350, segmentScroll.frame.size.height)];
            
        }
        else
        {
            NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            rightMainSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
            rightMainSegment.frame = CGRectMake(3, 7, 326, 30);
            //rightMainSegment.segmentedControlStyle = UISegmentedControlStylePlain;
            [rightMainSegment addTarget:self action:@selector(rightMainSegmentAction:) forControlEvents: UIControlEventValueChanged];
            [rightMainSegment setTintColor:[UIColor colorWithRed:0.239215686 green:0.239215686 blue:0.239215686 alpha:1.0]];
            
            [rightMainSegment setImage:[UIImage imageNamed:@"calendar_iphone.png"] forSegmentAtIndex:0];
            [rightMainSegment setImage:[UIImage imageNamed:@"route"] forSegmentAtIndex:1];
            [rightMainSegment setImage:[UIImage imageNamed:@"star.png"] forSegmentAtIndex:2];
            [rightMainSegment setImage:[UIImage imageNamed:@"sadsmiley_iphone.png"] forSegmentAtIndex:3];
            [rightMainSegment setImage:[UIImage imageNamed:@"happysmiley_iphone.png"] forSegmentAtIndex:4];
            [rightMainSegment setImage:[UIImage imageNamed:@"settings_iphone.png"] forSegmentAtIndex:5];
            [rightMainSegment setImage:[UIImage imageNamed:@"document_iphone.png"] forSegmentAtIndex:6];
            [rightMainSegment setImage:[UIImage imageNamed:@"pen_iphone.png"] forSegmentAtIndex:7];
            [rightMainSegment setImage:[UIImage imageNamed:@"upload_iphone.png"] forSegmentAtIndex:8];
            [rightMainSegment setImage:[UIImage imageNamed:@"message_iphone.png"] forSegmentAtIndex:9];
            [rightMainSegment setImage:[UIImage imageNamed:@"madform.png"] forSegmentAtIndex:10];
            [rightMainSegment setImage:[UIImage imageNamed:@"user_icon.png"] forSegmentAtIndex:11];

            [segmentScroll setContentSize:CGSizeMake(350, segmentScroll.frame.size.height)];
            
            
        }
        rightMainSegment.selectedSegmentIndex=0;
        
        [segmentScroll addSubview:rightMainSegment];
        
        
    }
    
    if ([sharedAppDelegate.checkSlideMenuAction isEqualToString:@"Menu"]) {
        
        [segmentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
        if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
       
            rightMainSegment.selectedSegmentIndex=0;
            [btnAddTak setHidden:FALSE];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:0];

            [self showCalenderView];
        }
        else
        {
            if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                rightMainSegment.selectedSegmentIndex=0;
                [btnAddTak setHidden:FALSE];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:0];

                [self showCalenderView];

            }
            else
            {
                if ([sharedAppDelegate.calendarVisibleStatus isEqualToString:@"1"]) {
                    
                    rightMainSegment.selectedSegmentIndex=0;
                    [btnAddTak setHidden:FALSE];
                    [rightMainSegment setEnabled:YES forSegmentAtIndex:0];

                    [self showCalenderView];

                }
                else
                {
                    rightMainSegment.selectedSegmentIndex=1;
                    [btnAddTak setHidden:TRUE];
                    [rightMainSegment setEnabled:NO forSegmentAtIndex:0];

                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                       
                        [self showSadSmileView];
                    }
                    else
                    {
                        [self showReimbursementsView];
                    }
                }
            }
        }
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            rightMainSegment.selectedSegmentIndex=6;
            
        }
        else
        {
            rightMainSegment.selectedSegmentIndex=9;
            
        }
        [segmentScroll setContentOffset:CGPointMake(60, 0) animated:YES];
        
        [btnAddTak setHidden:TRUE];
        [self showChatView];
    }
    
    [btnContactNotificationCount setHidden:TRUE];
    [btnChatCount setHidden:TRUE];
    
    btnChatCount=[UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        [btnChatCount setFrame:CGRectMake(315, 0, 20, 20)];
        
        
    }
    else if([sharedAppDelegate.userObj.role isEqualToString:@"3"])
    {
        [btnChatCount setFrame:CGRectMake(325, 0, 20, 20)];

    }
    else
    {
        [btnChatCount setFrame:CGRectMake(310, 0, 20, 20)];
        
    }
    [btnChatCount setTitle:@"" forState:UIControlStateNormal];
    [btnChatCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChatCount.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [btnChatCount setBackgroundImage:[UIImage imageNamed:@"NotificationCount"] forState:UIControlStateNormal];
    [segmentScroll addSubview:btnChatCount];
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        btnContactNotificationCount=[UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [btnContactNotificationCount setFrame:CGRectMake(188, 0, 20, 20)];
            
        }
        else
        {
            [btnContactNotificationCount setFrame:CGRectMake(200, 0, 20, 20)];
            
        }
        [btnContactNotificationCount setTitle:@"" forState:UIControlStateNormal];
        [btnContactNotificationCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnContactNotificationCount.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [btnContactNotificationCount setBackgroundImage:[UIImage imageNamed:@"NotificationCount"] forState:UIControlStateNormal];
        [segmentScroll addSubview:btnContactNotificationCount];
        
        
        if (sharedAppDelegate.unreadContactCount>0) {
            
            [btnContactNotificationCount setHidden:FALSE];
            [btnContactNotificationCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadContactCount] forState:UIControlStateNormal];
        }
        else
        {
            [btnContactNotificationCount setHidden:TRUE];
            
        }
        
        if (sharedAppDelegate.unreadMsgCount>0) {
            
            [btnChatCount setHidden:FALSE];
            [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadMsgCount] forState:UIControlStateNormal];
        }
        else
        {
            [btnChatCount setHidden:TRUE];
            
        }
        
    }
    else
    {
        [btnContactNotificationCount setHidden:TRUE];
        
        if (sharedAppDelegate.unreadGroupChatCount>0) {
            
            [btnChatCount setHidden:FALSE];
            [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
        }
        else
        {
            [btnChatCount setHidden:TRUE];
            
        }
        
        
    }
    
    //[btnChatCount setHidden:FALSE];
   // [btnContactNotificationCount setHidden:FALSE];
    
    
    
    if (![sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
            if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {

                    [rightMainSegment setEnabled:YES forSegmentAtIndex:6];

                }
                else
                {
                    [rightMainSegment setEnabled:NO forSegmentAtIndex:6];

                }


            }
            else
            {
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                    
                }
                else
                {
                    
                    [rightMainSegment setEnabled:NO forSegmentAtIndex:2];

                    if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                        
                        [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
                        [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
                        [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
                        [rightMainSegment setEnabled:YES forSegmentAtIndex:6];

                    }
                    else
                    {
                        [rightMainSegment setEnabled:NO forSegmentAtIndex:3];
                        [rightMainSegment setEnabled:NO forSegmentAtIndex:4];
                        [rightMainSegment setEnabled:NO forSegmentAtIndex:10];
                        [rightMainSegment setEnabled:NO forSegmentAtIndex:6];

                    }
                }
                
                
            }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name: AC_USER_UNREAD_BADGE_UPDATE object:nil];
    
}

-(void)setBadgeValue:(NSNotification*) note
{
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        if (sharedAppDelegate.unreadContactCount>0) {
            
            [btnContactNotificationCount setHidden:FALSE];
            [btnContactNotificationCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadContactCount] forState:UIControlStateNormal];
        }
        else
        {
            [btnContactNotificationCount setHidden:TRUE];
            
        }
        
        if (sharedAppDelegate.unreadMsgCount>0) {
            
            [btnChatCount setHidden:FALSE];
            [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadMsgCount] forState:UIControlStateNormal];
        }
        else
        {
            [btnChatCount setHidden:TRUE];
            
        }
        
    }
    else
    {
        [btnContactNotificationCount setHidden:TRUE];
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
            
            if (sharedAppDelegate.unreadGroupChatCount>0) {
                
                [btnChatCount setHidden:FALSE];
                [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
            }
            else
            {
                [btnChatCount setHidden:TRUE];
                
            }
            
        }
        
    }
    // [btnChatCount setHidden:FALSE];
    // [btnContactNotificationCount setHidden:FALSE];
    
}
#pragma mark IBAction methods --------

-(IBAction)rightMainSegmentAction:(id)sender
{
    [self removeView];
    
    if (rightMainSegment.selectedSegmentIndex==0) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showCalenderView];
    }
    else if (rightMainSegment.selectedSegmentIndex==1) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showReimbursementsView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==2) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showFavoriteView];
    }
    else if (rightMainSegment.selectedSegmentIndex==3) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSadSmileView];
    }
    else if (rightMainSegment.selectedSegmentIndex==4) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSmileView];
    }
    else if (rightMainSegment.selectedSegmentIndex==5) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSettingView];
    }
    else if (rightMainSegment.selectedSegmentIndex==6) {
        
        if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]){
            
            [btnAddTak setHidden:FALSE];
            
            
            [self showContactView];
        }
        else
        {
            [btnAddTak setHidden:TRUE];
            
            [self showFormListView];
        }
        
    }
    else if (rightMainSegment.selectedSegmentIndex==7) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUpdateStatusView];
    }
    else if (rightMainSegment.selectedSegmentIndex==8) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUploadView];
    }
    else if (rightMainSegment.selectedSegmentIndex==9) {
        
        [btnAddTak setHidden:TRUE];
        
        if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
            
            [self showMessageView];
            
        }
        else
        {
            [self showChatView];
            
        }
    }
    else if (rightMainSegment.selectedSegmentIndex==10) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showMadFormView];
    }
    else if (rightMainSegment.selectedSegmentIndex==11) {
        
        [btnAddTak setHidden:TRUE];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]||[sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [self showAllTagsView];
            
        }
        else
        {
            [self showContactView];
        }
        
    }
    else if (rightMainSegment.selectedSegmentIndex==12) {
        
        [btnAddTak setHidden:TRUE];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]||[sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [self showFormButtonView];
            
        }
        else
        {
            [self showAllSadFacePostView];
        }
        
    }
    else if (rightMainSegment.selectedSegmentIndex==13) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showScheduleButtonView];
    }
    else if (rightMainSegment.selectedSegmentIndex==14) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showAllPeopleView];
    }
    else if (rightMainSegment.selectedSegmentIndex==15) {
        
        [btnAddTak setHidden:TRUE];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [self showContactView];
        }
        else
        {
            [self showUserFormListView];
 
        }

    
    }
    else if (rightMainSegment.selectedSegmentIndex==16) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showTagFormListView];
    }
    else if (rightMainSegment.selectedSegmentIndex==17) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showAllDeletePostView];
    }
    else if (rightMainSegment.selectedSegmentIndex==18) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUploadManagerDocView];
    }
    else if (rightMainSegment.selectedSegmentIndex==19) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showManagerReimbursementView];
    }
    else if (rightMainSegment.selectedSegmentIndex==20) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showContactView];
    }

    else
    {
        [self removeView];
        
    }
    
    
}
-(IBAction)familyTopRightMainSegmentAction:(id)sender
{
    [self removeView];
    
    if (rightMainSegment.selectedSegmentIndex==0) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showCalenderView];
    }
    else if (rightMainSegment.selectedSegmentIndex==1) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSadSmileView];
        
        
    }
    else if (rightMainSegment.selectedSegmentIndex==2) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSmileView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==3) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSettingView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==4) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUpdateStatusView];
    }
    else if (rightMainSegment.selectedSegmentIndex==5) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUploadView];
        
        
    }
    else if (rightMainSegment.selectedSegmentIndex==6) {
        
        [btnAddTak setHidden:TRUE];
        
        if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
            
            [self showMessageView];
            
        }
        else
        {
            [self showChatView];
            
        }
    }
    else if (rightMainSegment.selectedSegmentIndex==7) {
        
        [self showFormListView];
       // [self showAllHappyFacePostView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==8) {
        
        [self showContactView];
        
    }
    else
    {
        [self removeView];
        
    }
    
    
}
-(IBAction)familyTopUserRightMainSegmentAction:(id)sender
{
        [self removeView];
        
        if (rightMainSegment.selectedSegmentIndex==0) {
            
            [btnAddTak setHidden:FALSE];
            
            [self showCalenderView];
        }
    
        else if (rightMainSegment.selectedSegmentIndex==1) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showSadSmileView];
            
            
        }
        else if (rightMainSegment.selectedSegmentIndex==2) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showSmileView];
            
        }
        else if (rightMainSegment.selectedSegmentIndex==3) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showSettingView];
            
        }
        else if (rightMainSegment.selectedSegmentIndex==4) {
            
            [btnAddTak setHidden:FALSE];
            
            [self showContactView];
        }
        else if (rightMainSegment.selectedSegmentIndex==5) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showUpdateStatusView];
            
        }
        else if (rightMainSegment.selectedSegmentIndex==6) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showUploadView];
            
        }
        else if (rightMainSegment.selectedSegmentIndex==7) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showMessageView];
          
            
        }
        else
        {
            [self removeView];
            
        }
    
}
-(IBAction)TopUserRightMainSegmentAction:(id)sender
{
    [self removeView];
    
    if (rightMainSegment.selectedSegmentIndex==0) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showCalenderView];
    }
    else if (rightMainSegment.selectedSegmentIndex==1) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showReimbursementsView];
        
        
    }
    else if (rightMainSegment.selectedSegmentIndex==2) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSadSmileView];
        
        
    }
    else if (rightMainSegment.selectedSegmentIndex==3) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSmileView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==4) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSettingView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==5) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showContactView];
    }
    else if (rightMainSegment.selectedSegmentIndex==6) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUpdateStatusView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==7) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUploadView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==8) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showMessageView];
        
    }
    else
    {
        [self removeView];
        
    }
    
}
-(IBAction)addTaskAction:(id)sender
{
    if (rightMainSegment.selectedSegmentIndex==0) {
        
        NSLog(@"%@",sharedAppDelegate.calenderCurrentDate);
        
        if (sharedAppDelegate.calenderCurrentDate==nil || sharedAppDelegate.calenderCurrentDate==(NSString*)[NSNull null] || [sharedAppDelegate.calenderCurrentDate isEqualToString:@""]) {
            
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
            sharedAppDelegate.calenderServerDate = [dateformate stringFromDate:[NSDate date]];
            sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:[NSDate date]];
            
        }
        
        rightMainSegment.selectedSegmentIndex=0;
        [self.objAddNewTaskVC.view removeFromSuperview];
        
        self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
        
        if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null] || [sharedAppDelegate.strSelectedTagId isEqualToString:@""]) {
            
            self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
            self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
            
        }
        else
        {
            self.objAddNewTaskVC.selectedTagId=sharedAppDelegate.strSelectedTagId;
            self.objAddNewTaskVC.selectedTag=sharedAppDelegate.strSelectedTag;
            self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
            self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
            
        }
        
        [rightInnerView addSubview:self.objAddNewTaskVC.view];
    }
    else if(rightMainSegment.selectedSegmentIndex==13)
    {
        self.objAddScheduleViewController=[[AddScheduleViewController alloc] initWithNibName:@"AddScheduleViewController_iphone" bundle:nil];
        self.objAddScheduleViewController.sData=nil;
        [rightInnerView addSubview:self.objAddScheduleViewController.view];
    }
    else
    {
        if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
            
            actionSheetbutton = (UIButton *)sender;
            [self dismissActionSheets];
            
            if (nil == self.normalActionSheetDelegate)
            {
                self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
                self.normalActionSheetDelegate.normalDelegate = self;
            }
            
            if (nil == self.activeSheet)
            {
                UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite Contacts:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Device Contacts", @"App Contacts", nil];
                self.activeSheet = normalActionSheet;
                self.activeSheet.tag = AC_ACTIONSHEET_INVITE_CONTACTS;
            }
            [self.activeSheet showFromRect:((UIButton*)sender).frame inView:self.view animated:YES];
        }
    }
    
    
}
#pragma mark- NormalActionSheetDelegate

-(void)dismissActionSheets
{
    if (self.activeSheet)
    {
        if ([self.activeSheet isVisible])
        {
            [self.activeSheet dismissWithClickedButtonIndex:-1 animated:YES];
        }
        self.activeSheet = nil;
    }
}

-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_INVITE_CONTACTS)
    {
        
        if(buttonIndex==0){
            
            ABPeoplePickerNavigationController *picker =
            [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
            
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }
        else if(buttonIndex==1){
            
            self.objAddContactsVC = [[AddContactsVC alloc] initWithNibName:@"AddContactsVC_iphone" bundle:nil];
            
            [rightInnerView addSubview:self.objAddContactsVC.view];
            
            
        }
    }
    else if(actionSheet.tag == AC_ACTIONSHEET_INVITE_VIA_IMESSAGE)
    {
        [self openMessageComposer:[arrEmail objectAtIndex:buttonIndex]];
    }
}
-(void)openMessageComposer:(NSString*)strPhone
{
    if(self.msgComposer!=nil){
        self.msgComposer = nil;
    }
    self.msgComposer = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        self.msgComposer.body = @"Hey!! I am using Amity Care for free calling and text. Download Amity-Care and enjoy.";
        self.msgComposer.recipients = [NSArray arrayWithObjects:strPhone, nil];
        //self.msgComposer.messageComposeDelegate = self;
        [self presentViewController:self.msgComposer animated:YES completion:^{
            
        }];
    }
}
-(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}
#pragma mark- ABAddressBookDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    //[self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:^{
        
        if(!IS_DEVICE_IPAD)
        {
            // open message composer with phone number
            ABMultiValueRef phoneNumbers = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSString* phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            if(!phoneNumber)
            {
                [self performSelector:@selector(openMessageComposer:) withObject:phoneNumber afterDelay:0.0f];
            }
            
            CFRelease(phoneNumbers);

        }
        else{
            // open message composer with email
            if(arrEmail!=nil){
                [arrEmail removeAllObjects];
                arrEmail = nil;
            }
            arrEmail = [[NSMutableArray alloc] init];
            
            ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
            if (ABMultiValueGetCount(multi) > 0) {
                // collect all emails in array
                for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
                    CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
                    [arrEmail addObject:(__bridge NSString *)emailRef];
                    CFRelease(emailRef);
                }
            }
            
            if([arrEmail count]>0)
            {
                
                /*   OptionsPopOverVC * opt = [[OptionsPopOverVC alloc] initWithTitleLabel:[UIColor clearColor] textColor:TEXT_COLOR_BLUE title:@"Select E-mail for iMessage" data:arrEmail delegate:self];
                 popover = [[UIPopoverController alloc] initWithContentViewController:opt];
                 [popover presentPopoverFromRect:CGRectMake(120, 350, 250, 230) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                 [popover setPopoverContentSize:CGSizeMake(250, 230)];*/
                
            }
            else {
                [ConfigManager showAlertMessage:nil Message:@"No E-mail configured with this contact"];
            }
        }
    }];
    
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
#pragma mark add views --------

-(void)removeView
{
    [self.objTaskCalenderViewController.view removeFromSuperview];
    [self.objUploadDocVC.view removeFromSuperview];
    [self.objFormListViewController.view removeFromSuperview];
    [self.objFavoriteViewController.view removeFromSuperview];
    [self.objSettingViewController.view removeFromSuperview];
    [self.objSadSmileViewController.view removeFromSuperview];
    [self.objUploadDocVC.view removeFromSuperview];
    [self.objUpdateStatusView setHidden:TRUE];
    [self.objSmileViewController.view removeFromSuperview];
    [self.objMessagesListVC.view removeFromSuperview];
    [self.objAddNewTaskVC.view removeFromSuperview];
    [self.objChatDetailVC.view removeFromSuperview];
    [self.objReimbursementsViewController.view removeFromSuperview];
    [self.objAllTagsViewController.view removeFromSuperview];
    [self.objAllPeopleViewController.view removeFromSuperview];
    [self.objFormButtonViewController.view removeFromSuperview];
    [self.objSchedulButtonViewController.view removeFromSuperview];
    [sharedAppDelegate.acContactsVC.view removeFromSuperview];
    [self.objAddContactsVC.view removeFromSuperview];
    
    // [self.objManagerAssignedTagViewController.view removeFromSuperview];
    [self.objManagerReimbursementViewController.view removeFromSuperview];
    [self.objUserCompletedFormViewController.view removeFromSuperview];
    [self.objCompletedTagFormViewController.view removeFromSuperview];
    [self.objUpdateSharePostViewController.view removeFromSuperview];
    [self.objDeletePostViewController.view removeFromSuperview];
    //[self.objUploadDropBoxFileViewController.view removeFromSuperview];
    [self.objAddScheduleViewController.view removeFromSuperview];
    [self.objBackPackViewCOntroller.view removeFromSuperview];
    
    
}

-(void)showCalenderView
{
    
    [DSBezelActivityView removeView];

    
    [self.objTaskCalenderViewController.view removeFromSuperview];
    
    self.objTaskCalenderViewController=[[TaskCalenderViewController alloc] initWithNibName:@"TaskCalenderViewController_iphone" bundle:nil];
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        self.objTaskCalenderViewController.tagId=@"";
        
    }
    else
    {
        self.objTaskCalenderViewController.tagId=sharedAppDelegate.strSelectedTagId;
        
    }
    
    [rightInnerView addSubview:self.objTaskCalenderViewController.view];
    
    
}

-(void)showSadSmileView
{
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objSadSmileViewController.view removeFromSuperview];
        
        self.objSadSmileViewController=[[SadSmileViewController alloc] initWithNibName:@"SadSmileViewController_iphone" bundle:nil];
        self.objSadSmileViewController.tagId=@"";
        [rightInnerView addSubview:self.objSadSmileViewController.view];
        
    }
    else
    {
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]|| [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [self.objSadSmileViewController.view removeFromSuperview];
            
            self.objSadSmileViewController=[[SadSmileViewController alloc] initWithNibName:@"SadSmileViewController_iphone" bundle:nil];
            self.objSadSmileViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objSadSmileViewController.view];
            
        }
        else
        {
            
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [self.objSadSmileViewController.view removeFromSuperview];
                
                self.objSadSmileViewController=[[SadSmileViewController alloc] initWithNibName:@"SadSmileViewController_iphone" bundle:nil];
                self.objSadSmileViewController.tagId=sharedAppDelegate.strSelectedTagId;
                
                [rightInnerView addSubview:self.objSadSmileViewController.view];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }
        
        
        
    }
    
}
-(void)showSmileView
{
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objSmileViewController.view removeFromSuperview];
        
        self.objSmileViewController=[[SmileViewController alloc] initWithNibName:@"SmileViewController_iphone" bundle:nil];
        
        self.objSmileViewController.tagId=@"";
        [rightInnerView addSubview:self.objSmileViewController.view];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]|| [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [self.objSmileViewController.view removeFromSuperview];
            
            self.objSmileViewController=[[SmileViewController alloc] initWithNibName:@"SmileViewController_iphone" bundle:nil];
            self.objSmileViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objSmileViewController.view];
        }
        else
        {
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [self.objSmileViewController.view removeFromSuperview];
                
                self.objSmileViewController=[[SmileViewController alloc] initWithNibName:@"SmileViewController_iphone" bundle:nil];
                self.objSmileViewController.tagId=sharedAppDelegate.strSelectedTagId;
                
                [rightInnerView addSubview:self.objSmileViewController.view];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }
        
        
        
    }
    
}
-(void)showFavoriteView
{
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objFavoriteViewController.view removeFromSuperview];
        
        self.objFavoriteViewController=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController_iphone" bundle:nil];
        
        self.objFavoriteViewController.tagId=@"";
        [rightInnerView addSubview:self.objFavoriteViewController.view];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [self.objFavoriteViewController.view removeFromSuperview];
            
            self.objFavoriteViewController=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController_iphone" bundle:nil];
            self.objFavoriteViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objFavoriteViewController.view];
        }
        else
        {
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [self.objFavoriteViewController.view removeFromSuperview];
                
                self.objFavoriteViewController=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController_iphone" bundle:nil];
                self.objFavoriteViewController.tagId=sharedAppDelegate.strSelectedTagId;
                
                [rightInnerView addSubview:self.objFavoriteViewController.view];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            
        }
        
        
    }
    
    
}
-(void)showSettingView
{
    [self.objSettingViewController.view removeFromSuperview];
    
    self.objSettingViewController=[[SettingViewController alloc] initWithNibName:@"SettingViewController_iphone" bundle:nil];
    
    [rightInnerView addSubview:self.objSettingViewController.view];
    
}
-(void)showFormListView
{
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objFormListViewController.view removeFromSuperview];
        
        self.objFormListViewController=[[FormListViewController alloc] initWithNibName:@"FormListViewController_iphone" bundle:nil];
        
        self.objFormListViewController.tagId=@"";
        [rightInnerView addSubview:self.objFormListViewController.view];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [self.objFormListViewController.view removeFromSuperview];
            
            self.objFormListViewController=[[FormListViewController alloc] initWithNibName:@"FormListViewController_iphone" bundle:nil];
            
            self.objFormListViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objFormListViewController.view];
        }
        else
        {
            
            [self.objFormListViewController.view removeFromSuperview];
            
            self.objFormListViewController=[[FormListViewController alloc] initWithNibName:@"FormListViewController_iphone" bundle:nil];
            
            self.objFormListViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objFormListViewController.view];
            
            
        }
        
        
    }
    
/*if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objFormFolderListViewController.view removeFromSuperview];
        
        self.objFormFolderListViewController=[[FormFolderListViewController alloc] initWithNibName:@"FormFolderListViewController_iphone" bundle:nil];
        
        self.objFormFolderListViewController.tagId=@"";
        [rightInnerView addSubview:self.objFormFolderListViewController.view];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [self.objFormFolderListViewController.view removeFromSuperview];
            
            self.objFormFolderListViewController=[[FormFolderListViewController alloc] initWithNibName:@"FormFolderListViewController_iphone" bundle:nil];
            
            self.objFormFolderListViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objFormFolderListViewController.view];
        }
        else
        {
            
            [self.objFormFolderListViewController.view removeFromSuperview];
            
            self.objFormFolderListViewController=[[FormFolderListViewController alloc] initWithNibName:@"FormFolderListViewController_iphone" bundle:nil];
            
            self.objFormFolderListViewController.tagId=sharedAppDelegate.strSelectedTagId;
            
            [rightInnerView addSubview:self.objFormFolderListViewController.view];
            
            
        }
        
        
    }*/

}
-(void)showUpdateStatusView
{
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objUpdateStatusView removeFromSuperview];
        [self.objUpdateStatusView setHidden:FALSE];
        
        self.objUpdateStatusView =[[UpdateStatusView_iphone alloc] initWithStatusArray:nil withDelegate:self];
        
        [self.objUpdateStatusView setFrame:CGRectMake(objUpdateStatusView.frame.origin.x, objUpdateStatusView.frame.origin.y, 675, 670)];
        
        
        [rightInnerView addSubview:self.objUpdateStatusView];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [self.objUpdateStatusView removeFromSuperview];
            [self.objUpdateStatusView setHidden:FALSE];
            
            self.objUpdateStatusView =[[UpdateStatusView_iphone alloc] initWithStatusArray:nil withDelegate:self];
            
            [self.objUpdateStatusView setFrame:CGRectMake(objUpdateStatusView.frame.origin.x, objUpdateStatusView.frame.origin.y, 675, 670)];
            
            
            [rightInnerView addSubview:self.objUpdateStatusView];
        }
        else
        {
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [self.objUpdateStatusView removeFromSuperview];
                [self.objUpdateStatusView setHidden:FALSE];
                
                self.objUpdateStatusView =[[UpdateStatusView_iphone alloc] initWithStatusArray:nil withDelegate:self];
                
                [self.objUpdateStatusView setFrame:CGRectMake(self.objUpdateStatusView.frame.origin.x, self.objUpdateStatusView.frame.origin.y, 675, 670)];
                
                
                [rightInnerView addSubview:self.objUpdateStatusView];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            
        }
        
    }
    
}
-(void)showUploadView
{
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objUploadDocVC.view removeFromSuperview];
        
        self.objUploadDocVC=[[UploadDocVC alloc] initWithNibName:@"UploadDocVC_iphone" bundle:nil];
        
        [rightInnerView addSubview:self.objUploadDocVC.view];
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [self.objUploadDocVC.view removeFromSuperview];
            
            self.objUploadDocVC=[[UploadDocVC alloc] initWithNibName:@"UploadDocVC_iphone" bundle:nil];
            
            [rightInnerView addSubview:self.objUploadDocVC.view];
            
        }
        else
        {
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [self.objUploadDocVC.view removeFromSuperview];
                
                self.objUploadDocVC=[[UploadDocVC alloc] initWithNibName:@"UploadDocVC_iphone" bundle:nil];
                
                [rightInnerView addSubview:self.objUploadDocVC.view];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}


-(void)updateUnreadMessage{
    
    if(sharedAppDelegate.unreadMsgCount > 0){
        [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadMsgCount] forState:UIControlStateNormal];
        [btnChatCount setHidden:FALSE];
    }
    else{
        sharedAppDelegate.unreadMsgCount = 0;
        [btnChatCount setHidden:TRUE];
    }
}


-(void)showMessageView
{
    [self.objMessagesListVC.view removeFromSuperview]; ////omprakash
  //  sharedAppDelegate.unreadMsgCount=0;
  //  [btnChatCount setHidden:TRUE];
    self.objMessagesListVC=[[MessagesListVC alloc] initWithNibName:@"MessagesListVC_iphone" bundle:nil];
    [rightInnerView addSubview:self.objMessagesListVC.view];
    
}
-(void)showChatView
{
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objChatDetailVC.view removeFromSuperview];
        
        self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
        
        self.objChatDetailVC.msgListSelected = FALSE;
        self.objChatDetailVC.backBtnVisibility=@"NO";
        
        sharedAppDelegate.unreadMsgCount=0;
        [btnChatCount setHidden:TRUE];
        
        self.objChatDetailVC.cData =sharedAppDelegate.contactObj;
        [rightInnerView addSubview:self.objChatDetailVC.view];
        
        
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [self.objChatDetailVC.view removeFromSuperview];
            
            self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
            
            
            self.objChatDetailVC.msgListSelected = FALSE;
            self.objChatDetailVC.cData =sharedAppDelegate.contactObj;
            sharedAppDelegate.checkSpecialGroupChat=@"0";
            self.objChatDetailVC.backBtnVisibility=@"NO";
            sharedAppDelegate.unreadGroupChatCount=0;
            [btnChatCount setHidden:TRUE];
            [rightInnerView addSubview:self.objChatDetailVC.view];
        }
        else
        {
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [self.objChatDetailVC.view removeFromSuperview];
                
                self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
                
                self.objChatDetailVC.msgListSelected = FALSE;
                self.objChatDetailVC.cData =sharedAppDelegate.contactObj;
                sharedAppDelegate.checkSpecialGroupChat=@"0";
                self.objChatDetailVC.backBtnVisibility=@"NO";
                sharedAppDelegate.unreadSpecialGroupChatCount=0;
                sharedAppDelegate.unreadGroupChatCount=0;

                [btnChatCount setHidden:TRUE];
                [rightInnerView addSubview:self.objChatDetailVC.view];
                
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            
        }
        
    }
}
-(void)showReimbursementsView
{
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [self.objReimbursementsViewController.view removeFromSuperview];
        
        self.objReimbursementsViewController=[[ReimbursementsViewController alloc] initWithNibName:@"ReimbursementsViewController_iphone" bundle:nil];
        self.objReimbursementsViewController.tagId=@"";
        self.objReimbursementsViewController.checkClockin=@"0";
        
        [rightInnerView addSubview:self.objReimbursementsViewController.view];
        
        
    }
    else
    {
        //if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        [self.objReimbursementsViewController.view removeFromSuperview];
        
        self.objReimbursementsViewController=[[ReimbursementsViewController alloc] initWithNibName:@"ReimbursementsViewController_iphone" bundle:nil];
        self.objReimbursementsViewController.tagId=sharedAppDelegate.strSelectedTagId;
        
        if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
            
            self.objReimbursementsViewController.checkClockin=@"1";
        }
        else
        {
            self.objReimbursementsViewController.checkClockin=@"0";
            
        }
        
        [rightInnerView addSubview:self.objReimbursementsViewController.view];
        
        /* }
         else
         {
         if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
         
         [objReimbursementsViewController.view removeFromSuperview];
         
         objReimbursementsViewController=[[ReimbursementsViewController alloc] initWithNibName:@"ReimbursementsViewController_iphone" bundle:nil];
         objReimbursementsViewController.tagId=sharedAppDelegate.strSelectedTagId;
         
         [rightInnerView addSubview:objReimbursementsViewController.view];
         
         
         }
         else
         {
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         }
         
         }*/
        
    }
    
    
    
    
}
-(void)showFormButtonView
{
    [self.objFormButtonViewController.view removeFromSuperview];
    self.objFormButtonViewController=[[FormButtonViewController alloc] initWithNibName:@"FormButtonViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objFormButtonViewController.view];
    
}
-(void)showAllTagsView
{
    [self.objAllTagsViewController.view removeFromSuperview];
    self.objAllTagsViewController=[[AllTagsViewController alloc] initWithNibName:@"AllTagsViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objAllTagsViewController.view];
    
}
-(void)showScheduleButtonView
{
    [self.objSchedulButtonViewController.view removeFromSuperview];
    self.objSchedulButtonViewController=[[SchedulButtonViewController alloc] initWithNibName:@"SchedulButtonViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objSchedulButtonViewController.view];
    
}
-(void)showAllPeopleView
{
    [self.objAllPeopleViewController.view removeFromSuperview];
    self.objAllPeopleViewController=[[AllPeopleViewController alloc] initWithNibName:@"AllPeopleViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objAllPeopleViewController.view];
    
}
-(void)showContactView
{
    [sharedAppDelegate.acContactsVC.view removeFromSuperview];
    [btnContactNotificationCount setHidden:TRUE];
    
    sharedAppDelegate.unreadContactCount=0;
    [rightInnerView addSubview:sharedAppDelegate.acContactsVC.view];
}
-(void)showAllHappyFacePostView
{
    [self.objAllHappyFacePostViewController.view removeFromSuperview];
    self.objAllHappyFacePostViewController=[[AllHappyFacePostViewController alloc] initWithNibName:@"AllHappyFacePostViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objAllHappyFacePostViewController.view];
    
}
-(void)showAllSadFacePostView
{
    [self.objAllSadFacePostViewController.view removeFromSuperview];
    self.objAllSadFacePostViewController=[[AllSadFacePostViewController alloc] initWithNibName:@"AllSadFacePostViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objAllSadFacePostViewController.view];
    
}

-(void)showManagerReimbursementView
{
    [self.objManagerReimbursementViewController.view removeFromSuperview];
    self.objManagerReimbursementViewController=[[ManagerReimbursementViewController alloc] initWithNibName:@"ManagerReimbursementViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objManagerReimbursementViewController.view];
    
}
-(void)showUserFormListView
{
    [self.objUserCompletedFormViewController.view removeFromSuperview];
    self.objUserCompletedFormViewController=[[UserCompletedFormViewController alloc] initWithNibName:@"UserCompletedFormViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objUserCompletedFormViewController.view];
    
}
-(void)showTagFormListView
{
    [self.objCompletedTagFormViewController.view removeFromSuperview];
    self.objCompletedTagFormViewController=[[CompletedTagFormViewController alloc] initWithNibName:@"CompletedTagFormViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objCompletedTagFormViewController.view];
    
}
-(void)showAllPostToShareView
{
    [self.objUpdateSharePostViewController.view removeFromSuperview];
    self.objUpdateSharePostViewController=[[UpdateSharePostViewController alloc] initWithNibName:@"UpdateSharePostViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objUpdateSharePostViewController.view];
    
}
-(void)showAllDeletePostView
{
    [self.objDeletePostViewController.view removeFromSuperview];
    self.objDeletePostViewController=[[DeletePostViewController alloc] initWithNibName:@"DeletePostViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objDeletePostViewController.view];
    
}
-(void)showUploadManagerDocView
{
    //    [objUploadDropBoxFileViewController.view removeFromSuperview];
    //    objUploadDropBoxFileViewController=[[UploadDropBoxFileViewController alloc] initWithNibName:@"UploadDropBoxFileViewController_iphone" bundle:nil];
    //    [rightInnerView addSubview:objUploadDropBoxFileViewController.view];
    
    [self.objUploadDocVC.view removeFromSuperview];
    
    self.objUploadDocVC=[[UploadDocVC alloc] initWithNibName:@"UploadDocVC_iphone" bundle:nil];
    
    [rightInnerView addSubview:self.objUploadDocVC.view];
    
}
-(void)showMadFormView
{
    [self.objMadFormViewController.view removeFromSuperview];
    self.objMadFormViewController=[[MadFormViewController alloc] initWithNibName:@"MadFormViewController_iphone" bundle:nil];
    [rightInnerView addSubview:self.objMadFormViewController.view];
    
}
-(IBAction)btnBackPackPressed:(id)sender
{
    self.objBackPackViewCOntroller=[[BackPackViewController alloc] initWithNibName:@"BackPackViewController_iphone" bundle:nil];
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {

        [rightInnerView addSubview:self.objBackPackViewCOntroller.view];

    }
    else
    {
        self.objBackPackViewCOntroller.tagId=sharedAppDelegate.strSelectedTagId;


        if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
        
            [rightInnerView addSubview:self.objBackPackViewCOntroller.view];

        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
