//
//  UpdateAppPinInvocation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 19/09/14.
//
//


#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UpdateAppPinInvocation;

@protocol UpdateAppPinInvocationDelegate

-(void)updateAppPinInvocationDidFinish:(UpdateAppPinInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface UpdateAppPinInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* appPin;

@end
