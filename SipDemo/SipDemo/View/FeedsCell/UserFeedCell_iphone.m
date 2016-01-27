//
//  UserFeedCell_iphone.m
//  Amity-Care
//
//  Created by Shweta Sharma on 20/10/14.
//
//

#import "UserFeedCell_iphone.h"
#import "UIImageView+WebCache.h"
#import "NSString+urlDecode.h"
#import "AppDelegate.h"

@implementation UserFeedCell_iphone

@synthesize viewMainBg,viewHearder,imgPostUserImgBg,imgPostUserImg,lblPostUserName,lblTime,lblViewInmap,btnLocMap;
@synthesize imgThumbnailBgOfDoc,viewThumbnailDocument,imgThumbnailOfDoc,btnThumbnail;

@synthesize viewDocDesc,lblTitleOfDoc,lblDescOfDoc;
@synthesize viewTags,lblTags,scrlView,lowerView;

@synthesize customEmployeeBtn,customManagerBtn,customTLBtn,customFamlityBtn,customTrainingBtn,customBSBtn,radioEmployeeBtn,radioManagerBtn,radioTLBtn,radioFamilyBtn,radioBSBtn,radioTrainingBtn,viewForm;

@synthesize delegate;

#define timefontsize    10.0f
#define descfontsize    13.0f

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//Post Type

//TODO: PostType
/*
 1->    Image document
 2->    Video
 3->    Docu
 4->    status
 5->    ClockIn Map image
 */

#pragma mark- Layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.viewForm.layer.cornerRadius=5;
    self.viewForm.clipsToBounds=YES;
    
    self.imgPostUserImg.layer.cornerRadius = floor(self.imgPostUserImg.frame.size.width/2.0);
    self.imgPostUserImg.clipsToBounds=YES;
    
    self.lblPostUserName.font = AC_FONT_GOTHIC_BOLD;
    self.lblPostUserName.adjustsFontSizeToFitWidth = YES;
    self.lblTime.font = [UIFont fontWithName:appfontName size:timefontsize];
    self.lblViewInmap.font = [UIFont fontWithName:appfontName size:11.0];
    self.lblTitleOfDoc.font = AC_FONT_GOTHIC_BOLD;
    self.lblDescOfDoc.font = [UIFont fontWithName:appfontName size:descfontsize];
    self.lblDescOfDoc.numberOfLines = 0;
    [self.imgThumbnailOfDoc setAlpha:0.3];
    
   /* [self.viewDocDesc setFrame:CGRectMake(self.viewDocDesc.frame.origin.x, 280, 320, 80)];
    
    [self.lblTitleOfDoc setFrame:CGRectMake(self.lblTitleOfDoc.frame.origin.x, 4, self.lblTitleOfDoc.frame.size.width, 21)];
    
    
    [self.lblDescOfDoc setFrame:CGRectMake(self.lblDescOfDoc.frame.origin.x, 34, self.lblDescOfDoc.frame.size.width, 21)];
    
    [self.lblTags setFrame:CGRectMake(self.lblTags.frame.origin.x, 50, 60, 25)];
*/
    
    int height = ceil([[self class] heightForCellWithPost:self.feed]);
    
    int factor =[self.feed.postType isEqualToString:@"4"]?115:355;
    
    CGRect frame = self.lblDescOfDoc.frame;
    frame.size.height = height - factor;
    self.lblDescOfDoc.frame = frame;
    
    if([self.feed.postType isEqualToString:@"4"])
    {
        
        frame = self.lblTags.frame;
        frame.origin.y = CGRectGetMaxY(self.lblDescOfDoc.frame)+5;
        self.lblTags.frame = frame;
        
        [self.viewDocDesc setFrame:CGRectMake(self.viewDocDesc.frame.origin.x, 0, 320, CGRectGetMaxY(self.lblTags.frame))];

        frame = self.viewDocDesc.frame;
        frame.origin.y = 80;
        frame.size.height = CGRectGetMaxY(self.lblDescOfDoc.frame)+5;
        self.viewDocDesc.frame = frame;
        
        frame = self.lowerView.frame;
        frame.origin.y = CGRectGetMaxY(self.viewDocDesc.frame)-2;
        self.lowerView.frame = frame;
        
        
        float height = CGRectGetMaxY(lowerView.frame);
        
           
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, height);
        
        
        [self.lowerView setUserInteractionEnabled:TRUE];
        
    }
    else{
        
        [self.viewDocDesc setFrame:CGRectMake(self.viewDocDesc.frame.origin.x, 280, 320, 80)];

        [self.lblTitleOfDoc setFrame:CGRectMake(self.lblTitleOfDoc.frame.origin.x, 4, self.lblTitleOfDoc.frame.size.width, 21)];
        
        
        [self.lblDescOfDoc setFrame:CGRectMake(self.lblDescOfDoc.frame.origin.x, 34, self.lblDescOfDoc.frame.size.width, 21)];
        
        [self.lblTags setFrame:CGRectMake(self.lblTags.frame.origin.x, 50, 60, 25)];

        
        frame = self.lblTags.frame;
        frame.origin.y = CGRectGetMaxY(self.lblDescOfDoc.frame)+5;
        self.lblTags.frame = frame;
        
        
        frame = self.viewDocDesc.frame;
        frame.size.height = CGRectGetMaxY(self.lblTags.frame);
        self.viewDocDesc.frame = frame;
        self.lblTags.font = [UIFont fontWithName:appfontName size:15.0];
        
        

        [self.lblTags setFrame:CGRectMake(self.lblTags.frame.origin.x, self.viewDocDesc.frame.size.height-25, 60, 25)];

        [self.scrlView setFrame:CGRectMake(self.scrlView.frame.origin.x, CGRectGetMaxY(self.viewDocDesc.frame), self.scrlView.frame.size.width, self.scrlView.frame.size.height)];
        
        
        
        [self.scrlView setScrollEnabled:YES];
        
        [self addTagsOnScrollView:self.feed.arrSimiliarTags];
        
        frame = self.lowerView.frame;
        frame.origin.y = CGRectGetMaxY(self.scrlView.frame)+2;
        self.lowerView.frame = frame;
        
        float height = CGRectGetMaxY(lowerView.frame);
        
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, height);
        
        if([self.feed.postType isEqualToString:@"5"])
        {
            lowerView.hidden = YES;
        }
        
        if ([self.feed.postType isEqualToString:@"6"]) {
            
            [viewForm setHidden:FALSE];
            
            [self addFormValuesOnScrollView:self.feed.arrFormValues];
            
        }
        else
        {
            [viewForm setHidden:TRUE];
            
            
        }
        
        
    }
    
}

- (void)setFeed:(Feeds *)post{
    
    _feed = post;
    self.lblPostUserName.text = [_feed.postUserName capitalizedString];
    self.lblTime.text = _feed.postTime;
    self.lblTitleOfDoc.text = _feed.postTitle;
    self.lblDescOfDoc.text = _feed.postDesc;
    [self.imgPostUserImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,_feed.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]||[sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        
    }
    else
    {
        [lowerView setHidden: YES];

    }
    
    if ([_feed.postId isEqualToString:@"-1"])
        [lowerView setHidden: YES];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
        
        if([_feed.employeeStatusStr integerValue] == 1)
        {
            [radioEmployeeBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([_feed.managerStatusStr integerValue] == 1)
        {
            [radioManagerBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([_feed.teamLeaderStatusStr integerValue] == 1)
        {
            [radioTLBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([_feed.familyStatusStr integerValue] == 1)
        {
            [radioFamilyBtn setImage:img forState:UIControlStateNormal];
        }
        
       /* if([_feed.trainingStatusStr integerValue] == 1)
        {
            [radioTrainingBtn setImage:img forState:UIControlStateNormal];
        }*/
        
        if([_feed.bsStatusStr integerValue] == 1)
        {
            [radioBSBtn setImage:img forState:UIControlStateNormal];
        }
        
    }
    
    
    if([_feed.postType isEqualToString:@"1"]){
        
        
        [self.imgThumbnailOfDoc sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallPostThumbnailImageURL,_feed.postThumbnailURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    }
    else if([_feed.postType isEqualToString:@"2"]){
        
        [self.imgThumbnailOfDoc sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,_feed.postThumbnailURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        [btnThumbnail setImage:[UIImage imageNamed:@"video_thumb.png"] forState:UIControlStateNormal];
    }
    else if([_feed.postType isEqualToString:@"3"])
    {
        [self.imgThumbnailOfDoc setImage:[UIImage imageNamed:@"document_thumb.png"]];
    }
    else if ([_feed.postType isEqualToString:@"4"]){
        [self.viewThumbnailDocument setHidden:YES];
        [lblTags setHidden:YES];
        [scrlView setHidden:YES];
    }
    else if([_feed.postType isEqualToString:@"5"]){
        
        NSString* strMapURL = [_feed.postVideoURL stringByDecodingURLFormat];
        strMapURL = [strMapURL stringByAppendingFormat:@"%f,%f",_feed.latitude,_feed.longitude];
        
        [self.imgThumbnailOfDoc sd_setImageWithURL:[NSURL URLWithString:[strMapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        
    }
    else if([_feed.postType isEqualToString:@"6"])
    {
        [viewThumbnailDocument setHidden:TRUE];
        [imgThumbnailBgOfDoc setHidden:TRUE];
        [imgThumbnailOfDoc setHidden:TRUE];
        [btnThumbnail setHidden:TRUE];
    }
    if(![_feed.postType isEqualToString:@"6"])
    {
        [self.viewForm setHidden:TRUE];
    }
   
    [self setNeedsLayout];
}

-(void)addTagsOnScrollView:(NSMutableArray*)arrTag
{
    int startX = 0;
    
    for (int i = 0 ; i < [arrTag count]; i++) {
        
        Tags *tag = [arrTag objectAtIndex:i];
        
        UIButton* btnTag = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTag.titleLabel.font = [UIFont fontWithName:appfontName size:12.0f];
        btnTag.titleLabel.textColor = [UIColor darkGrayColor];
        [btnTag setBackgroundImage:[[UIImage imageNamed:@"tags.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0] forState:UIControlStateNormal];
        
        CGRect textRect = [tag.tagTitle boundingRectWithSize:CGSizeMake(200, 30)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:12.0]}
                                             context:nil];
        
        CGSize size = textRect.size;
        
        int width=size.width+20;
        
        //int width = [tag.tagTitle sizeWithFont:[UIFont fontWithName:appfontName size:12.0] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:NSLineBreakByTruncatingTail].width+20;
      
        btnTag.frame = CGRectMake(startX, 0, width, 30);
        
        [btnTag setTitle:tag.tagTitle forState:UIControlStateNormal];
        [btnTag setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [btnTag setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnTag setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        
        [self.scrlView addSubview:btnTag];
        
        startX = startX+width+10;
    }
    
    [self.scrlView setContentSize:CGSizeMake(startX+10, 0)];
}
-(void)addFormValuesOnScrollView:(NSMutableArray*)arrTag{
    
    int y=0;
    
    NSArray *viewsToRemove = [self.viewForm subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    for (int i=0; i<[arrTag count]; i++) {
        
        FormValues *tag = [arrTag objectAtIndex:i];
        
        UILabel *lblQue=[[UILabel alloc] init];
        
        CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(200,130000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                     context:nil];
        
        CGSize size = textRect.size;
        
        //CGSize size = [tag.strFormQueStr sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(200,130000)lineBreakMode:NSLineBreakByWordWrapping];
        
        [lblQue setFrame:CGRectMake(0, y, 200, size.height+5)];
        [lblQue setBackgroundColor:[UIColor lightGrayColor]];
        [lblQue setTextAlignment:NSTextAlignmentLeft];
        [lblQue setFont:[UIFont boldSystemFontOfSize:14]];
        lblQue.numberOfLines=0;
        [lblQue setText:[NSString stringWithFormat:@"  %@",tag.strFormQueStr]];
        [self.viewForm addSubview:lblQue];
        
        y=y+size.height+15;
        
        
        if ([tag.strFormTypeStr isEqualToString:@"file"]) {
            
            UIImageView *imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(20, y+5, 160, 160)];
            
            [imgForm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallPostThumbnailImageURL,tag.strFormAnsStr]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
            
            NSLog(@"%@%@",smallPostThumbnailImageURL,tag.strFormAnsStr);
            [imgForm setBackgroundColor:[UIColor blueColor]];
            [self.viewForm addSubview:imgForm];
            
            
            y=y+160+20;
            
        }
        else
        {
            UILabel *lblAns=[[UILabel alloc] init];
            
           // CGSize Ansize = [tag.strFormAnsStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(180,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [tag.strFormAnsStr boundingRectWithSize:CGSizeMake(180,130000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                              context:nil];
            
            CGSize Ansize = textRect.size;

            
            [lblAns setFrame:CGRectMake(8, y, 180, Ansize.height+5)];
            [lblAns setBackgroundColor:[UIColor clearColor]];
            [lblAns setTextColor:[UIColor grayColor]];
            [lblAns setTextAlignment:NSTextAlignmentLeft];
            [lblAns setFont:[UIFont systemFontOfSize:14]];
            [lblAns setText:tag.strFormAnsStr];
            lblAns.numberOfLines=0;
            
            [self.viewForm addSubview:lblAns];
            
            y=y+Ansize.height+15;
            
        }
        
        
        
    }
    
    
    [self.viewForm setFrame:CGRectMake(self.viewForm.frame.origin.x, self.viewForm.frame.origin.y, self.viewForm.frame.size.width,y)];
    
    [self.viewDocDesc setFrame:CGRectMake(self.viewDocDesc.frame.origin.x, self.viewForm.frame.size.height+self.viewForm.frame.origin.y+5, self.viewDocDesc.frame.size.width,75)];
    
    [self.lblTags setFrame:CGRectMake(12, 50, 60, 25)];
    
    [self.lblTitleOfDoc setFrame:CGRectMake(self.lblTitleOfDoc.frame.origin.x, 4, self.lblTitleOfDoc.frame.size.width, 21)];
    
    
    [self.lblDescOfDoc setFrame:CGRectMake(self.lblDescOfDoc.frame.origin.x, 34, self.lblDescOfDoc.frame.size.width, 21)];
    
    [self.scrlView setFrame:CGRectMake(self.scrlView.frame.origin.x, 75+self.viewDocDesc.frame.origin.y, self.scrlView.frame.size.width,30)];
   
    [self.viewMainBg setFrame:CGRectMake(self.viewMainBg.frame.origin.x, self.viewMainBg.frame.origin.y, self.viewMainBg.frame.size.width,self.viewHearder.frame.size.height+self.viewForm.frame.size.height+self.viewDocDesc.frame.size.height+self.scrlView.frame.size.height)];
    
    [self.lowerView setFrame:CGRectMake(self.lowerView.frame.origin.x, self.scrlView.frame.origin.y+self.scrlView.frame.size.height+2, self.lowerView.frame.size.width,self.lowerView.frame.size.height)];
    
    [self.contentView setFrame:CGRectMake(0, 0, 320, self.lowerView.frame.size.height+CGRectGetMaxY(viewMainBg.frame))];

}

#pragma mark- CellHeight

+ (CGFloat)heightForCellWithPost:(Feeds *)post  {
    
    CGFloat cellHeight = 0.0f;
    
    if([post.postType isEqualToString:@"4"]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [post.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop

        cellHeight = fmaxf(140.0f, sizeToFit.height + 120);
    }
    else if([post.postType isEqualToString:@"5"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [post.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
       cellHeight = fmaxf(320.0f, sizeToFit.height + 370+30+10);
     //   cellHeight = fmaxf(494.0f, (float)sizeToFit.height + 330+30+10);

        
        //        cellHeight -= 40;//Jugad for clock in image ke niche ka space
        
    }
    else if([post.postType isEqualToString:@"6"])
    {
        int y=0;
        
        for (int i=0; i<[post.arrFormValues count]; i++) {
            
            FormValues *tag = [post.arrFormValues objectAtIndex:i];
            
                //CGSize size = [tag.strFormQueStr sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(200,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(200,130000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                              context:nil];
            
            CGSize size = textRect.size;

                
                y=y+size.height+15;
                
                if ([tag.strFormTypeStr isEqualToString:@"file"]) {
                    
                    y=y+160+20;
                    
                }
                else
                {
                    
                   // CGSize Ansize = [tag.strFormAnsStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(180,130000)lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGRect textRect = [tag.strFormAnsStr boundingRectWithSize:CGSizeMake(180,130000)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                                      context:nil];
                    
                    CGSize Ansize = textRect.size;
                    
                    y=y+Ansize.height+15;
                    
                }
            }
        
        cellHeight= y+160+35;
        
        NSLog(@"%2f",cellHeight);
        
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [post.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
        cellHeight = fmaxf(294.0f,(float)sizeToFit.height + 380);
        
      //  cellHeight = fmaxf(320.0f, (float)sizeToFit.height + 330+30+10+10);

        
    }
    return cellHeight;
}
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}
#pragma mark- IBActions

-(IBAction)userProfileAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(userProfileActionClicked_iphone:)]){
        [self.delegate userProfileActionClicked_iphone:sender];
    }
}

-(IBAction)docThumbnailAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(docThumbnailDidClicked_iphone:)]){
        [self.delegate docThumbnailDidClicked_iphone:sender];
    }
}

-(IBAction)userLocationBtnAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(userLocationDidClicked_iphone:)]){
        [self.delegate userLocationDidClicked_iphone:sender];
    }
}
-(IBAction)btnFormImagePressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(formImageDidClicked_iphone:)]){
        [self.delegate formImageDidClicked_iphone:sender];
    }
}



/*-(void)dealloc
{
    lblDescOfDoc = nil;
    lblPostUserName = nil;
    lblTags = nil;
    lblTime = nil;
    lblTitleOfDoc = nil;
    lblViewInmap = nil;
    btnLocMap = nil;
    btnThumbnail = nil;
    viewDocDesc= nil;
    viewHearder= nil;
    viewMainBg = nil;
    viewThumbnailDocument = nil;
    viewTags = nil;
    self.delegate = nil;
    
    [super dealloc];
}*/


@end
