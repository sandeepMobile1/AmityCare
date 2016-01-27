//
//  SetProfileInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SetProfileInvocation;

@protocol SetProfileInvocationDelegate

-(void)setProfileInvocationDidFinish:(SetProfileInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface SetProfileInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *userInfo;
@property(nonatomic, strong) NSData *imageData;
@end
