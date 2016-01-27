//
//  ProfileViewController.h
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView* containerView;
    IBOutlet UIImageView* imgProfilePic;
    IBOutlet UIButton* btnAddImage;
    IBOutlet UITextField* tfEmail;

    IBOutlet UITextField* tfFirstName;
    IBOutlet UITextField* tfLastName;
    IBOutlet UITextField* tfContactNo;
    IBOutlet UITextField* tfAddress;
    IBOutlet UITextView* txtvwAboutMe;
    IBOutlet UIButton* btnUpdateProfile;
    IBOutlet UILabel* lblAboutMe;
    
    IBOutlet UIScrollView *scrollView;
    
    UIPickerView *myPicker;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;
    
}
@property(nonatomic,strong)NSString* userid;
@property(nonatomic,assign)BOOL didPicUpdated;
@property(nonatomic,strong)UIView *imagePickerView;
@property(nonatomic,strong)UIImagePickerController *imagePickerController;
-(IBAction)btnAddImageAction:(id)sender;
-(IBAction)btnUpdateProfileAction:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(IBAction)btnBackAction:(id)sender;


@end
