//
//  ZoomInOutView.m
//  Amity-Care
//
//  Created by Vijay Kumar on 30/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ZoomInOutView.h"

@implementation ZoomInOutView
@synthesize scrollView,imageview;

/*

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arr = [[NSBundle mainBundle ] loadNibNamed:@"ZoomInOutView" owner:self options:nil];
        self = [arr objectAtIndex:0];
        [self setImageOnScroll:image];
    }
    return self;
}
*/

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imagev = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Default.png"]];
    self.imageview = imagev;
    imagev = nil;
    
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:self.imageview];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

/*
-(void)setImage:(UIImage *)imageV
{
    self.scrollVw.zoomScale = 1;
    self.scrollVw.hidden = NO;
    //toolbar.hidden = NO;
    UIImage* image = imageV;
    imageview.image = imageV;
    
    float width =  self.scrollVw.frame.size.width/image.size.width;
    if (image.size.width<self.scrollVw.frame.size.width) {
        width = 1;
    }
    
    float height = self.scrollVw.frame.size.height/image.size.height;
    if (image.size.height<self.scrollVw.frame.size.height) {
        height = 1;
    }
    
    float f = 0;
    
    if (width < height)
    {
        f = width;
    }
    else
    {
        f = height;
    }
    
    imageview.frame = CGRectMake(0, 0, image.size.width*f, image.size.height*f);
    
    
    CGRect frame = self.scrollVw.frame;
    self.scrollVw.contentSize = frame.size;
    imageview.center = CGPointMake(frame.size.width/2, frame.size.height/2);
}
*/

/*
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    float width = 0;
    float height = 0;
    
    if (self.imageview.frame.size.width < scrollView.frame.size.width)
    {
        width = self.scrollView.frame.size.width;
        
        if (self.imageview.frame.size.height < scrollView.frame.size.height)
        {
            height = self.scrollView.frame.size.height;
        }
        else
        {
            height = self.scrollView.contentSize.height;
        }
    }
    else
    {
        width = self.scrollView.contentSize.width;
        
        if (self.imageview.frame.size.height < scrollView.frame.size.height)
        {
            height = scrollView.frame.size.height;
        }
        else
        {
            height = scrollView.contentSize.height;
        }
    }
    self.imageview.center = CGPointMake(width/2, height/2);
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
