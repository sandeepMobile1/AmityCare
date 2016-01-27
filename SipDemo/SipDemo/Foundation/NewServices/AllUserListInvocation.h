//
//  AllUserListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 27/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllUserListInvocation;

@protocol AllUserListInvocationDelegate

-(void)AllUserListInvocationDidFinish:(AllUserListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllUserListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
