//
//  UploadBackPackViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import "UploadBackPackViewController.h"
#import "UIImageExtras.h"
#import "DropBoxManager.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface UploadBackPackViewController ()

@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) UIPopoverController* popover;

@end

@implementation UploadBackPackViewController

@synthesize checkUpload,popover,imgData;
@synthesize tagId,arrFolderList,folderId,imagePickerController,imagePickerView,masterView,dbManager,strExtension;


- (void)viewDidLoad {
    [super viewDidLoad];
    sharedAppDelegate.dropBoxContentD=nil;
    
    actionButton =nil;
    
    self.arrFolderList=[[NSMutableArray alloc] init];
    self.arrFileList=[[NSMutableArray alloc] init];
    
    fileView.layer.cornerRadius=5;
    fileView.clipsToBounds=YES;
    
    fieldsArray = [[NSArray alloc] initWithObjects:txtTitle,txtSelectFolder,nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFroDropBoxList) name: AC_DROPBOX_UPDATE object:nil];
    
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnImagePressed:(id)sender
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
        UIActionSheet *normalActionSheet;
        
        normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select any resource to upload file:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"DropBox",@"Choose from file",nil];
        
        self.activeSheet = normalActionSheet;
        self.activeSheet.tag = AC_ACTIONSHEET_SELECT_RESOURCE;
    }
    [self.activeSheet showFromRect:((UIButton*)sender).frame inView:[sender superview] animated:YES];
    
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)updateFroDropBoxList
{
    
    NSLog(@"%@",sharedAppDelegate.dropBoxContentD);
    
    self.imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[sharedAppDelegate.dropBoxContentD objectForKey:@"url"]]];
    
    NSString* extension = [sharedAppDelegate.dropBoxContentD valueForKey:@"extension"];
    
    self.strExtension=extension;
    
    if([DROPBOX_IMAGE_EXTENSION rangeOfString:extension].length>0 ){
        
        checkUpload=@"image";
        
        [btnImage setImage:[UIImage imageWithData:self.imgData] forState:UIControlStateNormal];
        
    }
    else if ([DROPBOX_VIDEO_EXTENSION rangeOfString:extension].length>0){
        
        checkUpload=@"video";
        
        [btnImage setImage:[UIImage imageNamed:@"video_thumb"] forState:UIControlStateNormal];
        
    }
    else if([DROPBOX_DOC_EXTENSION rangeOfString:extension].length>0 || [DROPBOX_TEXT_EXTENSION rangeOfString:extension].length>0){
        
        checkUpload=@"doc";
        
        [btnImage setImage:[UIImage imageNamed:@"document_thumb.png"] forState:UIControlStateNormal];
        
    }
    
}
-(IBAction)btnUploadPressed:(id)sender
{
    txtTitle.text = [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (txtTitle.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please enter title"];
    }
    else
    {
        
        if(imgData.length<=0)
        {
            [ConfigManager showAlertMessage:nil Message:@"Please select image"];
            
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:txtTitle.text forKey:@"title"];
            [dict setObject:self.folderId forKey:@"folder_id"];
            
            [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dict setObject:@"attachment" forKey:@"attachment_key"];
            [dict setObject:@"uploadBackpackMedia" forKey:@"request_path"];
            
            if ([self.checkUpload isEqualToString:@"image"]) {
                
                [dict setObject:[NSString stringWithFormat:@"%@.%@",@"image",self.strExtension] forKey:@"filename"];
                [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
                
            }
            else if([self.checkUpload isEqualToString:@"video"])
            {
                [dict setObject:[NSString stringWithFormat:@"%@.%@",@"video",self.strExtension] forKey:@"filename"];
                [dict setObject:[NSString stringWithFormat:@"%d",2] forKey:@"content_type"];
                
            }
            else
            {
                [dict setObject:[NSString stringWithFormat:@"%@.%@",@"docfile",self.strExtension] forKey:@"filename"];
                [dict setObject:[NSString stringWithFormat:@"%d",3] forKey:@"content_type"];
                
            }
            
            
            if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
                
                
            }
            else
            {
                [dict setObject:self.tagId forKey:@"tag_id"];
                
            }
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            
            [[AmityCareServices sharedService] AddPicInvocation:dict pic:imgData delegate:self];
        }
        
        
    }
    
}
-(IBAction)btnCrossAction:(id)sender
{
    [fileView removeFromSuperview];
}
-(IBAction)btnCreateFolderAction:(id)sender
{
    folderAlert = [[UIAlertView alloc] initWithTitle:nil
                                             message:@"Please enter folder name"
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Continue", nil];
    [folderAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    txtFolderAlert =nil;
    txtFolderAlert=[folderAlert textFieldAtIndex:0];
    txtFolderAlert.keyboardType = UIKeyboardTypeDefault;
    [folderAlert show];
    
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
            
            checkUpload=@"image";
            
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
            checkUpload=@"video";
            
            
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
            checkUpload=@"image";
            
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
            
            checkUpload=@"video";
            
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
    else if(alertView==folderAlert)
    {
        if (buttonIndex==1) {
            
            NSString *inputText = [[folderAlert textFieldAtIndex:0] text];
            
            if ([inputText length]>0) {
                
                if([ConfigManager isInternetAvailable]){
                    
                    inputText= [inputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    inputText = [inputText stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@"_"];
                    
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                    [dic setObject:inputText forKey:@"folderName"];
                    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
                        
                        
                    }
                    else
                    {
                        [dic setObject:self.tagId forKey:@"tag_id"];
                        
                    }
                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Creating Folder" width:200];
                    [[AmityCareServices sharedService] CreateFolderInvocation:dic delegate:self];
                    
                    
                }
                else{
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            
        }
        
    }
    
}
#pragma mark- UIALERTVIEW

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView==folderAlert) {
        
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return YES;
    }
    
}

#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_SELECT_RESOURCE)
    {
        
        if(buttonIndex==0){
            //camera
            if (nil == self.activeSheet)
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select File" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select Picture",@"Select Video", nil];
                alert.tag=101;
                [alert show];
                
            }
            
        }
        else if(buttonIndex==1){
            //gallery
            if (nil == self.activeSheet)
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select File" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select Picture",@"Select Video", nil];
                alert.tag=102;
                [alert show];
                
            }
            
            [self.activeSheet showFromRect:actionButton.frame inView:[actionButton superview]  animated:YES];
            
        }
        else if(buttonIndex==2)
        {
            if (IS_DEVICE_IPAD) {
                
                self.dbManager=[[DropBoxManager alloc] initWithNibName:@"DropBoxManager~ipad" bundle:nil];
            }
            else
            {
                self.dbManager=[[DropBoxManager alloc] initWithNibName:@"DropBoxManager" bundle:nil];
                
            }
            self.dbManager.checkView=@"backpack";
            
            [self.view addSubview:self.dbManager.view];
            
        }
        else
        {
            if([ConfigManager isInternetAvailable]){
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
                
                [self.arrFileList removeAllObjects];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                
                [[AmityCareServices sharedService] ChooseBackpackFileInvocation:dic delegate:self];
                
            }
            
        }
        
    }
    /*else if(actionSheet.tag == AC_ACTIONSHEET_UPLOAD_FROM_CAMERA)
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
     
     self. imagePickerView = self.imagePickerController.view;
     
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
     
     imagePickerView.frame = cameraViewFrame;
     
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
     
     [self.view addSubview:imagePickerView];
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
     
     [self.view addSubview:imagePickerView];
     // [self presentViewController:imagePickerController animated:YES completion:nil];
     }    }
     }*/
}

#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imgData=nil;
    
    NSString *mType = [info valueForKey:UIImagePickerControllerMediaType];
    
    if([mType isEqualToString:@"public.image"])
    {
        checkUpload=@"image";
        
        self.strExtension=@"jpg";
        
        UIImage *image = [((UIImage*)[info objectForKey:UIImagePickerControllerEditedImage]) imageByScalingAndCroppingForSize:CGSizeMake(600, 600)] ;
        
        self.imgData=(UIImageJPEGRepresentation(image, 0.50)) ;
        
        [btnImage setImage:image forState:UIControlStateNormal];
        
    }
    else if([mType isEqualToString:@"public.movie"]){
        
        checkUpload=@"video";
        
        self.strExtension=@"mp4";
        
        NSURL *url = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        
        self.imgData=[NSData dataWithContentsOfURL:url] ;
        
        [btnImage setImage:[UIImage imageNamed:@"video_thumb"] forState:UIControlStateNormal];
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [imagePickerView removeFromSuperview];
        
        
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

-(void)AddPicInvocationDidFinish:(AddPicInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSDictionary *msgDic=[dict valueForKey:@"response"];
        NSLog(@"%@",msgDic);
        
        NSString* strSuccess = NULL_TO_NIL([msgDic objectForKey:@"success"]);
        
        NSString* strMessage = NULL_TO_NIL([msgDic objectForKey:@"message"]);
        
        NSLog(@"%@",strSuccess);
        NSLog(@"%@",strMessage);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_BACKPACK_UPDATE object:nil];
            
            [self.view removeFromSuperview];
            
            successAlert=[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:strMessage];
            
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
    
}
-(void)CreateFolderInvocationDidFinish:(CreateFolderInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    if (!error) {
        
        NSDictionary *msgDic=[dict valueForKey:@"response"];
        NSLog(@"%@",msgDic);
        
        NSString* strSuccess = NULL_TO_NIL([msgDic objectForKey:@"success"]);
        
        NSString* strMessage = NULL_TO_NIL([msgDic objectForKey:@"message"]);
        
        NSLog(@"%@",strSuccess);
        NSLog(@"%@",strMessage);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [ConfigManager showAlertMessage:nil Message:strMessage];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:strMessage];
            
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
-(void)FolderListInvocationDidFinish:(FolderListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    
    NSLog(@"%@",dict);
    [self.arrFolderList removeAllObjects];
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* folderArray = NULL_TO_NIL([response valueForKey:@"backpackFolder"]);
            
            NSLog(@"%@",folderArray);
            
            for (int i=0; i< [folderArray count]; i++) {
                
                NSDictionary *fDict = [folderArray objectAtIndex:i];
                
                NSString *folderIdStr =[NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"id"])];
                NSString *folderTitleStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"title"])];
                
                [self.arrFolderList addObject:[NSDictionary dictionaryWithObjectsAndKeys:folderIdStr,@"id",folderTitleStr,@"title",nil]];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        if ([self.arrFolderList count]>0) {
            
            [self showFolderPicker];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Folder list is empty"];
        }
        
        [DSBezelActivityView removeView];
    }
    
    
    //
    
    
}
-(void)ChooseBackpackFileInvocationDidFinish:(ChooseBackpackFileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    [self.arrFileList removeAllObjects];
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* folderArray = NULL_TO_NIL([response valueForKey:@"attachement"]);
            
            NSLog(@"%@",folderArray);
            
            for (int i=0; i< [folderArray count]; i++) {
                
                NSDictionary *fDict = [folderArray objectAtIndex:i];
                
                NSString *folderTitleStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"file"])];
                
                NSString *folderTypeStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"type"])];
                
                
                [self.arrFileList addObject:[NSDictionary dictionaryWithObjectsAndKeys:folderTitleStr,@"file",folderTypeStr,@"type",nil]];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        if ([self.arrFileList count]>0) {
            
            [self showFileView];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"File list is empty"];
        }
        
        [DSBezelActivityView removeView];
    }
    
    
}
#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrFileList count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenitifier = @"cell";
    
    UITableViewCell *cell = [tblFileView dequeueReusableCellWithIdentifier:cellIdenitifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenitifier];
    }
    
    cell.textLabel.text = [[self.arrFileList objectAtIndex:indexPath.row] objectForKey:@"file"];
    
    cell.textLabel.numberOfLines=2;
    
    cell.textLabel.font=[UIFont systemFontOfSize:13.0];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",attachmentFileImageURL,[[self.arrFileList objectAtIndex:indexPath.row] objectForKey:@"file"]];
    
    
    NSString* fileExtension = [[[[self.arrFileList objectAtIndex:indexPath.row] objectForKey:@"file"] componentsSeparatedByString:@"."] lastObject];
    
    
    self.strExtension=fileExtension;
    
    if([DROPBOX_IMAGE_EXTENSION rangeOfString:fileExtension].length>0 ){
        
        checkUpload=@"image";
        
        
    }
    else if ([DROPBOX_VIDEO_EXTENSION rangeOfString:fileExtension].length>0){
        
        checkUpload=@"video";
        
        
    }
    else if([DROPBOX_DOC_EXTENSION rangeOfString:fileExtension].length>0 || [DROPBOX_TEXT_EXTENSION rangeOfString:fileExtension].length>0){
        
        checkUpload=@"doc";
        
        
    }
    
    
    [self performSelector:@selector(setImage:) withObject:urlStr afterDelay:0.1];
    
}
-(void)setImage:(NSString*)url
{
    
    self.imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    if([checkUpload isEqualToString:@"image"] ){
        
        [btnImage setImage:[UIImage imageWithData:self.imgData] forState:UIControlStateNormal];
        
    }
    else if ([checkUpload isEqualToString:@"video"]){
        
        
        [btnImage setImage:[UIImage imageNamed:@"video_thumb"] forState:UIControlStateNormal];
        
    }
    else{
        
        [btnImage setImage:[UIImage imageNamed:@"document_thumb.png"] forState:UIControlStateNormal];
        
    }
    
    
    
    [DSBezelActivityView removeView];
    
    [fileView removeFromSuperview];
    
}
#pragma mark----------
#pragma mark- PickerView delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

{
    return [self.arrFolderList count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

{
    
    return [[self.arrFolderList objectAtIndex:row] objectForKey:@"title"];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
}
#pragma mark----------
#pragma mark- IBActions

-(void)resignTextField
{
    [txtSelectFolder resignFirstResponder];
    [txtTitle resignFirstResponder];
    
}
#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        
        [self scrollViewToCenterOfScreen:textField];
        [textField setInputAccessoryView:keyboardtoolbar];
        
        if(DEVICE_OS_VERSION_7_0)
        {
            keyboardtoolbar.barStyle = UIBarStyleDefault;
            
        }
        for (int n=0; n<[fieldsArray count]; n++)
        {
            if ([fieldsArray objectAtIndex:n]==textField)
                
            {
                if (n==[fieldsArray count]-2)
                {
                    [barButton setStyle:UIBarButtonItemStyleDone];
                }
            }
        }
        
        
    }
    
    
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        if (textField) {
            [textField resignFirstResponder];
            
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
        }
        
    }
    
    return YES;
}

- (IBAction) next
{
    for (int n=0; n<[fieldsArray count]; n++)
    {
        if ([[fieldsArray objectAtIndex:n] isEditing] && n!=[fieldsArray count]-1)
        {
            
            [[fieldsArray objectAtIndex:n+1] becomeFirstResponder];
            
            if (n+1==[fieldsArray count]-1)
            {
                [barButton setTitle:@"Done"];
                [barButton setStyle:UIBarButtonItemStyleDone];
            }else
            {
                [barButton setTitle:@"Done"];
                [barButton setStyle:UIBarButtonItemStyleDone];
            }
            
            break;
        }
        
    }
}

- (IBAction) previous
{
    for (int n=0; n<[fieldsArray count]; n++)
    {
        
        if ([[fieldsArray objectAtIndex:n] isEditing]&& n!=0)
        {
            
            [[fieldsArray objectAtIndex:n-1] becomeFirstResponder];
            [barButton setTitle:@"Done"];
            [barButton setStyle:UIBarButtonItemStyleDone];
            
            break;
        }
        
    }
}

- (IBAction) dismissKeyboard:(id)sender
{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextField];
    
}

-(IBAction) slideFrameUp:(UITextField *)textField
{
    if (textField.tag == 3) {
        value = 1;
    }
    else if(textField.tag == 4) {
        value = 2;
    }
    else if(textField.tag == 5) {
        value = 3;
    }
    [self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
    [self slideFrame:NO];
}
-(void) slideFrame:(BOOL) up
{
    NSLog(@"11111");
    
    if(value == 1){
        
        NSLog(@"2222");
        
        
        movementDistance = 70;
        movementDuration = 0.3f;
    }
    else if(value == 2) {
        movementDistance = 120;
        movementDuration = 0.3f;
    }
    else if(value == 3){
        movementDistance = 210;
        movementDuration = 0.3f;
    }
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==txtSelectFolder)
    {
        [self.view endEditing:YES];
        
        if([ConfigManager isInternetAvailable]){
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
                
                
            }
            else
            {
                [dic setObject:self.tagId forKey:@"tag_id"];
                
            }
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Creating Folder" width:200];
            [[AmityCareServices sharedService] FolderListInvocation:dic delegate:self];
            
            
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
        
        
        return NO;
    }
    else
        return YES;
    
    
}
-(void)showFileView
{
    [fileView removeFromSuperview];
    
    if (IS_DEVICE_IPAD) {
        
        [fileView setFrame:CGRectMake(btnImage.frame.origin.x-70, btnImage.frame.origin.y+100, fileView.frame.size.width, fileView.frame.size.height)];
        
    }
    else
    {
        [fileView setFrame:CGRectMake(btnImage.frame.origin.x-60, btnImage.frame.origin.y+50, fileView.frame.size.width, fileView.frame.size.height)];
        
    }
    
    [self.view addSubview:fileView];
    
    [tblFileView reloadData];
}
-(void)showFolderPicker
{
    [self resignTextField];
    
    self.masterView = [[UIView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [self.masterView setFrame:CGRectMake(0, txtSelectFolder.frame.origin.y-260, 320, 260)];
    }
    else
    {
        if (IS_IPHONE_5) {
            
            [self.masterView setFrame:CGRectMake(0, 180+IPHONE_FIVE_FACTOR, 275, 260)];
            
        }
        else
        {
            [self.masterView setFrame:CGRectMake(0, 180, 275, 260)];
            
        }
        
    }
    
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:@"Folders"];
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.masterView addSubview:pickerToolbar];
    
    CGRect pickerFrame ;
    
    if (IS_DEVICE_IPAD) {
        
        pickerFrame = CGRectMake(0, 40, 320, 216);
    }
    else
    {
        pickerFrame = CGRectMake(0, 40,275, 216);
        
    }
    
    myPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    [myPicker setDataSource: self];
    [myPicker setDelegate: self];
    myPicker.tag=1;
    [myPicker setBackgroundColor:[UIColor whiteColor]];
    [myPicker selectRow:0 inComponent:0 animated:NO];
    [myPicker setShowsSelectionIndicator:YES];
    [self.masterView addSubview:myPicker];
    
    if (IS_DEVICE_IPAD) {
        
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        viewController.view = self.masterView;
        viewController.preferredContentSize = viewController.view.frame.size;
        popover =[[UIPopoverController alloc] initWithContentViewController:viewController];
        [popover presentPopoverFromRect:txtSelectFolder.bounds
                                 inView:txtSelectFolder
               permittedArrowDirections:UIPopoverArrowDirectionDown
                               animated:YES];
    }
    else
    {
        [self.view addSubview:self.masterView];
    }
}
- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    
    CGRect frame;
    
    if (IS_DEVICE_IPAD) {
        
        frame = CGRectMake(0, 0, 320, 44);
    }
    else
    {
        frame = CGRectMake(0, 0, 275, 44);
    }
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [self createButtonWithType:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [barItems addObject:flexSpace];
    if (title){
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
    
}
- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    [toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
    toolBarItemlabel.text = aTitle;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
    return buttonLabel;
    
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
    
}
- (IBAction)actionPickerDone:(id)sender {
    
    
    [txtSelectFolder setText:[[self.arrFolderList objectAtIndex:[myPicker selectedRowInComponent:0]]objectForKey:@"title"]];
    
    self.folderId=[[self.arrFolderList objectAtIndex:[myPicker selectedRowInComponent:0]]objectForKey:@"id"];
    
    
    if (IS_DEVICE_IPAD) {
        
        if (popover && popover.popoverVisible)
            [popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        [self resignTextField];
        
        [masterView removeFromSuperview];
    }
    
}
- (IBAction)actionPickerCancel:(id)sender {
    
    if (IS_DEVICE_IPAD) {
        
        if (popover && popover.popoverVisible)
            [popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self resignTextField];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        [self.masterView removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
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
