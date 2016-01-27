//
//  ShareReimbursementInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ShareReimbursementInvocation;

@protocol ShareReimbursementInvocationDelegate

-(void)ShareReimbursementInvocationDidFinish:(ShareReimbursementInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ShareReimbursementInvocation : SAServiceAsyncInvocation{
    
}


@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
