//
//  EditTagIntroViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/10/14.
//
//

#import <UIKit/UIKit.h>
#import "EditTagIntroInvocation.h"

@interface EditTagIntroViewController : UIViewController <UITextViewDelegate,EditTagIntroInvocationDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextView *txtView;
    
    IBOutlet UIButton *btnSubmit;
    IBOutlet UIButton *btnCancel;
    
}

@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSString *intro;

- (void)scrollViewToCenterOfScreen:(UIView *)theView;

-(IBAction)btnSubmitPressed:(id)sender;
-(IBAction)btnCancelPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnDoneAction:(id)sender;

@end
