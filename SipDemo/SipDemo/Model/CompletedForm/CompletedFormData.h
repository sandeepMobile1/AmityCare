//
//  CompletedFormData.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>

@interface CompletedFormData : NSObject

@property(nonatomic,strong) NSString* formId;
@property(nonatomic,strong) NSString* formTitle;
@property(nonatomic,strong) NSString* formType;
@property(nonatomic,strong) NSString* formTag;
@property(nonatomic,strong) NSString* formUserId;
@property(nonatomic,strong) NSString* formUserName;
@property(nonatomic,strong) NSString* formUserImage;
@property(nonatomic,strong) NSString* formCompletionTime;
@property(nonatomic,strong) NSString* formBadges;
@property(nonatomic,strong) NSString* formTagId;

@end
