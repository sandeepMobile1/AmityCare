//
//  FormListVC.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 03/09/14.
//
//

#import "FormListVC.h"
#import "Form.h"
#import "FormsField.h"
#import "ActionSheetPicker.h"
#import "NormalActionSheetDelegate.h"
#import "UIImageExtras.h"
#import "UIImageView+WebCache.h"
#import "RWTItem.h"
#import "IBeaconD.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface FormListVC ()<NormalActionDeledate>

@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;

@end

@implementation FormListVC

@synthesize formElementArr,radioBtnDic,submitDataArr,fileBtnArr,checkMendatory;
@synthesize formNameStr,submitDataDic,imagePickerController,imagePickerView,outputAudioView,signatureView,lowerView,drawingView,permissionView,largeWebView,zoomView;
@synthesize formData;
@synthesize capturedImg,serverDate,canvas,formOutputAudioStr,formOutputImageStr,totalFormArr,formOutputVideoStr,formsArr,formTypeStr,pageIndex,noOfPages;

@synthesize selectedBtn;
@synthesize scrollView,popover;

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
    
    if (IS_DEVICE_IPAD) {
        
        scrollView.layer.cornerRadius=5;
        [scrollView setClipsToBounds:YES];
        
        [scrollView setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    formElementArr = [NSMutableArray new];
    self.submitDataArr  = [NSMutableArray new];
    fileBtnArr     = [NSMutableArray new];
    radioBtnDic    = [NSMutableArray new];
    self.totalFormArr = [NSMutableArray new];
    self.formsArr    = [NSMutableArray new];
    
    localScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.scrollView addGestureRecognizer:tg];
    
    
    [self requestForGetFormDetail];
    // [self designView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    
}
-(void)requestForGetFormDetail
{
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        Form *f = formData;
        
        self.formOutputVideoStr=f.strFormOutputVideo;
        self.formOutputAudioStr=f.strFormOutputAudio;
        self.formOutputImageStr=f.strFormOutputImage;
        self.formTypeStr=f.strFormType;
        
        NSLog(@"%@",self.formTypeStr);
        NSLog(@"%@",self.formOutputImageStr);
        
        [[AmityCareServices sharedService] GetFormDetailInvocation:f.strFormId delegate:self];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    
}

-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
#pragma mark -
#pragma mark - Other Method

- (CGFloat)calculateTextHeight:(NSString *)str andFont:(UIFont *)font
{
    CGSize labelSize;
    
    if (IS_DEVICE_IPAD) {
        
        //        labelSize= [str sizeWithFont:font
        //                   constrainedToSize:CGSizeMake(400, 9999)
        //                       lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [str boundingRectWithSize:CGSizeMake(400, 9999)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil];
        
        labelSize = textRect.size;
    }
    else
    {
        //        labelSize= [str sizeWithFont:font
        //                   constrainedToSize:CGSizeMake(260, 9999)
        //                       lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [str boundingRectWithSize:CGSizeMake(300, 9999)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil];
        
        labelSize = textRect.size;
    }
    
    
    CGFloat labelHeight = labelSize.height;
    return labelHeight;
}
- (CGFloat)calculateRadioTextHeight:(NSString *)str andFont:(UIFont *)font
{
    CGSize labelSize;
    
    if (IS_DEVICE_IPAD) {
        
        //        labelSize= [str sizeWithFont:font
        //                   constrainedToSize:CGSizeMake(350, 9999)
        //                       lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [str boundingRectWithSize:CGSizeMake(350, 9999)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil];
        
        labelSize = textRect.size;
    }
    else
    {
        //        labelSize= [str sizeWithFont:font
        //                   constrainedToSize:CGSizeMake(210, 9999)
        //                       lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [str boundingRectWithSize:CGSizeMake(250, 9999)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil];
        
        labelSize = textRect.size;
    }
    
    
    CGFloat labelHeight = labelSize.height;
    return labelHeight;
}
- (void)convertScrollViewIntoImage
{
    UIGraphicsBeginImageContext(CGSizeMake(530, localScrollView.contentSize.height));
    {
        CGPoint savedContentOffset = localScrollView.contentOffset;
        CGRect savedFrame = localScrollView.frame;
        
        localScrollView.contentOffset = CGPointZero;
        localScrollView.frame = CGRectMake(0, 0, 530, localScrollView.contentSize.height);
        
        [localScrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        capturedImg = UIGraphicsGetImageFromCurrentImageContext();
        
        localScrollView.contentOffset = savedContentOffset;
        localScrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"Path %@",path);
    
}

- (void)designView
{
    yCoordinate = 10;
    
    if (self.formOutputImageStr.length>0) {
        
        [self createOutputImageField:nil];
        
    }
    if (self.formOutputVideoStr.length>0) {
        
        [self createOutputVedioField:nil];
        
    }
    if (self.formOutputAudioStr.length>0) {
        
        [self createOutputAudioField:nil];
        
    }
    
    NSLog(@"%lu",(unsigned long)[self.formsArr count]);
    
    for(int j = 0 ; j < [self.formsArr count]; j++)
    {
        FormsField *ff = [self.formsArr objectAtIndex:j];
        
        if ([ff.strFieldType isEqualToString:@"text"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createTextField:tempDic];
        }
        
        else if ([ff.strFieldType isEqualToString:@"textarea"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createTextView:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"checkbox"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            
            [self createCheckBox:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"radio"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createRadioView:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"file"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createImageView:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"number"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createNumberField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"signature"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createSignatureField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"audio"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createAudioField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"heading"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createHeadingField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"description"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createHeadingField:tempDic];
        }
    }
    
    [self.lowerView setFrame:CGRectMake(0, yCoordinate+25, self.lowerView.frame.size.width, self.lowerView.frame.size.height)];
    
    [self.scrollView addSubview:self.lowerView];
    
    
    // ------------------------- Submit Button -------------------------
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"green_btn"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:cancelBtn];

    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"green_btn"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitBtn];
    
    
    if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
        
        if ([self.formData.strFormRoleId isEqualToString:@"2"]) {
            
            [radioEmployeeBtn setSelected:YES];
            
        }
        else if ([self.formData.strFormRoleId isEqualToString:@"3"]) {
            
            [radioManagerBtn setSelected:YES];
            
        }
        else if ([self.formData.strFormRoleId isEqualToString:@"5"]) {
            
            [radioTLBtn setSelected:YES];
            
        }
        else if ([self.formData.strFormRoleId isEqualToString:@"6"]) {
            
            [radioFamilyBtn setSelected:YES];
            
        }
        else if ([self.formData.strFormRoleId isEqualToString:@"8"]) {
            
            [radioBSBtn setSelected:YES];
            
        }
        yCoordinate=yCoordinate+self.lowerView.frame.size.height;
        
        [self.lowerView setHidden:FALSE];
    }
    else
    {
        [self.lowerView setHidden:TRUE];
        
    }
    
    
    if (IS_DEVICE_IPAD) {
        
        cancelBtn.frame = CGRectMake(120, yCoordinate+50, 180, 60);
        
        submitBtn.frame = CGRectMake(380, yCoordinate+50, 150, 60);

       // submitBtn.frame = CGRectMake(100, yCoordinate+50, 200, 60);
    }
    else
    {
        cancelBtn.frame = CGRectMake(30, yCoordinate+50, 120, 60);
        
        submitBtn.frame = CGRectMake(170, yCoordinate+50, 120, 60);
        //submitBtn.frame = CGRectMake(30, yCoordinate+70, 200, 60);
    }
    
    submitBtn.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, yCoordinate+400)];
    
}
- (void)designMultiView
{
    yCoordinate = 10;
    
    if (self.formOutputImageStr.length>0) {
        
        [self createOutputImageField:nil];
        
    }
    if (self.formOutputVideoStr.length>0) {
        
        [self createOutputVedioField:nil];
        
    }
    if (self.formOutputAudioStr.length>0) {
        
        [self createOutputAudioField:nil];
        
    }
    
    formElementArr=[[NSMutableArray alloc] init];
    
    for(int j = 0 ; j < [[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"data"] count]; j++)
    {
        FormsField *ff = [[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"data"] objectAtIndex:j];
        
        NSLog(@"Type %@",ff.strFieldType);
        NSLog(@"strCSSClass %@",ff.strCSSClass);
        NSLog(@"strFieldRequired %@",ff.strFieldRequired);
        NSLog(@"strFieldValue %@",ff.strFieldValue);
        
        if ([ff.strFieldType isEqualToString:@"text"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createTextField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"textarea"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createTextView:tempDic];
            
        }
        else if ([ff.strFieldType isEqualToString:@"checkbox"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createCheckBox:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"radio"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            
            NSLog(@"%d",j);
            
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            NSLog(@"%@",tempDic);
            
            
            [self createRadioView:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"file"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createImageView:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"number"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createNumberField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"signature"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createSignatureField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"audio"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createAudioField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"heading"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createHeadingField:tempDic];
        }
        else if ([ff.strFieldType isEqualToString:@"description"])
        {
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            [tempDic setObject:ff forKey:@"form"];
            [tempDic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"index"];
            
            [self createHeadingField:tempDic];
        }
        
    }
    
    [self.lowerView setFrame:CGRectMake(0, yCoordinate+25, self.lowerView.frame.size.width, self.lowerView.frame.size.height)];
    
    [self.scrollView addSubview:self.lowerView];
    
    
    // ------------------------- Submit Button -------------------------
    
    
    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn setBackgroundImage:[UIImage imageNamed:@"green_btn"] forState:UIControlStateNormal];
    [prevBtn setTitle:@"PREV" forState:UIControlStateNormal];
    [prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:prevBtn];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"green_btn"] forState:UIControlStateNormal];
    
    [self.scrollView addSubview:submitBtn];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"green_btn"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:cancelBtn];

    
    NSLog(@"%d",pageIndex);
    NSLog(@"%lu",(unsigned long)[self.totalFormArr count]);
    
    if (pageIndex<[self.totalFormArr count]-1) {
        
        [submitBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.lowerView setHidden:TRUE];
        
    }
    else
    {
        [submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
            
            if ([self.formData.strFormRoleId isEqualToString:@"2"]) {
                
                [radioEmployeeBtn setSelected:YES];
                
            }
            else if ([self.formData.strFormRoleId isEqualToString:@"3"]) {
                
                [radioManagerBtn setSelected:YES];
                
            }
            else if ([self.formData.strFormRoleId isEqualToString:@"5"]) {
                
                [radioTLBtn setSelected:YES];
                
            }
            else if ([self.formData.strFormRoleId isEqualToString:@"6"]) {
                
                [radioFamilyBtn setSelected:YES];
                
            }
            else if ([self.formData.strFormRoleId isEqualToString:@"8"]) {
                
                [radioBSBtn setSelected:YES];
                
            }
            yCoordinate=yCoordinate+self.lowerView.frame.size.height;
            
            [self.lowerView setHidden:FALSE];
        }
        else
        {
            [self.lowerView setHidden:TRUE];
            
        }
        
    }
    
    
    
    
    if (pageIndex==0) {
        
        [prevBtn setHidden:TRUE];
        
        if (IS_DEVICE_IPAD) {
            
            cancelBtn.frame = CGRectMake(120, yCoordinate+50, 180, 60);

            submitBtn.frame = CGRectMake(380, yCoordinate+50, 150, 60);

            //submitBtn.frame = CGRectMake(100, yCoordinate+50, 200, 60);
            
        }
        else
        {
            cancelBtn.frame = CGRectMake(30, yCoordinate+50, 120, 60);

            submitBtn.frame = CGRectMake(170, yCoordinate+50, 120, 60);

           // submitBtn.frame = CGRectMake(50, yCoordinate+70, 150, 60);
        }
    }
    else
    {
        [prevBtn setHidden:FALSE];
        
        if (IS_DEVICE_IPAD) {
            
            prevBtn.frame = CGRectMake(120, yCoordinate+50, 180, 60);
            
            submitBtn.frame = CGRectMake(380, yCoordinate+50, 150, 60);
            
        }
        else
        {
            prevBtn.frame = CGRectMake(30, yCoordinate+50, 120, 60);
            
            submitBtn.frame = CGRectMake(170, yCoordinate+50, 120, 60);
        }
    }
    
    submitBtn.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    prevBtn.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, yCoordinate+400)];
    
}

- (void)createTextField:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    NSLog(@"Type %@",ff.strFieldType);
    NSLog(@"strCSSClass %@",ff.strCSSClass);
    NSLog(@"strFieldRequired %@",ff.strFieldRequired);
    NSLog(@"strFieldValue %@",ff.strFieldValue);
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        lblName.text = ff.strFieldValue;
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    
    UITextField *txtFld = [[UITextField alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 650, 30)];
        
    }
    else
    {
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 300, 30)];
        
    }
    
    txtFld.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    txtFld.delegate=self;
    [view addSubview:txtFld];
    [formElementArr addObject:txtFld];
    
    for(int i=0;i<[submitDataArr count];i++)
    {
        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
        
        if ([strLableName isEqualToString:ff.strFieldValue]) {
            
            txtFld.text=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
        }
        
    }
    [radioBtnDic addObject:@""];
    //  [fileBtnArr addObject:@""];
    
    yCoordinate += CGRectGetMaxY(txtFld.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 418, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    
    [self.scrollView addSubview:view];
}
- (void)createTextView:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    NSString *str = @"";
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        lblName.text = ff.strFieldValue;
        
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    UITextView *txtView = [[UITextView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        txtView.frame = CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 650, 80);
        
    }
    else
    {
        txtView.frame = CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 300, 80);
        
    }
    
    txtView.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    txtView.font = [UIFont systemFontOfSize:18];
    [view addSubview:txtView];
    txtView.delegate=self;
    [formElementArr addObject:txtView];
    
    for(int i=0;i<[submitDataArr count];i++)
    {
        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
        
        if ([strLableName isEqualToString:ff.strFieldValue]) {
            
            txtView.text=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
        }
        
    }
    
    [radioBtnDic addObject:@""];
    //  [fileBtnArr addObject:@""];
    
    yCoordinate += CGRectGetMaxY(txtView.frame)+10;;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [self.scrollView addSubview:view];
}
- (void)createImageView:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    yCoordinate += 10;
    
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    
    NSString *str = @"";
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
        lblName.text = ff.strFieldValue;
    
    str=ff.strFieldValue;
    
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame  = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height+10);
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [imgBtn setTag:[[tempDic objectForKey:@"index"] intValue]];
    
    UIImageView *imgBack=[[UIImageView alloc] init];
    [imgBack setBackgroundColor:[UIColor clearColor]];
    [imgBack setUserInteractionEnabled:YES];
    imgBack.image=nil;
    
    if (IS_DEVICE_IPAD) {
        
        imgBtn.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 450);
        imgBack.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 450);
        
    }
    else
    {
        imgBtn.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 260);
        imgBack.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 260);
        
    }
    
    
    [imgBtn setTitle:ff.strFieldValue  forState:UIControlStateReserved];
    for(int i=0;i<[submitDataArr count];i++)
    {
        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
        
        if ([strLableName isEqualToString:ff.strFieldValue]) {
            
            NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",largeThumbOutputImageURL,strLableName]);
            
            [imgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallPostThumbnailImageURL,strLableName]] placeholderImage:[UIImage imageNamed:@"upload.png"]];
            
        }
        
    }
    
    if (imgBack.image==nil) {
        
        imgBtn.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
        
        [imgBtn setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        
    }
    NSMutableArray *radioBtnArr = [NSMutableArray new];
    
    [radioBtnArr addObject:imgBtn];
    
    [radioBtnDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:radioBtnArr,ff.strFieldValue,nil]];
    
    //[radioBtnDic setObject:imgBtn forKey:ff.strFieldValue];
    
    [formElementArr addObject:imgBtn];
    
    if (IS_DEVICE_IPAD) {
        
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 345;
        
    }
    else
    {
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 245;
        
    }
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    
    [view addSubview:imgBack];
    [view addSubview:imgBtn];
    
    [self.scrollView addSubview:view];
}
- (void)createRadioView:(NSMutableDictionary *)tempDic1
{
    FormsField *ff = [tempDic1 objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbSelectOptions = [[UILabel alloc] init];
    [lbSelectOptions setFont:[UIFont systemFontOfSize:20]];
    
    lbSelectOptions.numberOfLines = 0;
    [view addSubview:lbSelectOptions];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    NSString *str;
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strTitle];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lbSelectOptions.attributedText = attrStr;
    }
    else
    {
        lbSelectOptions.text = ff.strTitle;
        str = ff.strTitle;
    }
    
    
    NSLog(@"%@",str);
    CGFloat height = [self calculateTextHeight:str andFont:lbSelectOptions.font];
    lbSelectOptions.frame = CGRectMake(lbSelectOptions.frame.origin.x, lbSelectOptions.frame.origin.y, lbSelectOptions.frame.size.width, height);
    
    float localYCoordiante = CGRectGetMaxY(lbSelectOptions.frame)+15;
    
    NSMutableArray *radioBtnArr = [NSMutableArray new];
    
    for (int i = 0 ; i < [ff.arrValues count]; i++)
    {
        NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
        
        UILabel *lblbtnTitle = [[UILabel alloc] init];
        lblbtnTitle.numberOfLines = 0;
        
        lblbtnTitle.text = [tempDic objectForKey:@"value"];
        [view addSubview:lblbtnTitle];
        
        UIButton *radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:radioBtn];
        [radioBtn setTitle:[tempDic objectForKey:@"value"] forState:UIControlStateReserved];
        
        [radioBtn setTitle:ff.strTitle forState:UIControlStateReserved];
        
        NSLog(@"%@",[tempDic1 objectForKey:@"index"]);
        
        [radioBtn setTag:[[tempDic1 objectForKey:@"index"] intValue]];
        
        if ([self.formTypeStr isEqualToString:@"3"]) {
            
            NSString *urlType=[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"imageUrlType"])];
            
            if ([urlType isEqualToString:@"1"]) {
                
                [radioBtn setTitle:[tempDic objectForKey:@"answerimage"] forState:UIControlStateApplication];
                
                [radioBtn addTarget:self action:@selector(redioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                [radioBtn setTitle:[tempDic objectForKey:@"answerurl"] forState:UIControlStateApplication];
                
                [radioBtn addTarget:self action:@selector(redioBtnVedioPressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            
        }
        else
        {
            [radioBtn addTarget:self action:@selector(redioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
        if ([[tempDic objectForKey:@"baseline"] caseInsensitiveCompare:@"true"] == NSOrderedSame)
            [radioBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        else
            [radioBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
        if (IS_DEVICE_IPAD) {
            
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 600, 20);
            
            radioBtn.frame = CGRectMake(620, localYCoordiante, 30, 30);
            
            
        }
        else
        {
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 250, 20);
            
            radioBtn.frame = CGRectMake(270, localYCoordiante, 30, 30);
            
            
        }
        
        CGFloat height = [self calculateRadioTextHeight:[tempDic objectForKey:@"value"] andFont:lblbtnTitle.font];
        lblbtnTitle.frame = CGRectMake(lblbtnTitle.frame.origin.x, lblbtnTitle.frame.origin.y, lblbtnTitle.frame.size.width, height);
        
        localYCoordiante=CGRectGetMaxY(lblbtnTitle.frame)+15;
        
        for(int i=0;i<[submitDataArr count];i++)
        {
            NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
            
            NSLog(@"%@",strLableName);
            NSLog(@"%@",ff.strTitle);
            
            
            if ([strLableName isEqualToString:ff.strTitle]) {
                
                NSString *strValue=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
                
                NSLog(@"%@",strValue);
                NSLog(@"%@",[tempDic objectForKey:@"value"]);
                
                
                if ([strValue isEqualToString:[tempDic objectForKey:@"value"]]) {
                    
                    [radioBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
                    
                }
            }
            
        }
        
        [radioBtnArr addObject:radioBtn];
        
        
    }
    
    //[radioBtnDic setObject:radioBtnArr forKey:ff.strTitle];
    [radioBtnDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:radioBtnArr,ff.strTitle,nil]];
    
    NSLog(@"%@",radioBtnDic);
    
    //[fileBtnArr addObject:@""];
    
    [formElementArr addObject:[radioBtnArr objectAtIndex:0]];
    
    yCoordinate += localYCoordiante+5;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [self.scrollView addSubview:view];
}
- (void)createCheckBox:(NSMutableDictionary *)tempDic1
{
    FormsField *ff = [tempDic1 objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbSelectOptions = [[UILabel alloc] init];
    [lbSelectOptions setFont:[UIFont systemFontOfSize:20]];
    
    lbSelectOptions.numberOfLines = 0;
    [view addSubview:lbSelectOptions];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    NSString *str;
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strTitle];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lbSelectOptions.attributedText = attrStr;
    }
    else
    {
        lbSelectOptions.text = ff.strTitle;
        
        str = ff.strTitle;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lbSelectOptions.font];
    lbSelectOptions.frame = CGRectMake(lbSelectOptions.frame.origin.x, lbSelectOptions.frame.origin.y, lbSelectOptions.frame.size.width, height);
    
    
    float localYCoordiante = CGRectGetMaxY(lbSelectOptions.frame)+15;
    
    NSMutableArray *radioBtnArr = [NSMutableArray new];
    
    
    for (int i = 0 ; i < [ff.arrValues count]; i++)
    {
        NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
        
        UILabel *lblbtnTitle = [[UILabel alloc] init];
        lblbtnTitle.numberOfLines = 0;
        lblbtnTitle.text = [tempDic objectForKey:@"value"];
        [view addSubview:lblbtnTitle];
        
        UIButton *radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [radioBtn addTarget:self action:@selector(checkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:radioBtn];
        [radioBtn setTitle:[tempDic objectForKey:@"value"] forState:UIControlStateReserved];
        [radioBtn setTag:[[tempDic1 objectForKey:@"index"] intValue]];
        
        if ([[tempDic objectForKey:@"baseline"] caseInsensitiveCompare:@"true"] == NSOrderedSame)
            [radioBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        else
            [radioBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
        if (IS_DEVICE_IPAD) {
            
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 600, 20);
            
            radioBtn.frame = CGRectMake(620, localYCoordiante, 30, 30);
            
        }
        else
        {
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 250, 20);
            
            radioBtn.frame = CGRectMake(270, localYCoordiante, 30, 30);
            
        }
        
        
        CGFloat height = [self calculateRadioTextHeight:[tempDic objectForKey:@"value"] andFont:lblbtnTitle.font];
        lblbtnTitle.frame = CGRectMake(lblbtnTitle.frame.origin.x, lblbtnTitle.frame.origin.y, lblbtnTitle.frame.size.width, height);
        
        
        localYCoordiante=CGRectGetMaxY(lblbtnTitle.frame)+15;
        
        
        for(int i=0;i<[submitDataArr count];i++)
        {
            NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
            
            NSLog(@"%@",strLableName);
            NSLog(@"%@",ff.strTitle);
            
            if ([strLableName isEqualToString:ff.strTitle]) {
                
                NSString *strValue=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
                
                NSArray *items = [strValue componentsSeparatedByString:@","];
                
                for (int j=0; j<[items count]; j++) {
                    
                    NSLog(@"%@",strValue);
                    NSLog(@"%@",[tempDic objectForKey:@"value"]);
                    
                    if ([[items objectAtIndex:j] isEqualToString:[tempDic objectForKey:@"value"]]) {
                        
                        [radioBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
                        
                    }
                }
                
                
            }
            
        }
        
        
        [radioBtnArr addObject:radioBtn];
        
        
    }
    
    [radioBtnDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:radioBtnArr,ff.strTitle,nil]];
    //[fileBtnArr addObject:@""];
    
    //[radioBtnDic setObject:radioBtnArr forKey:ff.strTitle];
    
    [formElementArr addObject:[radioBtnArr objectAtIndex:0]];
    
    yCoordinate += localYCoordiante+5;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [self.scrollView addSubview:view];
}
- (void)createLocalTextField:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        lblName.text = ff.strFieldValue;
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    UITextField *txtFld = [[UITextField alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 650, 30)];
        
    }
    else
    {
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 300, 30)];
        
    }
    
    txtFld.delegate=self;
    txtFld.text = [dic objectForKey:@"label_value"];
    txtFld.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    
    [view addSubview:txtFld];
    
    yLocalCoordinate += CGRectGetMaxY(txtFld.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [localScrollView addSubview:view];
}
- (void)createLocalTextView:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    lblName.text = ff.strFieldValue;
    
    
    NSString *str = @"";
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        lblName.text = ff.strFieldValue;
        
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    UITextView *txtView = [[UITextView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        txtView.frame = CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 650, 80);
        
    }
    else
    {
        txtView.frame = CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 300, 80);
        
    }
    txtView.delegate=self;
    txtView.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    txtView.font = [UIFont systemFontOfSize:18];
    txtView.text = [dic objectForKey:@"label_value"];
    [view addSubview:txtView];
    
    yLocalCoordinate += CGRectGetMaxY(txtView.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    
    [localScrollView addSubview:view];
}
- (void)createLocalImageView:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    yCoordinate += 10;
    
    
    //  UIImage *image = [dic objectForKey:@"image"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
        lblName.text = ff.strFieldValue;
    
    str = ff.strFieldValue;
    
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame  = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height+10);
    
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_DEVICE_IPAD) {
        
        imgBtn.frame     = CGRectMake(100, 10+CGRectGetMaxY(lblName.frame), 450, 450);
        
    }
    else
    {
        imgBtn.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 260);
        
    }
    
    [imgBtn setTitle:ff.strFieldValue forState:UIControlStateReserved];
    
    // [imgBtn setImage:image forState:UIControlStateNormal];
    
    if (IS_DEVICE_IPAD) {
        
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 345;
        
    }
    else
    {
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 245;
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    [view addSubview:imgBtn];
    
    [localScrollView addSubview:view];
}
- (void)createLocalRadioView:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    NSString *selectedValueStr = [dic objectForKey:@"label_value"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbSelectOptions = [[UILabel alloc] init];
    [lbSelectOptions setFont:[UIFont systemFontOfSize:20]];
    
    lbSelectOptions.numberOfLines = 0;
    [view addSubview:lbSelectOptions];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 300, 20)];
    }
    NSString *str;
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strTitle];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lbSelectOptions.attributedText = attrStr;
    }
    else
    {
        lbSelectOptions.text = ff.strTitle;
        str = ff.strTitle;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lbSelectOptions.font];
    lbSelectOptions.frame = CGRectMake(lbSelectOptions.frame.origin.x, lbSelectOptions.frame.origin.y, lbSelectOptions.frame.size.width, height);
    
    float localYCoordiante = CGRectGetMaxY(lbSelectOptions.frame)+15;
    
    for (int i = 0 ; i < [ff.arrValues count]; i++)
    {
        NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
        
        UILabel *lblbtnTitle = [[UILabel alloc] init];
        lblbtnTitle.numberOfLines = 0;
        lblbtnTitle.text = [tempDic objectForKey:@"value"];
        [view addSubview:lblbtnTitle];
        
        UIButton *radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:radioBtn];
        [radioBtn setTitle:[tempDic objectForKey:@"value"] forState:UIControlStateReserved];
        
        [radioBtn setTitle:ff.strTitle forState:UIControlStateReserved];
        
        NSString *urlType=[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"imageUrlType"])];
        
        if ([urlType isEqualToString:@"1"]) {
            
            [radioBtn setTitle:[tempDic objectForKey:@"answerimage"] forState:UIControlStateApplication];
            
        }
        else
        {
            [radioBtn setTitle:[tempDic objectForKey:@"answervideo"] forState:UIControlStateApplication];
            
        }
        
        
        
        if (IS_DEVICE_IPAD) {
            
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 600, 20);
            
            radioBtn.frame = CGRectMake(320, localYCoordiante, 30, 30);
            
            
        }
        else
        {
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 250, 20);
            
            radioBtn.frame = CGRectMake(270, localYCoordiante, 30, 30);
            
            
        }
        
        
        if ([selectedValueStr isEqualToString:[tempDic objectForKey:@"value"]])
            [radioBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        else
            [radioBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
        CGFloat height = [self calculateRadioTextHeight:[tempDic objectForKey:@"value"] andFont:lblbtnTitle.font];
        
        localYCoordiante=CGRectGetMaxY(lblbtnTitle.frame)+15;
        
        lblbtnTitle.frame = CGRectMake(lblbtnTitle.frame.origin.x, lblbtnTitle.frame.origin.y, lblbtnTitle.frame.size.width, height);
        
        
        
    }
    
    yLocalCoordinate += localYCoordiante+5;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [localScrollView addSubview:view];
}
- (void)createLocalCheckBox:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    NSString *selectedStr = [dic objectForKey:@"label_value"];
    
    NSArray *tempArr = [selectedStr componentsSeparatedByString:@","];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbSelectOptions = [[UILabel alloc] init];
    [lbSelectOptions setFont:[UIFont systemFontOfSize:20]];
    
    lbSelectOptions.numberOfLines = 0;
    [view addSubview:lbSelectOptions];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 150)];
        [lbSelectOptions setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    NSString *str;
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strTitle];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lbSelectOptions.attributedText = attrStr;
    }
    else
    {
        lbSelectOptions.text = ff.strTitle;
        
        str = ff.strTitle;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lbSelectOptions.font];
    lbSelectOptions.frame = CGRectMake(lbSelectOptions.frame.origin.x, lbSelectOptions.frame.origin.y, lbSelectOptions.frame.size.width, height);
    
    float localYCoordiante = CGRectGetMaxY(lbSelectOptions.frame)+15;
    
    for (int i = 0 ; i < [ff.arrValues count]; i++)
    {
        NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
        
        UILabel *lblbtnTitle = [[UILabel alloc] init];
        lblbtnTitle.numberOfLines = 0;
        lblbtnTitle.text = [tempDic objectForKey:@"value"];
        [view addSubview:lblbtnTitle];
        
        UIButton *radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:radioBtn];
        [radioBtn setTitle:[tempDic objectForKey:@"value"] forState:UIControlStateReserved];
        
        NSString *tempStr = @"";
        
        for(NSString *str in tempArr)
        {
            if ([str isEqualToString:[tempDic objectForKey:@"value"]])
            {
                tempStr = str;
                break;
            }
            else
            {
                tempStr = str;
                continue;
            }
        }
        
        
        if (IS_DEVICE_IPAD) {
            
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 600, 20);
            
            radioBtn.frame = CGRectMake(620, localYCoordiante, 30, 30);
            
            
        }
        else
        {
            lblbtnTitle.frame=CGRectMake(10, localYCoordiante, 250, 20);
            
            radioBtn.frame = CGRectMake(270, localYCoordiante, 30, 30);
            
            
        }
        
        if ([tempStr isEqualToString:[tempDic objectForKey:@"value"]])
            
            [radioBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
        else
            [radioBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
        [lblbtnTitle setBackgroundColor:[UIColor blueColor]];
        
        
        CGFloat height = [self calculateRadioTextHeight:[tempDic objectForKey:@"value"] andFont:lblbtnTitle.font];
        lblbtnTitle.frame = CGRectMake(lblbtnTitle.frame.origin.x, lblbtnTitle.frame.origin.y, lblbtnTitle.frame.size.width, height);
        
        localYCoordiante=CGRectGetMaxY(lblbtnTitle.frame)+15;
        
        
    }
    
    yLocalCoordinate += localYCoordiante+5;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    
    [localScrollView addSubview:view];
}
- (void)createSignatureField:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    //largeThumbOutputImageURL
    NSString *str = @"";
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
        lblName.text = ff.strFieldValue;
    
    str=ff.strFieldValue;
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame  = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height+10);
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn addTarget:self action:@selector(signatureImgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [imgBtn setTag:[[tempDic objectForKey:@"index"] intValue]];
    
    UIImageView *imgBack=[[UIImageView alloc] init];
    [imgBack setBackgroundColor:[UIColor clearColor]];
    imgBack.image=nil;
    [imgBack setUserInteractionEnabled:YES];
    
    if (IS_DEVICE_IPAD) {
        
        imgBtn.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 450);
        imgBack.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 450);
        
    }
    else
    {
        imgBtn.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 260);
        imgBack.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 260);
        
    }
    
    [imgBtn setTitle:ff.strFieldValue  forState:UIControlStateReserved];
    
    
    for(int i=0;i<[submitDataArr count];i++)
    {
        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
        
        if ([strLableName isEqualToString:ff.strFieldValue]) {
            
            NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,strLableName]);
            
            [imgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,strLableName]] placeholderImage:[UIImage imageNamed:@"upload.png"]];
            
        }
        
    }
    
    if (imgBack.image==nil) {
        
        imgBtn.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
        
        [imgBtn setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        
    }
    
    
    //[radioBtnDic setObject:imgBtn forKey:ff.strFieldValue];
    NSMutableArray *radioBtnArr = [NSMutableArray new];
    
    [radioBtnArr addObject:imgBtn];
    
    [radioBtnDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:radioBtnArr,ff.strFieldValue,nil]];
    
    [formElementArr addObject:imgBtn];
    
    if (IS_DEVICE_IPAD) {
        
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 345;
        
    }
    else
    {
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 245;
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    
    [view addSubview:imgBack];
    [view addSubview:imgBtn];
    
    [self.scrollView addSubview:view];
}
- (void)createAudioField:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    
    NSString *str = @"";
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
        lblName.text = ff.strFieldValue;
    
    str=ff.strFieldValue;
    
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame  = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height+10);
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    [imgBtn setTitle:@"Hold To Talk" forState:UIControlStateNormal];
    [imgBtn setTitle:@"Release to Send" forState:UIControlStateHighlighted];
    [imgBtn setTag:[[tempDic objectForKey:@"index"] intValue]];
    
    
    if (IS_DEVICE_IPAD) {
        
        imgBtn.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 60);
        
    }
    else
    {
        imgBtn.frame     = CGRectMake(30, CGRectGetMaxY(lblName.frame), 260, 60);
        
    }
    
    [imgBtn setTitle:ff.strFieldValue  forState:UIControlStateReserved];
    
    //[radioBtnDic setObject:imgBtn forKey:ff.strFieldValue];
    
    NSMutableArray *radioBtnArr = [NSMutableArray new];
    
    [radioBtnArr addObject:imgBtn];
    
    [radioBtnDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:radioBtnArr,ff.strFieldValue,nil]];
    
    
    [formElementArr addObject:imgBtn];
    
    //yCoordinate += 100;
    yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
    
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.cancelsTouchesInView = NO;
    [imgBtn addGestureRecognizer:longPress];
    
    [view addSubview:imgBtn];
    
    [self.scrollView addSubview:view];
}
- (void)createNumberField:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSLog(@"%@",ff.strFieldValue);
        
        NSLog(@"%@",str);
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        NSLog(@"%@",attrStr);
        
        
        lblName.attributedText = attrStr;
        
        NSLog(@"%@",lblName.attributedText);
        
    }
    else
    {
        NSLog(@"%@",ff);
        NSLog(@"%@",ff.strFieldValue);
        
        
        lblName.text = ff.strFieldValue;
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    
    UITextField *txtFld = [[UITextField alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 650, 30)];
        
    }
    else
    {
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 300, 30)];
        
    }
    
    txtFld.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    txtFld.delegate=self;
    [txtFld setKeyboardType:UIKeyboardTypeNumberPad];
    [view addSubview:txtFld];
    
    for(int i=0;i<[submitDataArr count];i++)
    {
        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
        
        if ([strLableName isEqualToString:ff.strFieldValue]) {
            
            txtFld.text=[[submitDataArr objectAtIndex:i] objectForKey:@"label_value"];
        }
        
    }
    
    [radioBtnDic addObject:@""];
    
    [formElementArr addObject:txtFld];
    
    
    
    yCoordinate += CGRectGetMaxY(txtFld.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    
    [self.scrollView addSubview:view];
}
- (void)createLocalSignatureField:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    //  UIImage *image = [dic objectForKey:@"image"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
        
        lblName.text = ff.strFieldValue;
    str = ff.strFieldValue;
    
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame  = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height+10);
    
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn addTarget:self action:@selector(signatureImgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_DEVICE_IPAD) {
        
        imgBtn.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 450);
        
    }
    else
    {
        imgBtn.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 260);
        
    }
    
    [imgBtn setTitle:ff.strFieldValue forState:UIControlStateReserved];
    
    //  [imgBtn setImage:image forState:UIControlStateNormal];
    
    if (IS_DEVICE_IPAD) {
        
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 345;
        
    }
    else
    {
        yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
        
        // yLocalCoordinate += 245;
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    [view addSubview:imgBtn];
    
    [localScrollView addSubview:view];
}
- (void)createLocalAudioField:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 275, 150)];
        [lblName setFrame:CGRectMake(10, 10, 260, 30)];
    }
    NSString *str = @"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        NSString *str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
        lblName.text = ff.strFieldValue;
    
    str=ff.strFieldValue;
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame  = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height+10);
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn setBackgroundColor:[UIColor lightGrayColor]];
    [imgBtn setTitle:@"Hold To Talk" forState:UIControlStateNormal];
    [imgBtn setTitle:@"Release to Send" forState:UIControlStateHighlighted];
    
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.cancelsTouchesInView = NO;
    [imgBtn addGestureRecognizer:longPress];
    
    if (IS_DEVICE_IPAD) {
        
        imgBtn.frame     = CGRectMake(100, CGRectGetMaxY(lblName.frame), 450, 60);
        
    }
    else
    {
        imgBtn.frame     = CGRectMake(30, 10+CGRectGetMaxY(lblName.frame), 260, 60);
        
    }
    [imgBtn setTitle:ff.strFieldValue forState:UIControlStateReserved];
    
    //yLocalCoordinate += 100;
    
    yCoordinate += CGRectGetMaxY(imgBtn.frame)+10;
    
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    [view addSubview:imgBtn];
    
    [localScrollView addSubview:view];
}
- (void)createLocalNumberField:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        NSLog(@"%@",ff.strFieldValue);
        
        lblName.text = ff.strFieldValue;
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    UITextField *txtFld = [[UITextField alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 650, 30)];
        
    }
    else
    {
        [txtFld setFrame:CGRectMake(10, 10+CGRectGetMaxY(lblName.frame), 300, 30)];
        
    }
    
    txtFld.delegate=self;
    txtFld.text = [dic objectForKey:@"label_value"];
    txtFld.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    
    [view addSubview:txtFld];
    
    yLocalCoordinate += CGRectGetMaxY(txtFld.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [localScrollView addSubview:view];
}
- (void)createOutputVedioField:(NSMutableDictionary *)tempDic
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    UIView *backview = [[UIView alloc] init];
    [backview setBackgroundColor:[UIColor blackColor]];

    UIWebView *webView = [[UIWebView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        webView.frame     = CGRectMake(180, 80, 350, 350);
        backview.frame     = CGRectMake(100, 30, 450, 450);

        
    }
    else
    {
        webView.frame     = CGRectMake(30, 50, 260, 260);
        
    }
    
    NSString *embedHTML;
    
    if (IS_DEVICE_IPAD) {
        
        embedHTML= [NSString stringWithFormat:@"\
                    <html><head>\
                    <style type=\"text/css\">\
                    body {\
                    background-color: black;\
                    color: black;\
                    }\
                    </style>\
                    </head><body style=\"margin:0\">\
                    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                    width=\"350.0f\" height=\"350.0f\"></embed>\
                    </body></html>",self.formOutputVideoStr];
        
    }
    else
    {
        embedHTML= [NSString stringWithFormat:@"\
                    <html><head>\
                    <style type=\"text/css\">\
                    body {\
                    background-color: transparent;\
                    color: white;\
                    }\
                    </style>\
                    </head><body style=\"margin:0\">\
                    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                    width=\"260.0f\" height=\"260.0f\"></embed>\
                    </body></html>",self.formOutputVideoStr];
        
    }
    [webView loadHTMLString:embedHTML baseURL:nil];
    NSLog(@"%@",self.formOutputVideoStr);
    
    webView.backgroundColor=[UIColor blackColor];
    //webView.backgroundColor= [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    
    if (IS_DEVICE_IPAD) {
        
        yCoordinate += 505;
        
    }
    else
    {
        yCoordinate += 315;
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    
    [view addSubview:backview];

    [view addSubview:webView];
    
    [self.scrollView addSubview:view];
}
- (void)createOutputAudioField:(NSMutableDictionary *)tempDic
{
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    
    if (IS_DEVICE_IPAD) {
        
        [self.outputAudioView setFrame:CGRectMake(50, 30, self.outputAudioView.frame.size.width, self.outputAudioView.frame.size.height)];
        
    }
    else
    {
        [self.outputAudioView setFrame:CGRectMake(30, 30, self.outputAudioView.frame.size.width, self.outputAudioView.frame.size.height)];
        
    }
    
    
    
    self.outputAudioView.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    
    yCoordinate += 130;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    
    [view addSubview:self.outputAudioView];
    
    [self.scrollView addSubview:view];
}
- (void)createOutputImageField:(NSMutableDictionary *)tempDic
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 150)];
        [lblName setFrame:CGRectMake(10, 10, 650, 30)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate+10, 320, 150)];
        [lblName setFrame:CGRectMake(10, 10, 300, 30)];
    }
    
    UIImageView *imgView=[[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0];
    
    if (IS_DEVICE_IPAD) {
        
        imgView.frame     = CGRectMake(100, 30, 450, 450);
        
    }
    else
    {
        imgView.frame     = CGRectMake(30, 50, 260, 260);
        
    }
    
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.formOutputImageStr] placeholderImage:[UIImage imageNamed:@"upload.png"]];
    
    if (IS_DEVICE_IPAD) {
        
        yCoordinate += 505;
        
    }
    else
    {
        yCoordinate += 315;
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 320, yCoordinate);
        
    }
    
    [view addSubview:imgView];
    
    [self.scrollView addSubview:view];
}

- (void)createHeadingField:(NSMutableDictionary *)tempDic
{
    FormsField *ff = [tempDic objectForKey:@"form"];
    
    NSLog(@"Type %@",ff.strFieldType);
    NSLog(@"strCSSClass %@",ff.strCSSClass);
    NSLog(@"strFieldRequired %@",ff.strFieldRequired);
    NSLog(@"strFieldValue %@",ff.strFieldValue);
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    
    if ([ff.strFieldType isEqualToString:@"heading"]) {
        
        [lblName setFont:[UIFont boldSystemFontOfSize:20]];
        
        
    }
    else
    {
        [lblName setFont:[UIFont systemFontOfSize:18]];
        
    }
    
    //  [lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        lblName.text = ff.strFieldValue;
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    [radioBtnDic addObject:@""];
    //  [fileBtnArr addObject:@""];
    
    [formElementArr addObject:lblName];
    
    yCoordinate += CGRectGetMaxY(lblName.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    
    [self.scrollView addSubview:view];
}
- (void)createLocalHeadingField:(NSMutableDictionary *)dic
{
    FormsField *ff = [dic objectForKey:@"form"];
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lblName = [[UILabel alloc] init];
    //[lblName setFont:[UIFont systemFontOfSize:20]];
    
    lblName.numberOfLines = 0;
    [view addSubview:lblName];
    if ([ff.strFieldType isEqualToString:@"heading"]) {
        
        [lblName setFont:[UIFont boldSystemFontOfSize:20]];
        
        
    }
    else
    {
        [lblName setFont:[UIFont systemFontOfSize:18]];
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        [view setFrame:CGRectMake(0, yCoordinate, 665, 100)];
        [lblName setFrame:CGRectMake(10, 10, 650, 20)];
    }
    else
    {
        [view setFrame:CGRectMake(0, yCoordinate, 320, 100)];
        [lblName setFrame:CGRectMake(10, 10, 300, 20)];
    }
    
    
    
    NSString *str=@"";
    
    if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        str = [NSString stringWithFormat:@"%@ *",ff.strFieldValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([str length]-1, 1)];
        lblName.attributedText = attrStr;
    }
    else
    {
        lblName.text = ff.strFieldValue;
        str = ff.strFieldValue;
    }
    
    CGFloat height = [self calculateTextHeight:str andFont:lblName.font];
    lblName.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width, height);
    
    
    yLocalCoordinate += CGRectGetMaxY(lblName.frame)+10;
    
    if (IS_DEVICE_IPAD) {
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 665, yCoordinate);
        
    }
    else
    {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,320, yCoordinate);
        
    }
    [localScrollView addSubview:view];
}
- (void) scrollViewToCenterOfScreen:(UIView *)theView
{
    
    CGFloat viewCenterY     = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat availableHeight = applicationFrame.size.height - 500; // Remove area covered by keyboard
    CGFloat y               = viewCenterY - availableHeight/3 ;
    
    if (y < 0)
        y = 0;
    
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}
-(void)setLayouts
{
    self.drawingView.layer.borderWidth = 1.0;
    self.drawingView.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.7] CGColor];
    self.drawingView.clipsToBounds = YES;
    
    
}
- (void)handleLongPress:(UILongPressGestureRecognizer*)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if ([sender.view isKindOfClass:[UIButton class]]) {
            
            UIButton *myButton = (UIButton *)sender.view;
            
            selectedBtn=myButton;
            self.selectedIndex=selectedBtn.tag;
            
            
        }
        
        [self performSelectorOnMainThread:@selector(stopRecording) withObject:nil waitUntilDone:YES];
        
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        
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
    
    
    
    [soundRecorder prepareToRecord];
    [soundRecorder record];
    
}
- (void)stopRecording
{
    
    
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
            [dict setObject:@"audio" forKey:@"attachment_key"];
            [dict setObject:@"uploadAudioForm" forKey:@"request_path"];
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            [dict setObject:@"audio.mp3" forKey:@"filename"];
            [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
            
            [[AmityCareServices sharedService] UploadAudioInvocation:dict signature:audioData delegate:self];
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
        
        
    }
}
-(IBAction)btnOutputAudioBtnAction:(UIButton*)sender
{
    // NSURL *url=[NSURL URLWithString:@"http://podcasts.cnn.net/cnn/services/podcasting/specials/audio/2007/05/milesobrien.mp3"];
    
    //NSURL *url=[NSURL URLWithString:@"http://encouraginginteraction.com/uploads/formAudio/audio_13795801759_1421151644.3ga"];
    
    
    NSLog(@"%@",self.formOutputAudioStr);
    
    
    
    NSURL *url=[NSURL URLWithString:self.formOutputAudioStr];
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    // AudioSessionSetProperty (ksAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSError* error;
    
    [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
    [audioSession setActive:YES error: nil];
    
    NSLog(@"%@",url);
    
    if (audioPlayer.playing) {
        
        sender.selected=NO;
        
        outputAudioSlider.value = 0.0;
        outputAudioSlider.enabled=YES;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [audioPlayer stop];
    }
    else
    {
        sender.selected=YES;
        outputAudioSlider.enabled = YES;
        
        // NSData *soundData = [NSData dataWithContentsOfURL:url];
        // audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
        
        //
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        [audioPlayer prepareToPlay];
        
        
        outputAudioSlider.maximumValue = [audioPlayer duration];
        outputAudioSlider.value = 0.0;
        outputAudioSlider.maximumValue = audioPlayer.duration;
        audioPlayer.currentTime = outputAudioSlider.value;
        
        NSLog(@"%f",[audioPlayer duration]);
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:sender repeats:YES];
        [audioPlayer play];
        
        
        /* if ([audioPlayer duration]>0) {
         
         [audioPlayer play];
         
         [audioProgressTimer invalidate];
         audioProgressTimer=nil;
         
         audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
         
         [audioProgressTimer fire];
         
         
         }
         else
         {
         [audioPlayer stop];
         sender.selected=NO;
         }*/
        
    }
}
- (void)updateTime:(NSTimer *)timer
{
    
    outputAudioSlider.value = audioPlayer.currentTime;
    
    NSLog(@"%f",audioPlayer.currentTime);
    
    if (outputAudioSlider.value<=0) {
        
        outputAudioSlider.enabled=NO;
        
        outputAudioButton.selected=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
    }
    
}
-(IBAction)btnAudioSliderMoveAction:(UISlider*)sender
{
    if (audioPlayer.isPlaying) {
        
        NSURL *url=[NSURL URLWithString:self.formOutputAudioStr];
        
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        //AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        NSError* error;
        
        [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        sender.selected=YES;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        outputAudioSlider.maximumValue = [audioPlayer duration];
        audioPlayer.currentTime = outputAudioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:sender repeats:YES];
        [audioPlayer play];
        
    }
    else
    {
        outputAudioSlider.enabled = YES;
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
- (void)resignKeyboard
{
    [self.view endEditing:YES];
}
- (void)uploadFormData
{
    isImageUpload = NO;
    
    if([ConfigManager isInternetAvailable])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:formData.strFormId forKey:@"form_id"];
        [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
        [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
        
        [dict setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];
        //[dict setObject:self.serverDate forKey:@"created"];
        
        //array('2'=>'Employee','3'=>'Manager','5'=>'Team Leader','6'=>'Family','7'=>'Training','8'=>'BS');
        
        NSLog(@"%@",sharedAppDelegate.userObj.role_id);
        
        // if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
        
        if (radioBSBtn.selected || [sharedAppDelegate.userObj.role_id isEqualToString:@"8"]) {
            
            [dict setObject:@"1" forKey:@"BS"];
            
        }
        else
        {
            [dict setObject:@"0" forKey:@"BS"];
            
        }
        
        if (radioTLBtn.selected || [sharedAppDelegate.userObj.role_id isEqualToString:@"5"]) {
            
            [dict setObject:@"1" forKey:@"teamleader"];
            
        }
        else
        {
            [dict setObject:@"0" forKey:@"teamleader"];
            
        }
        
        if (radioFamilyBtn.selected || [sharedAppDelegate.userObj.role_id isEqualToString:@"6"]) {
            
            [dict setObject:@"1" forKey:@"family"];
            
        }
        else
        {
            [dict setObject:@"0" forKey:@"family"];
            
        }
        
        if (radioEmployeeBtn.selected || [sharedAppDelegate.userObj.role_id isEqualToString:@"2"]) {
            
            [dict setObject:@"1" forKey:@"employee"];
            
        }
        else
        {
            [dict setObject:@"0" forKey:@"employee"];
            
        }
        
        
        [dict setObject:@"1" forKey:@"manager"];
        
        [dict setObject:formNameStr forKey:@"title"];
        [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        
        NSLog(@"%@",self.submitDataArr);
        
        [dict setObject:[self.submitDataArr JSONRepresentation] forKey:@"form_value"];
        
        [dict setObject:@"attachment" forKey:@"attachment_key"];
        [dict setObject:@"upload_from" forKey:@"request_path"];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
        
        [dict setObject:@"image.jpg" forKey:@"filename"];
        [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
        [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:(UIImageJPEGRepresentation(capturedImg, 0.50)) delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(BOOL)checkFromBeaconRange
{
    BOOL checkRange=FALSE;
    
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    self.uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];
    
    
    NSString *firstMinorValue=[NSString stringWithFormat:@"%@",formData.strBeaconMinorValue];
    
    NSString *firstMajorValue=[NSString stringWithFormat:@"%@",formData.strBeaconMajorValue];
    
    NSString *firstUuid=[NSString stringWithFormat:@"%@",formData.strBeaconUuid];
    
    NSString *firstDeviceName=[NSString stringWithFormat:@"%@",formData.strBeaconDeviceName];
    
    if (firstMajorValue==nil || firstMajorValue==(NSString*)[NSNull null]) {
        
        firstMajorValue=@"";
    }
    if (firstMinorValue==nil || firstMinorValue==(NSString*)[NSNull null]) {
        
        firstMinorValue=@"";
    }
    if (firstUuid==nil || firstUuid==(NSString*)[NSNull null]) {
        
        firstUuid=@"";
    }
    if (firstDeviceName==nil || firstDeviceName==(NSString*)[NSNull null]) {
        
        firstDeviceName=@"";
    }
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:firstUuid
                                                                options:kNilOptions
                                                                  range:NSMakeRange(0, firstUuid.length)];
    if (numberOfMatches > 0) {
        
        if (firstMinorValue.length>0 && firstMajorValue.length>0 && firstUuid.length>0 && firstDeviceName.length>0) {
            
            
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:firstUuid];
            
            RWTItem *item = [[RWTItem alloc] initWithName:firstDeviceName
                                                     uuid:uuid
                                                    major:[firstMajorValue intValue]
                                                    minor:[firstMinorValue intValue]];
            
            NSLog(@"%d",item.majorValue);
            NSLog(@"%d",item.minorValue);
            NSLog(@"%@",item.name);
            NSLog(@"%@",item.uuid);
            
            [array addObject:item];
            
            NSLog(@"count %lu",(unsigned long)sharedAppDelegate.arrIBeaconsList.count);
            
            BOOL check=FALSE;
            
            for (RWTItem *item1 in sharedAppDelegate.arrInRangeIbeacons) {
                
                NSLog(@"sss%d",item1.majorValue);
                NSLog(@"sss%d",item1.minorValue);
                // NSLog(@"sss%@",item1.name);
                NSLog(@"sss%@",item1.uuid);
                
                NSLog(@"sharedAppDelegate.arrInRangeIbeacons count");
                
                if (item.majorValue==item1.majorValue && item.minorValue==item1.minorValue && [item.name isEqualToString:item1.name] && [item.uuid isEqual:item1.uuid]) {
                    
                    NSLog(@"sharedAppDelegate.arrInRangeIbeacons containsObject:item");
                    
                    //check=TRUE;
                    
                    checkRange=TRUE;
                    
                    return checkRange;
                    
                }
                
            }
            
            if (check==FALSE) {
                
                checkRange=FALSE;
                
                return checkRange;
            }
        }
        
    }
    
    return checkRange;
}
-(BOOL)checkFromMultipleBeaconRange:(IBeaconD*)beaconData
{
    BOOL checkRange=FALSE;
    
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    self.uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];
    
    
    NSString *firstMinorValue=[NSString stringWithFormat:@"%@",beaconData.strBeaconMinorValue];
    
    NSString *firstMajorValue=[NSString stringWithFormat:@"%@",beaconData.strBeaconMajorValue];
    
    NSString *firstUuid=[NSString stringWithFormat:@"%@",beaconData.strBeaconUuid];
    
    NSString *firstDeviceName=[NSString stringWithFormat:@"%@",beaconData.strBeaconDeviceName];
    
    if (firstMajorValue==nil || firstMajorValue==(NSString*)[NSNull null]) {
        
        firstMajorValue=@"";
    }
    if (firstMinorValue==nil || firstMinorValue==(NSString*)[NSNull null]) {
        
        firstMinorValue=@"";
    }
    if (firstUuid==nil || firstUuid==(NSString*)[NSNull null]) {
        
        firstUuid=@"";
    }
    if (firstDeviceName==nil || firstDeviceName==(NSString*)[NSNull null]) {
        
        firstDeviceName=@"";
    }
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:firstUuid
                                                                options:kNilOptions
                                                                  range:NSMakeRange(0, firstUuid.length)];
    if (numberOfMatches > 0) {
        
        if (firstMinorValue.length>0 && firstMajorValue.length>0 && firstUuid.length>0 && firstDeviceName.length>0) {
            
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:firstUuid];
            
            RWTItem *item = [[RWTItem alloc] initWithName:firstDeviceName
                                                     uuid:uuid
                                                    major:[firstMajorValue intValue]
                                                    minor:[firstMinorValue intValue]];
            
            NSLog(@"aaaa%d",item.majorValue);
            NSLog(@"aaaa%d",item.minorValue);
            NSLog(@"aaaa%@",item.name);
            NSLog(@"aaaa%@",item.uuid);
            
            [array addObject:item];
            NSLog(@"count %lu",(unsigned long)sharedAppDelegate.arrInRangeIbeacons.count);
            
            
            BOOL check=FALSE;
            
            for (RWTItem *item1 in sharedAppDelegate.arrInRangeIbeacons) {
                
                NSLog(@"sss%d",item1.majorValue);
                NSLog(@"sss%d",item1.minorValue);
                NSLog(@"sss%@",item1.name);
                NSLog(@"sss%@",item1.uuid);
                
                
                if (item.majorValue==item1.majorValue && item.minorValue==item1.minorValue && [item.name isEqualToString:item1.name] && [item.uuid isEqual:item1.uuid]) {
                    
                    NSLog(@"sharedAppDelegate.arrInRangeIbeacons containsObject:item");
                    
                    //check=TRUE;
                    
                    checkRange=TRUE;
                    
                    return checkRange;
                    
                    
                }
                else
                {
                    NSLog(@"not containsObject:item");
                    
                }
                
                
            }
            
            if (check==FALSE) {
                
                checkRange=FALSE;
                return checkRange;
            }
        }
        
    }
    
    return checkRange;
    
}

#pragma mark -beaconData
#pragma mark - IBAction

-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)cancelBtnPressed:(id)sender
{
    [self.view removeFromSuperview];

}
- (void)checkBtnPressed:(UIButton *)sender
{
    UIButton *selectBtn = (UIButton *)sender;
    
    UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
    
    if ([selectBtn.currentImage isEqual:img])
    {
        [selectBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [selectBtn setImage:img forState:UIControlStateNormal];
    }
}

- (void)redioBtnPressed:(UIButton *)sender
{
    UIButton *selectBtn = (UIButton *)sender;
    
    NSString *key = [selectBtn titleForState:UIControlStateReserved];
    NSString *answerImage=@"";
    
    if ([self.formTypeStr isEqualToString:@"3"]) {
        
        answerImage =[NSString stringWithFormat:@"%@%@",formOriginalAnswerImageUrl,[selectBtn titleForState:UIControlStateApplication]];
        
        NSLog(@"%@",answerImage);
        
        
    }
    
    
    NSLog(@"%@",key);
    
    //NSArray *arr = [radioBtnDic objectForKey:key];
    NSLog(@"%ld",(long)selectBtn.tag);
    
    NSLog(@"%lu",(unsigned long)[radioBtnDic count]);
    
    NSLog(@"%@",[radioBtnDic objectAtIndex:selectBtn.tag]);
    
    NSArray *arr = [[radioBtnDic objectAtIndex:selectBtn.tag] objectForKey:key];
    
    
    NSLog(@"%@",arr);
    
    
    for (UIButton *btn in arr)
    {
        if (btn == selectBtn)
            
            if ([self.formTypeStr isEqualToString:@"3"]) {
                
                [selectBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
                
                [self showDynamicFormAnswer:answerImage];
                
                [selectBtn setEnabled:FALSE];
            }
            else
            {
                [selectBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
                
            }
        
            else
                if ([self.formTypeStr isEqualToString:@"3"]) {
                    
                    [btn setEnabled:FALSE];
                    
                    [btn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [btn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
                    
                }
    }
    
    
}
- (void)redioBtnVedioPressed:(UIButton *)sender
{
    UIButton *selectBtn = (UIButton *)sender;
    
    NSString *key = [selectBtn titleForState:UIControlStateReserved];
    NSString *answerVideo=@"";
    
    if ([self.formTypeStr isEqualToString:@"3"]) {
        
        answerVideo =[selectBtn titleForState:UIControlStateApplication];
        
        NSLog(@"%@",answerVideo);
        
    }
    
    
    NSLog(@"%@",key);
    
    //  NSArray *arr = [radioBtnDic objectForKey:key];
    NSArray *arr = [[radioBtnDic objectAtIndex:selectBtn.tag] objectForKey:key];
    
    NSLog(@"%@",arr);
    
    
    for (UIButton *btn in arr)
    {
        if (btn == selectBtn)
            
            if ([self.formTypeStr isEqualToString:@"3"]) {
                
                [selectBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
                
                [self showDynamicFormAnswerVideo:answerVideo];
                
                [selectBtn setEnabled:FALSE];
            }
            else
            {
                [selectBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
                
            }
        
            else
                if ([self.formTypeStr isEqualToString:@"3"]) {
                    
                    [btn setEnabled:FALSE];
                    
                    [btn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [btn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
                    
                }
    }
    
    
}

-(void)showDynamicFormAnswer:(NSString*)answer
{
    [self.largeWebView setHidden:TRUE];
    [largeImgView setHidden:FALSE];
    
    [self.zoomView removeFromSuperview];
    
    [self.zoomView setFrame:scrollView.frame];
    largeImgView.layer.cornerRadius = 5.0f;
    largeImgView.clipsToBounds = YES;
    
    NSLog(@"%@",answer);
    
    [largeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",answer]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        [self.view addSubview:self.zoomView];
                    }
                    completion:NULL];
    
    
    
}
-(void)showDynamicFormAnswerVideo:(NSString*)answer
{
    [self.largeWebView setHidden:FALSE];
    [largeImgView setHidden:TRUE];
    
    [self.zoomView removeFromSuperview];
    
    [self.zoomView setFrame:scrollView.frame];
    self.largeWebView.layer.cornerRadius = 5.0f;
    self.largeWebView.clipsToBounds = YES;
    [self.largeWebView setBackgroundColor:[UIColor blackColor]];
    
    NSLog(@"%@",answer);
    
    
    NSString *embedHTML;
    
    if (IS_DEVICE_IPAD) {
        
        embedHTML= [NSString stringWithFormat:@"\
                    <html><head>\
                    <style type=\"text/css\">\
                    body {\
                    background-color: black;\
                    color: black;\
                    }\
                    </style>\
                    </head><body style=\"margin:0\">\
                    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                    width=\"250.0f\" height=\"250.0f\"></embed>\
                    </body></html>",answer];
        
    }
    else
    {
        embedHTML= [NSString stringWithFormat:@"\
                    <html><head>\
                    <style type=\"text/css\">\
                    body {\
                    background-color: black;\
                    color: black;\
                    }\
                    </style>\
                    </head><body style=\"margin:0\">\
                    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                    width=\"262.0f\" height=\"310.0f\"></embed>\
                    </body></html>",answer];
        
    }
    [self.largeWebView loadHTMLString:embedHTML baseURL:nil];
    NSLog(@"%@",self.formOutputVideoStr);
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        [self.view addSubview:self.zoomView];
                    }
                    completion:NULL];
    
}
-(IBAction)btnCloseLargeImgViewAction:(id)sender
{
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [self.zoomView removeFromSuperview];
                    }
                    completion:NULL];
    
}

- (void)submitBtnPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    yLocalCoordinate = 0;
    
    for (UIView *view in [localScrollView subviews])
    {
        [view removeFromSuperview];
    }
    
    if ([self.formTypeStr isEqualToString:@"1"]) {
        
        [self submitSingleForm];
    }
    else
    {
        [self submitMultiForm];
        
    }
    
    NSLog(@"submitDataArr %@",self.submitDataArr);
    
    
    if ([self.submitDataArr count] == 0)
    {
        /* UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill some fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [av show];
         
         return;*/
    }
    else
    {
        if (checkMandatory==TRUE) {
            
            NSLog(@"yLocalCoordinate %f",yLocalCoordinate);
            
            [localScrollView setContentSize:CGSizeMake(localScrollView.frame.size.width, yLocalCoordinate)];
            [self convertScrollViewIntoImage];
            
            
            if ([self.formTypeStr isEqualToString:@"1"]) {
                
                NSLog(@"%@",formData.strBeaconStatus);
                
                if (formData.strBeaconStatus==nil || formData.strBeaconStatus==(NSString*)[NSNull null] || [formData.strBeaconStatus isEqualToString:@""]) {
                    
                    [self uploadFormData];
                    
                }
                else
                {
                    if ([formData.strBeaconStatus isEqualToString:@"1"]) {
                        
                        BOOL inRange=[self checkFromBeaconRange];
                        
                        if (inRange==TRUE) {
                            
                            [self uploadFormData];
                            //[ConfigManager showAlertMessage:nil Message:@"You are in beacon range"];
                            
                        }
                        else
                        {
                            NSString *msg=[NSString stringWithFormat:@"Please goto %@",formData.strBeaconDeviceName];
                            
                            [ConfigManager showAlertMessage:nil Message:msg];
                            
                        }
                        
                    }
                    else
                    {
                        [self uploadFormData];
                        
                    }
                    
                }
                
            }
            else
            {
                IBeaconD *objBeacon=[[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"beacon"] objectAtIndex:0];
                
                if (objBeacon.strBeaconStatus==nil || objBeacon.strBeaconStatus==(NSString*)[NSNull null] || [objBeacon.strBeaconStatus isEqualToString:@""]) {
                    
                    [self uploadFormData];
                    
                }
                else
                {
                    if ([objBeacon.strBeaconStatus isEqualToString:@"1"]) {
                        
                        BOOL inRange=[self checkFromMultipleBeaconRange:objBeacon];
                        
                        if (inRange==TRUE) {
                            
                            [self uploadFormData];
                            //[ConfigManager showAlertMessage:nil Message:@"You are in beacon range"];
                            
                        }
                        else
                        {
                            NSString *msg=[NSString stringWithFormat:@"Please goto %@",objBeacon.strBeaconDeviceName];
                            
                            [ConfigManager showAlertMessage:nil Message:msg];
                            
                        }
                        
                    }
                    else
                    {
                        [self uploadFormData];
                        
                    }
                }
                
            }
            
        }
        
    }
}

-(void)submitSingleForm
{
    checkMandatory=TRUE;
    
    for(int j = 0 ; j < [self.formsArr count]; j++)
    {
        FormsField *ff = [self.formsArr objectAtIndex:j];
        
        NSLog(@"Str value %@",ff.strFieldValue);
        NSLog(@"Str ff.strTitle %@",ff.strTitle);
        NSLog(@"Str strFieldRequired %@",ff.strFieldRequired);
        NSLog(@"Str ff.strTitle %@",ff.strFieldType);
        
        if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)// it means fields are mandatory
        {
            UIView *view = [formElementArr objectAtIndex:j];
            
            if ([ff.strFieldType caseInsensitiveCompare:@"text"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] == 0)
                {
                    checkMandatory=FALSE;
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    
                    return;
                }
                else
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"text" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalTextField:tempDic1];
                    
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"number"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([tf.text length] == 0)
                {
                    checkMandatory=FALSE;
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    
                    return;
                }
                else
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"number" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalNumberField:tempDic1];
                    
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"textarea"] == NSOrderedSame)// Text View
            {
                UITextView *tv = (UITextView *)view;
                
                tv.text= [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tv.text length] == 0)
                {
                    checkMandatory=FALSE;
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    
                    return;
                }
                else
                {
                    
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tv.text forKey:@"label_value"];
                    [dic setObject:@"textarea" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                    
                    NSMutableDictionary *tempDic = [NSMutableDictionary new];
                    [tempDic setObject:ff.strFieldValue forKey:@"label_name"];
                    [tempDic setObject:tv.text forKey:@"label_value"];
                    [tempDic setObject:ff forKey:@"form"];
                    
                    [self createLocalTextView:tempDic];
                    
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"file"] == NSOrderedSame)          {
                
                UIImage *img = [UIImage imageNamed:@"user_default.png"];//Change
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                
                // UIButton *btn = (UIButton *)[[radioBtnDic objectAtIndex:j] objectForKey:key];
                if (flag)
                {
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        checkMandatory=FALSE;
                        
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [av show];
                        
                        return;
                        
                    }
                    else
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            NSString *type = [dic objectForKey:@"type"];
                            
                            if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                if ([type isEqualToString:@"audio"]) {
                                    
                                    [tempDic setObject:ff forKey:@"form"];
                                    
                                    [self createLocalAudioField:tempDic];
                                    
                                }
                                else
                                {
                                    [tempDic setObject:ff forKey:@"form"];
                                    
                                    [self createLocalImageView:tempDic];
                                    
                                }
                                
                                [self.submitDataArr addObject:dic];
                                
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"signature"] == NSOrderedSame)// File(UIButton)
            {
                UIImage *img = [UIImage imageNamed:@"user_default.png"];//Change
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        checkMandatory=FALSE;
                        
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [av show];
                        
                        return;
                        
                    }
                    
                    else
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                // [tempDic setObject:btn.currentImage forKey:@"image"];
                                
                                [self createLocalSignatureField:tempDic];
                                
                                [self.submitDataArr addObject:dic];
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"audio"] == NSOrderedSame)// File(UIButton)
            {
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    
                }
                
                for (NSDictionary *dic in fileBtnArr)
                {
                    NSString *str = [dic objectForKey:@"label_name"];
                    
                    if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                    {
                        NSMutableDictionary *tempDic = [NSMutableDictionary new];
                        
                        [tempDic setObject:ff forKey:@"form"];
                        
                        [self createLocalAudioField:tempDic];
                        
                        [self.submitDataArr addObject:dic];
                        break;
                    }
                    continue;
                }
                continue;
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)// Radio
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                //  NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                NSString *valueStr;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
                    valueStr = [tempDic objectForKey:@"value"];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSLog(@"%@",ff.strFieldValue);
                    
                    if ([ff.strFieldValue length] == 0)
                        [dic setObject:ff.strTitle forKey:@"label_name"];
                    else
                        [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    
                    [dic setObject:valueStr forKey:@"label_value"];
                    [dic setObject:@"radio" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalRadioView:tempDic1];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                }
                else
                {
                    checkMandatory=FALSE;
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    return;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)// CheckBox
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSString *selectedValueStr = @"";
                //  NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                
                for (UIView *localView in tempArr)
                {
                    UIButton *btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        selectedValueStr = [selectedValueStr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"%@,",[btn titleForState:UIControlStateReserved]]];
                        NSLog(@"selected value %@",selectedValueStr);
                    }
                    else
                        continue;
                }
                
                if (flag)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    if ([ff.strFieldValue length] == 0)
                        [dic setObject:ff.strTitle forKey:@"label_name"];
                    else
                        [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    
                    [dic setObject:[selectedValueStr substringToIndex:[selectedValueStr length]-1] forKey:@"label_value"];
                    [dic setObject:@"checkbox" forKey:@"type"];
                    
                    NSLog(@"%@",dic);
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalCheckBox:tempDic1];
                }
                else
                {
                    checkMandatory=FALSE;
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    
                    return;
                }
            }
        }
        else// it means fields are not mandatory
        {
            UIView *view = [formElementArr objectAtIndex:j];
            
            if ([ff.strFieldType caseInsensitiveCompare:@"text"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"text" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalTextField:tempDic1];
                    
                    continue;
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"number"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"number" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalNumberField:tempDic1];
                    
                    continue;
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"textarea"] == NSOrderedSame)// Text View
            {
                UITextView *tv = (UITextView *)view;
                
                tv.text= [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tv.text length] != 0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tv.text forKey:@"label_value"];
                    [dic setObject:@"textarea" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalTextView:tempDic1];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"file"] == NSOrderedSame)// File(UIButton)
            {
                //UIButton *btn = (UIButton *)view;
                
                UIImage *img = [UIImage imageNamed:@"user_default.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                // [tempDic setObject:btn.currentImage forKey:@"image"];
                                
                                [self createLocalImageView:tempDic];
                                
                                [self.submitDataArr addObject:dic];
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"signature"] == NSOrderedSame)// File(UIButton)
            {
                UIImage *img = [UIImage imageNamed:@"user_default.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                
                                [self createLocalSignatureField:tempDic];
                                
                                [self.submitDataArr addObject:dic];
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"audio"] == NSOrderedSame)// File(UIButton)
            {
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    
                }
                
                for (NSDictionary *dic in fileBtnArr)
                {
                    NSString *str = [dic objectForKey:@"label_name"];
                    
                    if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                    {
                        NSMutableDictionary *tempDic = [NSMutableDictionary new];
                        
                        [tempDic setObject:ff forKey:@"form"];
                        
                        [self createLocalAudioField:tempDic];
                        
                        [self.submitDataArr addObject:dic];
                        break;
                    }
                    continue;
                }
                continue;
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)// Radio
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                //NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                UIButton *btn;
                
                NSString *valueStr = @"";
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
                        valueStr = [tempDic objectForKey:@"value"];
                        
                        NSMutableDictionary *dic = [NSMutableDictionary new];
                        
                        NSLog(@"%@",ff.strFieldValue);
                        
                        
                        if ([ff.strFieldValue length] == 0)
                            [dic setObject:ff.strTitle forKey:@"label_name"];
                        else
                            [dic setObject:ff.strFieldValue forKey:@"label_name"];
                        
                        [dic setObject:valueStr forKey:@"label_value"];
                        [dic setObject:@"radio" forKey:@"type"];
                        
                        [self.submitDataArr addObject:dic];
                        
                        NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                        [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                        [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                        [tempDic1 setObject:ff forKey:@"form"];
                        
                        [self createLocalRadioView:tempDic1];
                        
                        NSLog(@"submitDataArr %@",self.submitDataArr);
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)// CheckBox
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSString *selectedValueStr = @"";
                // NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                NSLog(@"%@",tempArr);
                NSLog(@"%@",radioBtnDic);
                NSLog(@"%lu",(unsigned long)[radioBtnDic count]);
                
                for (UIView *localView in tempArr)
                {
                    UIButton *btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        selectedValueStr = [selectedValueStr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"%@,",[btn titleForState:UIControlStateReserved]]];
                        NSLog(@"selected value %@",selectedValueStr);
                        
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if ([selectedValueStr length] != 0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    if ([ff.strFieldValue length] == 0)
                        [dic setObject:ff.strTitle forKey:@"label_name"];
                    else
                        [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    
                    [dic setObject:selectedValueStr forKey:@"label_value"];
                    [dic setObject:@"checkbox" forKey:@"type"];
                    
                    NSLog(@"%@",dic);
                    
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalCheckBox:tempDic1];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"heading"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"heading" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalHeadingField:tempDic1];
                    
                    continue;
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"description"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"description" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalHeadingField:tempDic1];
                    
                    continue;
                }
            }
        }
    }
    
}
-(void)submitMultiForm
{
    checkMandatory=TRUE;
    
    for(int j = 0 ; j < [[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"data"] count]; j++)
    {
        FormsField *ff = [[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"data"] objectAtIndex:j];
        
        NSLog(@"Str value %@",ff.strFieldValue);
        NSLog(@"Str ff.strTitle %@",ff.strTitle);
        NSLog(@"Str strFieldRequired %@",ff.strFieldRequired);
        NSLog(@"Str ff.strTitle %@",ff.strFieldType);
        
        if ([ff.strFieldRequired caseInsensitiveCompare:@"true"] == NSOrderedSame)// it means fields are mandatory
        {
            UIView *view = [formElementArr objectAtIndex:j];
            
            if ([ff.strFieldType caseInsensitiveCompare:@"text"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] == 0)
                {
                    checkMendatory=FALSE;
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    
                    return;
                }
                else
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"text" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:ff.strFieldValue]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalTextField:tempDic1];
                    
                    continue;
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"number"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] == 0)
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    checkMendatory=FALSE;
                    
                    return;
                }
                else
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"number" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:ff.strFieldValue]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalNumberField:tempDic1];
                    
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"textarea"] == NSOrderedSame)// Text View
            {
                
                UITextView *tv = (UITextView *)view;
                
                tv.text= [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tv.text length] == 0)
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    checkMendatory=FALSE;
                    
                    return;
                }
                else
                {
                    
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tv.text forKey:@"label_value"];
                    [dic setObject:@"textarea" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:ff.strFieldValue]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                    
                    NSMutableDictionary *tempDic = [NSMutableDictionary new];
                    [tempDic setObject:ff.strFieldValue forKey:@"label_name"];
                    [tempDic setObject:tv.text forKey:@"label_value"];
                    [tempDic setObject:ff forKey:@"form"];
                    
                    [self createLocalTextView:tempDic];
                    
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"file"] == NSOrderedSame)            {
                UIImage *img = [UIImage imageNamed:@"user_default.png"];//Change
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    if ([btn.currentImage isEqual:img])
                    {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [av show];
                        checkMendatory=FALSE;
                        
                        return;
                        
                    }
                    else
                    {
                        
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                [tempDic setObject:btn.currentImage forKey:@"image"];
                                
                                [self createLocalImageView:tempDic];
                                
                                for(int i=0;i<[submitDataArr count];i++)
                                {
                                    NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                                    
                                    if ([strLableName isEqualToString:str]) {
                                        
                                        [self.submitDataArr removeObjectAtIndex:i];
                                    }
                                    
                                }
                                
                                
                                [self.submitDataArr addObject:dic];
                                
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"signature"] == NSOrderedSame)// File(UIButton)
            {
                UIImage *img = [UIImage imageNamed:@"user_default.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                            {
                                
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                [tempDic setObject:btn.currentImage forKey:@"image"];
                                
                                [self createLocalSignatureField:tempDic];
                                
                                for(int i=0;i<[submitDataArr count];i++)
                                {
                                    NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                                    
                                    if ([strLableName isEqualToString:str]) {
                                        
                                        [self.submitDataArr removeObjectAtIndex:i];
                                    }
                                    
                                }
                                
                                
                                [self.submitDataArr addObject:dic];
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"audio"] == NSOrderedSame)// File(UIButton)
            {
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    
                }
                
                for (NSDictionary *dic in fileBtnArr)
                {
                    NSString *str = [dic objectForKey:@"label_name"];
                    
                    if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                    {
                        NSMutableDictionary *tempDic = [NSMutableDictionary new];
                        
                        [tempDic setObject:ff forKey:@"form"];
                        
                        [self createLocalAudioField:tempDic];
                        
                        [self.submitDataArr addObject:dic];
                        break;
                    }
                    continue;
                }
                continue;
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)// Radio
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                // NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                NSString *valueStr;
                NSString *imageStr=@"";
                NSString *videoStr=@"";
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
                    
                    valueStr = [tempDic objectForKey:@"value"];
                    
                    if ([self.formTypeStr isEqualToString:@"3"]) {
                        
                        imageStr =[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"answerimage"])];
                        
                        videoStr =[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"answerurl"])];
                        
                    }
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSString *chk=@"";
                    
                    NSLog(@"%@",ff.strFieldValue);
                    
                    if ([ff.strFieldValue length] == 0)
                    {
                        [dic setObject:ff.strTitle forKey:@"label_name"];
                        chk=ff.strTitle;
                    }
                    
                    else
                    {
                        [dic setObject:ff.strFieldValue forKey:@"label_name"];
                        chk=ff.strFieldValue;
                        
                    }
                    
                    [dic setObject:valueStr forKey:@"label_value"];
                    
                    if ([self.formTypeStr isEqualToString:@"3"]) {
                        
                        NSString *urlType=[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"imageUrlType"])];
                        
                        [dic setObject:imageStr forKey:@"answerimage"];
                        [dic setObject:videoStr forKey:@"answerurl"];
                        [dic setObject:urlType forKey:@"imageUrlType"];
                        
                    }
                    
                    [dic setObject:@"radio" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:chk]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    
                    if ([self.formTypeStr isEqualToString:@"3"]) {
                        
                        [tempDic1 setObject:[dic objectForKey:@"answerimage"] forKey:@"answerimage"];
                        
                        [tempDic1 setObject:[dic objectForKey:@"answerurl"] forKey:@"answerurl"];
                        
                        [tempDic1 setObject:[dic objectForKey:@"imageUrlType"] forKey:@"imageUrlType"];
                        
                    }
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalRadioView:tempDic1];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                }
                else
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    
                    checkMendatory=FALSE;
                    
                    return;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)// CheckBox
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSString *selectedValueStr = @"";
                // NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                
                for (UIView *localView in tempArr)
                {
                    UIButton *btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        selectedValueStr = [selectedValueStr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"%@,",[btn titleForState:UIControlStateReserved]]];
                        NSLog(@"selected value %@",selectedValueStr);
                    }
                    else
                        continue;
                }
                
                if (flag)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSString *chk=@"";
                    
                    if ([ff.strFieldValue length] == 0)
                    {
                        [dic setObject:ff.strTitle forKey:@"label_name"];
                        chk=ff.strTitle;
                    }
                    else
                    {
                        [dic setObject:ff.strFieldValue forKey:@"label_name"];
                        chk=ff.strFieldValue;
                        
                    }
                    
                    [dic setObject:[selectedValueStr substringToIndex:[selectedValueStr length]-1] forKey:@"label_value"];
                    [dic setObject:@"checkbox" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:chk]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalCheckBox:tempDic1];
                }
                else
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                    checkMendatory=FALSE;
                    
                    return;
                }
            }
        }
        else// it means fields are not mandatory
        {
            UIView *view = [formElementArr objectAtIndex:j];
            
            if ([ff.strFieldType caseInsensitiveCompare:@"text"] == NSOrderedSame)            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"text" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:ff.strFieldValue]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalTextField:tempDic1];
                    
                    continue;
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"number"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"number" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:ff.strFieldValue]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalNumberField:tempDic1];
                    
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"textarea"] == NSOrderedSame)// Text View
            {
                UITextView *tv = (UITextView *)view;
                
                tv.text= [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tv.text length] != 0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tv.text forKey:@"label_value"];
                    [dic setObject:@"textarea" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:ff.strFieldValue]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalTextView:tempDic1];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                    continue;
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"file"] == NSOrderedSame)// File(UIButton)
            {
                //UIButton *btn = (UIButton *)view;
                
                UIImage *img = [UIImage imageNamed:@"user_default.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if (flag)
                {
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                //  [tempDic setObject:btn.currentImage forKey:@"image"];
                                
                                [self createLocalImageView:tempDic];
                                
                                for(int i=0;i<[submitDataArr count];i++)
                                {
                                    NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                                    
                                    if ([strLableName isEqualToString:str]) {
                                        
                                        [self.submitDataArr removeObjectAtIndex:i];
                                    }
                                    
                                }
                                
                                
                                [self.submitDataArr addObject:dic];
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                }
                
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"signature"] == NSOrderedSame)// File(UIButton)
            {
                UIImage *img = [UIImage imageNamed:@"user_default.png"];//Change
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                BOOL flag = NO;
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if (![btn.currentImage isEqual:img])
                    {
                        flag = YES;
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                
                
                if (flag)
                {
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        checkMandatory=FALSE;
                        
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill the mandatory fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [av show];
                        
                        return;
                        
                    }
                    else
                    {
                        
                        for (NSDictionary *dic in fileBtnArr)
                        {
                            NSString *str = [dic objectForKey:@"label_name"];
                            
                            if ([str isEqualToString:key])
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                                
                                [tempDic setObject:ff forKey:@"form"];
                                // [tempDic setObject:btn.currentImage forKey:@"image"];
                                
                                [self createLocalSignatureField:tempDic];
                                
                                for(int i=0;i<[submitDataArr count];i++)
                                {
                                    NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                                    
                                    if ([strLableName isEqualToString:str]) {
                                        
                                        [self.submitDataArr removeObjectAtIndex:i];
                                    }
                                    
                                }
                                
                                
                                [self.submitDataArr addObject:dic];
                                break;
                            }
                            continue;
                        }
                        continue;
                    }
                    
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"audio"] == NSOrderedSame)// File(UIButton)
            {
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                UIButton *btn;
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    
                }
                
                for (NSDictionary *dic in fileBtnArr)
                {
                    NSString *str = [dic objectForKey:@"label_name"];
                    
                    if ([str isEqualToString:key] && btn.tag==[[dic objectForKey:@"index"] intValue])
                    {
                        NSMutableDictionary *tempDic = [NSMutableDictionary new];
                        
                        [tempDic setObject:ff forKey:@"form"];
                        
                        [self createLocalAudioField:tempDic];
                        
                        [self.submitDataArr addObject:dic];
                        break;
                    }
                    continue;
                }
                continue;
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)// Radio
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                // NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                UIButton *btn;
                
                NSString *valueStr = @"";
                NSString *imageStr = @"";
                NSString *videoStr=@"";
                
                int i;
                for (i = 0 ; i < [tempArr count]; i++)
                {
                    UIView *localView =  [tempArr objectAtIndex:i];
                    
                    btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        NSDictionary *tempDic = [ff.arrValues objectAtIndex:i];
                        
                        valueStr = [tempDic objectForKey:@"value"];
                        
                        if ([self.formTypeStr isEqualToString:@"3"]) {
                            
                            imageStr =[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"answerimage"])];
                            
                            videoStr =[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"answerurl"])];
                        }
                        
                        //answerimage
                        NSMutableDictionary *dic = [NSMutableDictionary new];
                        
                        NSString *chk=@"";
                        
                        NSLog(@"%@",ff.strFieldValue);
                        
                        
                        if ([ff.strFieldValue length] == 0)
                        {
                            [dic setObject:ff.strTitle forKey:@"label_name"];
                            chk=ff.strTitle;
                        }
                        
                        else
                        {
                            [dic setObject:ff.strFieldValue forKey:@"label_name"];
                            chk=ff.strFieldValue;
                            
                        }
                        
                        [dic setObject:valueStr forKey:@"label_value"];
                        
                        if ([self.formTypeStr isEqualToString:@"3"]) {
                            
                            NSString *urlType=[NSString stringWithFormat:@"%@",NULL_TO_NIL([tempDic objectForKey:@"imageUrlType"])];
                            
                            [dic setObject:imageStr forKey:@"answerimage"];
                            [dic setObject:videoStr forKey:@"answerurl"];
                            [dic setObject:urlType forKey:@"imageUrlType"];
                            
                        }
                        [dic setObject:@"radio" forKey:@"type"];
                        
                        for(int i=0;i<[submitDataArr count];i++)
                        {
                            NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                            
                            if ([strLableName isEqualToString:chk]) {
                                
                                [self.submitDataArr removeObjectAtIndex:i];
                            }
                            
                        }
                        
                        [self.submitDataArr addObject:dic];
                        
                        NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                        [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                        [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                        
                        if ([self.formTypeStr isEqualToString:@"3"]) {
                            
                            [tempDic1 setObject:[dic objectForKey:@"answerimage"] forKey:@"answerimage"];
                            
                            [tempDic1 setObject:[dic objectForKey:@"answerurl"] forKey:@"answerurl"];
                            
                            [tempDic1 setObject:[dic objectForKey:@"imageUrlType"] forKey:@"imageUrlType"];
                        }
                        [tempDic1 setObject:ff forKey:@"form"];
                        
                        [self createLocalRadioView:tempDic1];
                        
                        NSLog(@"submitDataArr %@",self.submitDataArr);
                        
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)// CheckBox
            {
                UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
                
                NSString *key;
                
                if ([ff.strTitle length] == 0)
                    key = ff.strFieldValue;
                else
                    key = ff.strTitle;
                
                NSString *selectedValueStr = @"";
                // NSArray *tempArr = [radioBtnDic objectForKey:key];
                NSArray *tempArr = [[radioBtnDic objectAtIndex:j] objectForKey:key];
                
                for (UIView *localView in tempArr)
                {
                    UIButton *btn = (UIButton *)localView;
                    
                    if ([btn.currentImage isEqual:img])
                    {
                        selectedValueStr = [selectedValueStr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"%@,",[btn titleForState:UIControlStateReserved]]];
                        NSLog(@"selected value %@",selectedValueStr);
                        
                    }
                    else
                    {
                        continue;
                    }
                }
                
                if ([selectedValueStr length] != 0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSString *chk=@"";
                    
                    if ([ff.strFieldValue length] == 0)
                    {
                        [dic setObject:ff.strTitle forKey:@"label_name"];
                        chk=ff.strTitle;
                    }
                    else
                    {
                        [dic setObject:ff.strFieldValue forKey:@"label_name"];
                        chk=ff.strFieldValue;
                        
                    }
                    [dic setObject:selectedValueStr forKey:@"label_value"];
                    [dic setObject:@"checkbox" forKey:@"type"];
                    
                    for(int i=0;i<[submitDataArr count];i++)
                    {
                        NSString *strLableName=[[submitDataArr objectAtIndex:i] objectForKey:@"label_name"];
                        
                        if ([strLableName isEqualToString:chk]) {
                            
                            [self.submitDataArr removeObjectAtIndex:i];
                        }
                        
                    }
                    
                    [self.submitDataArr addObject:dic];
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalCheckBox:tempDic1];
                    
                    NSLog(@"submitDataArr %@",self.submitDataArr);
                }
            }
            
            else if ([ff.strFieldType caseInsensitiveCompare:@"heading"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"text" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalHeadingField:tempDic1];
                    
                    continue;
                }
            }
            else if ([ff.strFieldType caseInsensitiveCompare:@"description"] == NSOrderedSame)// Text Field
            {
                UITextField *tf = (UITextField *)view;
                
                tf.text= [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                if ([tf.text length] != 0)// it means the field is not mandatory and value is selected by user
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:ff.strFieldValue forKey:@"label_name"];
                    [dic setObject:tf.text forKey:@"label_value"];
                    [dic setObject:@"text" forKey:@"type"];
                    
                    [self.submitDataArr addObject:dic];
                    
                    
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary new];
                    [tempDic1 setObject:[dic objectForKey:@"label_name"] forKey:@"label_name"];
                    [tempDic1 setObject:[dic objectForKey:@"label_value"] forKey:@"label_value"];
                    [tempDic1 setObject:ff forKey:@"form"];
                    
                    [self createLocalHeadingField:tempDic1];
                    
                    continue;
                }
            }
            
        }
    }
    
    NSLog(@"submitDataArr %@",self.submitDataArr);
    
}

- (void)nextBtnPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    
    checkMendatory=TRUE;
    
    yLocalCoordinate = 0;
    
    for (UIView *view in [localScrollView subviews])
    {
        [view removeFromSuperview];
    }
    
    [self submitMultiForm];
    
    NSLog(@"submitDataArr %@",self.submitDataArr);
    
    if ([self.submitDataArr count] == 0)
    {
        
        checkMendatory=FALSE;
        
        return;
    }
    else
    {
        
        if (checkMendatory==TRUE) {
            
            IBeaconD *objBeacon=[[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"beacon"] objectAtIndex:0];
            
            NSLog(@"%@",objBeacon.strBeaconStatus);
            NSLog(@"%@",objBeacon.strBeaconDeviceName);
            NSLog(@"%@",objBeacon.strBeaconUuid);
            NSLog(@"%@",objBeacon.strBeaconMajorValue);
            NSLog(@"%@",objBeacon.strBeaconMinorValue);
            
            if (objBeacon.strBeaconStatus==nil || objBeacon.strBeaconStatus==(NSString*)[NSNull null] || [objBeacon.strBeaconStatus isEqualToString:@""]) {
                
                [localScrollView setContentSize:CGSizeMake(localScrollView.frame.size.width, yLocalCoordinate)];
                
                [self convertScrollViewIntoImage];
                
                pageIndex=pageIndex+1;
                
                for (UIView *view in [scrollView subviews])
                {
                    [view removeFromSuperview];
                }
                
                [radioBtnDic removeAllObjects];
                
                [self designMultiView];
                
            }
            else
            {
                if ([objBeacon.strBeaconStatus isEqualToString:@"1"]) {
                    
                    
                    BOOL inRange=[self checkFromMultipleBeaconRange:objBeacon];
                    
                    if (inRange==TRUE) {
                        
                        [localScrollView setContentSize:CGSizeMake(localScrollView.frame.size.width, yLocalCoordinate)];
                        
                        [self convertScrollViewIntoImage];
                        
                        pageIndex=pageIndex+1;
                        
                        for (UIView *view in [scrollView subviews])
                        {
                            [view removeFromSuperview];
                        }
                        
                        [radioBtnDic removeAllObjects];
                        
                        [self designMultiView];
                        
                        
                        //[ConfigManager showAlertMessage:nil Message:@"You are in beacon range"];
                        
                    }
                    else
                    {
                        NSString *msg=[NSString stringWithFormat:@"Please goto %@",objBeacon.strBeaconDeviceName];
                        
                        [ConfigManager showAlertMessage:nil Message:msg];
                    }
                    
                }
                else
                {
                    [localScrollView setContentSize:CGSizeMake(localScrollView.frame.size.width, yLocalCoordinate)];
                    
                    [self convertScrollViewIntoImage];
                    
                    pageIndex=pageIndex+1;
                    
                    for (UIView *view in [scrollView subviews])
                    {
                        [view removeFromSuperview];
                    }
                    [radioBtnDic removeAllObjects];
                    
                    [self designMultiView];
                    
                }
                
            }
            
            
            
            
        }
        
        
        
    }
    
    
    
}
- (void)prevBtnPressed:(UIButton *)sender
{
    yLocalCoordinate = 0;
    
    for (UIView *view in [localScrollView subviews])
    {
        [view removeFromSuperview];
    }
    
    [localScrollView setContentSize:CGSizeMake(localScrollView.frame.size.width, yLocalCoordinate)];
    
    [self convertScrollViewIntoImage];
    
    pageIndex=pageIndex-1;
    
    for (UIView *view in [scrollView subviews])
    {
        [view removeFromSuperview];
    }
    [radioBtnDic removeAllObjects];
    
    [self designMultiView];
    
}
//- (void)cancelBtnPressed:(UIButton *)sender
//{
//    [self.view endEditing:YES];
//}


- (void)imgBtnPressed:(UIButton *)sender
{
    selectedBtn = (UIButton *)sender;
    
    self.selectedIndex=selectedBtn.tag;
    
    ACAlertView *alert=[[ACAlertView alloc] initWithTitle:@"Select Resource" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Picture", nil];
    alert.tag=102;
    [alert show];
    
}
-(void)signatureImgBtnPressed:(UIButton *)sender
{
    selectedBtn = (UIButton *)sender;
    self.selectedIndex=selectedBtn.tag;
    
    if (IS_DEVICE_IPAD) {
        
        [popover dismissPopoverAnimated:YES];
        [self.canvas removeFromSuperview];
        [self.signatureView removeFromSuperview];
        
        sharedAppDelegate.strCheckDrawLine=@"YES";
        
        self.canvas =[[SmoothLineView alloc] initWithFrame:self.drawingView.frame];
        sharedAppDelegate.strCheckDrawLine=@"YES";
        
        [self setLayouts];
        
        UIViewController* popoverContent = [[UIViewController alloc]init];
        
        popoverContent.preferredContentSize = CGSizeMake(400, 550);
        
        [popoverContent.view addSubview:self.signatureView];
        [popoverContent.view addSubview:self.canvas];
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        
        self.popover.popoverContentSize= CGSizeMake(400, 550);
        
        [popover presentPopoverFromRect:CGRectMake(250,100, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
    else
    {
        [self.canvas removeFromSuperview];
        [self.signatureView removeFromSuperview];
        sharedAppDelegate.strCheckDrawLine=@"YES";
        
        self.canvas =[[SmoothLineView alloc] initWithFrame:self.drawingView.frame];
        sharedAppDelegate.strCheckDrawLine=@"YES";
        
        [self.signatureView addSubview:self.canvas];
        [self setLayouts];
        
        // signatureView.layer.cornerRadius=5;
        // signatureView.clipsToBounds=YES;
        
        //[signatureView setFrame:CGRectMake(7, 30, signatureView.frame.size.width, signatureView.frame.size.height)];
        
        [sharedAppDelegate.window addSubview:self.signatureView];
        
    }
    
}
-(IBAction)btnSignatureSubmitAction:(id)sender
{
    UIGraphicsBeginImageContext(self.canvas.bounds.size);
    
    [self.canvas.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSLog(@"image size =%f %f",image.size.height,image.size.width);
    
    if([ConfigManager isInternetAvailable]){
        
        [selectedBtn setImage:image forState:UIControlStateNormal];
        
        if (IS_DEVICE_IPAD) {
            
            [self.popover dismissPopoverAnimated:YES];
            
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        isImageUpload = YES;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"attachment" forKey:@"attachment_key"];
        [dict setObject:@"uploadSignatureForm" forKey:@"request_path"];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
        [dict setObject:@"attachment" forKey:@"filename"];
        [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
        
        [[AmityCareServices sharedService] UploadSignatureInvocation:dict signature:(UIImageJPEGRepresentation(image, 0.50)) delegate:self];
        
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(IBAction)btnSignatureClearAction:(id)sender
{
    [self.canvas clear];
}
-(IBAction)btnCloseSignatureAction:(id)sender
{
    [self.signatureView removeFromSuperview];
    
}
-(void)audioBtnPressed:(UIButton*)sender
{
    
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

- (IBAction)employeeBtnPressed:(id)sender
{
    if (radioEmployeeBtn.selected) {
        
        [radioEmployeeBtn setSelected:NO];
    }
    else
    {
        [radioEmployeeBtn setSelected:YES];
        
    }
}
- (IBAction)managerBtnPressed:(id)sender
{
    if (radioManagerBtn.selected) {
        
        [radioManagerBtn setSelected:NO];
    }
    else
    {
        [radioManagerBtn setSelected:YES];
        
    }
}
- (IBAction)teamLeaderBtnPressed:(id)sender
{
    if (radioTLBtn.selected) {
        
        [radioTLBtn setSelected:NO];
    }
    else
    {
        [radioTLBtn setSelected:YES];
        
    }
}
/*- (IBAction)trainingBtnPressed:(id)sender
 {
 if (radioTrainingBtn.selected) {
 
 [radioTrainingBtn setSelected:NO];
 }
 else
 {
 [radioTrainingBtn setSelected:YES];
 
 }
 
 }*/
- (IBAction)familyBtnPressed:(id)sender
{
    if (radioFamilyBtn.selected) {
        
        [radioFamilyBtn setSelected:NO];
    }
    else
    {
        [radioFamilyBtn setSelected:YES];
        
    }
}
- (IBAction)bSBtnPressed:(id)sender
{
    if (radioBSBtn.selected) {
        
        [radioBSBtn setSelected:NO];
    }
    else
    {
        [radioBSBtn setSelected:YES];
        
    }
}
#pragma mark -
#pragma mark - TextField Deleagate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:tfTaskDate])
    {
        [textField resignFirstResponder];
        
        
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:tfTaskDate datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select Date"];
            
        }
        else
        {
            
            [self showDatePicker];
        }
        
        
    }
    
}

-(void)showDatePicker
{
    for(id x in [scrollView subviews]){
        if([x isKindOfClass:[UITextField class]] || [x isKindOfClass:[UITextView class]])
        {
            [x resignFirstResponder];
        }
        
    }
    
    
    toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(done)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 220.0+IPHONE_FIVE_FACTOR, 320.0, 44.0)];
        datePicker.frame=CGRectMake(0,264+IPHONE_FIVE_FACTOR,320, 216);
        
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 220.0, 320.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,264,320, 216);
        
    }
    
    [tfTaskDate resignFirstResponder];
    
}

-(IBAction)cancel
{
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [tfTaskDate resignFirstResponder];
    
}
-(IBAction)done
{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSDate *today  = [df2 dateFromString:[df2 stringFromDate:[NSDate date]]];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    /*  if ([today compare:date]==NSOrderedDescending) {
     tfTaskDate.text = @"";
     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"You can only add future task" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
     [alertView show];
     return;
     }*/
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    tfTaskDate.text = strDate;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [tfTaskDate resignFirstResponder];
    
    
}
-(void)selectDate:(id)sender
{
    [tfTaskDate resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSDate *today  = [df2 dateFromString:[df2 stringFromDate:[NSDate date]]];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    /* if ([today compare:date]==NSOrderedDescending) {
     tfTaskDate.text = @"";
     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"You can only add future task" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
     [alertView show];
     return;
     }*/
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    tfTaskDate.text = strDate;
}
-(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

#pragma mark -
#pragma mark - TextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        /*[UIView beginAnimations: @"anim" context: nil];
         [UIView setAnimationBeginsFromCurrentState: YES];
         [UIView setAnimationDuration: 0.25];
         [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
         [UIView commitAnimations];*/
        
        return NO;
        
    }
    
    
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        if (textField) {
            [textField resignFirstResponder];
            
            
            /* [UIView beginAnimations: @"anim" context: nil];
             [UIView setAnimationBeginsFromCurrentState: YES];
             [UIView setAnimationDuration: 0.25];
             [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
             [UIView commitAnimations];*/
        }
        
    }
    
    return YES;
}

#pragma mark- UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        
        checkClockOutTimer=@"form";
        
        [self.view removeFromSuperview];
        
        // [self.navigationController popViewControllerAnimated:YES];
        
        /*id controller = [self.navigationController viewControllers];
         
         for (id temp  in controller) {
         if([temp isKindOfClass:[UserTagsVC class]])
         {
         [self.navigationController popToViewController:temp animated:YES];
         break;
         }
         }*/
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
            self.imagePickerController= [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:selectedBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                //CGRect cameraViewFrame = CGRectMake(0, 0, 320, 568);
                CGRect cameraViewFrame =self.view.frame;

                
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
                    [self.popover presentPopoverFromRect:selectedBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else
                {
                    self.imagePickerView = self.imagePickerController.view;
                    
                   // CGRect cameraViewFrame = CGRectMake(0, 0, 320, 568);
                    CGRect cameraViewFrame =self.view.frame;

                    self.imagePickerView.frame = cameraViewFrame;
                    
                    [self.view addSubview:self.imagePickerView];
                    //  [self presentViewController:imagePickerController animated:YES completion:nil];
                }
            }
        }
        
    }
    
}

#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(buttonIndex==0)
    {
        //camera
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
        self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        if (IS_DEVICE_IPAD) {
            
            self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
            [self.popover presentPopoverFromRect:selectedBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
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
                [self.popover presentPopoverFromRect:selectedBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
        }
    }
}
#pragma mark -
#pragma mark - ImagePicker Controller Delegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [selectedBtn setImage:chosenImage forState:UIControlStateNormal];
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
        // [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    isImageUpload = YES;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"attachment" forKey:@"attachment_key"];
    [dict setObject:@"uploadDocForm" forKey:@"request_path"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
    [dict setObject:@"image.jpg" forKey:@"filename"];
    [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
    [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:(UIImageJPEGRepresentation(chosenImage, 0.50)) delegate:self];
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
#pragma mark- Invocation

-(void)uploadDocInvocationDidFinish:(UploadDocInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"uploadDocInvocationDidFinish =%@",dict);
    
    @try {
        
        if(!error)
        {
            if (isImageUpload)
            {
                id response = [dict valueForKey:@"response"];
                
                NSString *strSuccess = [response valueForKey:@"success"];
                
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setObject:[selectedBtn titleForState:UIControlStateReserved] forKey:@"label_name"];
                    [dic setObject:[response objectForKey:@"userImage"] forKey:@"label_value"];
                    [dic setObject:@"file" forKey:@"type"];
                    [dic setObject:[NSString stringWithFormat:@"%ld",self.selectedIndex] forKey:@"index"];
                    
                    [fileBtnArr addObject:dic];
                    
                    NSLog(@"submitDataArr %@",fileBtnArr);
                    
                }
                else if([strSuccess rangeOfString:@"false"].length>0)
                {
                    // [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                }
                
            }
            else
            {
                id response = [dict valueForKey:@"response"];
                
                NSString *strSuccess = [response valueForKey:@"success"];
                
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NULL_TO_NIL([response valueForKey:@"message"]) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    av.tag = 100;
                    [av show];
                }
                else if([strSuccess rangeOfString:@"false"].length>0)
                {
                    //  [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                }
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
-(void)UploadSignatureInvocationDidFinish:(UploadSignatureInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        
        NSString *strSuccess = [response valueForKey:@"success"];
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:[selectedBtn titleForState:UIControlStateReserved] forKey:@"label_name"];
            [dic setObject:[response objectForKey:@"file"] forKey:@"label_value"];
            [dic setObject:@"signature" forKey:@"type"];
            [dic setObject:[NSString stringWithFormat:@"%ld",self.selectedIndex] forKey:@"index"];
            
            [fileBtnArr addObject:dic];
            
            NSLog(@"submitDataArr %@",fileBtnArr);
            
        }
        else if([strSuccess rangeOfString:@"false"].length>0)
        {
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [self.signatureView removeFromSuperview];
    [DSBezelActivityView removeView];
}
-(void)UploadAudioInvocationDidFinish:(UploadAudioInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"uploadDocInvocationDidFinish =%@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        
        NSString *strSuccess = [response valueForKey:@"success"];
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:[selectedBtn titleForState:UIControlStateReserved] forKey:@"label_name"];
            [dic setObject:[response objectForKey:@"file"] forKey:@"label_value"];
            [dic setObject:@"audio" forKey:@"type"];
            [dic setObject:[NSString stringWithFormat:@"%ld",self.selectedIndex] forKey:@"index"];
            
            [fileBtnArr addObject:dic];
            
            NSLog(@"submitDataArr %@",fileBtnArr);
            
        }
        else if([strSuccess rangeOfString:@"false"].length>0)
        {
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}
- (void)GetFormDetailInvocationDidFinish:(GetFormDetailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFormNameInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            [self.totalFormArr removeAllObjects];
            [self.formsArr removeAllObjects];
            
            pageIndex=0;
            
            NSString* strSuccess = NULL_TO_NIL([dict valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSArray* formTag = [dict valueForKey:@"FormTag"];
                
                if([formTag count]>0)
                {
                    
                    NSMutableArray *formStructure = NULL_TO_NIL([formTag valueForKey:@"structure"]);
                    NSMutableArray *beaconStructure = NULL_TO_NIL([formTag valueForKey:@"Ibeacon"]);
                    
                    NSLog(@"%@",beaconStructure);
                    
                    NSLog(@"%lu",(unsigned long)[beaconStructure count]);
                    NSLog(@"%lu",(unsigned long)[formStructure count]);
                    
                    if ([formTypeStr isEqualToString:@"1"]) {
                        
                        for (int j = 0; j <[formStructure count]; j++)
                        {
                            NSDictionary *inner = [formStructure objectAtIndex:j];
                            
                            FormsField *ff = [[FormsField alloc] init];
                            
                            ff.strFieldRequired = NULL_TO_NIL([inner valueForKey:@"required"]);
                            ff.strFieldType = NULL_TO_NIL([inner valueForKey:@"type"]);
                            ff.strCSSClass = NULL_TO_NIL([inner valueForKey:@"cssClass"]);
                            
                            NSLog(@"Value %@",[inner valueForKey:@"values"]);
                            NSLog(@"type %@",[inner valueForKey:@"type"]);
                            NSLog(@"type %@",[inner valueForKey:@"required"]);
                            
                            if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)
                            {
                                ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                            }
                            
                            else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)
                            {
                                ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                            }
                            
                            else if ([ff.strFieldType caseInsensitiveCompare:@"select"] == NSOrderedSame)
                            {
                                ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                            }
                            
                            else
                                
                                ff.strFieldValue = NULL_TO_NIL([inner valueForKey:@"values"]);
                            
                            NSLog(@"ff.arrValues %@",ff.arrValues);
                            NSLog(@"ff.strFieldValue %@",ff.strFieldValue);
                            NSLog(@"ff.strTitle %@",ff.strTitle);
                            
                            [self.formsArr addObject:ff];
                        }
                        
                    }
                    
                    else
                    {
                        
                        for (int i = 0; i <[formStructure count]; i++)
                        {
                            NSMutableArray *formMultiStructure=[formStructure objectAtIndex:i];
                            [self.formsArr removeAllObjects];
                            NSMutableArray *arrFormData=[[NSMutableArray alloc] init];
                            NSMutableArray *arrBeanData=[[NSMutableArray alloc] init];
                            
                            NSLog(@"%@",formMultiStructure);
                            
                            for (int j = 0; j <[formMultiStructure count]; j++)
                            {
                                if ([[formMultiStructure objectAtIndex:j] isKindOfClass:[NSDictionary class]]) {
                                    
                                    NSDictionary *inner = [formMultiStructure objectAtIndex:j];
                                    
                                    FormsField *ff = [[FormsField alloc] init];
                                    
                                    ff.strFieldRequired = NULL_TO_NIL([inner valueForKey:@"required"]);
                                    ff.strFieldType = NULL_TO_NIL([inner valueForKey:@"type"]);
                                    ff.strCSSClass = NULL_TO_NIL([inner valueForKey:@"cssClass"]);
                                    
                                    NSLog(@"Value %@",[inner valueForKey:@"values"]);
                                    if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)
                                    {
                                        ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                        ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                                    }
                                    
                                    else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)
                                    {
                                        ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                        ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                                        
                                        NSLog(@"%@",NULL_TO_NIL([inner valueForKey:@"answerimage"]));
                                        
                                    }
                                    
                                    else if ([ff.strFieldType caseInsensitiveCompare:@"select"] == NSOrderedSame)
                                    {
                                        ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                        ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                                    }
                                    
                                    else
                                        ff.strFieldValue = NULL_TO_NIL([inner valueForKey:@"values"]);
                                    
                                    NSLog(@"ff.arrValues %@",ff.arrValues);
                                    NSLog(@"ff.strFieldValue %@",ff.strFieldValue);
                                    NSLog(@"ff.strTitle %@",ff.strTitle);
                                    
                                    NSLog(@"%@",ff.strFieldValue);
                                    
                                    [arrFormData addObject:ff];
                                }
                               
                                
                            }
                            
                            BOOL checkBeacon=FALSE;
                            
                            for(int k=0;k<[beaconStructure count]>0;k++)
                            {
                                NSDictionary *inner = [beaconStructure objectAtIndex:k];
                                
                                NSString *pageStr=[NSString stringWithFormat:@"%@",NULL_TO_NIL([inner valueForKey:@"page"])];
                                
                                NSLog(@"%@",pageStr);
                                
                                int pageValue=[pageStr intValue];
                                
                                NSLog(@"%d",pageValue);
                                
                                pageValue=pageValue-1;
                                
                                NSLog(@"%d",pageValue);
                                
                                if (pageValue==i) {
                                    
                                    checkBeacon=TRUE;
                                    
                                    IBeaconD *objIbeacon=[[IBeaconD alloc] init];
                                    
                                    objIbeacon.strBeaconStatus = @"1";
                                    objIbeacon.strBeaconDeviceName = [NSString stringWithFormat:@"%@",NULL_TO_NIL([inner valueForKey:@"device_name"])];
                                    objIbeacon.strBeaconUuid = [NSString stringWithFormat:@"%@",NULL_TO_NIL([inner valueForKey:@"uuid"])];
                                    objIbeacon.strBeaconMajorValue = [NSString stringWithFormat:@"%@",NULL_TO_NIL([inner valueForKey:@"major"])];
                                    objIbeacon.strBeaconMinorValue = [NSString stringWithFormat:@"%@",NULL_TO_NIL([inner valueForKey:@"minor"])];
                                    
                                    NSLog(@"%@",objIbeacon.strBeaconStatus);
                                    NSLog(@"%@",objIbeacon.strBeaconDeviceName);
                                    NSLog(@"%@",objIbeacon.strBeaconUuid);
                                    NSLog(@"%@",objIbeacon.strBeaconMajorValue);
                                    NSLog(@"%@",objIbeacon.strBeaconMinorValue);
                                    
                                    [arrBeanData addObject:objIbeacon];
                                }
                            }
                            
                            if (checkBeacon==FALSE) {
                                
                                IBeaconD *objIbeacon=[[IBeaconD alloc] init];
                                
                                objIbeacon.strBeaconStatus = @"0";
                                objIbeacon.strBeaconDeviceName = @"";
                                objIbeacon.strBeaconUuid = @"";
                                objIbeacon.strBeaconMajorValue = @"";
                                objIbeacon.strBeaconMinorValue = @"";
                                
                                [arrBeanData addObject:objIbeacon];
                            }
                            
                            
                            [self.totalFormArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:arrFormData,@"data",arrBeanData,@"beacon",nil]];
                            
                            NSLog(@"%lu",(unsigned long)[self.totalFormArr count]);
                            
                        }
                        
                        
                    }
                    
                    
                }
                else
                {
                    [self.totalFormArr removeAllObjects];
                    [self.formsArr removeAllObjects];
                    [ConfigManager showAlertMessage:nil Message:@"No Form found"];
                }
                
            }
            else
            {
                [self.totalFormArr removeAllObjects];
                [self.formsArr removeAllObjects];
                [ConfigManager showAlertMessage:nil Message:@"No form found"];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
            
            [self.totalFormArr removeAllObjects];
            [self.formsArr removeAllObjects];
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        NSLog(@"%lu",(unsigned long)[self.totalFormArr count]);
        
        if ([dict count]>0) {
            
            if ([self.formTypeStr isEqualToString:@"1"]) {
                
                [self designView];
                
            }
            else
            {
                [radioBtnDic removeAllObjects];
                
                [self designMultiView];
                
            }
        }
        
        [DSBezelActivityView removeView];
    }
}
#pragma mark iBeacons methods-

/*- (void)loadIbeaconsItems:(IBeaconD*)objBeacon
 {
 [self CanDeviceSupportAppBackgroundRefresh];
 
 sharedAppDelegate.arrIBeaconsList=[[NSMutableArray alloc] init];
 sharedAppDelegate.arrInRangeIbeacons=[[NSMutableArray alloc] init];
 
 self.uuidRegex=nil;
 RWTItem *item=nil;
 
 //IBeaconD *objBeacon=[[[self.totalFormArr objectAtIndex:pageIndex] objectForKey:@"beacon"] objectAtIndex:0];
 
 
 
 NSLog(@"%@",objBeacon.strBeaconStatus);
 NSLog(@"%@",objBeacon.strBeaconDeviceName);
 NSLog(@"%@",objBeacon.strBeaconUuid);
 NSLog(@"%@",objBeacon.strBeaconMajorValue);
 NSLog(@"%@",objBeacon.strBeaconMinorValue);
 
 
 NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
 self.uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
 options:NSRegularExpressionCaseInsensitive
 error:nil];
 
 
 NSString *firstMinorValue=objBeacon.strBeaconMinorValue;
 
 NSString *firstMajorValue=objBeacon.strBeaconMajorValue;
 
 NSString *firstUuid=objBeacon.strBeaconUuid;
 
 NSString *firstDeviceName=objBeacon.strBeaconDeviceName;
 
 if (firstMajorValue==nil || firstMajorValue==(NSString*)[NSNull null]) {
 
 firstMajorValue=@"";
 }
 if (firstMinorValue==nil || firstMinorValue==(NSString*)[NSNull null]) {
 
 firstMinorValue=@"";
 }
 if (firstUuid==nil || firstUuid==(NSString*)[NSNull null]) {
 
 firstUuid=@"";
 }
 if (firstDeviceName==nil || firstDeviceName==(NSString*)[NSNull null]) {
 
 firstDeviceName=@"";
 }
 
 NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:firstUuid
 options:kNilOptions
 range:NSMakeRange(0, firstUuid.length)];
 if (numberOfMatches > 0) {
 
 if (firstMinorValue.length>0 && firstMajorValue.length>0 && firstUuid.length>0 && firstDeviceName.length>0) {
 
 NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:firstUuid];
 
 item= [[RWTItem alloc] initWithName:firstDeviceName
 uuid:uuid
 major:[firstMajorValue intValue]
 minor:[firstMinorValue intValue]];
 
 item.currentBeaconName=firstDeviceName;
 
 NSLog(@"%d",item.majorValue);
 NSLog(@"%d",item.minorValue);
 NSLog(@"%@",item.name);
 NSLog(@"%@",item.uuid);
 
 item.currentProximity=@"";
 
 [sharedAppDelegate.arrIBeaconsList addObject:item];
 
 [self setItem:item];
 
 [self startMonitoringItem:item];
 
 [self persistItems];
 }
 
 }
 
 
 BOOL monitoringAvailable = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
 
 NSLog(@"Monitoring available: %@", [NSNumber numberWithBool:monitoringAvailable]);
 NSArray *locationServicesAuthStatuses = @[@"Not determined",@"Restricted",@"Denied",@"Authorized"];
 NSArray *backgroundRefreshAuthStatuses = @[@"Restricted",@"Denied",@"Available"];
 
 int lsAuth = (int)[CLLocationManager authorizationStatus];
 NSLog(@"Location services authorization status: %@", [locationServicesAuthStatuses objectAtIndex:lsAuth]);
 
 int brAuth = (int)[[UIApplication sharedApplication] backgroundRefreshStatus];
 NSLog(@"Background refresh authorization status: %@", [backgroundRefreshAuthStatuses objectAtIndex:brAuth]);
 
 NSLog(@"%d",[sharedAppDelegate.arrIBeaconsList count]);
 
 }
 - (void)persistItems {
 
 NSMutableArray *itemsDataArray = [NSMutableArray array];
 for (RWTItem *item in sharedAppDelegate.arrIBeaconsList) {
 NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
 [itemsDataArray addObject:itemData];
 }
 [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
 }
 - (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
 
 NSLog(@"beaconRegionWithItem");
 
 CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
 major:item.majorValue
 minor:item.minorValue
 identifier:item.name];
 
 if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
 {
 NSLog(@"I'm looking for a beacon");
 [sharedAppDelegate.locationManager startRangingBeaconsInRegion:beaconRegion];
 } else {
 NSLog(@"Device doesn't support beacons ranging");
 }
 
 return beaconRegion;
 }
 
 - (void)startMonitoringItem:(RWTItem *)item {
 
 NSLog(@"startMonitoringItem");
 
 CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
 [sharedAppDelegate.locationManager startMonitoringForRegion:beaconRegion];
 [sharedAppDelegate.locationManager startRangingBeaconsInRegion:beaconRegion];
 
 }
 
 - (void)stopMonitoringItem:(RWTItem *)item {
 
 NSLog(@"stopMonitoringItem");
 
 CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
 [sharedAppDelegate.locationManager stopMonitoringForRegion:beaconRegion];
 [sharedAppDelegate.locationManager stopRangingBeaconsInRegion:beaconRegion];
 }
 - (void)setItem:(RWTItem *)item {
 
 NSLog(@"setItem");
 
 if (sharedAppDelegate.beaconItem) {
 [sharedAppDelegate.beaconItem removeObserver:self forKeyPath:@"lastSeenBeacon"];
 
 NSLog(@"setItem1");
 
 }
 
 sharedAppDelegate.beaconItem = item;
 [sharedAppDelegate.beaconItem addObserver:self forKeyPath:@"lastSeenBeacon" options:NSKeyValueObservingOptionNew context:NULL];
 
 NSLog(@"item.name %@",item.name);
 
 
 }
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 
 }
 - (NSString *)nameForProximity:(CLProximity)proximity {
 
 // NSLog(@"proximity %d",proximity);
 
 switch (proximity) {
 case CLProximityUnknown:
 return @"Unknown";
 break;
 case CLProximityImmediate:
 return @"Immediate";
 break;
 case CLProximityNear:
 return @"Near";
 break;
 case CLProximityFar:
 return @"Far";
 break;
 }
 }
 
 - (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
 
 NSLog(@"didExitRegion");
 
 
 if ([region isKindOfClass:[CLBeaconRegion class]]) {
 //        UILocalNotification *notification = [[UILocalNotification alloc] init];
 //        notification.alertBody = @"Are you forgetting something?";
 //        notification.soundName = @"Default";
 //        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
 }
 }
 - (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
 NSLog(@"Failed monitoring region: %@", error);
 
 sharedAppDelegate.beaconsProximity=@"NO";
 
 NSLog(@"monitoringDidFailForRegion %@ %@",
 region, error.localizedDescription);
 
 for (CLRegion *monitoredRegion in manager.monitoredRegions) {
 
 NSLog(@"monitoredRegion: %@", monitoredRegion);
 }
 if ((error.domain != kCLErrorDomain || error.code != 5) &&
 [manager.monitoredRegions containsObject:region]) {
 NSString *message = [NSString stringWithFormat:@"%@ %@",
 region, error.localizedDescription];
 
 [ConfigManager showAlertMessage:@"monitoringDidFailForRegion" Message:message];
 }
 }
 - (void)locationManager:(CLLocationManager *)manager
 didRangeBeacons:(NSArray *)beacons
 inRegion:(CLBeaconRegion *)region
 {
 NSLog(@"didRangeBeacons");
 
 for (CLBeacon *beacon in beacons) {
 
 
 NSLog(@"didRangeBeacons1");
 
 for (RWTItem *item in sharedAppDelegate.arrIBeaconsList) {
 
 NSLog(@"didRangeBeacons2");
 
 
 item.lastSeenBeacon=nil;
 
 if ([item isEqualToCLBeacon:beacon]) {
 
 NSLog(@"didRangeBeacons3");
 
 
 item.lastSeenBeacon = beacon;
 
 NSLog(@"%d",item.majorValue);
 
 NSLog(@"%@",[self nameForProximity:item.lastSeenBeacon.proximity]);
 
 NSString *strProximity=[self nameForProximity:item.lastSeenBeacon.proximity];
 
 if ([strProximity isEqualToString:@"Immediate"] || [strProximity isEqualToString:@"Near"])
 {
 NSLog(@"YES");
 
 sharedAppDelegate.beaconsProximity=@"YES";
 
 
 }
 else
 {
 sharedAppDelegate.beaconsProximity=@"NO";
 NSLog(@"NO");
 
 }
 
 
 }
 
 else
 {
 //sharedAppDelegate.beaconsProximity=@"NO";
 
 
 }
 
 }
 }
 // [sharedAppDelegate.locationManager stopMonitoringForRegion:region];
 
 
 }
 
 
 - (void)beaconManager:(id)manager didStartMonitoringForRegion:(CLBeaconRegion *)region
 {
 NSLog(@"didStartMonitoringForRegion");
 
 }
 -(BOOL)CanDeviceSupportAppBackgroundRefresh
 {
 // Override point for customization after application launch.
 if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
 NSLog(@"Background updates are available for the app.");
 return YES;
 }
 else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
 {
 NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
 return NO;
 }
 else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
 {
 NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
 return NO;
 }
 
 return YES;
 }
 */

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
    
    //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];
    
}

#pragma mark -
#pragma mark - End Life Cycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
