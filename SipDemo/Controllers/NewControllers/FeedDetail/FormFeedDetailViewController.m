//
//  FormFeedDetailViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import "FormFeedDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "NSString+urlDecode.h"
#import "FormValues.h"
#import "UserLocationVC.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface FormFeedDetailViewController ()

@end

@implementation FormFeedDetailViewController

@synthesize feedDetails,audioLocalUrl,checkBSAndFamily,zoomView,locationVC;

#define timefontsize    12.0f
#define descfontsize    13.0f


- (void)viewDidLoad {
    [super viewDidLoad];
    
    checkSmile=TRUE;
    
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    imgUser.layer.cornerRadius = floor(imgUser.frame.size.width/2);
    imgUser.clipsToBounds = YES;
    
    scrollView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    scrollView.layer.borderWidth= 3.0f;
    
    scrollView.layer.cornerRadius = 5;
    scrollView.clipsToBounds = YES;
    
    viewForm.layer.cornerRadius = 5;
    viewForm.clipsToBounds = YES;
    
    NSLog(@"%@",feedDetails.postTagId);
    
    [self setFeedDetailsValues];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setFeedDetailsValues
{
    NSLog(@"%@",feedDetails.postUserName);
    
    [self setFrame];
    
    lblUserName.text=[feedDetails.postUserName capitalizedString];
    lblDate.text=self.feedDetails.postTime;
    lblFeedTitle.text=[self.feedDetails.postTitle capitalizedString];
    txtDesc.text=[self.feedDetails.postDesc capitalizedString];
    
    [imgUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,self.feedDetails.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        [permissionView setHidden:FALSE];
        
    }
    else
    {
        [permissionView setHidden:TRUE];
        
        
    }
    
    if ([self.feedDetails.postId isEqualToString:@"-1"])
    {
        [permissionView setHidden:TRUE];
        
        [btnFav setHidden:TRUE];
        [btnSadSmile setHidden:TRUE];
        [btnSmile setHidden:TRUE];
        
    }
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
        
        if([self.feedDetails.employeeStatusStr integerValue] == 1)
        {
            [radioEmployeeBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([self.feedDetails.managerStatusStr integerValue] == 1)
        {
            [radioManagerBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([self.feedDetails.teamLeaderStatusStr integerValue] == 1)
        {
            [radioTLBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([self.feedDetails.familyStatusStr integerValue] == 1)
        {
            [radioFamilyBtn setImage:img forState:UIControlStateNormal];
        }
        
        /* if([self.feedDetails.trainingStatusStr integerValue] == 1)
         {
         [radioTrainingBtn setImage:img forState:UIControlStateNormal];
         }*/
        
        if([self.feedDetails.bsStatusStr integerValue] == 1)
        {
            [radioBSBtn setImage:img forState:UIControlStateNormal];
        }
        
    }
    
    [self addTagsOnScrollView:self.feedDetails.arrSimiliarTags];
    
    
}
-(void)setFrame
{
    
    lblDate.font= [UIFont fontWithName:appfontName size:timefontsize];
    [lblUserName setFont:AC_FONT_GOTHIC_BOLD];
    [lblFeedTitle setFont:AC_FONT_GOTHIC_BOLD];
    [lblViewInmap setFont:[UIFont fontWithName:appfontName size:12.0]];
    [lblTags setFont:AC_FONT_GOTHIC_BOLD];
    [txtDesc setFont:[UIFont fontWithName:appfontName size:descfontsize]];
    
    [self addFormValuesOnScrollView:self.feedDetails.arrFormValues];
    
    int y=CGRectGetMaxY(viewForm.frame)+10;
    
    NSLog(@"%d",y);
    
    
    [lblFeedTitle setFrame:CGRectMake(lblFeedTitle.frame.origin.x, y, lblFeedTitle.frame.size.width, lblFeedTitle.frame.size.height)];
    
    y=CGRectGetMaxY(lblFeedTitle.frame)+10;
    
    if (self.feedDetails.postDesc==nil || self.feedDetails.postDesc==(NSString*)[NSNull null] || [self.feedDetails.postDesc isEqualToString:@""]) {
        
        [txtDesc setHidden:TRUE];
    }
    else
    {
        [txtDesc setHidden:FALSE];
        
        CGSize sizeToFit;
        
        if (IS_DEVICE_IPAD) {
            
           // sizeToFit= [self.feedDetails.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(400.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [self.feedDetails.postDesc boundingRectWithSize:CGSizeMake(400.0f, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:descfontsize]}
                                                       context:nil];
            
            sizeToFit = textRect.size;

            
        }
        else
        {
            
            CGRect textRect = [self.feedDetails.postDesc boundingRectWithSize:CGSizeMake(400.0f, CGFLOAT_MAX)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:descfontsize]}
                                                                     context:nil];
            
            sizeToFit = textRect.size;
            //sizeToFit= [self.feedDetails.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(285.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
        }
        
        
        [txtDesc setFrame:CGRectMake(txtDesc.frame.origin.x, y, txtDesc.frame.size.width, sizeToFit.height+20)];
        
        y=CGRectGetMaxY(txtDesc.frame)+10;
        
    }
    
    
    [lblTags setFrame:CGRectMake(lblTags.frame.origin.x,y,lblTags.frame.size.width, lblTags.frame.size.height)];
    
    y=CGRectGetMaxY(lblTags.frame)+10;
    
    if ([feedDetails.arrSimiliarTags count]>0) {
        
        
        [tagScroll setFrame:CGRectMake(tagScroll.frame.origin.x, y, tagScroll.frame.size.width, tagScroll.frame.size.height)];
        
        y=CGRectGetMaxY(tagScroll.frame)+10;
    }
    
    if (![feedDetails.postId isEqualToString:@"-1"]) {
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
        {
            [permissionView setFrame:CGRectMake(permissionView.frame.origin.x, y, permissionView.frame.size.width, permissionView.frame.size.height)];
            
            y=CGRectGetMaxY(permissionView.frame)+10;
            
            
            if (![sharedAppDelegate.userObj.userId isEqualToString:feedDetails.postUserId]) {
                
                [btnSadSmile setHidden:FALSE];
                [btnSmile setHidden:FALSE];
                [btnFav setHidden:FALSE];
                
                [btnFav setFrame:CGRectMake(btnFav.frame.origin.x, y, btnFav.frame.size.width, btnFav.frame.size.height)];
                
                [btnSadSmile setFrame:CGRectMake(btnSadSmile.frame.origin.x, y, btnSadSmile.frame.size.width, btnSadSmile.frame.size.height)];
                [btnSmile setFrame:CGRectMake(btnSmile.frame.origin.x, y, btnSmile.frame.size.width, btnSmile.frame.size.height)];
                
                y=CGRectGetMaxY(btnFav.frame)+10;

                
                if ([feedDetails.postStatus isEqualToString:@"1"]) {
                    
                    [btnSmile setImage:[UIImage imageNamed:@"smiley_tick"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setEnabled:FALSE];
                    [btnSmile setEnabled:FALSE];
                    
                }
                else if ([feedDetails.postStatus isEqualToString:@"2"]) {
                    
                    [btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley_tick"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setEnabled:FALSE];
                    [btnSmile setEnabled:FALSE];
                    
                }
                else
                {
                    [btnSmile setImage:[UIImage imageNamed:@"smiley"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setEnabled:TRUE];
                    [btnSmile setEnabled:TRUE];
                    
                }
                
            }
            else
            {
                [btnFav setFrame:CGRectMake(btnFav.frame.origin.x+60, y, btnFav.frame.size.width, btnFav.frame.size.height)];

                
                [btnSadSmile setHidden:TRUE];
                [btnSmile setHidden:TRUE];
                [btnFav setHidden:TRUE];
                
            }
            
            if ([feedDetails.postFavStatus isEqualToString:@"1"]) {
                
                [btnFav setImage:[UIImage imageNamed:@"star_tick"] forState:UIControlStateNormal];
            }
            else
            {
                [btnFav setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                
            }
            
        }
        else
        {
            [permissionView setHidden:TRUE];
            [btnFav setHidden:TRUE];
            [btnSadSmile setHidden:TRUE];
            [btnSmile setHidden:TRUE];
            
        }
        
    }
    else
    {
        [permissionView setHidden:TRUE];
        
        [btnFav setHidden:TRUE];
        [btnSadSmile setHidden:TRUE];
        [btnSmile setHidden:TRUE];
        
    }
    
    
    
    if (feedDetails.postTagId==nil || feedDetails.postTagId==(NSString*)[NSNull null]) {
        
    }
    else
    {
        if (![feedDetails.postId isEqualToString:@"-1"]) {
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]||[sharedAppDelegate.userObj.role isEqualToString:@"5"] || [sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                
                [scrollView addSubview:commentView];
                
                y=CGRectGetMaxY(commentView.frame)+10;
                
            }
            else
            {
                
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"])
                {
                    if ([self.checkBSAndFamily isEqualToString:@"YES"]) {
                        
                        [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                        
                        [scrollView addSubview:commentView];
                        
                        y=CGRectGetMaxY(commentView.frame)+10;
                    }
                    else
                    {
                        if (feedDetails.arrCommentValues==nil) {
                            
                        }
                        else
                        {
                            if ([feedDetails.arrCommentValues count]>0) {
                                
                                [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                                
                                [scrollView addSubview:commentView];
                                
                                y=CGRectGetMaxY(commentView.frame)+10;
                            }
                            
                        }
                        
                    }
                }
                else
                {
                    if (feedDetails.arrCommentValues==nil) {
                        
                    }
                    else
                    {
                        if ([feedDetails.arrCommentValues count]>0) {
                            
                            [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                            
                            [scrollView addSubview:commentView];
                            
                            y=CGRectGetMaxY(commentView.frame)+10;
                        }
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, y)];
    
    
    
}
-(void)addTagsOnScrollView:(NSMutableArray*)arrTag
{
    int startX = 0;
    
    for (int i = 0 ; i < [arrTag count]; i++) {
        
        Tags *tag = [arrTag objectAtIndex:i];
        
        UIButton* btnTag = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTag.titleLabel.font = [UIFont fontWithName:appfontName size:12.0f];
        btnTag.titleLabel.textColor = [UIColor whiteColor];
        [btnTag setBackgroundImage:[[UIImage imageNamed:@"tags.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0] forState:UIControlStateNormal];
        
        CGRect textRect = [tag.tagTitle boundingRectWithSize:CGSizeMake(200, 30)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:12.0]}
                                                                  context:nil];
        
        CGSize sizeToFit = textRect.size;

        int width= sizeToFit.width+20;
        
        //int width = [tag.tagTitle sizeWithFont:[UIFont fontWithName:appfontName size:12.0] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:NSLineBreakByTruncatingTail].width+20;
        btnTag.frame = CGRectMake(startX, 5, width, 30);
        
        [btnTag setTitle:tag.tagTitle forState:UIControlStateNormal];
        [btnTag setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [tagScroll addSubview:btnTag];
        
        startX = startX+width+10;
    }
    
    [tagScroll setContentSize:CGSizeMake(startX+10, 0)];
    //NSLog(@"content size =%@",NSStringFromCGSize(self.scrlView.frame.size));
}
-(void)addFormValuesOnScrollView:(NSMutableArray*)arrTag
{
    int y=0;
    
    NSArray *viewsToRemove = [viewForm subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    for (int i=0; i<[arrTag count]; i++) {
        
        FormValues *tag = [arrTag objectAtIndex:i];
        
        if ([tag.strFormTypeStr isEqualToString:@"heading"] || [tag.strFormTypeStr isEqualToString:@"description"]) {
            
            
            UILabel *lblQue=[[UILabel alloc] init];
            [lblQue setFont:[UIFont boldSystemFontOfSize:24]];

            CGSize size;
            
            if ([tag.strFormTypeStr isEqualToString:@"heading"]) {
                
                if (IS_DEVICE_IPAD) {
                    
                    CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(400,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]}
                                                                      context:nil];
                    
                    size = textRect.size;
                    
                    
                    [lblQue setFrame:CGRectMake(0, y, 400, size.height+10)];
                    
                }
                else
                {
                    CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(285,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]}
                                                                      context:nil];
                    
                    size = textRect.size;
                    [lblQue setFrame:CGRectMake(0, y, 285, size.height+10)];
                    
                }

            }
            else
            {
                [lblQue setFont:[UIFont boldSystemFontOfSize:17]];
                
                if (IS_DEVICE_IPAD) {
                    
                    CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(400,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}
                                                                      context:nil];
                    
                    size = textRect.size;
                    
                    
                    [lblQue setFrame:CGRectMake(0, y, 400, size.height+10)];
                    
                }
                else
                {
                    CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(285,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}
                                                                      context:nil];
                    
                    size = textRect.size;
                    [lblQue setFrame:CGRectMake(0, y, 285, size.height+10)];
                    
                }


            }
            
            [lblQue setBackgroundColor:[UIColor clearColor]];
            [lblQue setTextAlignment:NSTextAlignmentCenter];
            lblQue.numberOfLines=0;
            [lblQue setText:[NSString stringWithFormat:@"  %@",tag.strFormQueStr]];
            [viewForm addSubview:lblQue];
            
            
            y=y+size.height+15;
            
        }
        else
        {
            UILabel *lblQue=[[UILabel alloc] init];
            
            CGSize size;
            
            if (IS_DEVICE_IPAD) {
                
                CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(400,130000)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                                  context:nil];
                
                size = textRect.size;
                
                
                [lblQue setFrame:CGRectMake(0, y, 400, size.height+5)];
                
            }
            else
            {
                CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(285,130000)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                                  context:nil];
                
                size = textRect.size;
                [lblQue setFrame:CGRectMake(0, y, 285, size.height+5)];
                
            }
            
            [lblQue setBackgroundColor:[UIColor lightGrayColor]];
            [lblQue setTextAlignment:NSTextAlignmentLeft];
            [lblQue setFont:[UIFont boldSystemFontOfSize:14]];
            lblQue.numberOfLines=0;
            [lblQue setText:[NSString stringWithFormat:@"  %@",tag.strFormQueStr]];
            [viewForm addSubview:lblQue];
            
            y=y+size.height+15;
            
            if ([tag.strFormTypeStr isEqualToString:@"file"]) {
                
                UIImageView *imgForm;
                
                if (IS_DEVICE_IPAD) {
                    
                    imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(20, y+5, 360, 340)];
                    
                }
                else
                {
                    imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(40, y+5, 200, 200)];
                    
                }
                
                [imgForm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,tag.strFormAnsStr]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
                
                imgForm.layer.cornerRadius = 5;
                imgForm.clipsToBounds = YES;
                
                NSLog(@"%@%@",largePostThumbnailImageURL,tag.strFormAnsStr);
                
                [viewForm addSubview:imgForm];
                
                UIButton *btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                
                if (IS_DEVICE_IPAD) {
                    
                    [btnImage setFrame:CGRectMake(20, y+5, 360, 340)];
                    
                }
                else
                {
                    [btnImage setFrame:CGRectMake(40, y+5, 200, 200)];
                    
                }
                [btnImage addTarget:self action:@selector(btnFormImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                [btnImage setTitle:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,tag.strFormAnsStr] forState:UIControlStateReserved];
                
                [viewForm addSubview:btnImage];
                
                if (IS_DEVICE_IPAD) {
                    
                    y=y+340+20;
                    
                }
                else
                {
                    y=y+200+20;
                    
                }
                
            }
            else if ([tag.strFormTypeStr isEqualToString:@"signature"]) {
                
                UIImageView *imgForm;
                
                if (IS_DEVICE_IPAD) {
                    
                    imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(20, y+5, 360, 340)];
                    
                }
                else
                {
                    imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(40, y+5, 200, 200)];
                    
                }
                
                [imgForm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,tag.strFormAnsStr]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
                
                imgForm.layer.cornerRadius = 5;
                imgForm.clipsToBounds = YES;
                
                NSLog(@"%@%@",largePostThumbnailImageURL,tag.strFormAnsStr);
                
                [viewForm addSubview:imgForm];
                
                UIButton *btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                
                if (IS_DEVICE_IPAD) {
                    
                    [btnImage setFrame:CGRectMake(20, y+5, 360, 340)];
                    
                }
                else
                {
                    [btnImage setFrame:CGRectMake(40, y+5, 200, 200)];
                    
                }
                [btnImage addTarget:self action:@selector(btnFormImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                [btnImage setTitle:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,tag.strFormAnsStr] forState:UIControlStateReserved];
                
                [viewForm addSubview:btnImage];
                
                if (IS_DEVICE_IPAD) {
                    
                    y=y+340+20;
                    
                }
                else
                {
                    y=y+200+20;
                    
                }
                
            }
            else if ([tag.strFormTypeStr isEqualToString:@"audio"]){
                UIView *outputAudioView=[[UIView alloc] init];
                [outputAudioView setBackgroundColor:[UIColor clearColor]];
                
                UIButton *outputAudioButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [outputAudioButton setFrame:CGRectMake(14, y+5, 40, 40)];
                [outputAudioButton addTarget:self action:@selector(btnOutputAudioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [outputAudioButton setBackgroundImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
                [outputAudioButton setBackgroundImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateSelected];
                [outputAudioButton setTag:i*10+10];
                
                UISlider *outputAudioSlider=[[UISlider alloc] init];
                //[outputAudioSlider addTarget:self action:@selector(btnAudioSliderMoveAction:) forControlEvents:UIControlEventValueChanged];
                [outputAudioSlider setTag:i*10+10];
                
                
                if (IS_DEVICE_IPAD) {
                    
                    [outputAudioView setFrame:CGRectMake(0, y, 450, 60)];
                    [outputAudioSlider setFrame:CGRectMake(65, y+10, 370, 31)];
                    
                }
                else
                {
                    [outputAudioView setFrame:CGRectMake(0, y, 285, 60)];
                    [outputAudioSlider setFrame:CGRectMake(65, y+10, 208, 31)];
                }
                
                [viewForm addSubview:outputAudioButton];
                [viewForm addSubview:outputAudioSlider];
                
                //[viewForm addSubview:outputAudioView];
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
                
                NSArray *array=[[NSArray alloc] initWithObjects:tag.strFormAnsStr,outputAudioButton,outputAudioSlider, nil];
                
                [self performSelector:@selector(saveAudioUrl:) withObject:array afterDelay:0.1];
                
                
                /*  [outputAudioView setFrame:CGRectMake(0, y, outputAudioView.frame.size.width, outputAudioView.frame.size.height)];
                 
                 [viewForm addSubview:outputAudioView];
                 
                 [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
                 
                 NSArray *array=[[NSArray alloc] initWithObjects:tag.strFormAnsStr,outputAudioButton,outputAudioSlider, nil];
                 
                 [self performSelector:@selector(saveAudioUrl:) withObject:array afterDelay:0.1];
                 
                 [outputAudioButton setTitle:self.audioLocalUrl forState:UIControlStateReserved];*/
                
                y=y+60;
                
            }
            else{
                UILabel *lblAns=[[UILabel alloc] init];
                
                CGSize Ansize;
                
                if (IS_DEVICE_IPAD) {
                    
                    // Ansize= [tag.strFormAnsStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(382,130000)lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGRect textRect = [tag.strFormAnsStr boundingRectWithSize:CGSizeMake(382,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                      context:nil];
                    
                    Ansize = textRect.size;
                    
                    [lblAns setFrame:CGRectMake(8, y, 382, Ansize.height+5)];
                    
                }
                else
                {
                    // Ansize= [tag.strFormAnsStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(267,130000)lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGRect textRect = [tag.strFormAnsStr boundingRectWithSize:CGSizeMake(267,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                      context:nil];
                    
                    Ansize = textRect.size;
                    
                    
                    [lblAns setFrame:CGRectMake(8, y, 267, Ansize.height+5)];
                    
                    
                }
                
                [lblAns setBackgroundColor:[UIColor clearColor]];
                [lblAns setTextColor:[UIColor grayColor]];
                [lblAns setTextAlignment:NSTextAlignmentLeft];
                [lblAns setFont:[UIFont systemFontOfSize:14]];
                [lblAns setText:tag.strFormAnsStr];
                lblAns.numberOfLines=0;
                
                [viewForm addSubview:lblAns];
                
                y=y+Ansize.height+15;
                
            }
            
            NSLog(@"%@",tag.strFormUrlTypeStr);
            
            if (![tag.strFormUrlTypeStr isEqualToString:@""]) {
                
                if ([tag.strFormUrlTypeStr isEqualToString:@"1"]) {
                    UIImageView *imgForm;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(20, y+5, 360, 340)];
                        
                    }
                    else
                    {
                        imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(40, y+5, 200, 200)];
                        
                    }
                    
                    [imgForm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",formOriginalAnswerImageUrl,tag.strFormImageStr]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
                    
                    imgForm.layer.cornerRadius = 5;
                    imgForm.clipsToBounds = YES;
                    
                    NSLog(@"%@%@",formOriginalAnswerImageUrl,tag.strFormImageStr);
                    
                    [viewForm addSubview:imgForm];
                    
                    UIButton *btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                    
                    if (IS_DEVICE_IPAD) {
                        
                        [btnImage setFrame:CGRectMake(20, y+5, 360, 340)];
                        
                    }
                    else
                    {
                        [btnImage setFrame:CGRectMake(40, y+5, 200, 200)];
                        
                    }
                    [btnImage addTarget:self action:@selector(btnFormImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                    [btnImage setTitle:[NSString stringWithFormat:@"%@%@",formOriginalAnswerImageUrl,tag.strFormImageStr] forState:UIControlStateReserved];
                    
                    [viewForm addSubview:btnImage];
                    
                    if (IS_DEVICE_IPAD) {
                        
                        y=y+340+20;
                        
                    }
                    else
                    {
                        y=y+200+20;
                        
                    }
                    
                }
                else if ([tag.strFormUrlTypeStr isEqualToString:@"2"])
                {
                    UIWebView *webView;
                    
                    if (IS_DEVICE_IPAD) {
                        
                        webView=[[UIWebView alloc] initWithFrame:CGRectMake(20, y+5, 360, 340)];
                        
                    }
                    else
                    {
                        webView=[[UIWebView alloc] initWithFrame:CGRectMake(40, y+5, 200, 200)];
                        
                    }
                    
                    webView.layer.cornerRadius = 5;
                    webView.clipsToBounds = YES;
                    [webView setBackgroundColor:[UIColor blackColor]];
                    [viewForm addSubview:webView];
                    
                    NSString *embedHTML;
                    
                    NSLog(@"%@",tag.strFormVideoStr);
                    
                    if (IS_DEVICE_IPAD) {
                        
                        embedHTML= [NSString stringWithFormat:@"\
                                    <html><head>\
                                    <style type=\"text/css\">\
                                    body {\
                                    background-color: black;\
                                    color: black;\
                                    }\
                                    </style>\
                                    </head><body style=\"margin:20\">\
                                    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                                    width=\"360.0f\" height=\"340.0f\"></embed>\
                                    </body></html>",tag.strFormVideoStr];
                        
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
                                    width=\"200.0f\" height=\"200.0f\"></embed>\
                                    </body></html>",tag.strFormVideoStr];
                        
                    }
                    [webView loadHTMLString:embedHTML baseURL:nil];
                    
                    
                    if (IS_DEVICE_IPAD) {
                        
                        y=y+340+20;
                        
                    }
                    else
                    {
                        y=y+200+20;
                        
                    }
                    
                }
                
            }

        }
        
        
    }
    
    NSLog(@"%d",y);
    
    [viewForm setFrame:CGRectMake(viewForm.frame.origin.x, viewForm.frame.origin.y, viewForm.frame.size.width,y)];
    
    NSLog(@"%f",viewForm.frame.size.height);
    
    
}
-(void)addCommentsOnScrollView:(NSMutableArray*)arrComment yView:(int)yView
{
    int y=0;
    
    NSArray *viewsToRemove = [commentView subviews];
    
    for (UIView *v in viewsToRemove) {
        
        if ([v isKindOfClass:[UILabel class]]) {
            
            [v removeFromSuperview];
            
        }
        
    }
    
    for (int i=0; i<[arrComment count]; i++) {
        
        CommentValues *comment = [arrComment objectAtIndex:i];
        
        NSString *commentStr=[NSString stringWithFormat:@"%@   %@",comment.commentUserName,comment.commentMsg];
        
        UILabel *lblName=[[UILabel alloc] init];
        
        CGSize size;
        
        if (IS_DEVICE_IPAD) {
            
           // size= [commentStr sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(400,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [commentStr boundingRectWithSize:CGSizeMake(400,130000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                              context:nil];
            
            size = textRect.size;

            
            [lblName setFrame:CGRectMake(6, y, 390, size.height+5)];
            
        }
        else
        {
           // size= [commentStr sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(285,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [commentStr boundingRectWithSize:CGSizeMake(285,130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                       context:nil];
            
            size = textRect.size;
            
            [lblName setFrame:CGRectMake(6, y, 275, size.height+5)];
            
        }
        
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTextAlignment:NSTextAlignmentLeft];
        [lblName setFont:[UIFont systemFontOfSize:15]];
        lblName.numberOfLines=0;
        //[lblName setText:[NSString stringWithFormat:@"%@",commentStr]];
        [commentView addSubview:lblName];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:commentStr];
        
        NSRange selectedRange = NSMakeRange(0, comment.commentUserName.length); // 4 characters, starting at index 22
        
        [string beginEditing];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:15]
                       range:selectedRange];
        
        [string endEditing];
        
        [lblName setAttributedText:string];
        
        y=y+size.height+15;
        
    }
    
    [txtCommentView setFrame:CGRectMake(txtCommentView.frame.origin.x, y+10, txtCommentView.frame.size.width, txtCommentView.frame.size.height)];
    
    y=CGRectGetMaxY(txtCommentView.frame)+10;
    
    [commentView setFrame:CGRectMake(3, yView, commentView.frame.size.width,y)];
    
}

-(void)saveAudioUrl:(NSArray*)array
{
    
    NSString *audioUrl=[NSString stringWithFormat:@"%@%@",audioOutputUrl,[array objectAtIndex:0]];
    
    NSLog(@"%@",audioUrl);
    
    //NSData *audioData=[NSData dataWithContentsOfURL:[NSURL URLWithString:audioUrl]];
    
    NSString* userAgent;
    if (IS_DEVICE_IPAD) {
        
        userAgent=@"iPad";
        
    }
    else
    {
        userAgent=@"iPhone";

        
    }
    
    NSURL* url = [NSURL URLWithString:audioUrl];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url]
                                ;
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* audioData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSLog(@"%lu",(unsigned long)audioData.length);

    
    NSDate *date2 = [NSDate date];
    time_t interval1 = (time_t) [date2 timeIntervalSince1970];
    NSTimeInterval timeInMiliseconds1 = [[NSDate date] timeIntervalSince1970];
    
    NSString *timestampStr1= [NSString stringWithFormat:@"%ld%f", interval1,timeInMiliseconds1];
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    
    documentsDirectory1=[documentsDirectory1 stringByAppendingPathComponent:timestampStr1];
    NSString *savedAudioLocalPath = [documentsDirectory1 stringByAppendingFormat:@"%@",@"savedAudio.mp3"];
    [audioData writeToFile:savedAudioLocalPath atomically:NO];
    
    [[array objectAtIndex:1] setTitle:savedAudioLocalPath forState:UIControlStateReserved];
    
    self.audioLocalUrl=savedAudioLocalPath;
    
    [DSBezelActivityView removeView];
    
}
#pragma mark - IBAction Methods
-(IBAction)btnCrossAction:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
        
    }
    else
    {
        [self.view removeFromSuperview];
        
    }
}

-(IBAction)btnFormImagePressed:(UIButton*)sender
{
    [self.zoomView removeFromSuperview];
    
    [self.zoomView setFrame:scrollView.frame];
    largeImgView.layer.cornerRadius = 5.0f;
    largeImgView.clipsToBounds = YES;
    
    [largeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[sender titleForState:UIControlStateReserved]]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [self.view addSubview:self.zoomView];
    
}
-(IBAction)btnCloseLargeImgViewAction:(id)sender
{
    [self.zoomView removeFromSuperview];
}


-(IBAction)btnCloseAction:(id)sender
{
    
}
-(IBAction)btnMapLocationAction:(id)sender
{
    // if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
    
    if (self.feedDetails.latitude<=0 && self.feedDetails.longitude<=0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Location not available"];
    }
    else
    {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC" bundle:nil];
        }
        else
        {
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC_iphone" bundle:nil];
        }
        self.locationVC.feed = self.feedDetails;
        self.locationVC.checkLocationView=@"map";
        
        [self.view addSubview:self.locationVC.view];
        
    }
    
}
-(IBAction)btnOutputAudioBtnAction:(UIButton*)sender
{
    
    NSLog(@"%@",[sender titleForState:UIControlStateReserved]);
    
    NSURL *url=[NSURL URLWithString:[sender titleForState:UIControlStateReserved]];
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    
    /*AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);*/
    NSError* error;

    [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
    [audioSession setActive:YES error: nil];
    
    NSLog(@"%@",url);
    
    UISlider *slider;
    
    for(UIView * subView in viewForm.subviews ) // here write Name of you ScrollView.
    {
        if([subView isKindOfClass:[UISlider class]]) // Check is SubView Class Is UILabel class?
        {
            for(UISlider * sliderObj in viewForm.subviews)
            {
                NSLog(@"sliderObj.tag %ld",(long)sliderObj.tag);
                NSLog(@"sender.tag %ld",(long)sender.tag);
                
                if (sliderObj.tag==sender.tag) {
                    
                    slider=sliderObj;
                }
                
            }
            
        }
    }
    
    if (audioPlayer.playing) {
        
        sender.selected=NO;
        
        slider.value = 0.0;
        slider.enabled=YES;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [audioPlayer stop];
    }
    else
    {
        sender.selected=YES;
        slider.enabled = YES;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        [audioPlayer prepareToPlay];
        
        slider.maximumValue = [audioPlayer duration];
        slider.value = 0.0;
        slider.maximumValue = audioPlayer.duration;
        audioPlayer.currentTime = slider.value;
        
        NSLog(@"%f",[audioPlayer duration]);
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:sender repeats:YES];
        [audioPlayer play];
        
    }
}
- (void)updateTime:(NSTimer *)timer
{
    UIButton *btn=[timer userInfo];
    
    UISlider *slider;
    
    for(UIView * subView in viewForm.subviews ) // here write Name of you ScrollView.
    {
        if([subView isKindOfClass:[UISlider class]]) // Check is SubView Class Is UILabel class?
        {
            for(UISlider * sliderObj in viewForm.subviews)
            {
                if (sliderObj.tag==btn.tag) {
                    
                    NSLog(@"sliderObj.tag 1111 %ld",(long)sliderObj.tag);
                    NSLog(@"sender.tag 1111 %ld",(long)btn.tag);
                    
                    slider=sliderObj;
                }
                
            }
            
        }
    }
    
    slider.value = audioPlayer.currentTime;
    
    NSLog(@"%f",audioPlayer.currentTime);
    
    if (slider.value<=0) {
        
        slider.enabled=NO;
        
        btn.selected=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
    }
    
}

- (IBAction)employeeBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    NSLog(@"%@",feedDetails.employeeStatusStr);
    
    if ([feedDetails.employeeStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        // [radioEmployeeBtn setSelected:true];
        [radioEmployeeBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        //[radioEmployeeBtn setSelected:NO];
        
        [radioEmployeeBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
        
    }

    
    feedDetails.employeeStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
    // [dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:statusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
    
}
- (IBAction)managerBtnPressed:(id)sender
{
    NSString *statusStr;
    
    UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
    
    if (radioManagerBtn.currentImage == img)
    {
        statusStr = @"0";
        [radioManagerBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
    }
    else
    {
        statusStr = @"1";
        
        [radioManagerBtn setImage:img forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:statusStr forKey:@"manager"];
    
    if(radioEmployeeBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"employee"];
    else
        [dic setObject:@"0" forKey:@"employee"];
    
    if(radioTLBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"teamleader"];
    else
        [dic setObject:@"0" forKey:@"teamleader"];
    
    if(radioFamilyBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"family"];
    else
        [dic setObject:@"0" forKey:@"family"];
    
    /* if(radioTrainingBtn.currentImage == img)
     [dic setObject:@"1" forKey:@"training"];
     else
     [dic setObject:@"0" forKey:@"training"];*/
    
    if(radioBSBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"BS"];
    else
        [dic setObject:@"0" forKey:@"BS"];
    
    
    [dic setObject:feedDetails.postId forKey:@"post_id"];
    [dic setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dic delegate:self];
    
}
- (IBAction)teamLeaderBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    
    if ([feedDetails.teamLeaderStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioTLBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        [radioTLBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
    }    feedDetails.teamLeaderStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:statusStr forKey:@"teamleader"];
    [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
    //[dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
}
/*- (IBAction)trainingBtnPressed:(id)sender
 {
 
 NSString *statusStr;
 
 if ([feedDetails.trainingStatusStr isEqualToString:@"0"]) {
 
 statusStr=@"1";
 [radioTrainingBtn setSelected:YES];
 
 }
 else
 {
 statusStr=@"0";
 [radioTrainingBtn setSelected:NO];
 
 }
 feedDetails.trainingStatusStr=statusStr;
 
 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
 [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
 [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
 [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
 [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
 [dict setObject:statusStr forKey:@"training"];
 [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
 [dict setObject:feedDetails.postId forKey:@"post_id"];
 [dict setObject:feedDetails.postUserId forKey:@"user_id"];
 
 [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
 
 [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
 
 
 }*/
- (IBAction)familyBtnPressed:(id)sender
{
    NSString *statusStr;
    
    if ([feedDetails.familyStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioFamilyBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        [radioFamilyBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
    }

    feedDetails.familyStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:statusStr forKey:@"family"];
    //[dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
    
    
}
- (IBAction)bSBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    
    if ([feedDetails.bsStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioBSBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        [radioBSBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
    }
    feedDetails.bsStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:statusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
    //[dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
}

-(IBAction)favButtonAction:(id)sender
{
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddFavoriteInvocation:sharedAppDelegate.userObj.userId tagId:feedDetails.postTagId feedId:feedDetails.postId delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)smileButtonAction:(id)sender
{
    
    if([ConfigManager isInternetAvailable]){
        
        checkSmile=TRUE;
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddSmileInvocation:feedDetails.postUserId tagId:feedDetails.postTagId feedId:feedDetails.postId status:@"0" delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(IBAction)sadSmileButtonAction:(id)sender
{
    if([ConfigManager isInternetAvailable]){
        
        checkSmile=FALSE;
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddSmileInvocation:feedDetails.postUserId tagId:feedDetails.postTagId feedId:feedDetails.postId status:@"1" delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}


- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        [self scrollViewToCenterOfScreen:commentView];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([str length] > 0){
        
        [self requestSendChatText:str];
    }
    
    return TRUE;
    
}

- (void)requestSendChatText:(NSString*)message{
    
    if([ConfigManager isInternetAvailable]){
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        NSLog(@"%@",feedDetails.postId);
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:feedDetails.postId forKey:@"post_id"];
        [dic setObject:feedDetails.postTagId forKey:@"tag_id"];
        
        if (![message isEqualToString:@""]) {
            
            [dic setValue:[QSStrings encodeBase64WithString:message] forKey:@"comment"];
            
        }
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
        
        [[AmityCareServices sharedService] AddCommentInvocation:dic delegate:self];
        
    }
    else{
        [txtCommentView setText:nil];
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

#pragma mark - Status Invocation Delegates

- (void)statusInvocationDidFinish:(StatusInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    if(!error)
    {
        NSString* strSuccess = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
-(void)AddCommentInvocationDidFinish:(AddCommentInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    if(!error)
    {
        NSString* strSuccess = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"success"]);
        NSString* strCommentId = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"commentId"]);
        NSString* strCommentDate = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"time"]);
        
        NSLog(@"%@",strSuccess);
        
        if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
            
            [ConfigManager showAlertMessage:nil Message:@"Comment has not submitted"];

        }
        else
        {
            CommentValues *t = [[CommentValues alloc] init];
            
            t.commentId=[NSString stringWithFormat:@"%@",strCommentId];
            t.commentUserId = sharedAppDelegate.userObj.userId;
            t.commentUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
            t.commentUserImage = @"";
            t.commentDate = [NSString stringWithFormat:@"%@",strCommentDate];
            t.commentMsg = txtCommentView.text;
            
            [feedDetails.arrCommentValues addObject:t];
            
            [self setFeedDetailsValues];
            
            [DSBezelActivityView removeView];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
    txtCommentView.text=@"";
    
}

#pragma mark- Add Favorite Invocation

-(void)AddFavoriteInvocationDidFinish:(AddFavoriteInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            
            feedDetails.postFavStatus=@"1";
            [btnFav setImage:[UIImage imageNamed:@"star_tick"] forState:UIControlStateNormal];
            
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}


#pragma mark- Add Smile Invocation

-(void)AddSmileInvocationDidFinish:(AddSmileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            if (checkSmile==TRUE) {
                
                feedDetails.postStatus=@"1";
                
                [btnSmile setImage:[UIImage imageNamed:@"smiley_tick"] forState:UIControlStateNormal];
                
            }
            else
            {
                feedDetails.postStatus=@"2";

                 [btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley_tick"] forState:UIControlStateNormal];

            }
            
            
            [btnSadSmile setEnabled:FALSE];
            [btnSmile setEnabled:FALSE];
            
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
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
