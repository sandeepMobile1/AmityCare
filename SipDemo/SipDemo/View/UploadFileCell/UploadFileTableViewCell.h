//
//  UploadFileTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <UIKit/UIKit.h>

@class  UploadFileTableViewCell;

@protocol UploadFileTableViewCellDelegate <NSObject>

@end

@interface UploadFileTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *   imgView;
@property(nonatomic,strong)IBOutlet UIButton *  btnDelete;
@property(nonatomic,strong)IBOutlet UILabel *  lblTitle;

@property(nonatomic,assign) id<UploadFileTableViewCellDelegate>delegate;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

+(UploadFileTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


@end
