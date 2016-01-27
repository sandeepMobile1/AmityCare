//
//  ShareBackpackInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 04/05/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ShareBackpackInvocation;

@protocol ShareBackpackInvocationDelegate

-(void)ShareBackpackInvocationDidFinish:(ShareBackpackInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ShareBackpackInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;




@end
