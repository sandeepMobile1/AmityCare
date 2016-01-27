//
//  PeopleData.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import <Foundation/Foundation.h>

@interface PeopleData : NSObject

@property(nonatomic,strong) NSString* userId;
@property(nonatomic,strong) NSString* tagId;
@property(nonatomic,strong) NSString* userName;
@property(nonatomic,strong) NSString* userImage;
@property(nonatomic,strong) NSString* userClockInTag;
@property(nonatomic,strong) NSString* userClockInTime;
@property(nonatomic,strong) NSString* userClockOutTime;
@property(nonatomic,strong) NSString* userEditedClockOutTime;

@property(nonatomic,strong) NSString* userClockInCreatedTime;
@property(nonatomic,strong) NSString* userClockOutCreatedTime;
@property(nonatomic,strong) NSString* postId;
@property(nonatomic,strong) NSString* userClockInHour;
@property(nonatomic,strong) NSString* userClockInLatitude;
@property(nonatomic,strong) NSString* userClockInLongitude;
@property(nonatomic,strong) NSString* userClockOutLatitude;
@property(nonatomic,strong) NSString* userClockOutLongitude;
@property(nonatomic,strong) NSString* userClockOutAddress;

@end
