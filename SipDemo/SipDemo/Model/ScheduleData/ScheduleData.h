//
//  ScheduleData.h
//  Amity-Care
//
//  Created by Admin on 18/03/15.
//
//

#import <Foundation/Foundation.h>

@interface ScheduleData : NSObject

@property(nonatomic,strong) NSString* ScheduleId;
@property(nonatomic,strong) NSString* ScheduleTagId;
@property(nonatomic,strong) NSString* ScheduleTagName;

@property(nonatomic,strong) NSString* ScheduleStartWeek;
@property(nonatomic,strong) NSString* ScheduleEndWeek;
@property(nonatomic,strong) NSString* ScheduleCreatedDate;
@property(nonatomic,strong) NSMutableArray* ScheduleArray;
@property(nonatomic,strong) NSMutableArray* ScheduleUserArray;


@end
