//
//  TagSelectionVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 29/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagSelectionDelegate <NSObject>

@optional
-(void)didFinishAssignTags:(NSMutableArray*)arrSEL ;
@end

@interface TagSelectionVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //id<TagSelectionDelegate>_tagDelegate;
    IBOutlet UITableView* tblViewTags;
}

@property(nonatomic,strong)NSMutableArray *arrTagData;
@property(nonatomic,strong)NSMutableArray* arrSelectedTags;
@property(nonatomic,assign)BOOL multipleSelection;
@property(nonatomic,unsafe_unretained)id<TagSelectionDelegate>tagDelegate;
@property(nonatomic,assign)BOOL checkRecieptSelection;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnDoneAction:(id)sender;

@end
