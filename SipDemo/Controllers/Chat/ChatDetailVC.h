//
//  ChatDetailVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "ContactD.h"
#import "MessageD.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AudioRecieverCell.h"
#import "AudioSenderCell.h"
#import "ImageReciverCell.h"
#import "ImageSenderCell.h"

#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

#import "HPGrowingTextView.h"
#import "UploadChatAudioInvocation.h"
#import "UploadChatImageInvocation.h"
#import "AudioRecieverCell.h"
#import "AudioSenderCell.h"
#import "ImageReciverCell.h"
#import "ImageSenderCell.h"
#import "AudioRecieverCell.h"
#import "AudioSenderCell.h"
#import "GroupChatDetailInvocation.h"

@class AVAudioRecorder;
@class AVAudioSession;
@class AVAudioPlayer;
@class PDFVC;

@interface ChatDetailVC : UIViewController<NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate,AVAudioSessionDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UploadChatImageInvocationDelegate,UploadChatAudioInvocationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AudioRecieverCellDelegate,AudioSenderCellDelegate,ImageReciverCellDelegate,ImageSenderCellDelegate,GroupChatDetailInvocationDelegate>
{
    IBOutlet UITableView* tblChatDetail;
    
    
    NSUInteger selectedIndex;
    UILongPressGestureRecognizer *longPress;

    IBOutlet UIButton *btnBack;
    UIButton *audioBtn;
    UIButton *keyBoardBtn;
    UIButton *HoldToTalkBtn;
    UIButton *imageBtn;
    
    AVAudioRecorder * soundRecorder;
    AVAudioPlayer *audioPlayer;
    NSTimer *audioProgressTimer;
    
    
    
    
    NSString *checkPN;

    UIImageView *imgLoadingView;
    int loadingCounter;
    NSTimer *audioTimer;
    
    IBOutlet UISegmentedControl *segment;
    
    IBOutlet UIButton *btnSpecialChatCount;
    IBOutlet UIButton *btnGroupChatCount;

}
@property(nonatomic,strong)IBOutlet UIView *zoomView;
@property(nonatomic,strong)IBOutlet UIImageView *largeImgView;
@property(nonatomic,strong)HPGrowingTextView *textView;
@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,strong)UIView *imagePickerView;
@property(nonatomic,strong)UIView *containerView;
@property(nonatomic,strong)ContactD* cData;
@property(nonatomic,strong) MessageD* mData;
@property(nonatomic,assign)BOOL msgListSelected;
@property(nonatomic,strong)NSMutableArray* arrChatData;
@property(nonatomic,strong)NSString *recorderFilePath;
@property(nonatomic,strong)NSString *checkChatType;
@property(nonatomic,strong)NSString *uploadedFileName;
@property(nonatomic,strong)NSString *backBtnVisibility;
@property(nonatomic,strong)PDFVC *pvc;
@property (nonatomic, strong) UIPopoverController* popover;
@property(nonatomic,strong)NSIndexPath *selectedRowIndexPath;

-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnCloseLargeImgViewAction:(id)sender;
-(IBAction)segmentAction:(id)sender;

@end
