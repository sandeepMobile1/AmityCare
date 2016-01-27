//
//  ContactDetailVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 22/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ContactDetailVC.h"
#import "UIImageView+WebCache.h"
#import "ChatDetailVC.h"

@interface ContactDetailVC ()

@end

@implementation ContactDetailVC
@synthesize cObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    [self viewLayouts];
 
    [self fillDetails];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
       // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- --------

-(void)fillDetails
{
    [imgViewProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largeThumbImageURL,cObj.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    lblUserName.text = cObj.userName;
}

-(void)viewLayouts
{
    lblUserName.font = [UIFont fontWithName:boldfontName size:20.0f];
    btnFreeCALL.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    btnFreeTEXT.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
}

-(CallingView*)AC_CallingView
{
    if(!_callingView){
       //_callingView = [[CallingView alloc] initWithFrame:sharedAppDelegate.window.bounds delegate:self];
    }
    return _callingView;
}

#pragma mark- TopNavigation
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- IBActions

-(IBAction)freeCALLAction:(id)sender
{
    CallingView *c = [self AC_CallingView];
    [sharedAppDelegate.window addSubview:c.view];
}

-(IBAction)freeTEXTAction:(id)sender
{
    ChatDetailVC * chatView;
    
    if (IS_DEVICE_IPAD) {
        
        chatView = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
    }
    else
    {
        chatView = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
    }
    
    chatView.msgListSelected = FALSE;
    chatView.cData = cObj;
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark- CallingViewDelegate
-(void)muteBtnDidClicked:(id)sender
{
    
}

-(void)transferCallBtnDidClicked:(id)sender
{
    
}

-(void)speakerBtnDidClicked:(id)sender
{
    
}

-(void)contactsBtnDidClicked:(id)sender
{
    
}

-(void)hello
{
    //[_callingView removeFromSuperview];
    _callingView = nil;
}

-(void)callEndDidClicked:(id)sender
{
    [self performSelector:@selector(hello) withObject:nil afterDelay:0.3f];
}
#pragma mark orientation delegates

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    
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
            sharedAppDelegate.isPortrait=NO;
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            sharedAppDelegate.isPortrait=YES;
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}

@end
