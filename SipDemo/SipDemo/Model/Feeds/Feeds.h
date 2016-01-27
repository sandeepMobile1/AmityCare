//
//  Feeds.h
//  Amity-Care
//
//  Created by Vijay Kumar on 03/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tags.h"
#import "ConfigManager.h"

@interface Feeds : NSObject

@property(nonatomic,strong) NSString* postUserName;
@property(nonatomic,strong) NSString* postUserId;
@property(nonatomic,assign) CGFloat   latitude;
@property(nonatomic,assign) CGFloat   longitude;
@property(nonatomic,strong) NSString* postUserImgURL;
@property(nonatomic,strong) NSString* postTime;
@property(nonatomic,strong) NSString* postActualTime;
@property(nonatomic,strong) NSString* postThumbnailURL;
@property(nonatomic,strong) NSString* postTitle;
@property(nonatomic,strong) NSString* postType;
@property(nonatomic,strong) NSString* postVideoURL;
@property(nonatomic,strong) NSString* postId;
@property(nonatomic,strong) NSString* postDesc;
@property(nonatomic,strong) NSString* postTagId;
@property(nonatomic,strong) NSString* postUserEmail;

@property(nonatomic,strong) NSString* tagTitle;
@property(nonatomic,strong) NSString* postFavStatus;

@property(nonatomic,strong) NSString* postStatus;


@property(nonatomic,strong) NSString* employeeStatusStr;
@property(nonatomic,strong) NSString* managerStatusStr;
@property(nonatomic,strong) NSString* teamLeaderStatusStr;
@property(nonatomic,strong) NSString* familyStatusStr;
@property(nonatomic,strong) NSString* trainingStatusStr;
@property(nonatomic,strong) NSString* bsStatusStr;

@property(nonatomic,strong) NSMutableArray* arrSimiliarTags;
@property(nonatomic,strong) NSMutableArray* arrFormValues;
@property(nonatomic,strong) NSMutableArray* arrCommentValues;

@property(nonatomic,strong) NSString* formId;
@property(nonatomic,strong) NSString* formTitle;
@property(nonatomic,strong) NSString* formType;
@property(nonatomic,strong) NSString* formTag;
@property(nonatomic,strong) NSString* formUserId;
@property(nonatomic,strong) NSString* formUserName;
@property(nonatomic,strong) NSString* formUserImage;
@property(nonatomic,strong) NSString* formCompletionTime;
@property(nonatomic,strong) NSString* formBadges;
@property(nonatomic,strong) NSString* formTagId;

@property(nonatomic,strong) NSString* routeId;
@property(nonatomic,strong) NSString* routeCreated;
@property(nonatomic,strong) NSString* routeStartLatitude;
@property(nonatomic,strong) NSString* routeStartLongitude;
@property(nonatomic,strong) NSString* routeEndLatitude;
@property(nonatomic,strong) NSString* routeEndLongitude;
@property(nonatomic,strong) NSString* routeDistance;
@property(nonatomic,strong) NSString* routeImage;
@property(nonatomic,strong) NSString* routeStartAdd;
@property(nonatomic,strong) NSString* routeEndAdd;
@property(nonatomic,strong) NSString* routeStartTime;
@property(nonatomic,strong) NSString* routeEndTime;
@property(nonatomic,strong) NSString* routeWeekDay;
@property(nonatomic,strong) NSString* routeShareByUser;
@property(nonatomic,strong) NSString* routeType;

@property(nonatomic,strong) NSString* recieptMerchantName;
@property(nonatomic,strong) NSString* recieptAmount;
@property(nonatomic,strong) NSString* recieptDate;
@property(nonatomic,strong) NSString* recieptDescription;
@property(nonatomic,strong) NSString* recieptImage;
@property(nonatomic,strong) NSString* recieptReimbursementStatus;


@end
