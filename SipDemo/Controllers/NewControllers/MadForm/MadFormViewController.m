//
//  MadFormViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 07/04/15.
//
//

#import "MadFormViewController.h"
#import "EditMadFormViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface MadFormViewController ()

@end

@implementation MadFormViewController

@synthesize webView,fileName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                    
                }
                else
                {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 886)];
                    
                }
            }
            else if([sharedAppDelegate.userObj.role isEqualToString:@"3"])
            {
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                    
                }
                else
                {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 855)];
                    
                }
            }
            /*else if([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"])
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 886)];
                
            }*/
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 675)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }

    /*if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [self.webView setFrame:CGRectMake(0, 54, 320, 510)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                [self.webView setFrame:CGRectMake(0, 54, 320, 510-IPHONE_FIVE_FACTOR)];
                
            }
        }
        else
        {
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [self.webView setFrame:CGRectMake(0, 54, 320, 500)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [self.webView setFrame:CGRectMake(0, 54, 320, 500-IPHONE_FIVE_FACTOR)];
                
            }
        }
        
    }*/
    
    if (IS_DEVICE_IPAD) {
        
        [scrollView setContentSize:CGSizeMake(417, 1200)];
    }
    else
    {
        [self.webView setFrame:CGRectMake(0, 0, 275, 650)];

        [scrollView setContentSize:CGSizeMake(275, 650)];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];

 
    NSString* url = [[NSBundle mainBundle] pathForResource:@"MAR_Forms" ofType:@"pdf"];
    NSLog(@"%@",url);
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
    
   
    // Do any additional setup after loading the view from its nib.
}
-(void)dissmissView
{
    [popoverController dismissPopoverAnimated:YES];
}
-(IBAction)btnPdfAction:(id)sender
{

    if (IS_DEVICE_IPAD) {
        
        NSLog(@"AC_MADFORM_CREATED_UPDATES");
        
        [[NSNotificationCenter defaultCenter] postNotificationName: AC_MADFORM_CREATED_UPDATES object:nil];

    }
    else
    {
        objEditMadFormViewController=[[EditMadFormViewController alloc] initWithNibName:@"EditMadFormViewController_iphone" bundle:nil];
        
        [sharedAppDelegate.window addSubview:objEditMadFormViewController.view];
    }
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        
    }}

-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}

#pragma mark
#pragma mark - IBAction

-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark orientation delegates

- (BOOL)shouldAutorotate {
    
    if (IS_DEVICE_IPAD) {
        
        return YES;
        
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    if (IS_DEVICE_IPAD) {
        
        return UIInterfaceOrientationMaskAll;
        
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            sharedAppDelegate.isPortrait=YES;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            sharedAppDelegate.isPortrait=NO;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}
#pragma mark- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [DSBezelActivityView removeView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [DSBezelActivityView removeView];
    if(error){
        [ConfigManager showAlertMessage:@"Error Loading Page" Message:[error description]];
    }
}

- (void)didReceiveMemoryWarning
{
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
