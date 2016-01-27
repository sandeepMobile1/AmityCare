//
//  ContactD.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SipAcDetails.h"

@interface ContactD : NSObject

@property(nonatomic,strong)NSString* contact_id;
@property(nonatomic,strong)NSString* firstName;
@property(nonatomic,strong)NSString* lastName;
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* image;
@property(nonatomic,strong)NSString* introduction;
@property (nonatomic,strong)NSString* request_status;
@property(nonatomic,strong) NSString* userid;
@property(nonatomic,strong) NSString* clockInTime;
@property(nonatomic,strong) NSString* notificationStatus;

@property(nonatomic,assign)BOOL isOnline;

@property (nonatomic, strong) SipAcDetails *sip;

@property(nonatomic,assign)BOOL isConnected; // in case of app contacts when sending reqeust


@end
