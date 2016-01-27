//
//  GetStatusInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetStatusInvocation;

@protocol GetStatusInvocationDelegate

-(void)getStatusInvocationDidFinish:(GetStatusInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface GetStatusInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
