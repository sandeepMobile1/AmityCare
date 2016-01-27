//
//  Config.m
//  Amity-Care
//
//  Created by Vijay Kumar on 28/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ConfigManager.h"
#import "Reachability.h"

@implementation ConfigManager

float longitude =0.0;
float latitude =0.0;

//const NSString *urlstring = @"http://192.168.1.67/amity_care/web_services/";
//const NSString *smallThumbImageURL = @"http://192.168.1.67/amity_care/uploads/user/thumb/";
//const NSString *largeThumbImageURL = @"http://192.168.1.67/amity_care/uploads/user/large/";
//const NSString *smallPostThumbnailImageURL = @"http://192.168.1.67/amity_care/uploads/post/";
//const NSString *largePostThumbnailImageURL = @"http://192.168.1.67/amity_care/uploads/post/thumb/";

//const NSString *urlstring = @"http://64.15.136.251:8080/amity_care/web_services/";
//const NSString *smallThumbImageURL = @"http://64.15.136.251:8080/amity_care/uploads/user/thumb/";
//const NSString *largeThumbImageURL = @"http://64.15.136.251:8080/amity_care/uploads/user/large/";
//const NSString *smallPostThumbnailImageURL = @"http://64.15.136.251:8080/amity_care/uploads/post/";
//const NSString *largePostThumbnailImageURL = @"http://64.15.136.251:8080/amity_care/uploads/post/thumb/";

//const NSString *urlstring = @"http://209.208.125.225/~encouraginginter/web_services/";
//const NSString *smallThumbImageURL = @"http://209.208.125.225/~encouraginginter/uploads/user/thumb/";
//const NSString *largeThumbImageURL = @"http://209.208.125.225/~encouraginginter/uploads/user/large/";
//const NSString *smallPostThumbnailImageURL = @"http://209.208.125.225/~encouraginginter/uploads/post/";
//const NSString *largePostThumbnailImageURL = @"http://209.208.125.225/~encouraginginter/uploads/post/thumb/";


//const NSString *urlstring = @"https://192.168.1.67/amity_care/web_services/";
//const NSString *smallThumbImageURL = @"https://192.168.1.67/amity_care/uploads/user/thumb/";
//const NSString *largeThumbImageURL = @"https://192.168.1.67/amity_care/uploads/user/large/";
//const NSString *smallPostThumbnailImageURL = @"https://192.168.1.67/amity_care/uploads/post/";
//const NSString *largePostThumbnailImageURL = @"https://192.168.1.67/amity_care/uploads/post/thumb/";

//const NSString *urlstring = @"https://64.15.136.251:8080/amity_care/web_services/";
//const NSString *smallThumbImageURL = @"https://64.15.136.251:8080/amity_care/uploads/user/thumb/";
//const NSString *largeThumbImageURL = @"https://64.15.136.251:8080/amity_care/uploads/user/large/";
//const NSString *smallPostThumbnailImageURL = @"https://64.15.136.251:8080/amity_care/uploads/post/";
//const NSString *largePostThumbnailImageURL = @"https://64.15.136.251:8080/amity_care/uploads/post/thumb/";

//const NSString *urlstring = @"https://209.208.125.225/~encouraginginter/web_services/";
//const NSString *smallThumbImageURL = @"https://209.208.125.225/~encouraginginter/uploads/user/thumb/";
//const NSString *largeThumbImageURL = @"https://209.208.125.225/~encouraginginter/uploads/user/large/";
//const NSString *smallPostThumbnailImageURL = @"https://209.208.125.225/~encouraginginter/uploads/post/";
//const NSString *largePostThumbnailImageURL = @"https://209.208.125.225/~encouraginginter/uploads/post/thumb/";


//const NSString *urlstring = @"http://www.encouraginginteraction.com/web_services/";
//const NSString *urlstring = @"http://www.encouraginginteraction.com/web_services3/";
const NSString *urlstring = @"http://www.encouraginginteraction.com/web_services4/";

const NSString *smallThumbImageURL = @"http://encouraginginteraction.com/uploads/user/thumb/";
const NSString *largeThumbImageURL = @"http://encouraginginteraction.com/uploads/user/large/";
const NSString *smallPostThumbnailImageURL = @"http://encouraginginteraction.com/uploads/post/";
const NSString *largePostThumbnailImageURL = @"http://encouraginginteraction.com/uploads/post/";
const NSString *tagThumbImageURL = @"http://encouraginginteraction.com/uploads/tag/";
const NSString *pdfURL = @"http://encouraginginteraction.com/uploads/pdf/";
const NSString *checkClockOutTimer=@"";
NSString *gDeviceToke=@"";

const NSString *largeThumbOutputImageURL=@"http://encouraginginteraction.com/uploads/thumb/";
const NSString *tinyOutputImageURL=@"http://encouraginginteraction.com/uploads/tiny";
const NSString *originalOutputImageURL=@"http://encouraginginteraction.com/uploads/form/";
const NSString *audioOutputUrl=@"http://encouraginginteraction.com/uploads/formAudio/";

const NSString *largeThumbChatImageURL=@"http://encouraginginteraction.com/uploads/chat/image/thumb/";
const NSString *tinyChatImageURL=@"http://encouraginginteraction.com/uploads/chat/image/tiny/";
const NSString *originalChatImageURL=@"http://encouraginginteraction.com/uploads/chat/image/";
const NSString *chatAudioUrl=@"http://encouraginginteraction.com/uploads/chat/audio/";

const NSString *formOriginalAnswerImageUrl=@"http://encouraginginteraction.com/uploads/answer/";
const NSString *formThumbAnswerImageUrl=@"http://encouraginginteraction.com/uploads/answer/thumb/";

const NSString *MapOriginalImageUrl=@"http://encouraginginteraction.com/uploads/rootmap/";
const NSString *mapThumbImageUr=@"http://encouraginginteraction.com/uploads/rootmap/thumb/";

const NSString *largeBackPackImageURL=@"http://encouraginginteraction.com/uploads/backpack/";
const NSString *backPackThumbImageURL=@"http://encouraginginteraction.com/uploads/backpack/thumb/";
const NSString *recieptImageURL=@"http://encouraginginteraction.com/uploads/receipt/";
const NSString *recieptThumbImageURL=@"http://encouraginginteraction.com/uploads/receipt/thumb/";

const NSString *attachmentFileImageURL=@"http://encouraginginteraction.com/uploads/attachement/";

/*
 * validatePassword: takes an string and check for atleast one special,uppercase,lowercase,number.
 * password: input string
 * return type: if pattern found return YES if not returns NO
 */

+(BOOL)validatePassword:(NSString*)password
{
    /*
     (?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$  "matches atleast one special,uppercase,lowercase,numer"
     "(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[!@#$%^&*()?:;])(?=.*[a-zA-Z]).*$"
     */
    
   // NSString *emailRegex = @"(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[!@#$%^&*\\-()?:;])(?=.*[a-zA-Z]).*$";
    NSString *emailRegex = @"(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[!@#$%^&*\\-()?:;])(?=.*[A-Z]).*$";

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSLog(@"Bool =%d",[emailTest evaluateWithObject:password]);
    return [emailTest evaluateWithObject:password];
}

/*
 * validateEmail: takes an string and check for valid email address.
 * email: input string
 * return type: if pattern found return YES if not returns NO
 */
+(BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*
 * validatePhoneNum: takes an string and check for valid Phone Number.
 * phoneno: input string
 * return type: BOOL if pattern found return YES if not returns NO
 */
+(BOOL)validatePhoneNum:(NSString*)phoneno
{
    NSString *emailRegex = @"\\+?[0-9]{6,13}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:phoneno];
}

/*
 * showInstalledFonts: Shows all the custom installed fonts.
 */

+(void)showInstalledFonts
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

+(int)getLabelHeight:(UILabel*)label constrainedSize:(CGSize)size text:(NSString*)string
{
    CGSize maximumLabelSize = size;
    
    // CGSize expectedLabelSize = [string sizeWithFont:[UIFont fontWithName:label.font.fontName size:label.font.pointSize]   constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:label.font.fontName size:label.font.pointSize]}
                                           context:nil];
    
    CGSize expectedLabelSize = textRect.size;
    
    return ceil(expectedLabelSize.height);
    
}

/*
 * timeDifferenceInHrs: Calculates difference between dates in Hrs
 * dateNew: New date
 * datePre: Previous date
 * return type: total differnce in hrs
 */

+ (NSInteger)timeDifferenceInDays:(NSDate*)dateNew previousDate:(NSDate*)datePre
{
    /*
     NSTimeInterval interval = [dateNew timeIntervalSinceDate:datePre];
     int days = (abs(interval)) / 86400;
     return days;
     */
    NSLog(@"Old= %@ New=%@",datePre,dateNew);
    
    //    NSDate* date1 = [NSDate date];
    //    NSDate *date2 = [NSDate dateWithTimeInterval:6588888 sinceDate:[NSDate date]];
    //
    //    NSLog(@"Old= %@ New=%@",date1,date2);
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:dateNew
                                                          toDate:datePre
                                                         options:0];
    
    NSLog(@"days =%ld",(long)[components day]);
    return [components day];
}



/*
 * timeDifferenceInHrs: Calculates difference between dates in Hrs
 * dateNew: New date
 * datePre: Previous date
 * return type: total differnce in hrs
 */

+ (NSInteger)timeDifferenceInHrs:(NSDate*)dateNew previousDate:(NSDate*)datePre
{
    NSTimeInterval interval = [dateNew timeIntervalSinceDate:datePre];
    int hours = (abs(interval)) / 3600;
    return hours;
}


+(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}


/*
 * showAlertMessage: Presents an alertview
 * title: title to be displayed on alertview
 * msg: message to be display
 * return type: if pattern found return YES if not returns NO
 */

+ (void) showAlertMessage:(NSString *)title Message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/*
 * alertViewWithButtonTitle: Presents an alertview
 * title: title to be displayed on alertview
 * msg: message to be display
 * btnTitle: OK button title to be displayed on alertview
 * return type: if pattern found return YES if not returns NO
 */

+ (void)alertViewWithButtonTitle:(NSString *)title Message:(NSString *)msg okBtnTitle:(NSString*)btnTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:btnTitle,nil];
   	[alert show];
}

+ (ACAlertView*)alertView:(NSString*)title message:(NSString*)message del:(id)delegate
{
    return ([[ACAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"OK", nil]);
}

+(BOOL)isInternetAvailable
{
    BOOL flag = FALSE;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus status =[reachability currentReachabilityStatus];
    if(status ==ReachableViaWiFi || status == ReachableViaWWAN ){
        flag = TRUE;
    }
    return flag;
}


+(BOOL)stringContainsSpecialCharacters:(NSString*)string
{
    NSString *specialCharacterString = @"!~`%^*+();:={}[]<>?\'"; //!~`@#$%^&*-+();:={}[],<>?\\/\"\'
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([string.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        return TRUE;
    }
    return FALSE;
}

+(BOOL)stringContainsEmoji:(NSString*)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

+(NSString*)trimmedString:(NSString*)input{
    return [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
