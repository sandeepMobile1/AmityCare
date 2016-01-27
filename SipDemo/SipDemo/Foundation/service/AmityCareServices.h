//
//  OpenCartServices.h
//  SimpleAddiction
//
//  Created by Sandeep Agarwal on 19/12/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAService.h"
#import "RegistrationInvocation.h"
#import "LoginInvocation.h"
#import "CheckEmailInvocation.h"
#import "ForgotPasswordInvocation.h"
#import "LogoutInvocation.h"
#import "ChangePasswordInvocation.h"
#import "TagsInvocation.h"
#import "ClockInInvocation.h"
#import "GetProfileInvocation.h"
#import "SetProfileInvocation.h"
#import "GetStatusInvocation.h"
#import "SetStatusInvocation.h"
#import "GetFeedsInvocation.h"
#import "UploadDocInvocation.h"
#import "AddTaskInvocation.h"
#import "EditTaskInvocation.h"
#import "DeleteTaskInvocation.h"
#import "UserListInvocation.h"
#import "GetTaskListInvocation.h"
#import "ClockoutInvocation.h"
#import "SortFeedsDateWiseInvocation.h"
#import "GetAssignTaskInvocation.h"
#import "TaskStatusInvocation.h"
#import "AppContactsInvoation.h"
#import "GetAmityContactsList.h"
#import "SendContactRequestInvocation.h"
#import "DeleteContactInvocation.h"
#import "SendMessageInvocation.h"
#import "ChatDetailInvocation.h"
#import "ChatListInvocation.h"
#import "DeleteMsgInvocation.h"
#import "SecureLoginInvocation.h"
#import "GetNotificationInvocation.h"
#import "TagsListInvocation.h"
#import "TagsInUserListInvocation.h"
#import "AssignTagInvocation.h"
#import "DeleteNotificationInvocation.h"
#import "BackgroundClockInInvocation.h"
#import "CallNotifierInvocation.h"
#import "TagSearchInvocation.h"
#import "GetKeywordFeedsInvocation.h"
#import "ClockInStatusInvocation.h"
#import "AcceptanceInvocation.h"
#import "DeleteAllNotificationInvocation.h"
#import "StatusInvocation.h"
#import "GetFormNameInvacation.h"
#import "GetFormListInvocation.h"
#import "UpdateAppPinInvocation.h"
#import "UpdateContactNotificationInvocation.h"
#import "CheckPinInvocation.h"
#import "TagCalenderListInvocation.h"
#import "UserCalenderListInvocation.h"
#import "EditTagIntroInvocation.h"
#import "InboxListInvocation.h"
#import "InboxDetailInvocation.h"
#import "DeleteMailInvocation.h"
#import "UserFeedListInvocation.h"
#import "TagFeedListInvocaiton.h"
#import "TagStatusListInvocation.h"
#import "UserStatusListInvocation.h"
#import "TagNotificationListInvocation.h"
#import "UserNotificationLIstInvocation.h"
#import "SadSmileFeedListInvocation.h"
#import "SmileFeedListInvocation.h"
#import "FavoriteFeedListInvocation.h"
#import "AddFavoriteInvocation.h"
#import "AddSadSmileInvocation.h"
#import "AddSmileInvocation.h"
#import "UserEmailListInvocation.h"
#import "SortUserFeedsDateWiseInvocation.h"
#import "SortUserStatusDateWiseInvocation.h"
#import "SortTagStatusDateWiseInvocation.h"
#import "GetKeywordStatusInvocation.h"
#import "TagAssignCalendarListInvocation.h"
#import "UserAssignCalandarListInvocation.h"
#import "DeleteUserEmailInvocation.h"
#import "DeleteAllTagNotificationInvocation.h"
#import "UploadSignatureInvocation.h"
#import "GetFormDetailInvocation.h"
#import "UploadAudioInvocation.h"
#import "UploadChatAudioInvocation.h"
#import "UploadChatImageInvocation.h"
#import "GroupChatDetailInvocation.h"
#import "ShareReimbursementInvocation.h"
#import "ReimembursementListInvocation.h"
#import "AllTagsListInvocation.h"
#import "ScheduleFormListInvocation.h"
#import "ScheduleStatusListInvocation.h"
#import "ScheduleEmailListInvocation.h"
#import "FilterScheduleListInvocation.h"
#import "AllTagPostInvocation.h"
#import "AllUserListInvocation.h"
#import "ScheduleUserDetailInvocation.h"
#import "AddCommentInvocation.h"
#import "SettingNotificationInvocation.h"
#import "EmailPermissionInvocation.h"
#import "OfflineMessageInvocation.h"
#import "UpdateScheduleInvocation.h"
#import "SelfCreatedScheduleListInvocation.h"
#import "UpdateSelfCreatedScheduleInvocation.h"
#import "AddSelfCreatedScheduleInvocation.h"
#import "DeleteSelfCreatedScheduleINvocation.h"
#import "AllSadFacePostsInvocation.h"
#import "AllHappyFacePostsInvocation.h"
#import "ManagerReimbursementListInvocation.h"
#import "UserCompletedFormListInvocation.h"
#import "TagCompletedFormListInvocation.h"
#import "UserCompletedFormDetailInvocation.h"
#import "TagCompletedFormDetailInvocation.h"
#import "ManagerAssignedTagListInvocation.h"
#import "ManagerSharePostListInvocation.h"
#import "DeleteEmailListInvocation.h"
#import "AllPostListInvocation.h"
#import "DeletePostInvocation.h"
#import "DeleteEmailInvocation.h"
#import "GetRecordingDetailInvocation.h"
#import "UploadBackgroundRecordingInvocation.h"
#import "UploadMadFormInvocation.h"
#import "DeleteRootInvocation.h"
#import "AllReminderListInvocation.h"
#import "AllBackpackMessageListInvocation.h"
#import "AllBackpackPicListInvocation.h"
#import "AllBackPackFileListInvocation.h"
#import "AddReminderInvocation.h"
#import "AddMessageInvocation.h"
#import "AddPicInvocation.h"
#import "AddFileInvocation.h"
#import "ShareRootListInvocation.h"

#import "DeleteBackpackReminderInvocation.h"
#import "DeletebackpackMessageInvocation.h"
#import "DeleteBackpackPicInvocation.h"
#import "DeleteBackpackFileInvocation.h"
#import "ShareBackpackInvocation.h"
#import "CreateFolderInvocation.h"
#import "FolderListInvocation.h"
#import "DeleteSmileyInvocation.h"

#import "UploadOcrInvocation.h"
#import "OcrListInvocation.h"
#import "DeleteOcrInvocation.h"
#import "AddRouteCommentInvocation.h"
#import "RouteCommentListInvocation.h"
#import "DeleteRouteCommentInvocation.h"
#import "UploadReceiptInvocation.h"
#import "ChooseBackpackFileInvocation.h"

@interface AmityCareServices : SAService {
	
}

+(AmityCareServices*)sharedService;

-(void)registrationInvocationInfo:(NSMutableDictionary*)infoDict  delegate:(id<RegistrationInvocationDelegate>)delegate;
-(void)loginInvocationEmail:(NSString*)email password:(NSString*)pass devToken:(NSString*)token delegate:(id<LoginInvocationDelegate>)delegate;
-(void)checkEmailInvocation:(NSString*)email delegate:(id<CheckEmailInvocationDelegate>)delegate;
-(void)forgotPasswordInvocation:(NSString*)email delegate:(id<ForgotPasswordInvocationDelegate>)delegate;
-(void)logoutInvocation:(NSString*)userId delegate:(id<LogoutInvocationDelegate>)delegate;
-(void)changePasswordInvocation:(NSMutableDictionary*)infoDict  delegate:(id<ChangePasswordInvocationDelegate>)delegate;

-(void)secureLoginInvocation:(NSString*)email password:(NSString*)pass  delegate:(id<SecureLoginInvocationDelegate>)delegate;

-(void)tagInvocation:(NSString*)userid  delegate:(id<TagsInvocationDelegate>)delegate;
-(void)assignTagsInvocation:(NSString*)userid tag_id:(NSString *)tag_id users:(NSString *)users delegate:(id<AssignTagInvocationDelegate>)delegate;

-(void)clockInUserInvocation:(NSMutableDictionary*)infoDict  delegate:(id<ClockInInvocationDelegate>)delegate;

-(void)backgroundClockInInvocation:(NSMutableDictionary*)infoDict  delegate:(id<BackgroundClockInInvocationDelegate>)delegate;


-(void)GetProfileInvocation:(NSString*)userid delegate:(id<GetProfileInvocationDelegate>)delegate;

-(void)setProfileInvocation:(NSMutableDictionary*)infoDict imgData:(NSData*)data delegate:(id<SetProfileInvocationDelegate>)delegate;

-(void)setStatusInvocation:(NSMutableDictionary*)infoDict delegate:(id<SetStatusInvocationDelegate>)delegate;

-(void)getStatusInvocation:(NSString*)userID delegate:(id<GetStatusInvocationDelegate>)delegate;

-(void)getTagFeedsInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<GetFeedsInvocationDelegate>)delegate;

-(void)getKeywordsFeedsInvocation:(NSMutableDictionary*)mDict delegate:(id<GetKeywordFeedsInvocationDelegate>)delegate;

-(void)GetKeywordStatusInvocation:(NSMutableDictionary*)mDict delegate:(id<GetKeywordStatusInvocationDelegate>)delegate;


-(void)tagSearchFeedsInvocation:(NSMutableDictionary*)mDict delegate:(id<TagSearchInvocationDelegate>)delegate;

-(void)uploadDocInvocation:(NSMutableDictionary*)dict uploadData:(NSData*)data delegate:(id<UploadDocInvocationDelegate>)delegate;

-(void)addNewTaskInvocation:(NSMutableDictionary*)tskDict delegate:(id<AddTaskInvocationDelegate>)delegate;

-(void)editTaskInvocation:(NSMutableDictionary*)tskDict delegate:(id<EditTaskInvocationDelegate>)delegate;

-(void)deleteTaskInvocation:(NSString*)taskID userId:(NSString*)userID delegate:(id<DeleteTaskInvocationDelegate>)delegate;

-(void)getTaskListInvocation:(NSString*)userId role:(NSString*)role delegate:(id<GetTaskListInvocationDelegate>)delegate;

-(void)taskStatusInvocation:(NSString*)userID taskID:(NSString*)taskID delegate:(id<TaskStatusInvocationDelegate>)delegate;

-(void)getUsersListInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<UserListInvocationDelegate>)delegate;

-(void)clockOutInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<ClockoutInvocationDelegate>)delegate;

-(void)sortFeedsByDate:(NSMutableDictionary*)dict delegate:(id<SortFeedsDateWiseInvocationDelegate>)delegate;

-(void)getAssignMngrTasksInvocation:(NSString*)userId role:(NSString*)role delegate:(id<GetAssignTaskInvocationDelegate>)delegate;

-(void)getAmityContactListInvocation:(NSString*)userID delegate:(id<GetAmityContactsListDelegate>)delegate;

-(void)appContactListInvocation:(NSString*)userID delegate:(id<AppContactsInvoationDelegate>)delegate;

-(void)sendContactRequestInvocation:(NSString*)userID memberID:(NSString*)memID delegate:(id<SendContactRequestInvocationDelegate>)delegate;

-(void)deleteContactInvocation:(NSString*)userID memberID:(NSString*)memID delegate:(id<DeleteContactInvocationDelegate>)delegate;
// message
-(void)SendMessageInvocation:(NSMutableDictionary*)dict delegate:(id<SendMessageInvocationDelegate>)delegate;

-(void)getChatDetailInvocation:(NSString*)userId withMemId:(NSString*)mem_id delegate:(id<ChatDetailInvocationDelegate>)delegate;

-(void)GroupChatDetailInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<GroupChatDetailInvocationDelegate>)delegate;


-(void)getChatListInvocation:(NSString*)user_ID delegate:(id<ChatListInvocationDelegate>)delegate;

-(void)deleteMessageInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteMsgInvocationDelegate>)delegate;

-(void)getNotificationList:(NSString*)userId page_index:(NSString *)page_index delegate:(id<GetNotificationInvocationDelegate>)delegate;

-(void)tagListInvocation:(NSString*)userid  delegate:(id<TagsListInvocationDelegate>)delegate;

-(void)tagInUsesrListInvocation:(NSString*)userid tag_id:(NSString *)tag_id delegate:(id<TagsInUserListInvocationDelegate>)delegate;

-(void)deleteNotificationInvocation:(NSString*)userid notificationID:(NSString*)nid  delegate:(id<DeleteNotificationInvocationDelegate>)delegate;

-(void)callRecieveNotification:(NSMutableDictionary*)dict delegate:(id<CallNotifierInvocationDelegate>)delegate;

-(void)userAcceptanceRecieveNotification:(NSMutableDictionary*)dict delegate:(id<AcceptanceInvocationDelegate>)delegate;


-(void)deleteAllNotificationDelegate:(NSMutableDictionary*)dict delegate:(id<DeleteAllNotificationInvocationDelegate>)delegate;

-(void)setFeedInocation:(NSDictionary*)dict delegate:(id<StatusInvocationDelegate>)delegate;

-(void)getFormNameInvocation:(NSDictionary*)dict delegate:(id<GetFormNameInvacationDelegate>)delegate;

-(void)getFormListInvocation:(NSDictionary*)dict delegate:(id<GetFormListInvocationDelegate>)delegate;

- (void)updatePinInvocation:(NSDictionary*)dict delegate:(id<UpdateAppPinInvocationDelegate>)delegate;

- (void)updateContactNotificationInvocation:(NSDictionary*)dict delegate:(id<UpdateContactNotificationInvocationDelegate>)delegate;

- (void)checkPinInvocation:(NSDictionary*)dict delegate:(id<CheckPinInvocationDelegate>)delegate;

-(void)TagCalenderListInvocation:(NSString*)userId tagId:(NSString*)tagId   delegate:(id<TagCalenderListInvocationDelegate>)delegate;

-(void)UserCalenderListInvocation:(NSString*)userId delegate:(id<UserCalenderListInvocationDelegate>)delegate;

-(void)TagAssignCalendarListInvocation:(NSString*)userId tagId:(NSString*)tagId   delegate:(id<TagAssignCalendarListInvocationDelegate>)delegate;


-(void)UserAssignCalandarListInvocation:(NSString*)userId delegate:(id<UserAssignCalandarListInvocationDelegate>)delegate;

-(void)EditTagIntroInvocation:(NSString*)userId tagId:(NSString*)tagId intro:(NSString*)intro delegate:(id<EditTagIntroInvocationDelegate>)delegate;

-(void)InboxListInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<InboxListInvocationDelegate>)delegate;

-(void)InboxDetailInvocation:(NSString*)userId tagId:(NSString*)tagId mailId:(NSString*)mailId delegate:(id<InboxDetailInvocationDelegate>)delegate;

-(void)DeleteMailInvocation:(NSString*)userId tagId:(NSString*)tagId mailId:(NSString*)mailId delegate:(id<DeleteMailInvocationDelegate>)delegate;


-(void)UserFeedListInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<UserFeedListInvocationDelegate>)delegate;

-(void)TagFeedListInvocaiton:(NSString*)userId tagId:(NSString*)tagId delegate:(id<TagFeedListInvocaitonDelegate>)delegate;

-(void)UserStatusListInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<UserStatusListInvocationDelegate>)delegate;

-(void)TagStatusListInvocation:(NSString*)userid tagID:(NSString*)tagId index:(NSString*)index roleId:(NSString *)roleId time:(NSString *)time delegate:(id<TagStatusListInvocationDelegate>)delegate;

-(void)SortUserFeedsDateWiseInvocation:(NSMutableDictionary*)dict delegate:(id<SortUserFeedsDateWiseInvocationDelegate>)delegate;

-(void)SortUserStatusDateWiseInvocation:(NSMutableDictionary*)dict delegate:(id<SortUserStatusDateWiseInvocationDelegate>)delegate;

-(void)SortTagStatusDateWiseInvocation:(NSMutableDictionary*)dict delegate:(id<SortTagStatusDateWiseInvocationDelegate>)delegate;

-(void)UserNotificationLIstInvocation:(NSString*)userId delegate:(id<UserNotificationLIstInvocationDelegate>)delegate;

-(void)TagNotificationListInvocation:(NSString*)userId tagId:(NSString*)tagId page_index:(NSString*)page_index delegate:(id<TagNotificationListInvocationDelegate>)delegate;

-(void)SadSmileFeedListInvocation:(NSString*)userId tagId:(NSString*)tagId status:(NSString*)status delegate:(id<SadSmileFeedListInvocationDelegate>)delegate;

-(void)SmileFeedListInvocation:(NSString*)userId tagId:(NSString*)tagId status:(NSString*)status delegate:(id<SmileFeedListInvocationDelegate>)delegate;

-(void)FavoriteFeedListInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<FavoriteFeedListInvocationDelegate>)delegate;

-(void)AddFavoriteInvocation:(NSString*)userId tagId:(NSString*)tagId feedId:(NSString*)feedId delegate:(id<AddFavoriteInvocationDelegate>)delegate;

-(void)AddSadSmileInvocation:(NSString*)userId tagId:(NSString*)tagId feedId:(NSString*)feedId status:(NSString*)status delegate:(id<AddSadSmileInvocationDelegate>)delegate;

-(void)AddSmileInvocation:(NSString*)userId tagId:(NSString*)tagId feedId:(NSString*)feedId status:(NSString*)status delegate:(id<AddSmileInvocationDelegate>)delegate;

-(void)UserEmailListInvocation:(NSString*)userId delegate:(id<UserEmailListInvocationDelegate>)delegate;


-(void)DeleteUserEmailInvocation:(NSString*)userId emailId:(NSString*)emailId delegate:(id<DeleteUserEmailInvocationDelegate>)delegate;

-(void)DeleteAllTagNotificationInvocation:(NSString*)userId tagId:(NSString*)tagId delegate:(id<DeleteAllTagNotificationInvocationDelegate>)delegate;

-(void)UploadSignatureInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<UploadSignatureInvocationDelegate>)delegate;

-(void)GetFormDetailInvocation:(NSString*)formId delegate:(id<GetFormDetailInvocationDelegate>)delegate;

-(void)UploadAudioInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<UploadAudioInvocationDelegate>)delegate;

-(void)UploadChatAudioInvocation:(NSMutableDictionary*)dict data:(NSData*)data delegate:(id<UploadChatAudioInvocationDelegate>)delegate;

-(void)UploadChatImageInvocation:(NSMutableDictionary*)dict data:(NSData*)data delegate:(id<UploadChatImageInvocationDelegate>)delegate;

-(void)ShareReimbursementInvocation:(NSMutableDictionary*)dict mapData:(NSData*)data delegate:(id<ShareReimbursementInvocationDelegate>)delegate;

-(void)ReimembursementListInvocation:(NSString*)userId tagId:(NSString*)tagId startDate:(NSString*)startDate endDate:(NSString*)endDate userName:(NSString*)userName tagName:(NSString*)tagName delegate:(id<ReimembursementListInvocationDelegate>)delegate;

-(void)AllTagsListInvocation:(NSString*)userId delegate:(id<AllTagsListInvocationDelegate>)delegate;

-(void)ScheduleFormListInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleFormListInvocationDelegate>)delegate;

-(void)ScheduleStatusListInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleStatusListInvocationDelegate>)delegate;

-(void)ScheduleEmailListInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleEmailListInvocationDelegate>)delegate;

-(void)FilterScheduleListInvocation:(NSDictionary*)dict  delegate:(id<FilterScheduleListInvocationDelegate>)delegate;

-(void)AllTagPostInvocation:(NSMutableDictionary*)dict delegate:(id<AllTagPostInvocationDelegate>)delegate;

-(void)AllUserListInvocation:(NSMutableDictionary*)dict delegate:(id<AllUserListInvocationDelegate>)delegate;

-(void)ScheduleUserDetailInvocation:(NSMutableDictionary*)dict delegate:(id<ScheduleUserDetailInvocationDelegate>)delegate;

-(void)AddCommentInvocation:(NSMutableDictionary*)dict delegate:(id<AddCommentInvocationDelegate>)delegate;

-(void)SettingNotificationInvocation:(NSMutableDictionary*)dict delegate:(id<SettingNotificationInvocationDelegate>)delegate;

-(void)EmailPermissionInvocation:(NSMutableDictionary*)dict delegate:(id<EmailPermissionInvocationDelegate>)delegate;

-(void)OfflineMessageInvocation:(NSMutableDictionary*)dict delegate:(id<OfflineMessageInvocationDelegate>)delegate;

-(void)UpdateScheduleInvocation:(NSMutableDictionary*)dict delegate:(id<UpdateScheduleInvocationDelegate>)delegate;

-(void)AddSelfCreatedScheduleInvocation:(NSMutableDictionary*)dict delegate:(id<AddSelfCreatedScheduleInvocationDelegate>)delegate;


-(void)UpdateSelfCreatedScheduleInvocation:(NSMutableDictionary*)dict delegate:(id<UpdateSelfCreatedScheduleInvocationDelegate>)delegate;


-(void)SelfCreatedScheduleListInvocation:(NSMutableDictionary*)dict delegate:(id<SelfCreatedScheduleListInvocationDelegate>)delegate;

-(void)DeleteSelfCreatedScheduleINvocation:(NSMutableDictionary*)dict delegate:(id<DeleteSelfCreatedScheduleINvocationDelegate>)delegate;

-(void)AllHappyFacePostsInvocation:(NSMutableDictionary*)dict delegate:(id<AllHappyFacePostsInvocationDelegate>)delegate;

-(void)AllSadFacePostsInvocation:(NSMutableDictionary*)dict delegate:(id<AllSadFacePostsInvocationDelegate>)delegate;

-(void)ManagerReimbursementListInvocation:(NSMutableDictionary*)dict delegate:(id<ManagerReimbursementListInvocationDelegate>)delegate;

-(void)UserCompletedFormListInvocation:(NSMutableDictionary*)dict delegate:(id<UserCompletedFormListInvocationDelegate>)delegate;

-(void)TagCompletedFormListInvocation:(NSMutableDictionary*)dict delegate:(id<TagCompletedFormListInvocationDelegate>)delegate;

-(void)UserCompletedFormDetailInvocation:(NSMutableDictionary*)dict delegate:(id<UserCompletedFormDetailInvocationDelegate>)delegate;

-(void)TagCompletedFormDetailInvocation:(NSMutableDictionary*)dict delegate:(id<TagCompletedFormDetailInvocationDelegate>)delegate;

-(void)ManagerAssignedTagListInvocation:(NSMutableDictionary*)dict delegate:(id<ManagerAssignedTagListInvocationDelegate>)delegate;

-(void)ManagerSharePostListInvocation:(NSMutableDictionary*)dict delegate:(id<ManagerSharePostListInvocationDelegate>)delegate;

-(void)DeleteEmailListInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteEmailListInvocationDelegate>)delegate;

-(void)AllPostListInvocation:(NSMutableDictionary*)dict delegate:(id<AllPostListInvocationDelegate>)delegate;

-(void)DeletePostInvocation:(NSMutableDictionary*)dict delegate:(id<DeletePostInvocationDelegate>)delegate;

-(void)DeleteEmailInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteEmailInvocationDelegate>)delegate;

-(void)GetRecordingDetailInvocation:(NSMutableDictionary*)dict delegate:(id<GetRecordingDetailInvocationDelegate>)delegate;

-(void)UploadBackgroundRecordingInvocation:(NSMutableDictionary*)dict data:(NSData*)data delegate:(id<UploadBackgroundRecordingInvocationDelegate>)delegate;

-(void)UploadMadFormInvocation:(NSMutableDictionary*)dict signature:(NSData*)data delegate:(id<UploadMadFormInvocationDelegate>)delegate;

-(void)DeleteRootInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteRootInvocationDelegate>)delegate;

-(void)AllReminderListInvocation:(NSMutableDictionary*)dict delegate:(id<AllReminderListInvocationDelegate>)delegate;

-(void)AllBackpackMessageListInvocation:(NSMutableDictionary*)dict delegate:(id<AllBackpackMessageListInvocationDelegate>)delegate;

-(void)AllBackpackPicListInvocation:(NSMutableDictionary*)dict delegate:(id<AllBackpackPicListInvocationDelegate>)delegate;

-(void)AllBackPackFileListInvocation:(NSMutableDictionary*)dict delegate:(id<AllBackPackFileListInvocationDelegate>)delegate;

-(void)AddReminderInvocation:(NSMutableDictionary*)dict delegate:(id<AddReminderInvocationDelegate>)delegate;

-(void)AddMessageInvocation:(NSMutableDictionary*)dict delegate:(id<AddMessageInvocationDelegate>)delegate;

-(void)AddPicInvocation:(NSMutableDictionary*)dict pic:(NSData*)data delegate:(id<AddPicInvocationDelegate>)delegate;

-(void)AddFileInvocation:(NSMutableDictionary*)dict file:(NSData*)data delegate:(id<AddFileInvocationDelegate>)delegate;

-(void)DeleteBackpackReminderInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteBackpackReminderInvocationDelegate>)delegate;

-(void)DeletebackpackMessageInvocation:(NSMutableDictionary*)dict delegate:(id<DeletebackpackMessageInvocationDelegate>)delegate;

-(void)DeleteBackpackPicInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteBackpackPicInvocationDelegate>)delegate;

-(void)DeleteBackpackFileInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteBackpackFileInvocationDelegate>)delegate;

-(void)ShareRootListInvocation:(NSMutableDictionary*)dict delegate:(id<ShareRootListInvocationDelegate>)delegate;

-(void)ShareBackpackInvocation:(NSMutableDictionary*)dict delegate:(id<ShareBackpackInvocationDelegate>)delegate;

-(void)CreateFolderInvocation:(NSMutableDictionary*)dict delegate:(id<CreateFolderInvocationDelegate>)delegate;

-(void)FolderListInvocation:(NSMutableDictionary*)dict delegate:(id<FolderListInvocationDelegate>)delegate;

-(void)DeleteSmileyInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteSmileyInvocationDelegate>)delegate;

-(void)UploadOcrInvocation:(NSMutableDictionary*)dict uploadData:(NSData*)data delegate:(id<UploadOcrInvocationDelegate>)delegate;

-(void)OcrListInvocation:(NSMutableDictionary*)dict delegate:(id<OcrListInvocationDelegate>)delegate;

-(void)DeleteOcrInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteOcrInvocationDelegate>)delegate;

-(void)AddRouteCommentInvocation:(NSMutableDictionary*)dict delegate:(id<AddRouteCommentInvocationDelegate>)delegate;

-(void)RouteCommentListInvocation:(NSMutableDictionary*)dict delegate:(id<RouteCommentListInvocationDelegate>)delegate;

-(void)DeleteRouteCommentInvocation:(NSMutableDictionary*)dict delegate:(id<DeleteRouteCommentInvocationDelegate>)delegate;

-(void)UploadReceiptInvocation:(NSMutableDictionary*)dict uploadData:(NSData*)data delegate:(id<UploadReceiptInvocationDelegate>)delegate;

-(void)ChooseBackpackFileInvocation:(NSMutableDictionary*)dict delegate:(id<ChooseBackpackFileInvocationDelegate>)delegate;

@end
