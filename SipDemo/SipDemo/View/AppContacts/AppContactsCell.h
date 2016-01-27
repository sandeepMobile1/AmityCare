//
//  TaskCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactD.h"

@protocol AppContactCellDelegate <NSObject>

-(void)sendRequestButtonDidClick:(UIButton*)sender;

@end

@interface AppContactsCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *   lblUname;
@property(nonatomic,strong)IBOutlet UILabel *   lblIntro;
@property(nonatomic,strong)IBOutlet UIButton*   btnRequest;
@property(nonatomic,strong)IBOutlet UIImageView*profileImage;
@property(nonatomic,strong)IBOutlet UIImageView*imgReqSent;

@property(nonatomic,strong)ContactD *contact;
@property(nonatomic,assign) id<AppContactCellDelegate>delegate;

-(IBAction)sendRequestAction:(id)sender;

@end
