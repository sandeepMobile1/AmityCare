//
//  ChatD.h
//  Amity-Care
//
//  Created by Vijay Kumar on 21/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatD : NSObject
@property(nonatomic,strong)NSString* msg_id;
@property(nonatomic,strong)NSString* message;
@property(nonatomic,strong)NSString* sender_id;
@property(nonatomic,strong)NSString* msg_date;
@property(nonatomic,strong)NSString* sender_image;
@end
