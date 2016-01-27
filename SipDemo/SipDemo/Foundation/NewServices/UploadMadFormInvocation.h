//
//  UploadMadFormInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadMadFormInvocation;

@protocol UploadMadFormInvocationDelegate

-(void)UploadMadFormInvocationDidFinish:(UploadMadFormInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UploadMadFormInvocation : SAServiceAsyncInvocation{
    
}


@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;


@end
