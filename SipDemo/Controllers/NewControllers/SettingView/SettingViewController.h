//
//  SettingViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "LogoutInvocation.h"
#import "SettingNotificationInvocation.h"

@class ProfileDetailVC;
@class ProfileViewController;
@class ChangePasswordVC;
@class UpdateAppPinVC;
@class TagAsignViewController;

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate,LogoutInvocationDelegate,UIAlertViewDelegate,SettingNotificationInvocationDelegate>
{
    IBOutlet UITableView *tblView;
    UIPopoverController* popover;
    UISwitch *notificationSwitch;

}
@property(nonatomic,strong)NSMutableArray *arrSettingList;
@property(nonatomic,strong)ProfileDetailVC *objProfileDetailVC;
@property(nonatomic,strong)ProfileViewController *objProfileViewController;
@property(nonatomic,strong)ChangePasswordVC *objChangePasswordVC;
@property(nonatomic,strong)UpdateAppPinVC *objUpdateAppPinVC;
@property(nonatomic,strong)TagAsignViewController *objTagAsignViewController;
@property(nonatomic,strong)MFMailComposeViewController *mailComposer ;
@property(nonatomic,strong)UIView *mailView;


@end
