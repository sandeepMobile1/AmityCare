//
//  OpenCartAsyncInvocation.m
//  SimpleAddiction
//
//  Created by Sandeep Agarwal on 19/12/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import "AmityCareAsyncInvocation.h"

@implementation AmityCareAsyncInvocation

-(id)init {
	self = [super init];
	if (self) {
		self.clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
		self.clientVersionHeaderName = @"ProductStore-Client-Version";
	}
	return self;
}

@end