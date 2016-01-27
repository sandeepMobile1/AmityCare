//
//  ContactsCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 05/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactD.h"

@protocol ContactsCellDelegate <NSObject>
-(void)callBtnDidClicked:(UIButton*)sender;
-(void)msgBtnDidClicked:(UIButton*)sender;
@end

@interface ContactsCell : UITableViewCell
{
    id<ContactsCellDelegate>_delegate;
}
@property(nonatomic,strong)ContactD* contact;
@property(nonatomic,unsafe_unretained)id<ContactsCellDelegate>delegate;
@end
