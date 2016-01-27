//
//  Task.m
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "Tags.h"

@implementation Tags
@synthesize tagId,tagTitle,tagDesc;
@synthesize isSelected;


-(id)copy
{
    Tags* t = [[Tags alloc] init];
    
    t.tagId = self.tagId;
    t.tagTitle = self.tagTitle;
    t.tagDesc = self.tagDesc;
    t.isSelected = self.isSelected;
    return t;
}

@end
