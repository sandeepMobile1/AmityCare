//
//  AcceptanceInvocation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 20/08/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AcceptanceInvocation;

@protocol AcceptanceInvocationDelegate

- (void)userAcceptanceInvocationDidFinish:(AcceptanceInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AcceptanceInvocation : SAServiceAsyncInvocation
{
    
}

@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *memberID;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *contactId;

@end

