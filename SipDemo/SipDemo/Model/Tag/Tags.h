//
//  Task.h
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tags : NSObject

@property(nonatomic,strong) NSString*tagId;
@property(nonatomic,strong) NSString*tagTitle;
@property(nonatomic,strong) NSString*tagDesc;

/*
 isSelected: Keeps track when user has selected a tag, Generally when creating a task or uploading document
*/
@property(nonatomic,assign) BOOL isSelected;
@end
