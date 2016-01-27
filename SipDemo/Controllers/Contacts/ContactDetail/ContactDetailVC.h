//
//  ContactDetailVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 22/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallingView.h"
#import "ContactD.h"

@interface ContactDetailVC : UIViewController<CallingViewDelegate>
{
    IBOutlet UIView *containerView;
    IBOutlet UIImageView* imgViewProfile;
    IBOutlet UILabel* lblUserName;
    IBOutlet UIButton* btnFreeCALL;
    IBOutlet UIButton* btnFreeTEXT;
}
@property (nonatomic,strong) CallingView *callingView;
@property (nonatomic,strong) ContactD *cObj;
-(IBAction)freeCALLAction:(id)sender;
-(IBAction)freeTEXTAction:(id)sender;
@end
