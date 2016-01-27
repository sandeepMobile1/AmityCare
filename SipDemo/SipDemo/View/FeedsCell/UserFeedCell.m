//
//  UserFeedCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 03/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "UserFeedCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+urlDecode.h"
#import "AppDelegate.h"

@implementation UserFeedCell

@synthesize viewMainBg,viewHearder,imgPostUserImgBg,imgPostUserImg,lblPostUserName,lblTime,lblViewInmap,btnLocMap;
@synthesize imgThumbnailBgOfDoc,viewThumbnailDocument,imgThumbnailOfDoc,btnThumbnail;

@synthesize viewDocDesc,lblTitleOfDoc,lblDescOfDoc;
@synthesize viewTags,lblTags,scrlView,lowerView;

@synthesize customEmployeeBtn,customManagerBtn,customTLBtn,customFamlityBtn,customTrainingBtn,customBSBtn,radioEmployeeBtn,radioManagerBtn,radioTLBtn,radioFamilyBtn,radioBSBtn,radioTrainingBtn,viewForm;//,lblQue,lblAns;;

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
    
    int height = ceil([[self class] heightForCellWithPost:self.feed]);
    
    int factor =[self.feed.postType isEqualToString:@"4"]?115:480;
    
    CGRect frame = self.lblDescOfDoc.frame;
    frame.size.height = height - factor; //factor =total cell height-(header+doc+title+tag+scroll)height
    self.lblDescOfDoc.frame = frame;
    
    if([self.feed.postType isEqualToString:@"4"])
    {

        frame = self.lblTags.frame;
        frame.origin.y = CGRectGetMaxY(self.lblDescOfDoc.frame)+5;
        self.lblTags.frame = frame;
        
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
        
//        [self bringSubviewToFront:lowerView];
    }
    else{
        

        frame = self.lblTags.frame;
        frame.origin.y = CGRectGetMaxY(self.lblDescOfDoc.frame)+5;
        self.lblTags.frame = frame;
        
        frame = self.viewDocDesc.frame;
        frame.size.height = CGRectGetMaxY(self.lblTags.frame);
        self.viewDocDesc.frame = frame;
        self.lblTags.font = [UIFont fontWithName:appfontName size:15.0];
        
        [self.scrlView setFrame:CGRectMake(self.scrlView.frame.origin.x, CGRectGetMaxY(self.viewDocDesc.frame), self.scrlView.frame.size.width, self.scrlView.frame.size.height)];
        
        [self.lblTags setFrame:CGRectMake(12, self.viewDocDesc.frame.size.height-25, 60, 25)];

        
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
    [self.imgPostUserImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,_feed.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
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
        
        
        [self.imgThumbnailOfDoc setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallPostThumbnailImageURL,_feed.postThumbnailURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    }
    else if([_feed.postType isEqualToString:@"2"]){
        
        [self.imgThumbnailOfDoc setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,_feed.postThumbnailURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        [btnThumbnail setImage:[UIImage imageNamed:@"video_thumb.png"] forState:UIControlStateNormal];
    }
    else if([_feed.postType isEqualToString:@"3"])
    {
        [self.imgThumbnailOfDoc setImage:[UIImage imageNamed:@"document_thumb"]];
    }
    else if ([_feed.postType isEqualToString:@"4"]){
        [self.viewThumbnailDocument setHidden:YES];
        [lblTags setHidden:YES];
        [scrlView setHidden:YES];
    }
    else if([_feed.postType isEqualToString:@"5"]){
        
        NSString* strMapURL = [_feed.postVideoURL stringByDecodingURLFormat];
        strMapURL = [strMapURL stringByAppendingFormat:@"%f,%f",_feed.latitude,_feed.longitude];
        
        [self.imgThumbnailOfDoc setImageWithURL:[NSURL URLWithString:[strMapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        
    }
    else if([_feed.postType isEqualToString:@"6"])
    {
        [viewThumbnailDocument setHidden:TRUE];
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
        
      //  int width = [tag.tagTitle sizeWithFont:[UIFont fontWithName:appfontName size:12.0] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:NSLineBreakByTruncatingTail].width+20;
        
        CGRect textRect = [tag.tagTitle boundingRectWithSize:CGSizeMake(200, 30)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:12.0]}
                                                         context:nil];
        
        CGSize size = textRect.size;
        
        int width=size.width+20;
        
        btnTag.frame = CGRectMake(startX, 0, width, 30);
        
        [btnTag setTitle:tag.tagTitle forState:UIControlStateNormal];
        [btnTag setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [btnTag setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnTag setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        
        [self.scrlView addSubview:btnTag];
        
        startX = startX+width+10;
    }
    
    [self.scrlView setContentSize:CGSizeMake(startX+10, 0)];
    //NSLog(@"content size =%@",NSStringFromCGSize(self.scrlView.frame.size));
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
        
       // CGSize size = [tag.strFormQueStr sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300,130000)lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(300,130000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                     context:nil];
        
        CGSize size = textRect.size;
        
        
        [lblQue setFrame:CGRectMake(0, y, 300, size.height+5)];
        [lblQue setBackgroundColor:[UIColor lightGrayColor]];
        [lblQue setTextAlignment:NSTextAlignmentLeft];
        [lblQue setFont:[UIFont boldSystemFontOfSize:14]];
        lblQue.numberOfLines=0;
        [lblQue setText:[NSString stringWithFormat:@"  %@",tag.strFormQueStr]];
        [self.viewForm addSubview:lblQue];
        
        y=y+size.height+15;
        
        if ([tag.strFormTypeStr isEqualToString:@"file"]) {

            UIImageView *imgForm=[[UIImageView alloc] initWithFrame:CGRectMake(20, y+5, 260, 240)];
            [imgForm setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallPostThumbnailImageURL,tag.strFormAnsStr]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
            
            NSLog(@"%@%@",smallPostThumbnailImageURL,tag.strFormAnsStr);
            
            [self.viewForm addSubview:imgForm];
            
            UIButton *btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
            [btnImage setFrame:CGRectMake(20, y+5, 160, 160)];
            [btnImage addTarget:self action:@selector(btnFormImagePressed:) forControlEvents:UIControlEventTouchUpInside];
            [btnImage setTitle:[NSString stringWithFormat:@"%@%@",smallPostThumbnailImageURL,tag.strFormAnsStr] forState:UIControlStateReserved];
            
            [self.viewForm addSubview:btnImage];


            y=y+240+20;

        }
        else
        {
            UILabel *lblAns=[[UILabel alloc] init];
            
           // CGSize Ansize = [tag.strFormAnsStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(282,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [tag.strFormAnsStr boundingRectWithSize:CGSizeMake(282,130000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                              context:nil];
            
            CGSize Ansize = textRect.size;
            
            [lblAns setFrame:CGRectMake(8, y, 282, Ansize.height+5)];
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
    
    [self.scrlView setFrame:CGRectMake(self.scrlView.frame.origin.x, 75+self.viewDocDesc.frame.origin.y, self.scrlView.frame.size.width,30)];
    
    [self.lblTags setFrame:CGRectMake(12, 50, 60, 25)];
    
    [self.lblDescOfDoc setFrame:CGRectMake(self.lblDescOfDoc.frame.origin.x, self.lblDescOfDoc.frame.origin.y, self.lblDescOfDoc.frame.size.width, 21)];

    [self.viewMainBg setFrame:CGRectMake(self.viewMainBg.frame.origin.x, self.viewMainBg.frame.origin.y, self.viewMainBg.frame.size.width,self.viewHearder.frame.size.height+self.viewForm.frame.size.height+self.viewDocDesc.frame.size.height+self.scrlView.frame.size.height)];

    [self.lowerView setFrame:CGRectMake(self.lowerView.frame.origin.x, self.scrlView.frame.origin.y+self.scrlView.frame.size.height+8, self.lowerView.frame.size.width,self.lowerView.frame.size.height)];

}
#pragma mark- CellHeight

+ (CGFloat)heightForCellWithPost:(Feeds *)post {

    CGFloat cellHeight = 0.0f;
    
    if([post.postType isEqualToString:@"4"]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [post.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(500.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        //NSLog(@"cell height =%f",fmaxf(140.0f, (float)sizeToFit.height + 120));
        cellHeight = fmaxf(140.0f, (float)sizeToFit.height + 120);
    }
    else if([post.postType isEqualToString:@"5"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [post.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(500.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        //NSLog(@"cell height =%f",fmaxf(494.0f, (float)sizeToFit.height + 420));
        
        cellHeight = fmaxf(494.0f, (float)sizeToFit.height + 430+30+10);

//        cellHeight -= 40;//Jugad for clock in image ke niche ka space
        
    }
    else if([post.postType isEqualToString:@"6"])
    {
        int y=0;
        
        for (int i=0; i<[post.arrFormValues count]; i++) {
            
            FormValues *tag = [post.arrFormValues objectAtIndex:i];
            
            
          //  CGSize size = [tag.strFormQueStr sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [tag.strFormQueStr boundingRectWithSize:CGSizeMake(300,130000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                              context:nil];
            
            CGSize size = textRect.size;
            
            y=y+size.height+15;
            
            if ([tag.strFormTypeStr isEqualToString:@"file"]) {
                
                y=y+240+20;
                
            }
            else
            {           

            //CGSize Ansize = [tag.strFormAnsStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(282,130000)lineBreakMode:NSLineBreakByWordWrapping];
                
            CGRect textRect = [tag.strFormAnsStr boundingRectWithSize:CGSizeMake(282,130000)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
                                                                  context:nil];
                
            CGSize Ansize = textRect.size;

            y=y+Ansize.height+15;
                
            }

        }
        
       cellHeight= y+160+42;

        NSLog(@"%2f",cellHeight);

    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [post.postDesc sizeWithFont:[UIFont fontWithName:appfontName size:descfontsize] constrainedToSize:CGSizeMake(500.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
        cellHeight = fmaxf(494.0f, (float)sizeToFit.height + 430+30+10+10);
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
    if([self.delegate respondsToSelector:@selector(userProfileActionClicked:)]){
        [self.delegate userProfileActionClicked:sender];
    }
}

-(IBAction)docThumbnailAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(docThumbnailDidClicked:)]){
        [self.delegate docThumbnailDidClicked:sender];
    }
}

-(IBAction)userLocationBtnAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(userLocationDidClicked:)]){
        [self.delegate userLocationDidClicked:sender];
    }
}
-(IBAction)btnFormImagePressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(formImageDidClicked:)]){
        [self.delegate formImageDidClicked:sender];
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

}
 */

#pragma mark- MKMapView

//- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    
//    static NSString *pinIdentifier = @"pinIndentifier";
//    
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)
//    [theMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
//    if (pinView == nil)
//    {
//        // if an existing pin view was not available, create one
//        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
//                                              initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
//        customPinView.pinColor = MKPinAnnotationColorGreen;
//        customPinView.animatesDrop = YES;
//        customPinView.canShowCallout = YES;
//        
//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self
//                        action:@selector(showDetails:)
//              forControlEvents:UIControlEventTouchUpInside];
//        customPinView.rightCalloutAccessoryView = rightButton;
//        
//        return customPinView;
//    }
//    else
//    {
//        pinView.annotation = annotation;
//    }
//    return pinView;
//}

@end
