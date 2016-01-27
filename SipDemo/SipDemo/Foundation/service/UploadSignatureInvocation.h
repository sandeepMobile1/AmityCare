//
//  UploadSignatureInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 12/01/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadSignatureInvocation;

@protocol UploadSignatureInvocationDelegate

-(void)UploadSignatureInvocationDidFinish:(UploadSignatureInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UploadSignatureInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
