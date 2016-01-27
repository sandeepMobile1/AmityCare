//
//  SipAcDetails.h
//  Amity-Care
//
//  Created by Vijay Kumar on 27/06/14.
//
//

#import <Foundation/Foundation.h>

@interface SipAcDetails : NSObject<NSCoding>

@property(nonatomic,strong)NSString* ipAddress;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,strong)NSString* username;

@end
