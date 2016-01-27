//
//  AddSadSmileInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddSadSmileInvocation;

@protocol AddSadSmileInvocationDelegate

-(void)AddSadSmileInvocationDidFinish:(AddSadSmileInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface AddSadSmileInvocation :SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;
@property(nonatomic, strong) NSString *feed_id;
@property(nonatomic, strong) NSString *status;

@end
