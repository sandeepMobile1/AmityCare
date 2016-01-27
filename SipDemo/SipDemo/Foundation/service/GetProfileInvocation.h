//
//  SetProfileInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetProfileInvocation;

@protocol GetProfileInvocationDelegate

-(void)getProfileInvocationDidFinish:(GetProfileInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface GetProfileInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *resultString;
@property(nonatomic, strong) NSDictionary* resultsd;

@end
