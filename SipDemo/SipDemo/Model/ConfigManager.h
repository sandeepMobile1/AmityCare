//
//  Config.h
//  Amity-Care
//
//  Created by Vijay Kumar on 28/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACAlertView.h"

/*
 Local Path:
 User image path:
 Origional image path:http://192.168.1.67/amity_care/uploads/user
 Origional thumb image path:http://192.168.1.67/amity_care/uploads/user/thumb
 Origional large image path:http://192.168.1.67/amity_care/uploads/user/large
 
 User default image path:http://192.168.1.67/amity_care/uploads/user/thumb/no_img.png
 
 64 server:
 User image path:
 Origional image path:http://64.15.136.251:8080/amity_care/uploads/user
 Origional thumb image path:http://64.15.136.251:8080/amity_care/uploads/user/thumb
 Origional large image path:http://64.15.136.251:8080/amity_care/uploads/user/large
 
 User default image path:http://64.15.136.251:8080/amity_care/uploads/user/thumb/no_img.png
 
 */


@interface ConfigManager : NSObject


extern float longitude;
extern float latitude;

extern const NSString *urlstring ;

extern const NSString *smallThumbImageURL;
extern const NSString *largeThumbImageURL;

extern const NSString *smallPostThumbnailImageURL;
extern const NSString *largePostThumbnailImageURL;
extern const NSString *tagThumbImageURL;
extern const NSString *pdfURL;
extern const NSString *checkClockOutTimer;
extern NSString *gDeviceToke;


extern const NSString *largeThumbOutputImageURL;
extern const NSString *tinyOutputImageURL;
extern const NSString *originalOutputImageURL;
extern const NSString *audioOutputUrl;


extern const NSString *largeThumbChatImageURL;
extern const NSString *tinyChatImageURL;
extern const NSString *originalChatImageURL;
extern const NSString *chatAudioUrl;

extern const NSString *formOriginalAnswerImageUrl;
extern const NSString *formThumbAnswerImageUrl;

extern const NSString *MapOriginalImageUrl;
extern const NSString *mapThumbImageUrl;

extern const NSString *largeBackPackImageURL;
extern const NSString *backPackThumbImageURL;

extern const NSString *recieptImageURL;
extern const NSString *recieptThumbImageURL;

extern const NSString *attachmentFileImageURL;

#pragma mark- TextField Validations
+(BOOL)validatePassword:(NSString*)string;
+(BOOL)validateEmail:(NSString*)string;
+(BOOL)validatePhoneNum:(NSString*)email;

#pragma mark- Custom fonts names
+(void)showInstalledFonts;
+(int)getLabelHeight:(UILabel*)label constrainedSize:(CGSize)size text:(NSString*)string;

#pragma mark- Time & Date Validations
+(NSInteger)timeDifferenceInHrs:(NSDate*)dateNew previousDate:(NSDate*)datePre;
+(NSInteger)timeDifferenceInDays:(NSDate*)dateNew previousDate:(NSDate*)datePre;
+(NSString*)shortStyleDate:(NSDate*)date;
+(BOOL)isInternetAvailable;

#pragma mark- String Validations
+(BOOL)stringContainsSpecialCharacters:(NSString*)string;
+(BOOL)stringContainsEmoji:(NSString*)string;
+(NSString*)trimmedString:(NSString*)input;


#pragma mark- Alertview
+ (void) showAlertMessage:(NSString *)title Message:(NSString *)msg;
+ (void)alertViewWithButtonTitle:(NSString *)title Message:(NSString *)msg okBtnTitle:(NSString*)btnTitle;
+ (ACAlertView*)alertView:(NSString*)title message:(NSString*)message del:(id)delegate;

@end
