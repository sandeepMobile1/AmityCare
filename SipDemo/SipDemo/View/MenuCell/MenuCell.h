//
//  MenuCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 02/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
{
    CGSize imageSize;
}
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) int cellIndex;
-(void)configureCell:(NSString*)image title:(NSString*)title setSelected:(BOOL)selected;
@end
