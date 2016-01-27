//
//  AddMessageInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddMessageInvocation;

@protocol AddMessageInvocationDelegate

-(void)AddMessageInvocationDidFinish:(AddMessageInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AddMessageInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
