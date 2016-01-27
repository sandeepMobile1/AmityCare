//
//  PasswordView.h
//  Amity-Care
//
//  Created by Vijay Kumar on 29/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordView;

@protocol PasswordViewDelegate <NSObject>
@optional

-(void)secureCredentialDidSubmitted:(PasswordView*)view;
-(void)secureCredentialDidCancel:(PasswordView*)view;

@end

@interface PasswordView : UIView
{
    IBOutlet UIView *containerView;
    IBOutlet UILabel* lblTitle;
    IBOutlet UITextField* tfEmail;
    IBOutlet UITextField* tfPassword;
    IBOutlet UIButton* btnSubmit, *btnCancel;
    id<PasswordViewDelegate>_delegate;
}

@property(nonatomic,unsafe_unretained)id<PasswordViewDelegate>delegate;
@property(nonatomic,strong)NSString *tagId;

-(IBAction)submitBtnAction:(id)sender;
-(IBAction)cancelBtnAction:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
