//
//  UserCalenderListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 13/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserCalenderListInvocation;

@protocol UserCalenderListInvocationDelegate

-(void)UserCalenderListInvocationDidFinish:(UserCalenderListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface UserCalenderListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;

@end