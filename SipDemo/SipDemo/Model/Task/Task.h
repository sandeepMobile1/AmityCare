//
//  Task.h
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property(nonatomic,strong) NSString*taskId;
@property(nonatomic,strong) NSString*taskTitle;
@property(nonatomic,strong) NSString*taskDesc;
@property(nonatomic,strong) NSString*taskDate;
@property(nonatomic,strong) NSString*taskCreatedOn;
@property(nonatomic,strong) NSString* assignUserName;
@property(nonatomic,strong) NSString* assignUserId;
@property(nonatomic,strong) NSString* taskStatus;
@property(nonatomic,strong) NSString* repeatStatus;
@property(nonatomic,strong) NSString* assignedToSelf;
@property(nonatomic,strong) NSString* taskReminder;

@property(nonatomic,strong) NSString*mngrID;
@property(nonatomic,strong) NSString*mngrName;

@property(nonatomic,strong) NSMutableArray *arrTags;
@property(nonatomic,strong) NSMutableArray *arrAssignUser;
@end
