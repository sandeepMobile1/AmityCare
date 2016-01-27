//
//  OpenCartServices.m
//  SimpleAddiction
//
//  Created by Sandeep Agarwal on 19/12/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import "AmityCareServices.h"

@implementation AmityCareServices

+(AmityCareServices*)sharedService
{
    static AmityCareServices *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

-(void)registrationInvocationInfo:(NSMutableDictionary*)infoDict  delegate:(id<RegistrationInvocationDelegate>)delegate{

    RegistrationInvocation *invocation = [[RegistrationInvocation alloc]init];
    invocation.userInfo = infoDict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)loginInvocationEmail:(NSString*)email password:(NSString*)pass devToken:(NSString*)token delegate:(id<LoginInvocationDelegate>)delegate
{
    LoginInvocation *invocation = [[LoginInvocation alloc]init];
    invocation.email = email;
    invocation.password= pass;
    invocation.token = token;
    [self invoke:invocation withDelegate:delegate];
}

-(void)checkEmailInvocation:(NSString*)email delegate:(id<CheckEmailInvocationDelegate>)delegate
{
    CheckEmailInvocation* invocation = [[CheckEmailInvocation alloc] init];
    invocation.email = email;
    [self invoke:invocation withDelegate:delegate];
}

-(void)forgotPasswordInvocation:(NSString*)email delegate:(id<ForgotPasswordInvocationDelegate>)delegate
{
    ForgotPasswordInvocation* invocation = [[ForgotPasswordInvocation alloc] init];
    invocation.email = email;
    [self invoke:invocation withDelegate:delegate];
}

-(void)secureLoginInvocation:(NSString*)email password:(NSString*)pass  delegate:(id<SecureLoginInvocationDelegate>)delegate
{
    SecureLoginInvocation* invocation = [[SecureLoginInvocation alloc]init];
    invocation.email = email;
    invocation.tagId= pass;
    [self invoke:invocation withDelegate:delegate];
}

-(void)logoutInvocation:(NSString*)userId delegate:(id<LogoutInvocationDelegate>)delegate
{
    LogoutInvocation* invocation = [[LogoutInvocation alloc] init];
    invocation.userId = userId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getNotificationList:(NSString*)userId page_index:(NSString *)page_index delegate:(id<GetNotificationInvocationDelegate>)delegate
{
    GetNotificationInvocation* invocation = [[GetNotificationInvocation alloc] init];
    invocation.user_id = userId;
    invocation.page_index=page_index;
    [self invoke:invocation withDelegate:delegate];
}

-(void)changePasswordInvocation:(NSMutableDictionary*)infoDict  delegate:(id<ChangePasswordInvocationDelegate>)delegate
{
    ChangePasswordInvocation *invocation = [[ChangePasswordInvocation alloc]init];
    invocation.userInfo = infoDict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)tagInvocation:(NSString*)userid  delegate:(id<TagsInvocationDelegate>)delegate
{
    TagsInvocation *invocation = [[TagsInvocation alloc] init];
    invocation.user_id = userid;
    [self invoke:invocation withDelegate:delegate];
    
}


-(void)tagListInvocation:(NSString*)userid  delegate:(id<TagsListInvocationDelegate>)delegate{
    TagsListInvocation *invocation = [[TagsListInvocation alloc] init];
    invocation.user_id = userid;
    [self invoke:invocation withDelegate:delegate];
}

-(void)assignTagsInvocation:(NSString*)userid tag_id:(NSString *)tag_id users:(NSString *)users delegate:(id<AssignTagInvocationDelegate>)delegate{
    AssignTagInvocation *invocation = [[AssignTagInvocation alloc] init];
    invocation.user_id = userid;
    invocation.tag_id = tag_id;
    invocation.users = users;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)tagInUsesrListInvocation:(NSString*)userid tag_id:(NSString *)tag_id delegate:(id<TagsInUserListInvocationDelegate>)delegate{
    TagsInUserListInvocation *invocation = [[TagsInUserListInvocation alloc] init];
    invocation.user_id = userid;
    invocation.tag_id = tag_id;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)clockInUserInvocation:(NSMutableDictionary*)infoDict  delegate:(id<ClockInInvocationDelegate>)delegate
{
    ClockInInvocation *invocation = [[ClockInInvocation alloc] init];
    invocation.userInfo = infoDict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)backgroundClockInInvocation:(NSMutableDictionary*)infoDict  delegate:(id<BackgroundClockInInvocationDelegate>)delegate
{
    BackgroundClockInInvocation *invocation = [[BackgroundClockInInvocation alloc] init];
    invocation.userInfo = infoDict;
    [self invoke:invocation withDelegate:delegate];
}


-(void)GetProfileInvocation:(NSString*)userid delegate:(id<GetProfileInvocationDelegate>)delegate;
{
    GetProfileInvocation *invocation = [[GetProfileInvocation alloc] init];
    invocation.user_id = userid;
    [self invoke:invocation withDelegate:delegate];
}

-(void)setProfileInvocation:(NSMutableDictionary*)infoDict imgData:(NSData*)data delegate:(id<SetProfileInvocationDelegate>)delegate
{
    SetProfileInvocation *invocation = [[SetProfileInvocation alloc] init];
    invocation.userInfo = infoDict;
    invocation.imageData = data;
    [self invoke:invocation withDelegate:delegate];
    
}

-(void)setStatusInvocation:(NSMutableDictionary*)infoDict delegate:(id<SetStatusInvocationDelegate>)delegate
{
    SetStatusInvocation *invocation = [[SetStatusInvocation alloc] init];
    invocation.userInfo = infoDict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getStatusInvocation:(NSString*)userID delegate:(id<GetStatusInvocationDelegate>)delegate
{
    GetStatusInvocation *invocation = [[GetStatusInvocation alloc] init];
    invocation.user_id = userID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)tagSearchFeedsInvocation:(NSMutableDictionary*)mDict delegate:(id<TagSearchInvocationDelegate>)delegate
{
    TagSearchInvocation *invocation = [[TagSearchInvocation alloc] init];
    invocation.infoDict = mDict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getKeywordsFeedsInvocation:(NSMutableDictionary*)mDict delegate:(id<GetKeywordFeedsInvocationDelegate>)delegate
{
    GetKeywordFeedsInvocation *invocation = [[GetKeywordFeedsInvocation alloc] init];
    invocation.infoDict = mDict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)GetKeywordStatusInvocation:(NSMutableDictionary*)mDict delegate:(id<GetKeywordStatusInvocationDelegate>)delegate;
{
    GetKeywordStatusInvocation *invocation = [[GetKeywordStatusInvocation alloc] init];
    invocation.infoDict = mDict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)getTagFeedsInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<GetFeedsInvocationDelegate>)delegate
{
    GetFeedsInvocation *invocation = [[GetFeedsInvocation alloc] init];
    invocation.userid = userid;
    invocation.tagId = tagId;
    invocation.lastIndex = index;
    invocation.roleId = roleId;
    invocation.timeLine = time;
    [self invoke:invocation withDelegate:delegate];
}

-(void)uploadDocInvocation:(NSMutableDictionary*)dict uploadData:(NSData*)data delegate:(id<UploadDocInvocationDelegate>)delegate
{
    UploadDocInvocation* invocation = [[UploadDocInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];
}

#pragma mark- Task
-(void)addNewTaskInvocation:(NSMutableDictionary*)tskDict delegate:(id<AddTaskInvocationDelegate>)delegate
{
    AddTaskInvocation *invocation = [[AddTaskInvocation alloc] init];
    invocation.taskDict = tskDict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)editTaskInvocation:(NSMutableDictionary*)tskDict delegate:(id<EditTaskInvocationDelegate>)delegate
{
    EditTaskInvocation *invocation = [[EditTaskInvocation alloc] init];
    invocation.taskDict = tskDict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)deleteTaskInvocation:(NSString*)taskID userId:(NSString*)userID delegate:(id<DeleteTaskInvocationDelegate>)delegate
{
    DeleteTaskInvocation *invocation = [[DeleteTaskInvocation alloc] init];
    invocation.task_id = taskID;
    invocation.user_id = userID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getUsersListInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<UserListInvocationDelegate>)delegate
{
    UserListInvocation *invocation = [[UserListInvocation alloc] init];
    invocation.user_id = userId;
    invocation.tagId = tagId;

    [self invoke:invocation withDelegate:delegate];
}

-(void)getAssignMngrTasksInvocation:(NSString*)userId role:(NSString*)role delegate:(id<GetAssignTaskInvocationDelegate>)delegate
{
    GetAssignTaskInvocation *invocation = [[GetAssignTaskInvocation alloc] init];
    invocation.user_id = userId;
    invocation.role = role;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getTaskListInvocation:(NSString*)userId role:(NSString*)role delegate:(id<GetTaskListInvocationDelegate>)delegate
{
    GetTaskListInvocation *invocation = [[GetTaskListInvocation alloc] init];
    invocation.user_id = userId;
    invocation.role = role;
    [self invoke:invocation withDelegate:delegate];
}

-(void)taskStatusInvocation:(NSString*)userID taskID:(NSString*)taskID delegate:(id<TaskStatusInvocationDelegate>)delegate
{
    TaskStatusInvocation* invocation = [[TaskStatusInvocation alloc] init];
    invocation.task_id = taskID;
    invocation.user_id = userID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)clockOutInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<ClockoutInvocationDelegate>)delegate
{
    ClockoutInvocation *invocation = [[ClockoutInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];
}

-(void)sortFeedsByDate:(NSMutableDictionary*)dict delegate:(id<SortFeedsDateWiseInvocationDelegate>)delegate
{
    SortFeedsDateWiseInvocation* invocation = [[SortFeedsDateWiseInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getAmityContactListInvocation:(NSString*)userID delegate:(id<GetAmityContactsListDelegate>)delegate
{
    GetAmityContactsList* invocation = [[GetAmityContactsList alloc] init];
    invocation.user_id = userID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)appContactListInvocation:(NSString*)userID delegate:(id<AppContactsInvoationDelegate>)delegate
{
    AppContactsInvoation* invocation = [[AppContactsInvoation alloc] init];
    invocation.user_id = userID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)sendContactRequestInvocation:(NSString*)userID memberID:(NSString*)memID delegate:(id<SendContactRequestInvocationDelegate>)delegate
{
    SendContactRequestInvocation* invocation = [[SendContactRequestInvocation alloc] init];
    invocation.user_id = userID;
    invocation.member_id = memID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)deleteContactInvocation:(NSString*)userID memberID:(NSString*)memID delegate:(id<DeleteContactInvocationDelegate>)delegate
{
    DeleteContactInvocation* invocation = [[DeleteContactInvocation alloc] init];
    invocation.user_id = userID;
    invocation.member_id = memID;
    [self invoke:invocation withDelegate:delegate];
}

// message
-(void)SendMessageInvocation:(NSMutableDictionary*)dict delegate:(id<SendMessageInvocationDelegate>)delegate
{
    SendMessageInvocation* invocation = [[SendMessageInvocation alloc] init];
    invocation.msdDict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getChatDetailInvocation:(NSString*)userId withMemId:(NSString*)mem_id delegate:(id<ChatDetailInvocationDelegate>)delegate
{
    ChatDetailInvocation* invocation = [[ChatDetailInvocation alloc] init];
    invocation.user_id = userId;
    invocation.member_id = mem_id;
    [self invoke:invocation withDelegate:delegate];
}
-(void)GroupChatDetailInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<GroupChatDetailInvocationDelegate>)delegate
{
    GroupChatDetailInvocation* invocation = [[GroupChatDetailInvocation alloc] init];
    invocation.user_id = userId;
    invocation.tag_id = tagId;
    [self invoke:invocation withDelegate:delegate];

}

-(void)getChatListInvocation:(NSString*)user_ID delegate:(id<ChatListInvocationDelegate>)delegate
{
    ChatListInvocation* invocation = [[ChatListInvocation alloc] init];
    invocation.user_id = user_ID;
    [self invoke:invocation withDelegate:delegate];
}

-(void)deleteMessageInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteMsgInvocationDelegate>)delegate
{
    DeleteMsgInvocation *invocation =[[DeleteMsgInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)deleteNotificationInvocation:(NSString*)userid notificationID:(NSString*)nid  delegate:(id<DeleteNotificationInvocationDelegate>)delegate
{
    DeleteNotificationInvocation *invocation =[[DeleteNotificationInvocation alloc] init];
    invocation.user_id = userid;
    invocation.n_id = nid;
    [self invoke:invocation withDelegate:delegate];
}

-(void)callRecieveNotification:(NSMutableDictionary *)dict delegate:(id<CallNotifierInvocationDelegate>)delegate
{
    CallNotifierInvocation *invocation =[[CallNotifierInvocation alloc] init];
    invocation.userInfo = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)ClockInStatusInvocation:(NSString*)userId tagId:(NSString*)tagId  startDate:(NSString*)startDate endDate:(NSString*)endDate index:(NSString*)index delegate:(id<ClockInStatusInvocationDelegate>)delegate
{
    ClockInStatusInvocation *invocation =[[ClockInStatusInvocation alloc] init];
    invocation.userId = userId;
    invocation.tagId = tagId;
    invocation.startDate = startDate;
    invocation.endDate = endDate;
    invocation.index=index;
    
    [self invoke:invocation withDelegate:delegate];

}


- (void)userAcceptanceRecieveNotification:(NSMutableDictionary *)dict delegate:(id<AcceptanceInvocationDelegate>)delegate
{
    AcceptanceInvocation *invocation =[[AcceptanceInvocation alloc] init];
    invocation.userID = [dict objectForKey:@"userId"];
    invocation.memberID= [dict objectForKey:@"memberId"];;
    invocation.status = [dict objectForKey:@"status"];;
    invocation.contactId = [dict objectForKey:@"contactId"];;
    
    [self invoke:invocation withDelegate:delegate];
}

- (void)deleteAllNotificationDelegate:(NSMutableDictionary *)dict delegate:(id<DeleteAllNotificationInvocationDelegate>)delegate
{
    DeleteAllNotificationInvocation *invocation =[[DeleteAllNotificationInvocation alloc] init];
    invocation.userId = [dict objectForKey:@"userId"];
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)setFeedInocation:(NSDictionary*)dict delegate:(id<StatusInvocationDelegate>)delegate
{
    StatusInvocation *invocation =[[StatusInvocation alloc] init];
    invocation.statusDic = dict;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)getFormNameInvocation:(NSDictionary *)dict delegate:(id)delegate
{
    GetFormNameInvacation *invocation =[[GetFormNameInvacation alloc] init];
    invocation.tagId = [dict objectForKey:@"tag_id"];
    
    [self invoke:invocation withDelegate:delegate];
}

- (void)getFormListInvocation:(NSDictionary *)dict delegate:(id)delegate
{
    GetFormListInvocation *invocation =[[GetFormListInvocation alloc] init];
    invocation.tagId = [dict objectForKey:@"tag_id"];
    
    [self invoke:invocation withDelegate:delegate];
}


- (void)updatePinInvocation:(NSDictionary*)dict delegate:(id<UpdateAppPinInvocationDelegate>)delegate
{
    UpdateAppPinInvocation *invocation =[[UpdateAppPinInvocation alloc] init];
    invocation.userId = [dict objectForKey:@"user_id"];
    invocation.appPin = [dict objectForKey:@"appPin"];
    
    [self invoke:invocation withDelegate:delegate];
}

- (void)updateContactNotificationInvocation:(NSDictionary *)dict delegate:(id<UpdateContactNotificationInvocationDelegate>)delegate
{
    UpdateContactNotificationInvocation *invocation =[[UpdateContactNotificationInvocation alloc] init];
    invocation.contactId = [dict objectForKey:@"contact_id"];
    invocation.notificationStatus = [dict objectForKey:@"notification_status"];
    
    [self invoke:invocation withDelegate:delegate];
}

- (void)checkPinInvocation:(NSDictionary*)dict delegate:(id<CheckPinInvocationDelegate>)delegate
{
    CheckPinInvocation *invocation =[[CheckPinInvocation alloc] init];
    invocation.userId = [dict objectForKey:@"user_id"];
    invocation.secretPin = [dict objectForKey:@"secret_pin"];
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)TagCalenderListInvocation:(NSString*)userId tagId:(NSString*)tagId   delegate:(id<TagCalenderListInvocationDelegate>)delegate
{
    TagCalenderListInvocation *invocation =[[TagCalenderListInvocation alloc] init];
    invocation.userId = userId;
    invocation.tagId = tagId;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)UserCalenderListInvocation:(NSString*)userId delegate:(id<UserCalenderListInvocationDelegate>)delegate
{
    UserCalenderListInvocation *invocation =[[UserCalenderListInvocation alloc] init];
    invocation.userId = userId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)TagAssignCalendarListInvocation:(NSString*)userId tagId:(NSString*)tagId   delegate:(id<TagAssignCalendarListInvocationDelegate>)delegate
{
    TagAssignCalendarListInvocation *invocation =[[TagAssignCalendarListInvocation alloc] init];
    invocation.userId = userId;
    invocation.tagId = tagId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)UserAssignCalandarListInvocation:(NSString*)userId delegate:(id<UserAssignCalandarListInvocationDelegate>)delegate
{
    UserAssignCalandarListInvocation *invocation =[[UserAssignCalandarListInvocation alloc] init];
    invocation.userId = userId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)EditTagIntroInvocation:(NSString*)userId tagId:(NSString*)tagId intro:(NSString*)intro delegate:(id<EditTagIntroInvocationDelegate>)delegate
{
    EditTagIntroInvocation *invocation =[[EditTagIntroInvocation alloc] init];
    invocation.userId = userId;
    invocation.tagId = tagId;
    invocation.intro = intro;

    [self invoke:invocation withDelegate:delegate];

}
-(void)InboxListInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<InboxListInvocationDelegate>)delegate
{
    InboxListInvocation *invocation =[[InboxListInvocation alloc] init];
   
    invocation.userId = userId;
    invocation.tagId = tagId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)InboxDetailInvocation:(NSString*)userId tagId:(NSString*)tagId mailId:(NSString*)mailId delegate:(id<InboxDetailInvocationDelegate>)delegate
{
    InboxDetailInvocation *invocation =[[InboxDetailInvocation alloc] init];
    invocation.userId = userId;
    invocation.tagId = tagId;
    invocation.mailId = mailId;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)DeleteMailInvocation:(NSString*)userId tagId:(NSString*)tagId mailId:(NSString*)mailId delegate:(id<DeleteMailInvocationDelegate>)delegate
{
    DeleteMailInvocation *invocation =[[DeleteMailInvocation alloc] init];
    invocation.user_id=userId;
    invocation.mail_id = mailId;
    invocation.tag_id=tagId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)UserFeedListInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<UserFeedListInvocationDelegate>)delegate;
{
    UserFeedListInvocation *invocation =[[UserFeedListInvocation alloc] init];
    invocation.userid = userid;
    invocation.tagId = tagId;
    invocation.lastIndex = index;
    invocation.roleId = roleId;
    invocation.timeLine = time;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)TagFeedListInvocaiton:(NSString*)userId tagId:(NSString*)tagId delegate:(id<TagFeedListInvocaitonDelegate>)delegate
{
    TagFeedListInvocaiton *invocation =[[TagFeedListInvocaiton alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    
    [self invoke:invocation withDelegate:delegate];

}
-(void)UserStatusListInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<UserStatusListInvocationDelegate>)delegate
{
    UserStatusListInvocation *invocation = [[UserStatusListInvocation alloc] init];
    invocation.userid = userid;
    invocation.tagId = tagId;
    invocation.lastIndex = index;
    invocation.roleId = roleId;
    invocation.timeLine = time;
    [self invoke:invocation withDelegate:delegate];

}

-(void)TagStatusListInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<TagStatusListInvocationDelegate>)delegate
{
    TagStatusListInvocation *invocation = [[TagStatusListInvocation alloc] init];
    invocation.userid = userid;
    invocation.tagId = tagId;
    invocation.lastIndex = index;
    invocation.roleId = roleId;
    invocation.timeLine = time;
    [self invoke:invocation withDelegate:delegate];
}

-(void)SortUserFeedsDateWiseInvocation:(NSMutableDictionary*)dict delegate:(id<SortUserFeedsDateWiseInvocationDelegate>)delegate
{
    SortUserFeedsDateWiseInvocation* invocation = [[SortUserFeedsDateWiseInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)SortUserStatusDateWiseInvocation:(NSMutableDictionary*)dict delegate:(id<SortUserStatusDateWiseInvocationDelegate>)delegate
{
    SortUserStatusDateWiseInvocation* invocation = [[SortUserStatusDateWiseInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)SortTagStatusDateWiseInvocation:(NSMutableDictionary*)dict delegate:(id<SortTagStatusDateWiseInvocationDelegate>)delegate
{
    SortTagStatusDateWiseInvocation* invocation = [[SortTagStatusDateWiseInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}


-(void)UserNotificationLIstInvocation:(NSString*)userId delegate:(id<UserNotificationLIstInvocationDelegate>)delegate
{
    UserNotificationLIstInvocation *invocation =[[UserNotificationLIstInvocation alloc] init];
    invocation.user_id=userId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)TagNotificationListInvocation:(NSString*)userId tagId:(NSString*)tagId page_index:(NSString*)page_index delegate:(id<TagNotificationListInvocationDelegate>)delegate
{
    TagNotificationListInvocation *invocation =[[TagNotificationListInvocation alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    invocation.page_index = page_index;

    [self invoke:invocation withDelegate:delegate];

}

-(void)SadSmileFeedListInvocation:(NSString*)userId tagId:(NSString*)tagId status:(NSString*)status delegate:(id<SadSmileFeedListInvocationDelegate>)delegate
{
    SadSmileFeedListInvocation *invocation =[[SadSmileFeedListInvocation alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    invocation.status=status;

    [self invoke:invocation withDelegate:delegate];
}

-(void)SmileFeedListInvocation:(NSString*)userId tagId:(NSString*)tagId status:(NSString*)status delegate:(id<SmileFeedListInvocationDelegate>)delegate;
{
    SmileFeedListInvocation *invocation =[[SmileFeedListInvocation alloc] init];
   
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    invocation.status=status;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)FavoriteFeedListInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<FavoriteFeedListInvocationDelegate>)delegate
{
    FavoriteFeedListInvocation *invocation =[[FavoriteFeedListInvocation alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)AddFavoriteInvocation:(NSString*)userId tagId:(NSString*)tagId feedId:(NSString*)feedId delegate:(id<AddFavoriteInvocationDelegate>)delegate
{
    AddFavoriteInvocation *invocation =[[AddFavoriteInvocation alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    invocation.feed_id=feedId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)AddSadSmileInvocation:(NSString*)userId tagId:(NSString*)tagId feedId:(NSString*)feedId status:(NSString*)status delegate:(id<AddSadSmileInvocationDelegate>)delegate
{
    AddSadSmileInvocation *invocation =[[AddSadSmileInvocation alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    invocation.feed_id=feedId;
    invocation.status=status;

    [self invoke:invocation withDelegate:delegate];
}

-(void)AddSmileInvocation:(NSString*)userId tagId:(NSString*)tagId feedId:(NSString*)feedId status:(NSString*)status delegate:(id<AddSmileInvocationDelegate>)delegate
{
    AddSmileInvocation *invocation =[[AddSmileInvocation alloc] init];
    invocation.user_id=userId;
    invocation.tag_id = tagId;
    invocation.feed_id=feedId;
    invocation.status=status;

    [self invoke:invocation withDelegate:delegate];
}
-(void)UserEmailListInvocation:(NSString*)userId delegate:(id<UserEmailListInvocationDelegate>)delegate
{
    UserEmailListInvocation *invocation =[[UserEmailListInvocation alloc] init];
    invocation.user_id=userId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)DeleteUserEmailInvocation:(NSString*)userId emailId:(NSString*)emailId delegate:(id<DeleteUserEmailInvocationDelegate>)delegate
{
    DeleteUserEmailInvocation *invocation =[[DeleteUserEmailInvocation alloc] init];
    invocation.user_id=userId;
    invocation.mail_id=emailId;

    [self invoke:invocation withDelegate:delegate];
}

-(void)DeleteAllTagNotificationInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<DeleteAllTagNotificationInvocationDelegate>)delegate
{
    DeleteAllTagNotificationInvocation *invocation =[[DeleteAllTagNotificationInvocation alloc] init];
    invocation.userId=userId;
    invocation.tagId=tagId;

    [self invoke:invocation withDelegate:delegate];
}
-(void)UploadSignatureInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<UploadSignatureInvocationDelegate>)delegate
{
    UploadSignatureInvocation *invocation = [[UploadSignatureInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];
}
-(void)GetFormDetailInvocation:(NSString*)formId delegate:(id<GetFormDetailInvocationDelegate>)delegate
{
    GetFormDetailInvocation *invocation = [[GetFormDetailInvocation alloc] init];
    invocation.formId = formId;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UploadAudioInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<UploadAudioInvocationDelegate>)delegate
{
    UploadAudioInvocation *invocation = [[UploadAudioInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];

}
-(void)UploadChatAudioInvocation:(NSMutableDictionary*)dict data:(NSData*)data delegate:(id<UploadChatAudioInvocationDelegate>)delegate
{
    UploadChatAudioInvocation *invocation = [[UploadChatAudioInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];

}

-(void)UploadChatImageInvocation:(NSMutableDictionary*)dict data:(NSData*)data delegate:(id<UploadChatImageInvocationDelegate>)delegate
{
    UploadChatImageInvocation *invocation = [[UploadChatImageInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];

}
-(void)ShareReimbursementInvocation:(NSMutableDictionary*)dict mapData:(NSData*)data delegate:(id<ShareReimbursementInvocationDelegate>)delegate;
{
    ShareReimbursementInvocation *invocation = [[ShareReimbursementInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];
}
-(void)ReimembursementListInvocation:(NSString*)userId tagId:(NSString*)tagId startDate:(NSString*)startDate endDate:(NSString*)endDate userName:(NSString*)userName tagName:(NSString*)tagName delegate:(id<ReimembursementListInvocationDelegate>)delegate
{
    ReimembursementListInvocation *invocation = [[ReimembursementListInvocation alloc] init];
    invocation.userId = userId;
    invocation.tagId = tagId;
    invocation.startDate=startDate;
    invocation.endDate=endDate;
    invocation.userName=userName;
    invocation.tagName=tagName;
    [self invoke:invocation withDelegate:delegate];
}
-(void)AllTagsListInvocation:(NSString*)userId delegate:(id<AllTagsListInvocationDelegate>)delegate
{
    AllTagsListInvocation *invocation = [[AllTagsListInvocation alloc] init];
    invocation.userId = userId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)ScheduleFormListInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleFormListInvocationDelegate>)delegate
{
    ScheduleFormListInvocation *invocation = [[ScheduleFormListInvocation alloc] init];
    invocation.dict = dict;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)ScheduleStatusListInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleStatusListInvocationDelegate>)delegate
{
    ScheduleStatusListInvocation *invocation = [[ScheduleStatusListInvocation alloc] init];
    invocation.dict = dict;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)ScheduleEmailListInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleEmailListInvocationDelegate>)delegate
{
    ScheduleEmailListInvocation *invocation = [[ScheduleEmailListInvocation alloc] init];
    invocation.dict = dict;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)FilterScheduleListInvocation:(NSMutableDictionary*)dict delegate:(id<FilterScheduleListInvocationDelegate>)delegate;
{
    FilterScheduleListInvocation *invocation = [[FilterScheduleListInvocation alloc] init];
    invocation.dict = dict;
    
    [self invoke:invocation withDelegate:delegate];

}
-(void)AllTagPostInvocation:(NSMutableDictionary*)dict delegate:(id<AllTagPostInvocationDelegate>)delegate;
{
    AllTagPostInvocation *invocation=[[AllTagPostInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)AllUserListInvocation:(NSMutableDictionary*)dict delegate:(id<AllUserListInvocationDelegate>)delegate
{
    AllUserListInvocation *invocation=[[AllUserListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)ScheduleUserDetailInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleUserDetailInvocationDelegate>)delegate
{
    ScheduleUserDetailInvocation *invocation=[[ScheduleUserDetailInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)AddCommentInvocation:(NSMutableDictionary*)dict delegate:(id<AddCommentInvocationDelegate>)delegate
{
    AddCommentInvocation *invocation=[[AddCommentInvocation alloc] init];
    invocation.commentDict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)SettingNotificationInvocation:(NSMutableDictionary*)dict delegate:(id<SettingNotificationInvocationDelegate>)delegate{
    SettingNotificationInvocation *invocation=[[SettingNotificationInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)EmailPermissionInvocation:(NSMutableDictionary*)dict delegate:(id<EmailPermissionInvocationDelegate>)delegate
{
    EmailPermissionInvocation *invocation=[[EmailPermissionInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)OfflineMessageInvocation:(NSMutableDictionary*)dict delegate:(id<OfflineMessageInvocationDelegate>)delegate
{
    OfflineMessageInvocation *invocation=[[OfflineMessageInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UpdateScheduleInvocation:(NSMutableDictionary*)dict delegate:(id<UpdateScheduleInvocationDelegate>)delegate
{
    UpdateScheduleInvocation *invocation=[[UpdateScheduleInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)AddSelfCreatedScheduleInvocation:(NSMutableDictionary*)dict delegate:(id<AddSelfCreatedScheduleInvocationDelegate>)delegate
{
    AddSelfCreatedScheduleInvocation *invocation=[[AddSelfCreatedScheduleInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)SelfCreatedScheduleListInvocation:(NSMutableDictionary*)dict delegate:(id<SelfCreatedScheduleListInvocationDelegate>)delegate
{
    SelfCreatedScheduleListInvocation *invocation=[[SelfCreatedScheduleListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UpdateSelfCreatedScheduleInvocation:(NSMutableDictionary*)dict delegate:(id<UpdateSelfCreatedScheduleInvocationDelegate>)delegate
{
    UpdateSelfCreatedScheduleInvocation *invocation=[[UpdateSelfCreatedScheduleInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)DeleteSelfCreatedScheduleINvocation:(NSMutableDictionary*)dict delegate:(id<DeleteSelfCreatedScheduleINvocationDelegate>)delegate
{
    DeleteSelfCreatedScheduleINvocation *invocation=[[DeleteSelfCreatedScheduleINvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)AllHappyFacePostsInvocation:(NSMutableDictionary*)dict delegate:(id<AllHappyFacePostsInvocationDelegate>)delegate
{
    AllHappyFacePostsInvocation *invocation=[[AllHappyFacePostsInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)AllSadFacePostsInvocation:(NSMutableDictionary*)dict delegate:(id<AllSadFacePostsInvocationDelegate>)delegate
{
    AllSadFacePostsInvocation *invocation=[[AllSadFacePostsInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)ManagerReimbursementListInvocation:(NSMutableDictionary*)dict delegate:(id<ManagerReimbursementListInvocationDelegate>)delegate
{
    ManagerReimbursementListInvocation *invocation=[[ManagerReimbursementListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)UserCompletedFormListInvocation:(NSMutableDictionary*)dict delegate:(id<UserCompletedFormListInvocationDelegate>)delegate
{
    UserCompletedFormListInvocation *invocation=[[UserCompletedFormListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)TagCompletedFormListInvocation:(NSMutableDictionary*)dict delegate:(id<TagCompletedFormListInvocationDelegate>)delegate
{
    TagCompletedFormListInvocation *invocation=[[TagCompletedFormListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)UserCompletedFormDetailInvocation:(NSMutableDictionary*)dict delegate:(id<UserCompletedFormDetailInvocationDelegate>)delegate
{
    UserCompletedFormDetailInvocation *invocation=[[UserCompletedFormDetailInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)TagCompletedFormDetailInvocation:(NSMutableDictionary*)dict delegate:(id<TagCompletedFormDetailInvocationDelegate>)delegate
{
    TagCompletedFormDetailInvocation *invocation=[[TagCompletedFormDetailInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)ManagerAssignedTagListInvocation:(NSMutableDictionary*)dict delegate:(id<ManagerAssignedTagListInvocationDelegate>)delegate
{
    ManagerAssignedTagListInvocation *invocation=[[ManagerAssignedTagListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)ManagerSharePostListInvocation:(NSMutableDictionary*)dict delegate:(id<ManagerSharePostListInvocationDelegate>)delegate
{
    ManagerSharePostListInvocation *invocation=[[ManagerSharePostListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)DeleteEmailListInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteEmailListInvocationDelegate>)delegate
{
    DeleteEmailListInvocation *invocation=[[DeleteEmailListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)AllPostListInvocation:(NSMutableDictionary*)dict delegate:(id<AllPostListInvocationDelegate>)delegate
{
    AllPostListInvocation *invocation=[[AllPostListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)DeletePostInvocation:(NSMutableDictionary*)dict delegate:(id<DeletePostInvocationDelegate>)delegate
{
    DeletePostInvocation *invocation=[[DeletePostInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)DeleteEmailInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteEmailInvocationDelegate>)delegate
{
    DeleteEmailInvocation *invocation=[[DeleteEmailInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)GetRecordingDetailInvocation:(NSMutableDictionary*)dict delegate:(id<GetRecordingDetailInvocationDelegate>)delegate
{
    GetRecordingDetailInvocation *invocation=[[GetRecordingDetailInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UploadBackgroundRecordingInvocation:(NSMutableDictionary*)dict data:(NSData*)data delegate:(id<UploadBackgroundRecordingInvocationDelegate>)delegate
{
    UploadBackgroundRecordingInvocation* invocation = [[UploadBackgroundRecordingInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];

}
-(void)UploadMadFormInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<UploadMadFormInvocationDelegate>)delegate
{
    UploadMadFormInvocation* invocation = [[UploadMadFormInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];

}
-(void)DeleteRootInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteRootInvocationDelegate>)delegate
{
    DeleteRootInvocation *invocation=[[DeleteRootInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)AllReminderListInvocation:(NSMutableDictionary*)dict delegate:(id<AllReminderListInvocationDelegate>)delegate
{
    AllReminderListInvocation *invocation=[[AllReminderListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AllBackpackMessageListInvocation:(NSMutableDictionary*)dict delegate:(id<AllBackpackMessageListInvocationDelegate>)delegate
{
    AllBackpackMessageListInvocation *invocation=[[AllBackpackMessageListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AllBackpackPicListInvocation:(NSMutableDictionary*)dict delegate:(id<AllBackpackPicListInvocationDelegate>)delegate
{
    AllBackpackPicListInvocation *invocation=[[AllBackpackPicListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AllBackPackFileListInvocation:(NSMutableDictionary*)dict delegate:(id<AllBackPackFileListInvocationDelegate>)delegate
{
    AllBackPackFileListInvocation *invocation=[[AllBackPackFileListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AddReminderInvocation:(NSMutableDictionary*)dict delegate:(id<AddReminderInvocationDelegate>)delegate
{
    AddReminderInvocation *invocation=[[AddReminderInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AddMessageInvocation:(NSMutableDictionary*)dict delegate:(id<AddMessageInvocationDelegate>)delegate
{
    AddMessageInvocation *invocation=[[AddMessageInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AddPicInvocation:(NSMutableDictionary*)dict pic:(NSData*)data delegate:(id<AddPicInvocationDelegate>)delegate
{
    AddPicInvocation* invocation = [[AddPicInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];
}

-(void)AddFileInvocation:(NSMutableDictionary*)dict file:(NSData*)data delegate:(id<AddFileInvocationDelegate>)delegate
{
    AddFileInvocation* invocation = [[AddFileInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata = data;
    [self invoke:invocation withDelegate:delegate];
}

-(void)DeleteBackpackReminderInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteBackpackReminderInvocationDelegate>)delegate;
{
    DeleteBackpackReminderInvocation* invocation = [[DeleteBackpackReminderInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)DeletebackpackMessageInvocation:(NSMutableDictionary*)dict delegate:(id<DeletebackpackMessageInvocationDelegate>)delegate
{
    DeletebackpackMessageInvocation* invocation = [[DeletebackpackMessageInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)DeleteBackpackPicInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteBackpackPicInvocationDelegate>)delegate
{
    DeleteBackpackPicInvocation* invocation = [[DeleteBackpackPicInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)DeleteBackpackFileInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteBackpackFileInvocationDelegate>)delegate
{
    DeleteBackpackFileInvocation* invocation = [[DeleteBackpackFileInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)ShareRootListInvocation:(NSMutableDictionary*)dict delegate:(id<ShareRootListInvocationDelegate>)delegate
{
    ShareRootListInvocation* invocation = [[ShareRootListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)ShareBackpackInvocation:(NSMutableDictionary*)dict delegate:(id<ShareBackpackInvocationDelegate>)delegate
{
    ShareBackpackInvocation* invocation = [[ShareBackpackInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)CreateFolderInvocation:(NSMutableDictionary*)dict delegate:(id<CreateFolderInvocationDelegate>)delegate
{
    CreateFolderInvocation* invocation = [[CreateFolderInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)FolderListInvocation:(NSMutableDictionary*)dict delegate:(id<FolderListInvocationDelegate>)delegate;
{
    FolderListInvocation* invocation = [[FolderListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)DeleteSmileyInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteSmileyInvocationDelegate>)delegate
{
    DeleteSmileyInvocation* invocation = [[DeleteSmileyInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UploadOcrInvocation:(NSMutableDictionary*)dict uploadData:(NSData*)data delegate:(id<UploadOcrInvocationDelegate>)delegate
{
    UploadOcrInvocation* invocation = [[UploadOcrInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata=data;
    [self invoke:invocation withDelegate:delegate];

}

-(void)OcrListInvocation:(NSMutableDictionary*)dict delegate:(id<OcrListInvocationDelegate>)delegate
{
    OcrListInvocation* invocation = [[OcrListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}

-(void)DeleteOcrInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteOcrInvocationDelegate>)delegate
{
    DeleteOcrInvocation* invocation = [[DeleteOcrInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)AddRouteCommentInvocation:(NSMutableDictionary*)dict delegate:(id<AddRouteCommentInvocationDelegate>)delegate
{
    AddRouteCommentInvocation* invocation = [[AddRouteCommentInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)RouteCommentListInvocation:(NSMutableDictionary*)dict delegate:(id<RouteCommentListInvocationDelegate>)delegate
{
    RouteCommentListInvocation* invocation = [[RouteCommentListInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];

}
-(void)DeleteRouteCommentInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteRouteCommentInvocationDelegate>)delegate
{
    DeleteRouteCommentInvocation* invocation = [[DeleteRouteCommentInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UploadReceiptInvocation:(NSMutableDictionary*)dict uploadData:(NSData*)data delegate:(id<UploadReceiptInvocationDelegate>)delegate
{
    UploadReceiptInvocation* invocation = [[UploadReceiptInvocation alloc] init];
    invocation.dict = dict;
    invocation.mdata=data;
    [self invoke:invocation withDelegate:delegate];
}
-(void)ChooseBackpackFileInvocation:(NSMutableDictionary*)dict delegate:(id<ChooseBackpackFileInvocationDelegate>)delegate
{
    ChooseBackpackFileInvocation* invocation = [[ChooseBackpackFileInvocation alloc] init];
    invocation.dict = dict;
    [self invoke:invocation withDelegate:delegate];
}

@end
