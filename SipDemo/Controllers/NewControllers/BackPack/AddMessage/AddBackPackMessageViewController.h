//
//  AddBackPackMessageViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <UIKit/UIKit.h>
#import "AddMessageInvocation.h"

@interface AddBackPackMessageViewController : UIViewController <UITextViewDelegate,AddMessageInvocationDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextView *txtDesc;
    IBOutlet UIScrollView *scrollView;
    UIAlertView *successAlert;
}
@property(nonatomic,strong)NSString *tagId;

-(IBAction)AddMessagePressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
