//
//  UploadDocVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "UploadDocVC.h"
#import "UIImageExtras.h"
#import "UploadMediaFilesVc.h"
#import "DropBoxManager.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface UploadDocVC ()<TopNavigationViewDelegate>
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) UIPopoverController* popover;

@end

@implementation UploadDocVC

@synthesize popover,uploadMediaVc,imagePickerView,imagePickerController,dbManager;

UIButton *actionButton =nil;


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
    
   /* TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
    [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    navigation.lblTitle.text = @"Upload";
    [self.view addSubview:navigation];*/
    
    lblUploadDoc.font = [UIFont fontWithName:appfontName size:15.0];
    btnBrowseDoc.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:18.0];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    }

    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
      //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];

    }
    
  //  self.navigationController.navigationBarHidden = YES;
    
  //  [sharedAppDelegate aGlobalNavigation:[self navigationController]];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc
{
    NSLog(@"%@ dealloc------!!!",[self class]);
    lblUploadDoc = nil;
    btnBrowseDoc = nil;
    
    [super dealloc];
}*/

#pragma mark- NavigationBtn Actions

-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- IBACTIONS
-(IBAction)browseButtonAction:(id)sender
{
    actionButton = (UIButton *)sender;
    [self dismissActionSheets];
    
    if (nil == self.normalActionSheetDelegate)
    {
        self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
        self.normalActionSheetDelegate.normalDelegate = self;
    }
    
    if (nil == self.activeSheet)
    {
        UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select any resource to upload file:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", @"DropBox", nil];
        
        self.activeSheet = normalActionSheet;
        self.activeSheet.tag = AC_ACTIONSHEET_SELECT_RESOURCE;
    }
    [self.activeSheet showFromRect:((UIButton*)sender).frame inView:[sender superview] animated:YES];
}

-(void)dismissActionSheets
{
    if (self.activeSheet)
    {
        if ([self.activeSheet isVisible])
        {
            [self.activeSheet dismissWithClickedButtonIndex:-1 animated:YES];
        }
        self.activeSheet = nil;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
            return;
        }
        if (buttonIndex==0) {
          
                self.imagePickerController = [[UIImagePickerController alloc] init];
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
                self.imagePickerController.delegate = self;
                self.imagePickerController.allowsEditing = YES;
                self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
           
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
              //  [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            }
        
        else if(buttonIndex==1)
        {
                self.imagePickerController = [[UIImagePickerController alloc] init] ;
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
                self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
                self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                self.imagePickerController.videoMaximumDuration = 60.0f;//no. of seconds
                self.imagePickerController.delegate = self;
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                //[self presentViewController:imagePickerController animated:YES completion:nil];
            }
            }
      
    }
    else if(alertView.tag==102)
    {
        if(buttonIndex==0)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            
           


            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
               // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
               self. imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
               // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }

    }

}

#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_SELECT_RESOURCE)
    {
        
        if(buttonIndex==0){
            if (nil == self.activeSheet)
            {
               
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select File" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select Picture",@"Select Video", nil];
                alert.tag=101;
                [alert show];

            }
            
        }
        else if(buttonIndex==1){
            if (nil == self.activeSheet)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select File" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select Picture",@"Select Video", nil];
                alert.tag=102;
                [alert show];
                
            }
            [self.activeSheet showFromRect:actionButton.frame inView:[actionButton superview]  animated:YES];
            
        }
        else if(buttonIndex==2){

            
            if (IS_DEVICE_IPAD) {
               
                self.dbManager=[[DropBoxManager alloc] initWithNibName:@"DropBoxManager~ipad" bundle:nil];
            }
            else
            {
                self.dbManager=[[DropBoxManager alloc] initWithNibName:@"DropBoxManager" bundle:nil];

            }
            self.dbManager.checkView=@"uploadDoc";
            [self.view addSubview:self.dbManager.view];
            //[self.navigationController pushViewController:dbManager animated:YES];
        }
    }
    else if(actionSheet.tag == AC_ACTIONSHEET_UPLOAD_FROM_CAMERA)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
            return;
        }
        if(buttonIndex==0)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
           
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
               // overlay = [[CameraOverlayView alloc] initWithFrame:self.view.bounds];
               
                //[self setOverlayViewModel];
                
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                //[self presentViewController:imagePickerController animated:YES completion:nil];
            }
           
        }
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init] ;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            self.imagePickerController.videoMaximumDuration = 60.0f;//no. of seconds
            self.imagePickerController.delegate = self;
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
               // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
    else if (actionSheet.tag == AC_ACTIONSHEET_UPLOAD_FROM_GALLERY)
    {
        if(buttonIndex==0)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
               // [self presentViewController:imagePickerController animated:YES completion:nil];
            }      }
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
               // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        
        }
    }
}

#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"%@",info);
    
    NSString *mType = [info valueForKey:UIImagePickerControllerMediaType];
    if([mType isEqualToString:@"public.movie"]){
        NSURL *url = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        //NSData* videoData = [NSData dataWithContentsOfURL:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
        
        
        if (IS_DEVICE_IPAD) {
            
            self.uploadMediaVc = [[UploadMediaFilesVc alloc] initWithNibName:@"UploadMediaFilesVc" bundle:nil];
        }
        else
        {
            self.uploadMediaVc = [[UploadMediaFilesVc alloc] initWithNibName:@"UploadMediaFilesVc_iphone" bundle:nil];
        }
        
        self.uploadMediaVc.uploadMedia = uploadMeidaVideoFile;
        self.uploadMediaVc.videoURL = url;
        
        [self.view addSubview:self.uploadMediaVc.view];

      //  [self.navigationController pushViewController:uploadMediaVc animated:YES];
        
    }
    else if([mType isEqualToString:@"public.image"])
    {
        UIImage *image = [((UIImage*)[info objectForKey:UIImagePickerControllerEditedImage]) imageByScalingAndCroppingForSize:CGSizeMake(600, 600)] ;

        
        if (IS_DEVICE_IPAD) {
            
            self.uploadMediaVc = [[UploadMediaFilesVc alloc] initWithNibName:@"UploadMediaFilesVc" bundle:nil];
        }
        else
        {
            self.uploadMediaVc = [[UploadMediaFilesVc alloc] initWithNibName:@"UploadMediaFilesVc_iphone" bundle:nil];
        }
        self.uploadMediaVc.uploadMedia = uploadMeidaImageFile;
        self.uploadMediaVc.imageFile = image;
        
        [self.view addSubview:self.uploadMediaVc.view];
       // [self.navigationController pushViewController:uploadMediaVc animated:YES];
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];

    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
        //[self dismissViewControllerAnimated:YES completion:nil];

    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (IS_DEVICE_IPAD) {
        
        if(self.popover)
        {
            [self.popover dismissPopoverAnimated:YES];
        }
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }
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
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}

@end
