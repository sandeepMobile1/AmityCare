//
//  MessageD.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageD : NSObject
@property(nonatomic,strong)NSString* msg_id;
@property(nonatomic,strong)NSString* fileType;
@property(nonatomic,strong)NSString* msg_text;
@property(nonatomic,strong)NSString* msg_date;
@property(nonatomic,strong)NSString* sender_image;
@property(nonatomic,strong)NSString* sender_id;
@property(nonatomic,strong)NSString* sender_uname;
@property(nonatomic,strong)NSString* msg_display_time;
@property(nonatomic,strong)NSString* msg_type;
@property(nonatomic,strong)NSString* fileName;
@property(nonatomic,assign)BOOL     isRead;
@property(nonatomic,strong)NSString* individualCount;

@end
