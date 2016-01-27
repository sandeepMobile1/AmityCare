//
//  DeleteMailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteMailInvocation;

@protocol DeleteMailInvocationDelegate

-(void)DeleteMailInvocationDidFinish:(DeleteMailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteMailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *mail_id;
@property(nonatomic, strong) NSString *tag_id;

@end
