//
//  NotificationD.h
//  Amity-Care
//
//  Created by Vijay Kumar on 23/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationD : NSObject
@property(nonatomic,strong)NSString* nid;
@property(nonatomic,strong)NSString* ntext;
@property(nonatomic,assign)BOOL isRead;
@property(nonatomic,strong)NSString *createdTime;
@end
