//
//  Form.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 04/09/14.
//
//

#import <Foundation/Foundation.h>

@interface Form : NSObject

@property(nonatomic,strong) NSString * strFormId;
@property(nonatomic,strong) NSString * strFormTitleStr;
@property(nonatomic,strong) NSString * strFormOutputVideo;
@property(nonatomic,strong) NSString * strFormOutputAudio;
@property(nonatomic,strong) NSString * strFormOutputImage;
@property(nonatomic,strong) NSString * strFormType;
@property(nonatomic,strong) NSString * strNumberOfPages;
@property(nonatomic,strong) NSString * strNumber;
@property(nonatomic,strong) NSString * strBeaconStatus;
@property(nonatomic,strong) NSString * strBeaconMinorValue;
@property(nonatomic,strong) NSString * strBeaconMajorValue;
@property(nonatomic,strong) NSString * strBeaconDeviceName;
@property(nonatomic,strong) NSString * strBeaconUuid;
@property(nonatomic,strong) NSString * strFormRoleId;

@property(nonatomic,strong) NSMutableArray* arrStructue;

@end
