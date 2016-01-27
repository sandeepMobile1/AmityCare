//
//  CheckPinInvocation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 22/09/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class CheckPinInvocation;

@protocol CheckPinInvocationDelegate

-(void)checkPinInvocationDidFinish:(CheckPinInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface CheckPinInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* secretPin;
@property(nonatomic,strong)NSString* userId;

@end