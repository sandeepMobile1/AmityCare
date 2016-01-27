//
//  InboxData.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <Foundation/Foundation.h>

@interface InboxData : NSObject

@property(nonatomic,strong) NSString* mailTitle;
@property(nonatomic,strong) NSString* mailSubject;
@property(nonatomic,strong) NSString* mailMessage;
@property(nonatomic,strong) NSString* mailDate;
@property(nonatomic,strong) NSString* mailTo;
@property(nonatomic,strong) NSString* mailFrom;
@property(nonatomic,strong) NSString* mailAttechment;
@property(nonatomic,strong) NSString* mailId;
@property(nonatomic,strong) NSString* mail_attachment_status;
@property(nonatomic,strong) NSString* user_id;
@property(nonatomic,strong) NSString* read_status;

@property(nonatomic,strong) NSString* employeeStatusStr;
@property(nonatomic,strong) NSString* managerStatusStr;
@property(nonatomic,strong) NSString* teamLeaderStatusStr;
@property(nonatomic,strong) NSString* familyStatusStr;
@property(nonatomic,strong) NSString* bsStatusStr;


@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSAttributedString* mail_short_desc;

@end
