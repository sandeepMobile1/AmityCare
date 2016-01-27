//
//  IBeaconD.h
//  Amity-Care
//
//  Created by Shweta Sharma on 16/04/15.
//
//

#import <Foundation/Foundation.h>

@interface IBeaconD : NSObject

@property(nonatomic,strong) NSString * strBeaconStatus;
@property(nonatomic,strong) NSString * strBeaconMinorValue;
@property(nonatomic,strong) NSString * strBeaconMajorValue;
@property(nonatomic,strong) NSString * strBeaconDeviceName;
@property(nonatomic,strong) NSString * strBeaconUuid;

@end
