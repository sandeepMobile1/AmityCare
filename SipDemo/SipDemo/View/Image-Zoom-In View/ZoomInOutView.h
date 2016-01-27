//
//  ZoomInOutView.h
//  Amity-Care
//
//  Created by Vijay Kumar on 30/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomInOutView : UIViewController<UIScrollViewDelegate>

{
}
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *imageview;

@end
