//
//  ChatDetailVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ChatDetailVC.h"
#import "ReciverCell.h"
#import "SenderCell.h"
#import "QSStrings.h"
#import "PDFCell.h"
#import "PDFVC.h"
#import "ImageReciverCell.h"
#import "ImageSenderCell.h"
#import "AudioRecieverCell.h"
#import "AudioSenderCell.h"
#import "UIImageExtras.h"
#import "UIImageView+WebCache.h"

@interface ChatDetailVC ()<SendMessageInvocationDelegate,ChatDetailInvocationDelegate,DeleteMsgInvocationDelegate>

@end

@implementation ChatDetailVC
@synthesize cData;
@synthesize mData;
@synthesize msgListSelected,arrChatData,recorderFilePath,popover,selectedRowIndexPath,checkChatType,uploadedFileName,backBtnVisibility,containerView,pvc,textView,largeImgView,zoomView,imagePickerController,imagePickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    checkPN=@"YES";
    
    
    if (IS_DEVICE_IPAD) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }}
- (void)viewDidLoad
{
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
    
   
    
    self.arrChatData = [[NSMutableArray alloc] init];
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    
    if(IS_DEVICE_IPAD)
    {
        if (sharedAppDelegate.isPortrait) {
            
            if(DEVICE_OS_VERSION_7_0)
                self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 418, 50)]; //(0, self.view.frame.size.height - 98, 320, 50)
            else
                self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 418, 50)]; //0, self.view.frame.size.height - 50, 320, 50
            
            self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(77, 3, self.view.frame.size.width-113, 50)];
            entryImageView.frame = CGRectMake(77, 0, self.view.frame.size.width-113, 45);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        else
        {
            if(DEVICE_OS_VERSION_7_0)
                self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 675, 50)]; //(0, self.view.frame.size.height - 98, 320, 50)
            else
                self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 675, 50)]; //0, self.view.frame.size.height - 50, 320, 50
            
            self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(77, 3, self.view.frame.size.width-113, 50)];
            entryImageView.frame = CGRectMake(77, 0, self.view.frame.size.width-113, 45);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        
        
    }
    else
    {
        if(DEVICE_OS_VERSION_7_0)
            self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 275, 50)]; //(0, self.view.frame.size.height - 98, 320, 50)
        else
            self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 275, 50)]; //0, self.view.frame.size.height - 50, 320, 50
        
        self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(77, 3, self.view.frame.size.width-113, 50)];
        
        entryImageView.frame = CGRectMake(77, 0, self.view.frame.size.width-113, 45);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 6;
    self.textView.returnKeyType = UIReturnKeyDefault; //just as an example
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.containerView];
    
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background] ;
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:self.textView];
    [self.containerView addSubview:entryImageView];
    
    UIImage *AudioBtnBackground = [[UIImage imageNamed:@"audio"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedAudioBtnBackground = [[UIImage imageNamed:@"audio"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    audioBtn.frame = CGRectMake(2, 5, 35, 35);
    [audioBtn addTarget:self action:@selector(audioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [audioBtn setBackgroundImage:AudioBtnBackground forState:UIControlStateNormal];
    [audioBtn setBackgroundImage:selectedAudioBtnBackground forState:UIControlStateSelected];
    [self.containerView addSubview:audioBtn];
    
    
    UIImage *KeyBoardBtnBackground = [[UIImage imageNamed:@"Keyboard"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedKeyBoardBtnBackground = [[UIImage imageNamed:@"Keyboard"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBoardBtn.frame = CGRectMake(2, 5, 35, 35);
    [keyBoardBtn addTarget:self action:@selector(keyBoardBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [keyBoardBtn setBackgroundImage:KeyBoardBtnBackground forState:UIControlStateNormal];
    [keyBoardBtn setBackgroundImage:selectedKeyBoardBtnBackground forState:UIControlStateSelected];
    [self.containerView addSubview:keyBoardBtn];
    
    
    // containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    UIImage *ImageBtnBackground = [[UIImage imageNamed:@"camera"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedImageBtnBackground = [[UIImage imageNamed:@"camera"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(40, 5, 35, 35);
    [imageBtn addTarget:self action:@selector(imageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [imageBtn setBackgroundImage:ImageBtnBackground forState:UIControlStateNormal];
    [imageBtn setBackgroundImage:selectedImageBtnBackground forState:UIControlStateSelected];
    [self.containerView addSubview:imageBtn];
    
    // containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    
    UIImage *HoldToTalkBtnBackground = [[UIImage imageNamed:@"HoldToTalk"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedHoldToTalkBtnBackground = [[UIImage imageNamed:@"HoldToTalk"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    HoldToTalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    HoldToTalkBtn.frame = CGRectMake(self.textView.frame.origin.x-1, self.textView.frame.origin.y+5, self.view.frame.size.width-115, self.textView.frame.size.height+1);
    [HoldToTalkBtn setTitle:@"Hold To Talk" forState:UIControlStateNormal];
    [HoldToTalkBtn setTitle:@"Release To Send" forState:UIControlStateHighlighted];
    [HoldToTalkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [HoldToTalkBtn setBackgroundImage:HoldToTalkBtnBackground forState:UIControlStateNormal];
    HoldToTalkBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [HoldToTalkBtn setBackgroundImage:selectedHoldToTalkBtnBackground forState:UIControlStateSelected];
    [self.containerView addSubview:HoldToTalkBtn];
    
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.cancelsTouchesInView = NO;
    [HoldToTalkBtn addGestureRecognizer:longPress];
    
    [keyBoardBtn setHidden:TRUE];
    [audioBtn setHidden:FALSE];
    [HoldToTalkBtn setHidden:TRUE];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"send.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"send.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 40, 5, 35, 35);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font =[UIFont fontWithName:appfontName size:15.0];
    
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    [self.containerView addSubview:doneBtn];
    
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    if ([backBtnVisibility isEqualToString:@"NO"]) {
        
        [btnBack setHidden:TRUE];
    }
    else
    {
        [btnBack setHidden:FALSE];
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        imgLoadingView=[[UIImageView alloc] initWithFrame:CGRectMake(20, containerView.frame.origin.y-35, 200, 21)];
        
    }
    else
    {
        imgLoadingView=[[UIImageView alloc] initWithFrame:CGRectMake(20, containerView.frame.origin.y-35, 200, 21)];
        
    }
    [imgLoadingView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imgLoadingView];
    [imgLoadingView setHidden:FALSE];
    
    // [self performSelector:@selector(requetForChatDetails) withObject:nil afterDelay:0.1];
    
    [btnGroupChatCount setHidden:TRUE];
    [btnSpecialChatCount setHidden:TRUE];
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [segment setHidden:TRUE];
        
        
    }
    else
    {
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [segment setHidden:FALSE];
            
            if (sharedAppDelegate.unreadSpecialGroupChatCount>0) {
                
                [btnSpecialChatCount setHidden:FALSE];
                
                [btnSpecialChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadSpecialGroupChatCount] forState:UIControlStateNormal];
            }
            else
            {
                [btnSpecialChatCount setHidden:TRUE];
            }
            
            if (sharedAppDelegate.unreadGroupChatCount>0) {
                
                [btnGroupChatCount setHidden:FALSE];
                
                [btnGroupChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
            }
            else
            {
                [btnSpecialChatCount setHidden:TRUE];
            }
        }
        else
        {
            [segment setHidden:TRUE];
            
        }
        
    }
    
    [self performSelectorOnMainThread:@selector(requetForChatDetails) withObject:nil waitUntilDone:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:AC_USER_MESSAGE_RECIEVE object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name: AC_USER_UNREAD_BADGE_UPDATE object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveBackgroundNotification:(NSNotification*) note{
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSLog(@"%@",notification);
        
        NSString* nType = [notification valueForKeyPath:@"aps.type"];
        
        if (nType==nil || nType==(NSString*)[NSNull null] || [nType isEqualToString:@""]) {
            
        }
        else
        {
            
            if ([nType isEqualToString:@"chat"] || [nType isEqualToString:@"groupchat"] || [nType isEqualToString:@"specialchat"]) {
                
                NSString* member_id = self.msgListSelected?self.mData.sender_id:self.cData.userid;
                
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    NSString* nUserId = [notification valueForKeyPath:@"aps.senderId"];
                    NSLog(@"nUserId %@",nUserId);
                    NSLog(@"member_id %@",member_id);
                    
                    if (nUserId==nil || nUserId==(NSString*)[NSNull null] || [nUserId isEqualToString:@""]) {
                        
                    }
                    else
                    {
                        if ([nUserId isEqualToString:member_id]) {
                            
                            //  [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"fetching chat history..." width:200];
                            
                            // [[AmityCareServices sharedService] getChatDetailInvocation:sharedAppDelegate.userObj.userId withMemId:member_id delegate:self];
                            
                            [self performSelectorOnMainThread:@selector(requetForChatDetails) withObject:nil waitUntilDone:YES];
                            
                        }
                        
                    }
                    
                    
                }
                else
                {
                    NSString* nGroupId = [notification valueForKeyPath:@"aps.tagId"];
                    
                    NSLog(@"nGroupId %@",nGroupId);
                    NSLog(@"strSelectedTagId %@",sharedAppDelegate.strSelectedTagId);
                    
                    if (nGroupId==nil || nGroupId==(NSString*)[NSNull null] || [nGroupId isEqualToString:@""]) {
                        
                    }
                    else
                    {
                        
                        if ([nGroupId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                            
                            if ([nType isEqualToString:@"specialchat"] && [sharedAppDelegate.checkSpecialGroupChat isEqualToString:@"1"]) {
                                
                                // [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"fetching chat history..." width:200];
                                
                                //[[AmityCareServices sharedService] GroupChatDetailInvocation:sharedAppDelegate.userObj.userId tagId:sharedAppDelegate.strSelectedTagId delegate:self];
                                
                                [self performSelectorOnMainThread:@selector(requetForChatDetails) withObject:nil waitUntilDone:YES];
                                
                            }
                            else if ([nType isEqualToString:@"groupchat"] && [sharedAppDelegate.checkSpecialGroupChat isEqualToString:@"0"]) {
                                
                                // [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"fetching chat history..." width:200];
                                
                                [self performSelectorOnMainThread:@selector(requetForChatDetails) withObject:nil waitUntilDone:YES];
                                
                                // [[AmityCareServices sharedService] GroupChatDetailInvocation:sharedAppDelegate.userObj.userId tagId:sharedAppDelegate.strSelectedTagId delegate:self];
                            }
                            
                            
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
}
-(void)setBadgeValue:(NSNotification*) note
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                NSString* nType = [notification valueForKeyPath:@"aps.type"];
                
                if ([nType isEqualToString:@"specialchat"]) {
                    
                    if (sharedAppDelegate.unreadSpecialGroupChatCount>0) {
                        
                        
                        if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                            
                            [btnSpecialChatCount setHidden:FALSE];
                            
                            [btnSpecialChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadSpecialGroupChatCount] forState:UIControlStateNormal];
                            
                        }
                        else
                        {
                            [btnSpecialChatCount setHidden:TRUE];
                        }
                    }
                    else
                    {
                        [btnSpecialChatCount setHidden:TRUE];
                        
                    }
                    
                }
                
                else if ([nType isEqualToString:@"groupchat"]) {
                    
                    if (sharedAppDelegate.unreadGroupChatCount>0) {
                        
                        [btnGroupChatCount setHidden:FALSE];
                        [btnGroupChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btnGroupChatCount setHidden:TRUE];
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
}
-(void)requetForChatDetails{
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"fetching chat history..." width:200];
        
        NSString* member_id = self.msgListSelected?self.mData.sender_id:self.cData.userid;
        
        if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
            
            [[AmityCareServices sharedService] getChatDetailInvocation:sharedAppDelegate.userObj.userId withMemId:member_id delegate:self];
        }
        else
        {
            if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                if (segment.selectedSegmentIndex==0) {
                    
                    sharedAppDelegate.checkSpecialGroupChat=@"0";
                }
                else
                {
                    sharedAppDelegate.checkSpecialGroupChat=@"1";
                    
                }
            }
            else
            {
                sharedAppDelegate.checkSpecialGroupChat=@"0";
            }
                [[AmityCareServices sharedService] GroupChatDetailInvocation:sharedAppDelegate.userObj.userId tagId:sharedAppDelegate.strSelectedTagId delegate:self];
        }
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)segmentAction:(id)sender
{
    tblChatDetail.delegate=nil;
    tblChatDetail.dataSource=nil;
    
    [self.arrChatData removeAllObjects];
    
    if (segment.selectedSegmentIndex==0) {
        
        sharedAppDelegate.checkSpecialGroupChat=@"0";
        sharedAppDelegate.unreadGroupChatCount=0;
        [btnGroupChatCount setHidden:TRUE];
    }
    else
    {
        sharedAppDelegate.checkSpecialGroupChat=@"1";
        sharedAppDelegate.unreadSpecialGroupChatCount=0;
        [btnSpecialChatCount setHidden:TRUE];
        
    }
    tblChatDetail.delegate=self;
    tblChatDetail.dataSource=self;
    
    [self performSelectorOnMainThread:@selector(requetForChatDetails) withObject:nil waitUntilDone:YES];
}
-(IBAction)audioBtnPressed:(id)sender
{
    [HoldToTalkBtn setHidden:FALSE];
    [self.textView setHidden:TRUE];
    [audioBtn setHidden:TRUE];
    [keyBoardBtn setHidden:FALSE];
}
-(IBAction)imageBtnPressed:(id)sender
{
    ACAlertView *alert=[[ACAlertView alloc] initWithTitle:@"Select Resource" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Picture", nil];
    alert.tag=102;
    [alert show];
}
-(IBAction)keyBoardBtnPressed:(id)sender
{
    [HoldToTalkBtn setHidden:TRUE];
    [self.textView setHidden:FALSE];
    [audioBtn setHidden:FALSE];
    [keyBoardBtn setHidden:TRUE];
}
-(void) ChatRecieverImageButtonClick:(ImageReciverCell*)cellValue;
{
    NSIndexPath * indexPath = [tblChatDetail indexPathForCell:cellValue];
    
    MessageD *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    [self.zoomView removeFromSuperview];
    
    [self.zoomView setFrame:self.view.frame];
    self.largeImgView.layer.cornerRadius = 5.0f;
    self.largeImgView.clipsToBounds = YES;
    
    [self.largeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largeThumbChatImageURL,data.fileName]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [self.view addSubview:self.zoomView];
    
}
-(void) ChatSenderImageButtonClick:(ImageSenderCell*)cellValue
{
    NSIndexPath * indexPath = [tblChatDetail indexPathForCell:cellValue];
    
    MessageD *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    [self.zoomView removeFromSuperview];
    
    [self.zoomView setFrame:self.view.frame];
    self.largeImgView.layer.cornerRadius = 5.0f;
    self.largeImgView.clipsToBounds = YES;
    
    [self.largeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largeThumbChatImageURL,data.fileName]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [self.view addSubview:self.zoomView];
}

-(IBAction)btnCloseLargeImgViewAction:(id)sender
{
    [self.zoomView removeFromSuperview];
}
- (void)handleLongPress:(UILongPressGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        [imgLoadingView setHidden:TRUE];
        
        [self performSelectorOnMainThread:@selector(stopRecording) withObject:nil waitUntilDone:YES];
        
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        
        [imgLoadingView setHidden:FALSE];
        
        loadingCounter=1;
        
        [self performSelectorOnMainThread:@selector(startRecording) withObject:nil waitUntilDone:YES];
        
    }
    
}

- (void) startRecording
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    // Create a new dated file
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    self.recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [self documentsDirectoryPath ], caldate];
    
    NSURL *url = [NSURL fileURLWithPath:self.recorderFilePath];
    err = nil;
    soundRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    soundRecorder.delegate=self;
    soundRecorder.meteringEnabled = YES;
    if(!soundRecorder){
        
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else
    {
        
        audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                      target:self
                                                    selector:@selector(recordingTime)
                                                    userInfo:nil
                                                     repeats:YES];
        
    }
    
    
    [soundRecorder prepareToRecord];
    [soundRecorder record];
    
    
}
-(void)recordingTime {
    
    NSString *img=[NSString stringWithFormat:@"img_%d",loadingCounter];
    [imgLoadingView setImage:[UIImage imageNamed:img]];
    
    loadingCounter=loadingCounter+1;
    
    if (loadingCounter==9) {
        
        loadingCounter=1;
    }
    
}

- (void)stopRecording
{
    [audioTimer invalidate];
    
    [soundRecorder stop];
    
    NSURL *url = [NSURL fileURLWithPath: self.recorderFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    if(!audioData)
        NSLog(@"audio data: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
    
    NSLog(@"%lu",(unsigned long)[audioData length]);
    
    if (audioData.length==0 || audioData==nil) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Audio file not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
       // AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        NSError* error;
        
        [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        if([ConfigManager isInternetAvailable]){
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"audiofile" forKey:@"attachment_key"];
            [dict setObject:@"uploadmedia" forKey:@"request_path"];
            [dict setObject:@"4" forKey:@"type"];
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            [dict setObject:@"audio.mp3" forKey:@"filename"];
            [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
            
            [[AmityCareServices sharedService] UploadChatAudioInvocation:dict data:audioData delegate:self];
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
        
        
    }
}
-(void) ChatSenderAudioButtonClick:(AudioSenderCell*)cellValue
{
    
    NSIndexPath * indexPath = [tblChatDetail indexPathForCell:cellValue];
    MessageD *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if (self.selectedRowIndexPath!=nil) {
        
        NSLog(@"%ld",(long)indexPath.row);
        NSLog(@"%ld",(long)self.selectedRowIndexPath.row);
        
        if (indexPath.row!=self.selectedRowIndexPath.row) {
            
            [audioProgressTimer invalidate];
            audioProgressTimer=nil;
            
            [audioPlayer stop];
            
            [tblChatDetail reloadRowsAtIndexPaths:@[self.selectedRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            self.selectedRowIndexPath=nil;
            
        }
    }
    
    self.selectedRowIndexPath=indexPath;
    
    NSLog(@"%@",self.selectedRowIndexPath);
    
    
    NSURL *url=[NSURL URLWithString:data.fileName];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    NSError* error;
    
    [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
    [audioSession setActive:YES error: nil];
    
    NSLog(@"%@",url);
    
    if (audioPlayer.playing) {
        
        cellValue.btnPlay.selected=NO;
        
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.enabled=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [audioPlayer stop];
    }
    else
    {
        
        cellValue.btnPlay.selected=YES;
        cellValue.audioSlider.enabled = YES;
        
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        [audioPlayer prepareToPlay];
        
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.maximumValue = audioPlayer.duration;
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSenderTime:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
    
    
}
- (void)updateSenderTime:(NSTimer *)timer{
    
    AudioSenderCell *cellValue=[timer userInfo];
    
    cellValue.audioSlider.value = audioPlayer.currentTime;
    
    cellValue.btnPlay.selected=YES;
    
    if (cellValue.audioSlider.value<=0) {
        
        cellValue.btnPlay.selected=NO;
        cellValue.audioSlider.value=0.0;
        cellValue.audioSlider.enabled=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
    }
    
}
-(void) ChatSenderAudioSliderMovedClick:(AudioSenderCell*)cellValue
{
    if (audioPlayer.isPlaying) {
        
        [audioPlayer stop];
        
        NSIndexPath * indexPath = [tblChatDetail indexPathForCell:cellValue];
        MessageD *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        
        NSURL *url=[NSURL URLWithString:data.fileName];
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        //AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        NSError* error;
        
        [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        cellValue.btnPlay.selected=YES;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSenderTime:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
    
    
    else
    {
        cellValue.audioSlider.enabled = NO;
    }
    
}

-(void) ChatRecieverAudioButtonClick:(AudioRecieverCell*)cellValue
{
    
    
    NSIndexPath * indexPath = [tblChatDetail indexPathForCell:cellValue];
    MessageD *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if (self.selectedRowIndexPath!=nil) {
        
        NSLog(@"%ld",(long)indexPath.row);
        NSLog(@"%ld",(long)self.selectedRowIndexPath.row);
        
        if (indexPath.row!=self.selectedRowIndexPath.row) {
            
            [audioProgressTimer invalidate];
            audioProgressTimer=nil;
            
            [audioPlayer stop];
            
            [tblChatDetail reloadRowsAtIndexPaths:@[self.selectedRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            self.selectedRowIndexPath=nil;
            
        }
    }
    
    self.selectedRowIndexPath=indexPath;
    
    NSLog(@"%@",self.selectedRowIndexPath);
    
    NSURL *url=[NSURL URLWithString:data.fileName];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
   // AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSError* error;
    
    [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
    [audioSession setActive:YES error: nil];
    
    NSLog(@"%@",url);
    
    if (audioPlayer.playing) {
        
        cellValue.btnPlay.selected=NO;
        
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.enabled=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [audioPlayer stop];
    }
    else
    {
        
        cellValue.btnPlay.selected=YES;
        cellValue.audioSlider.enabled = YES;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        [audioPlayer prepareToPlay];
        
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.maximumValue = audioPlayer.duration;
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateRecieverTime:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
    
    
}
- (void)updateRecieverTime:(NSTimer *)timer{
    
    AudioRecieverCell *cellValue=[timer userInfo];
    
    cellValue.audioSlider.value = audioPlayer.currentTime;
    
    cellValue.btnPlay.selected=YES;
    
    if (cellValue.audioSlider.value<=0) {
        
        cellValue.btnPlay.selected=NO;
        cellValue.audioSlider.value=0.0;
        cellValue.audioSlider.enabled=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
    }
    
}
-(void) ChatRecieverAudioSliderMovedClick:(AudioRecieverCell*)cellValue
{
    if (audioPlayer.isPlaying) {
        
        [audioPlayer stop];
        
        NSIndexPath * indexPath = [tblChatDetail indexPathForCell:cellValue];
        MessageD *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        
        NSURL *url=[NSURL URLWithString:data.fileName];
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
       // AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        NSError* error;
        
        [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        cellValue.btnPlay.selected=YES;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateRecieverTime:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
    else
    {
        cellValue.audioSlider.enabled = NO;
    }
    
}

-(NSString *)documentsDirectoryPath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [dirPaths objectAtIndex:0];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    return documentPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc
{
    NSLog(@"=====%@==dealloc",[self class]);
    tblChatDetail = nil;
    [self.arrChatData removeAllObjects];
    self.arrChatData = nil;
    textView = nil;
    
    [super dealloc];
}*/


#pragma mark- -----------



-(void)dummyData
{
    for (int i= 0; i< 35; i++) {
        MessageD *m = [[MessageD alloc] init];
        m.msg_date = @"22/03/2014";
        if(i%2==0)
            m.msg_text= @"Could not load oad the menu";
        else if(i%3==0)
            m.msg_text= @"hi..";
        else
            m.msg_text= @"Could not load oad the menu image referenced from a nib in the bundle with identifier com.octalsoftware.icloud Could not load oad the menu image referenced from a nib in the bundle with identifier com.octalsoftware.icloud Could not load oad the menu image referenced from a nib in the bundle with identifier com.octalsoftware.icloud";
        
        m.sender_uname = @"Me";
        [self.arrChatData addObject:m];
    }
}

#pragma mark- NavigationDelegate
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pdfBtnPressed:(UIButton *)sender
{
    MessageD *msg = [self.arrChatData objectAtIndex:sender.tag];
    
    
    
    if (IS_DEVICE_IPAD) {
        
        self.pvc = [[PDFVC alloc] initWithNibName:@"PDFVC" bundle:nil];
    }
    else
    {
        self.pvc = [[PDFVC alloc] initWithNibName:@"PDFVC_iphone" bundle:nil];
    }
    
    self.pvc.fileName = msg.fileName;
    
    [self.view addSubview:self.pvc.view];
    
    //[self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark- -----------
#pragma mark- HPGrowingTextView
-(void)resignTextView
{
    //
    [self.textView resignFirstResponder];
    NSString *str = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([str length] > 0){
        
        self.checkChatType=@"text";
        
        [self requestSendChatText:str chatType:@"1" fileName:@""];
    }
}

- (void)requestSendChatText:(NSString*)message chatType:(NSString*)chatType fileName:(NSString*)fileName{
    
    NSLog(@"%@",message);
    
    NSString* strMemberId = self.msgListSelected?self.mData.sender_id:self.cData.userid;
    
    NSMutableDictionary* dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dictionary setValue:chatType forKey:@"textType"];
    [dictionary setValue:fileName forKey:@"file"];
    [dictionary setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [dictionary setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    
    if (![message isEqualToString:@""]) {
        
        [dictionary setValue:[QSStrings encodeBase64WithString:message ] forKey:@"message"];
        
    }
    
    if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
        
        [dictionary setValue:strMemberId forKey:@"member_id"];
        
    }
    else
    {
        
        [dictionary setValue:sharedAppDelegate.strSelectedTagId forKey:@"tagId"];
        [dictionary setValue:sharedAppDelegate.checkSpecialGroupChat forKey:@"special"];
        
    }
    
    [self performSelectorOnMainThread:@selector(sendChatData:) withObject:dictionary waitUntilDone:YES];
    
}
-(void)sendChatData:(NSMutableDictionary*)dic
{
    if([ConfigManager isInternetAvailable]){
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"sending..." width:150];
        [[AmityCareServices sharedService] SendMessageInvocation:dic delegate:self];
    }
    else{
        [self.textView setText:nil];
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
/*
 -(void)sendBase64Reqeust:(NSString*)path :(NSDictionary*)dictionary
 {
 NSString* strD = [dictionary JSONRepresentation];
 
 NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init] ;
	NSString* url = [NSMutableString stringWithFormat:@"%@%@",urlstring,path];
 
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
 
	NSData *data = [[strD dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO] base64EncodedDataWithOptions:0];
	[request setHTTPBody:data];
 [NSURLConnection connectionWithRequest:request delegate:self];
 }
 
 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
 }
 - (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
 {
 
 }
 
 NSMutableData *mutData;
 - (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
 {
 if(!mutData){
 mutData = [[NSMutableData alloc] init];
 }
 [mutData appendData:data];
 }
 
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection{
 NSLog(@"connectionDidFinishLoading =%@",[[NSString alloc] initWithData:mutData encoding:NSUTF8StringEncoding]);
 NSData* da = [[NSData alloc] initWithBase64EncodedData:mutData options:0];
 NSString* response = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
 
 NSLog(@"response %@",response);
 mutData = nil;
 }
 - (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
 {
 NSLog(@"error  =%@",[error debugDescription]);
 }
 
 */

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    CGRect frame = tblChatDetail.frame;
    if(DEVICE_OS_VERSION_7_0){
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);//52
        tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,tblChatDetail.bounds.size.height-keyboardBounds.size.height);
    }
    else{
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);//52
        tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,tblChatDetail.bounds.size.height-keyboardBounds.size.height);
    } 	// animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect containerFrame = containerView.frame;
    
    CGRect frame = tblChatDetail.frame;
    
    if (IS_DEVICE_IPAD) {
        
        if(DEVICE_OS_VERSION_7_0){
            containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
            tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,796);
        }
        else{
            containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
            tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,796);
        }
        
    }
    else
    {
        if (IS_IPHONE_5) {
            
            if(DEVICE_OS_VERSION_7_0){
                
                containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
                tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,364);
            }
            else{
                
                containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
                tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,364);
            }
            
        }
        else
        {
            if(DEVICE_OS_VERSION_7_0){
                
                containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
                tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,364-IPHONE_FIVE_FACTOR);
            }
            else{
                
                containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
                tblChatDetail.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,364-IPHONE_FIVE_FACTOR);
            }
            
        }
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    containerView.frame = containerFrame;
    [UIView commitAnimations];
    
    
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
    
}

#pragma mark- UIALERTVIEW
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_MSG_CONFIRMATION){
        
        if(buttonIndex==0){
            
            MessageD* msgD = [self.arrChatData objectAtIndex:selectedIndex];
            
            NSMutableDictionary* mdict = [[NSMutableDictionary alloc] init];
            [mdict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            NSString* member_id = self.msgListSelected?self.mData.sender_id:self.cData.userid;
            
            if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                
                [mdict setObject:member_id forKey:@"member_id"];
                
            }
            else
            {
                [mdict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
                
            }
            
            [mdict setObject:msgD.msg_id forKey:@"msg_id"];
            
            if([ConfigManager isInternetAvailable])
            {
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Deleting message..." width:150];
                [[AmityCareServices sharedService] deleteMessageInvocation:mdict delegate:self];
            }
        }
    }
    
    else if(alertView.tag==102)
    {
        
        if(buttonIndex==0)
        {
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
                return;
            }
            //camera
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [popover presentPopoverFromRect:CGRectMake(120, 800, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
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
        else
        {
            //gallery
            if(buttonIndex==1)
            {
                self.imagePickerController = [[UIImagePickerController alloc] init];
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
                self.imagePickerController.delegate = self;
                self.imagePickerController.allowsEditing = YES;
                if (IS_DEVICE_IPAD) {
                    
                    self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                    [popover presentPopoverFromRect:CGRectMake(120, 800, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
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
        
    }
    
}

#pragma mark- UITableViewDataSource Delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        MessageD* msg = [self.arrChatData objectAtIndex:indexPath.row];
        
        NSLog(@"TYpe %@",msg.fileType);
        
        if([msg.msg_type isEqualToString:@"Sender"])
        {
            if ([msg.fileType isEqualToString:@"pdf"])
            {
                static NSString* cellIdentifier = @"PDFCell";
                
                PDFCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(!cell)
                {
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"PDFCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"PDFCell_iphone" owner:self options:Nil];
                    }
                    
                    cell = [arr objectAtIndex:0];
                }
                
                cell.pdfBtn.tag = indexPath.row;
                
                [cell.pdfBtn addTarget:self action:@selector(pdfBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.lblTime.text = msg.msg_display_time;
                
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            else if ([msg.fileType isEqualToString:@"text"])
            {
                static NSString* cellIdentifier = @"ReciverCell";
                ReciverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                
                if(!cell)
                {
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"ReciverCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"ReciverCell_iphone" owner:self options:Nil];
                    }
                    
                    
                    cell = [arr objectAtIndex:0];
                }
                cell.message = msg;//[arrChatData objectAtIndex:indexPath.row];
                return cell;
            }
            else if([msg.fileType isEqualToString:@"image"])
            {
                static NSString* cellIdentifier = @"imageCell";
                
                ImageSenderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(!cell)
                {
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"ImageSenderCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"ImageSenderCell_iphone" owner:self options:Nil];
                    }
                    
                    cell = [arr objectAtIndex:0];
                }
                cell.cellDelegate=self;
                
                cell.message = msg;
                
                cell.btnImage.tag = indexPath.row;
                
                
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }
            else if([msg.fileType isEqualToString:@"audio"])
            {
                static NSString* cellIdentifier = @"audioCell";
                
                AudioSenderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(!cell)
                {
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"AudioSenderCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"AudioSenderCell_iphone" owner:self options:Nil];
                    }
                    
                    cell = [arr objectAtIndex:0];
                }
                cell.message = msg;
                
                cell.btnPlay.tag = indexPath.row;
                cell.audioSlider.value = 0.0;
                
                cell.cellDelegate=self;
                
                //  [cell.btnPlay addTarget:self action:@selector(playBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            else
            {
                return nil;
            }
        }
        else{
            
            if ([msg.fileType isEqualToString:@"pdf"])
            {
                static NSString* cellIdentifier = @"PDFCell";
                PDFCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell)
                {
                    
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"PDFCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"PDFCell_iphone" owner:self options:Nil];
                    }
                    
                    
                    cell = [arr objectAtIndex:0];
                }
                
                cell.pdfBtn.tag = indexPath.row;
                
                [cell.pdfBtn addTarget:self action:@selector(pdfBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblTime.text = msg.msg_display_time;
                
                return cell;
            }
            else if([msg.fileType isEqualToString:@"text"])
            {
                static NSString* cellIdentifier = @"SenderCell";
                
                SenderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell)
                {
                    
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"SenderCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"SenderCell_iphone" owner:self options:Nil];
                    }
                    
                    
                    cell = [arr objectAtIndex:0];
                }
                cell.message = msg;//[arrChatData objectAtIndex:indexPath.row];
                return cell;
                
            }
            else if([msg.fileType isEqualToString:@"image"])
            {
                static NSString* cellIdentifier = @"imageCell";
                
                ImageReciverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(!cell)
                {
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"ImageReciverCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"ImageReciverCell_iphone" owner:self options:Nil];
                    }
                    
                    cell = [arr objectAtIndex:0];
                }
                cell.cellDelegate=self;
                
                cell.message = msg;
                
                cell.btnImage.tag = indexPath.row;
                
                [cell.btnImage setTitle:msg.fileName forState:UIControlStateReserved];
                
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
                
            }
            else if([msg.fileType isEqualToString:@"audio"])
            {
                static NSString* cellIdentifier = @"audioCell";
                
                AudioRecieverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(!cell)
                {
                    NSArray *arr;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"AudioRecieverCell" owner:self options:Nil];
                    }
                    else
                    {
                        arr  = [[NSBundle mainBundle] loadNibNamed:@"AudioRecieverCell_iphone" owner:self options:Nil];
                    }
                    
                    cell = [arr objectAtIndex:0];
                }
                cell.cellDelegate=self;
                cell.message = msg;
                cell.audioSlider.value = 0.0;
                
                cell.btnPlay.tag = indexPath.row;
                cell.audioSlider.tag = indexPath.row;
                
                [cell.btnPlay setTitle:msg.fileName forState:UIControlStateReserved];
                
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else
            {
                return nil;
            }
            
        }
        
        return nil;
    }
    @catch (NSException *exception) {
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrChatData count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        selectedIndex = indexPath.row;
        
        ACAlertView *alertView = [[ACAlertView alloc] initWithTitle:nil message:@"Delete message" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        alertView.alertTag = AC_ALERTVIEW_DELETE_MSG_CONFIRMATION;
        [alertView show];
    }
    
}

#pragma mark- UITableView Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageD* msg = [self.arrChatData objectAtIndex:indexPath.row];
    
    if ([msg.fileType isEqualToString:@"text"])
    {
        float height =[msg.msg_type isEqualToString:@"Sender"]?[SenderCell senderCellHeight:msg]:[ReciverCell recieverCellHeight:msg];
        
        return height;
    }
    else if([msg.fileType isEqualToString:@"image"])
    {
        return 205;
        
    }
    else if([msg.fileType isEqualToString:@"audio"])
    {
        return 80;
        
    }
    else
    {
        return 108;
        
    }
    
}

#pragma mark- Invocation
-(void)sendMessageInvocationDidFinish:(SendMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"sendMessageInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            NSString* strMessage = [response valueForKey:@"message"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                MessageD* msg = [[MessageD alloc] init];
                msg.msg_text = self.textView.text;
                
                msg.sender_id = self.msgListSelected?self.mData.sender_id:self.cData.userid;
                msg.sender_uname = self.msgListSelected?self.mData.sender_uname:self.cData.userName;
                msg.msg_display_time = @"now";
                msg.msg_type = @"Sender";
                msg.fileType = self.checkChatType;
                msg.msg_id = NULL_TO_NIL([response valueForKey:@"msg_id"]);
                
                if ([msg.fileType isEqualToString:@"image"]) {
                    
                    msg.fileName=self.uploadedFileName;
                }
                else if([msg.fileType isEqualToString:@"audio"])
                {
                    if (self.uploadedFileName.length>0) {
                        
                        NSString *audioUrl=[NSString stringWithFormat:@"%@%@",chatAudioUrl,self.uploadedFileName];
                        
                        NSLog(@"%@",audioUrl);
                        
                        NSData *audioData=[NSData dataWithContentsOfURL:[NSURL URLWithString:audioUrl]];
                        
                        NSDate *date2 = [NSDate date];
                        time_t interval1 = (time_t) [date2 timeIntervalSince1970];
                        NSTimeInterval timeInMiliseconds1 = [[NSDate date] timeIntervalSince1970];
                        
                        NSString *timestampStr1= [NSString stringWithFormat:@"%ld%f", interval1,timeInMiliseconds1];
                        NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                        
                        documentsDirectory1=[documentsDirectory1 stringByAppendingPathComponent:timestampStr1];
                        NSString *savedAudioLocalPath = [documentsDirectory1 stringByAppendingFormat:@"%@",@"savedAudio.m3u8"];
                        [audioData writeToFile:savedAudioLocalPath atomically:NO];
                        
                        msg.fileName = savedAudioLocalPath;
                    }
                    else
                    {
                        msg.fileName=@"";
                    }
                }
                
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd/MM/yyyy"];
                NSString* strd = [df stringFromDate:[NSDate date]];
                msg.msg_date = strd;
                
                [self.arrChatData addObject:msg];
                
                [tblChatDetail beginUpdates];
                [tblChatDetail insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:([self.arrChatData count]-1) inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
                [tblChatDetail endUpdates];
                
                NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.arrChatData indexOfObject:[self.arrChatData lastObject]] inSection:0];
                [tblChatDetail scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                [self.textView setText:nil];
                
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                [ConfigManager showAlertMessage:nil Message:strMessage];
            }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}

-(void)deleteMsgInvocationDidFinish:(DeleteMsgInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"deleteMsgInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            id response = NULL_TO_NIL([dict valueForKey:@"response"]);
            NSString *strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length > 0){
                
                [self.arrChatData removeObjectAtIndex:selectedIndex
                 ];
                
                [tblChatDetail beginUpdates];
                [tblChatDetail deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:selectedIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
                [tblChatDetail endUpdates];
                
            }
        }
        else{
            [ConfigManager showAlertMessage:@"Error!!" Message:@"Message not deleted"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception Delete Msg =%@",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}


-(void)chatDetailInvocationDidFinish:(ChatDetailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"chatDetailInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            
            id response = NULL_TO_NIL([dict valueForKey:@"response"]);
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            int unreadCount = [NULL_TO_NIL([response valueForKey:@"unreadCount"]) intValue];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [self.arrChatData removeAllObjects];
                NSArray* arrChat = NULL_TO_NIL([response valueForKey:@"ChatDetail"]);
                if([arrChat count]>0){
                    
                    for (int i=0; i< [arrChat count]; i++) {
                        
                        NSDictionary* cDict = [arrChat objectAtIndex:i];
                        
                        MessageD* m = [[MessageD alloc] init];
                        
                        m.msg_id = NULL_TO_NIL([cDict valueForKey:@"msgid"]);
                        m.msg_display_time = NULL_TO_NIL([cDict valueForKey:@"display_time"]);
                        m.msg_date = NULL_TO_NIL([cDict valueForKey:@"date"]);
                        m.sender_id = NULL_TO_NIL([cDict valueForKey:@"friend_id"]);
                        m.msg_type = NULL_TO_NIL([cDict valueForKey:@"type"]);
                        m.sender_uname = NULL_TO_NIL([cDict valueForKey:@"username"]);
                        m.fileType = NULL_TO_NIL([cDict valueForKey:@"text_type"]);
                        m.individualCount = NULL_TO_NIL([cDict valueForKey:@"individualCount"]);

                        
                        NSString *msgStr=NULL_TO_NIL([cDict valueForKey:@"message"]);
                        
                        msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                        
                        m.msg_text = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                        
                        if ([m.fileType isEqualToString:@"audio"]) {
                            
                            NSString *audioStr=NULL_TO_NIL([cDict valueForKey:@"file"]);
                            
                            if (audioStr.length>0) {
                                
                                NSString *audioUrl=[NSString stringWithFormat:@"%@%@",chatAudioUrl,audioStr];
                                
                                NSLog(@"%@",audioUrl);
                                
                                NSData *audioData=[NSData dataWithContentsOfURL:[NSURL URLWithString:audioUrl]];
                                
                                NSDate *date2 = [NSDate date];
                                time_t interval1 = (time_t) [date2 timeIntervalSince1970];
                                NSTimeInterval timeInMiliseconds1 = [[NSDate date] timeIntervalSince1970];
                                
                                NSString *timestampStr1= [NSString stringWithFormat:@"%ld%f", interval1,timeInMiliseconds1];
                                NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                                
                                documentsDirectory1=[documentsDirectory1 stringByAppendingPathComponent:timestampStr1];
                                NSString *savedAudioLocalPath = [documentsDirectory1 stringByAppendingFormat:@"%@",@"savedAudio.m3u8"];
                                [audioData writeToFile:savedAudioLocalPath atomically:NO];
                                
                                m.fileName = savedAudioLocalPath;
                            }
                            else
                            {
                                m.fileName=@"";
                            }
                        }
                        else
                        {
                            m.fileName= NULL_TO_NIL([cDict valueForKey:@"file"]);
                            
                        }
                        
                        
                        
                        [self.arrChatData addObject:m];
                    }
                }
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                [self.arrChatData removeAllObjects];
            }
            
            //tblChatDetail.delegate=nil;
            // tblChatDetail.dataSource=nil;
            [tblChatDetail reloadData];
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.arrChatData indexOfObject:[self.arrChatData lastObject]] inSection:0];
            [tblChatDetail scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            sharedAppDelegate.unreadMsgCount = unreadCount;
            if(sharedAppDelegate.unreadMsgCount >0 ){
                [[NSNotificationCenter defaultCenter] postNotificationName:AC_UPDATE_MESSAGE_COUNT object:nil userInfo:nil];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}
-(void)GroupChatDetailInvocationDidFinish:(GroupChatDetailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"chatDetailInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            
            id response = NULL_TO_NIL([dict valueForKey:@"response"]);
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            int unreadCount = [NULL_TO_NIL([response valueForKey:@"unreadCount"]) intValue];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [self.arrChatData removeAllObjects];
                NSArray* arrChat = NULL_TO_NIL([response valueForKey:@"ChatDetail"]);
                if([arrChat count]>0){
                    
                    for (int i=0; i< [arrChat count]; i++) {
                        
                        NSDictionary* cDict = [arrChat objectAtIndex:i];
                        
                        MessageD* m = [[MessageD alloc] init];
                        
                        m.msg_id = NULL_TO_NIL([cDict valueForKey:@"msgid"]);
                        m.msg_display_time = NULL_TO_NIL([cDict valueForKey:@"display_time"]);
                        m.msg_date = NULL_TO_NIL([cDict valueForKey:@"date"]);
                        m.sender_id = NULL_TO_NIL([cDict valueForKey:@"friend_id"]);
                        m.msg_type = NULL_TO_NIL([cDict valueForKey:@"type"]);
                        m.sender_uname = NULL_TO_NIL([cDict valueForKey:@"username"]);
                        m.fileType = NULL_TO_NIL([cDict valueForKey:@"text_type"]);
                        m.individualCount = NULL_TO_NIL([cDict valueForKey:@"individualCount"]);

                        NSString *msgStr=NULL_TO_NIL([cDict valueForKey:@"message"]);
                        
                        msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                        
                        m.msg_text = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                        
                        if ([m.fileType isEqualToString:@"audio"]) {
                            
                            NSString *audioStr=NULL_TO_NIL([cDict valueForKey:@"file"]);
                            
                            if (audioStr.length>0) {
                                
                                NSString *audioUrl=[NSString stringWithFormat:@"%@%@",chatAudioUrl,audioStr];
                                
                                NSLog(@"%@",audioUrl);
                                
                                NSData *audioData=[NSData dataWithContentsOfURL:[NSURL URLWithString:audioUrl]];
                                
                                NSDate *date2 = [NSDate date];
                                time_t interval1 = (time_t) [date2 timeIntervalSince1970];
                                NSTimeInterval timeInMiliseconds1 = [[NSDate date] timeIntervalSince1970];
                                
                                NSString *timestampStr1= [NSString stringWithFormat:@"%ld%f", interval1,timeInMiliseconds1];
                                NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                                
                                documentsDirectory1=[documentsDirectory1 stringByAppendingPathComponent:timestampStr1];
                                NSString *savedAudioLocalPath = [documentsDirectory1 stringByAppendingFormat:@"%@",@"savedAudio.m3u8"];
                                [audioData writeToFile:savedAudioLocalPath atomically:NO];
                                
                                m.fileName = savedAudioLocalPath;
                            }
                            else
                            {
                                m.fileName=@"";
                            }
                        }
                        else
                        {
                            m.fileName= NULL_TO_NIL([cDict valueForKey:@"file"]);
                            
                        }
                        
                        
                        
                        [self.arrChatData addObject:m];
                    }
                }
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                [self.arrChatData removeAllObjects];
            }
            
            //tblChatDetail.delegate=nil;
            // tblChatDetail.dataSource=nil;
            [tblChatDetail reloadData];
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.arrChatData indexOfObject:[self.arrChatData lastObject]] inSection:0];
            [tblChatDetail scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            sharedAppDelegate.unreadMsgCount = unreadCount;

            if(sharedAppDelegate.unreadMsgCount >0 ){
                [[NSNotificationCenter defaultCenter] postNotificationName:AC_UPDATE_MESSAGE_COUNT object:nil userInfo:nil];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}
-(void)UploadChatImageInvocationDidFinish:(UploadChatImageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        
        NSString *strSuccess = [response valueForKey:@"success"];
        
        if(strSuccess==nil || strSuccess==(NSString*)[NSNull null] || [strSuccess isEqualToString:@""])
        {
            [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"error"]];
            
        }
        else
        {
            self.checkChatType=@"image";
            self.uploadedFileName=[response valueForKey:@"image"];
            
            [self requestSendChatText:@"" chatType:@"3" fileName:[response valueForKey:@"image"]];
            
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
}
-(void)UploadChatAudioInvocationDidFinish:(UploadChatAudioInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        
        NSString *strSuccess = [response valueForKey:@"success"];
        
        if(strSuccess==nil || strSuccess==(NSString*)[NSNull null] || [strSuccess isEqualToString:@""])
        {
            [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"error"]];
        }
        else
        {
            self.checkChatType=@"audio";
            self.uploadedFileName=[response valueForKey:@"audio"];
            
            [self requestSendChatText:@"" chatType:@"4" fileName:[response valueForKey:@"audio"]];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}
#pragma mark -
#pragma mark - ImagePicker Controller Delegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"attachment" forKey:@"attachment_key"];
    [dict setObject:@"uploadmedia" forKey:@"request_path"];
    [dict setObject:@"3" forKey:@"type"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
    [dict setObject:@"image.jpg" forKey:@"filename"];
    [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
    [[AmityCareServices sharedService] UploadChatImageInvocation:dict data:(UIImageJPEGRepresentation(chosenImage, 0.50)) delegate:self];
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
        
        // [self dismissViewControllerAnimated:YES completion:nil];
        
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
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 675)];
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    
    checkPN=@"NO";
    
 //   [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


@end
