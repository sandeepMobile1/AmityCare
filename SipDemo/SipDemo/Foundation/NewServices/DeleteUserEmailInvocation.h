//
//  DeleteUserEmailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteUserEmailInvocation;

@protocol DeleteUserEmailInvocationDelegate

-(void)DeleteUserEmailInvocationDidFinish:(DeleteUserEmailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteUserEmailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *mail_id;

@end
