//
//  UploadPicTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <UIKit/UIKit.h>

@class  UploadPicTableViewCell;

@protocol UploadPicTableViewCellDelegate <NSObject>

@end


@interface UploadPicTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *   imgView;
@property(nonatomic,strong)IBOutlet UIButton *  btnDelete;
@property(nonatomic,strong)IBOutlet UILabel *  lblTitle;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

@property(nonatomic,assign) id<UploadPicTableViewCellDelegate>delegate;

+(UploadPicTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


@end
