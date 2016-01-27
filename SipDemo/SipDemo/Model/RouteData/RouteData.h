//
//  RouteData.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/02/15.
//
//

#import <Foundation/Foundation.h>

@interface RouteData : NSObject

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
@property(nonatomic,strong) NSString* routePostedByUser;

@property(nonatomic,strong) NSString* routePostId;

@property(nonatomic,strong) NSString* recieptMerchantName;
@property(nonatomic,strong) NSString* recieptImage;
@property(nonatomic,strong) NSString* recieptDate;
@property(nonatomic,strong) NSString* recieptDescription;
@property(nonatomic,strong) NSString* recieptReimbursementStatus;
@property(nonatomic,strong) NSString *routType;

@property(nonatomic,strong) NSMutableArray* arrCommentList;
@property(nonatomic,strong)NSString *rootTagId;
@property(nonatomic,strong)NSString *rootTagName;

@property(nonatomic,strong)NSString *recieptAmount;

@end
