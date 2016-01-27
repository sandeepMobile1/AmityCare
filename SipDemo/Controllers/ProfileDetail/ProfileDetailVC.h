//
//  ProfileDetailVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 10/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class TaskCalenderViewController;

@interface ProfileDetailVC : UIViewController
{
    IBOutlet UIImageView* imgProfilePic;

    IBOutlet UITextField* tfUserId;

    IBOutlet UITextField* tfFirstName;
    IBOutlet UITextField* tfLastName;
    IBOutlet UITextField* tfEmail;
    IBOutlet UITextField* tfPhoneNo;
    IBOutlet UITextField* tfAddress;
    IBOutlet UITextField* tfDefaultEmail;

    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UILabel* lblAboutMe;
    IBOutlet UILabel* lblFname;
    IBOutlet UILabel* lblLname;
    IBOutlet UILabel* lblEmail;
    IBOutlet UILabel* lblPhone;
    IBOutlet UILabel* lblAddr;
    IBOutlet UILabel* lblAbt;
    IBOutlet UIImageView* imgAvailableStatus;
    
}
@property(nonatomic,strong)TaskCalenderViewController *objTaskCalenderViewController;

@property(nonatomic,assign) BOOL userPhotoClicked;
@property(nonatomic,strong) NSString* userid;
@property(nonatomic,assign) BOOL isAvailable;

@property(nonatomic,assign) BOOL checkLocationProfile;

- (IBAction)calederBtnPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
