//
//  ShareRootListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 30/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ShareRootListInvocation;

@protocol ShareRootListInvocationDelegate

-(void)ShareRootListInvocationDidFinish:(ShareRootListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ShareRootListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;



@end
