//
//  User.h
//  Amity-Care
//
//  Created by Vijay Kumar on 01/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SipAcDetails.h"

@interface User : NSObject<NSCoding>

@property (nonatomic,strong)NSString* appPin;
@property (nonatomic,strong)NSString* fname;
@property (nonatomic,strong)NSString* lname;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* image;
@property (nonatomic,strong)NSString* username;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* default_email;
@property (nonatomic,strong)NSString* loginStatus;

@property (nonatomic,strong)NSString* userId;
@property (nonatomic,strong)NSString* phoneNo;
@property (nonatomic,strong)NSString* address;
@property (nonatomic,strong)NSString* aboutMe;
@property (nonatomic,strong)NSString* role;
@property (nonatomic,strong)NSString* role_id;
@property (nonatomic,strong)NSString* notification_status;

@property (nonatomic,strong)NSString* clockInTagId;
@property (nonatomic,strong)NSString* clockInTagTitle;


@property (nonatomic,strong)NSString* recordingLength;
@property (nonatomic,strong)NSString* recordingStatus;
@property (nonatomic,strong)NSString* recordingTimeInterval;


@property (nonatomic,strong)NSString* sipipAddress;
@property (nonatomic,strong)NSString* sippassword;
@property (nonatomic,strong)NSString* sipusername;


@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,assign)BOOL status;
@property (nonatomic,assign)BOOL isEmployee;
@property (nonatomic,strong)SipAcDetails* sip;


- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end


