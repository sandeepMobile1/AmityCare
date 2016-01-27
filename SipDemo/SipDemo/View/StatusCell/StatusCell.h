//
//  StatusCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 09/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface StatusCell : UITableViewCell
@property(nonatomic,strong) Status* statusD;

+ (CGFloat)heightForCellWithPost:(Status *)status;

@end
