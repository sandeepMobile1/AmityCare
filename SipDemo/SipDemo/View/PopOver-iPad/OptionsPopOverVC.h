//
//  OptionsPopOverVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 23/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsPopOverVCDelegate <NSObject>

-(void)popoverOptionDidSelected:(NSString*)value;

@end

@interface OptionsPopOverVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* tblViewOptions;
    NSArray* arrOptions;
    NSString* titleText;
    UIColor *bgColor,*txtColor;
    UIPopoverController *popoverController;
}

@property(nonatomic,strong)IBOutlet UILabel* lblTitle;
@property(nonatomic,unsafe_unretained)id<OptionsPopOverVCDelegate>delegate;
-(id)initWithTitleLabel:(UIColor*)backgroundColor textColor:(UIColor*)textColor title:(NSString*)title data:(NSArray*)optionsArr delegate:(id<OptionsPopOverVCDelegate>)del;

@end

