//
//  PasswordViewIphone.h
//  Amity-Care
//
//  Created by Shweta Sharma on 22/10/14.
//
//

#import <UIKit/UIKit.h>

@class PasswordViewIphone;

@protocol PasswordViewIphoneDelegate <NSObject>
@optional

-(void)secureCredentialDidSubmitted_Iphone:(PasswordViewIphone*)view;
-(void)secureCredentialDidCancel_Iphone:(PasswordViewIphone*)view;

@end

@interface PasswordViewIphone : UIView <UITextFieldDelegate>
{
    IBOutlet UIView *containerView;
    IBOutlet UILabel* lblTitle;
    IBOutlet UITextField* tfEmail;
    IBOutlet UITextField* tfPassword;
    IBOutlet UIButton* btnSubmit, *btnCancel;
    id<PasswordViewIphoneDelegate>_delegate;
}

@property(nonatomic,unsafe_unretained)id<PasswordViewIphoneDelegate>delegate;
@property(nonatomic,strong)NSString *tagId;

-(IBAction)submitBtnAction:(id)sender;
-(IBAction)cancelBtnAction:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
