//
//  InboxDetailViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import "InboxDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+urlDecode.h"
#import "InboxData.h"
#import "ALToastView.h"
#import "Utils.h"

@interface InboxDetailViewController ()

@end

@implementation InboxDetailViewController

@synthesize arrMailData,selectedIndex;

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
    
       // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    /*if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
         
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblView setFrame:CGRectMake(0, 54, 320, 510)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblView setFrame:CGRectMake(0, 54, 320, 510-IPHONE_FIVE_FACTOR)];
                
            }
        }
        else
        {
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblView setFrame:CGRectMake(0, 54, 320, 500)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblView setFrame:CGRectMake(0, 54, 320, 500-IPHONE_FIVE_FACTOR)];
                
            }
        }
        
    }*/
}
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 40.0f;
   
    if(indexPath.row == 4)
    {
        if (IS_DEVICE_IPAD) {
            
            height=650;
        }
        else
        {
            
        
            height = self.view.frame.size.height-160; //340
           

        }
        
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[MailDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InboxData *data = [self.arrMailData objectAtIndex:selectedIndex];
    
    if(indexPath.row == 0)
    {
        cell.lblHeading.text = @"From:";
        CGSize Size = [self getLabelHeight:data.mailFrom];
        CGRect Frame = cell.lblValue.frame;
        cell.lblValue.frame = CGRectMake(Frame.origin.x, Frame.origin.y, Size.width,  Frame.size.height);
        cell.lblValue.text = data.mailFrom;
        cell.lblValue.backgroundColor = MESSAGE_MAIL_TEXT_BACKGROUND_BUBBLE_COLOR;
        cell.lblValue.layer.cornerRadius = 13.0;
        cell.lblValue.layer.masksToBounds = YES;
    }
    else if(indexPath.row == 1)
    {
        cell.lblHeading.text = @"To:";
        CGSize Size = [self getLabelHeight:data.mailFrom];
        CGRect Frame = cell.lblValue.frame;
        cell.lblValue.frame = CGRectMake(Frame.origin.x, Frame.origin.y, Size.width,  Frame.size.height);
        cell.lblValue.text = data.mailTo;
        cell.lblValue.backgroundColor = MESSAGE_MAIL_TEXT_BACKGROUND_BUBBLE_COLOR;
        cell.lblValue.layer.cornerRadius = 13.0;
        cell.lblValue.layer.masksToBounds = YES;
    }
    else if(indexPath.row == 2)
    {
        cell.lblHeading.text = @"Sub:";
        cell.lblValue.text = data.mailSubject;
        cell.lblValue.font = [UIFont boldSystemFontOfSize:13.0f];
    }
    else if(indexPath.row == 3)
    {
        cell.imageView.image = [UIImage imageNamed:@"attachment.png"];
        
        NSLog(@"%@",data.mailAttechment);
        
        cell.lblValue.text = data.mailAttechment!=nil?data.mailAttechment:@"No Attachment";
        cell.lblValue.font = [UIFont boldSystemFontOfSize:13.0f];
    }
    else
    {
        UIWebView *webView;
        
        if (IS_DEVICE_IPAD) {
            
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 450, 620)];
 
        }
        else
        {
            if(IS_IPHONE_5)
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
            else
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 300-IPHONE_FIVE_FACTOR)];
        }
        
        NSLog(@"%@",data.mailMessage);

        
       [webView loadHTMLString:data.mailMessage baseURL:nil];
        webView.dataDetectorTypes = UIDataDetectorTypeNone;
        [webView setDelegate:self];
         webView.scrollView.minimumZoomScale=3.0f;
        webView.scrollView.maximumZoomScale =5.0f;
        webView.scalesPageToFit = YES;

        [cell.contentView addSubview:webView];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        InboxData *mbData = [self.arrMailData objectAtIndex:selectedIndex];
        if(mbData.mailAttechment)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download" message:@"Do you want to download the attachment." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
            [alert show];
        }
    }
}
-(CGSize)getLabelHeight:(NSString *)str
{
    CGSize maximumLabelSize;
    
    if (IS_DEVICE_IPAD) {
        
        maximumLabelSize= CGSizeMake(250,25);

    }
    else
    {
        maximumLabelSize= CGSizeMake(460,25);

    }
    
   // CGSize expectedLabelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect textRect = [str boundingRectWithSize:maximumLabelSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                               context:nil];
    
    CGSize expectedLabelSize = textRect.size;
    
    return expectedLabelSize;
}
#pragma mark- Image & Video Handler
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    @try {
        NSLog(@"Finished saving video with error: %@ %@", error,videoPath);
        if(!error){
            [self removeAttachmentFromDocDir];
            [Utils showAlertMessage:nil Message:@"Attachment saved to gallery"];
        }
        else{
            [Utils showAlertMessage:nil Message:[error localizedDescription]];
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"Finished saving video with error: %@", error);
    
    @try {
        if(!error)
            [Utils showAlertMessage:nil Message:@"Attachment saved to gallery"];
        else
            [Utils showAlertMessage:nil Message:[error localizedDescription]];
        
    }
    @catch (NSException *exception) {
    }
}
-(void)removeAttachmentFromDocDir
{
    @try {
        InboxData *mailData = [self.arrMailData objectAtIndex:self.selectedIndex];
        
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* fileToDownload = mailData.mailAttechment;
        NSString* filePath = [docsDir stringByAppendingPathComponent: fileToDownload];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSError *error =nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if(error)
            {
                NSLog(@"Error while deleting attachment data file =%@",[error description]);
            }
        }
    }
    @catch (NSException *exception) {
    }
}

#pragma mark- UIWebViewDelegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSLog(@"webViewDidFinishLoad");
  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");

}

#pragma mark- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //implement the downloading of the attachment.
        @try {
            InboxData *mailData = [self.arrMailData objectAtIndex:self.selectedIndex];
            [ALToastView toastInView:self.view withText:@"downloading attachment"];
            NSLog(@"encoded string =%@",[mailData.mailAttechment getEncodedData:mailData.mailAttechment]);
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
               
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_MAIL_ATTACHMENT_URL,[mailData.mailAttechment getEncodedData:mailData.mailAttechment]]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if([mailData.mailAttechment rangeOfString:@".mp4"].length>0){
                        
                        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        NSString* fileToDownload = mailData.mailAttechment;
                        NSString* filePath = [docsDir stringByAppendingPathComponent: fileToDownload];
                        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                        {
                            NSError *error =nil;
                            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                            if(error)
                            {
                                NSLog(@"Error while deleting attachment data file =%@",[error description]);
                            }
                        }
                        [data writeToFile: filePath atomically: YES];
                        [ALToastView toastInView:self.view withText:@"File downloaded successfully"];
                        UISaveVideoAtPathToSavedPhotosAlbum (filePath,self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
                    }
                    else {
                        UIImage *image = [UIImage imageWithData:data];
                        [ALToastView toastInView:self.view withText:@"File downloaded successfully"];
                        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    }
                });
            });
        }
        @catch (NSException *exception) {
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
