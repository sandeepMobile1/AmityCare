//
//  BackPackD.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>

@interface BackPackD : NSObject

@property(nonatomic,strong) NSString * backPackReminderId;
@property(nonatomic,strong) NSString * backPackReminderTitle;
@property(nonatomic,strong) NSString * backPackReminderDate;
@property(nonatomic,strong) NSString * backPackReminderDesc;

@property(nonatomic,strong) NSString * backPackMessageId;
@property(nonatomic,strong) NSString * backPackMessage;

@property(nonatomic,strong) NSString * backPackPicId;
@property(nonatomic,strong) NSString * backPackPicName;
@property(nonatomic,strong) NSString * backPackPic;
@property(nonatomic,strong) NSString * backPackType;

@property(nonatomic,strong) NSString * backPackFileId;
@property(nonatomic,strong) NSString * backPackFileName;

@end
