//
//  User.m
//  Amity-Care
//
//  Created by Vijay Kumar on 01/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "User.h"

@interface User ()

@end

@implementation User
@synthesize fname,lname,image,username,email,userId,phoneNo,address,aboutMe,password,role,role_id,appPin,notification_status;
@synthesize isEmployee,status,isSelected,clockInTagId,clockInTagTitle;
@synthesize sipipAddress;
@synthesize sippassword;
@synthesize sipusername;
@synthesize sip;

@synthesize recordingLength,recordingStatus,recordingTimeInterval;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
	if (self != nil)
    {
        self.appPin = [decoder decodeObjectForKey:@"appPin"];
        self.fname = [decoder decodeObjectForKey:@"firstname"];
        self.lname=[decoder decodeObjectForKey:@"lastname"];
        self.image=[decoder decodeObjectForKey:@"image"];
        self.email = [decoder decodeObjectForKey:@"emailid"];
        self.phoneNo=[decoder decodeObjectForKey:@"phonenumber"];
        self.address=[decoder decodeObjectForKey:@"address"];
        self.password=[decoder decodeObjectForKey:@"password"];
        self.userId=[decoder decodeObjectForKey:@"userid"];
        self.aboutMe=[decoder decodeObjectForKey:@"aboutme"];
        self.role=[decoder decodeObjectForKey:@"role"];
        self.role_id=[decoder decodeObjectForKey:@"role_id"];
        self.isEmployee=[decoder decodeBoolForKey:@"employee"];
        self.status=[decoder decodeBoolForKey:@"status"];
        self.isSelected=[decoder decodeBoolForKey:@"selected"];
        self.sip =[decoder decodeObjectForKey:@"sip_details"];
        self.notification_status=[decoder decodeObjectForKey:@"notificationStatus"];
        
        self.recordingStatus=[decoder decodeObjectForKey:@"recordingStatus"];
        self.recordingTimeInterval=[decoder decodeObjectForKey:@"recordingTimeInterval"];
        self.recordingLength=[decoder decodeObjectForKey:@"recordingLength"];
        self.clockInTagId=[decoder decodeObjectForKey:@"tagId"];
        self.clockInTagTitle=[decoder decodeObjectForKey:@"tagTitle"];
        self.default_email=[decoder decodeObjectForKey:@"default_email"];
        self.loginStatus=[decoder decodeObjectForKey:@"login_status"];


    }
	return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.appPin forKey:@"appPin"];
    [encoder encodeObject:self.fname forKey:@"firstname"];
    [encoder encodeObject:self.lname forKey:@"lastname"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.userId forKey:@"userid"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.email forKey:@"emailid"];
    [encoder encodeObject:self.phoneNo forKey:@"phonenumber"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.aboutMe forKey:@"aboutme"];
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.role_id forKey:@"role_id"];
    [encoder encodeBool:self.isEmployee forKey:@"employee"];
    [encoder encodeBool:self.status forKey:@"status"];
    [encoder encodeBool:self.isSelected forKey:@"selected"];
    [encoder encodeObject:self.sip forKey:@"sip_details"];
    [encoder encodeObject:self.notification_status forKey:@"notificationStatus"];
    
    [encoder encodeObject:self.recordingStatus forKey:@"recordingStatus"];
    [encoder encodeObject:self.recordingTimeInterval forKey:@"recordingTimeInterval"];
    [encoder encodeObject:self.recordingLength forKey:@"recordingLength"];

    [encoder encodeObject:self.clockInTagId forKey:@"tagId"];
    [encoder encodeObject:self.clockInTagTitle forKey:@"tagTitle"];
    [encoder encodeObject:self.default_email forKey:@"default_email"];
    [encoder encodeObject:self.loginStatus forKey:@"login_status"];

}

@end

