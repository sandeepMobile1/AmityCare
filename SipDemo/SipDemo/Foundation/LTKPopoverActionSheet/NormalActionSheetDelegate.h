//
//  NormalActionSheetDelegate.h
//  Amity-Care
//
//  Created by Vijay Kumar on 04/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum
{
    AC_ACTIONSHEET_SELECT_RESOURCE,
    AC_ACTIONSHEET_UPLOAD_FROM_CAMERA,
    AC_ACTIONSHEET_UPLOAD_FROM_GALLERY,
    AC_ACTIONSHEET_UPLOAD_FROM_DROPBOX,
    AC_ACTIONSHEET_UPLOAD_PROFILE_PIC,
    AC_ACTIONSHEET_INVITE_CONTACTS,
    AC_ACTIONSHEET_INVITE_VIA_IMESSAGE,
};

@protocol NormalActionDeledate <NSObject>
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface NormalActionSheetDelegate : NSObject <UIActionSheetDelegate>
@property (nonatomic,unsafe_unretained)id<NormalActionDeledate>normalDelegate;
@end
