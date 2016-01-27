//
//  MadFormViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 07/04/15.
//
//

#import <UIKit/UIKit.h>

@class EditMadFormViewController;

@interface MadFormViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UIScrollView *scrollView;

    EditMadFormViewController *objEditMadFormViewController;
    UIPopoverController *popoverController;
    UIPopoverController *clockOutPopoverController;
}

@property (retain, nonatomic) NSString *fileName;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnPdfAction:(id)sender;

@end
