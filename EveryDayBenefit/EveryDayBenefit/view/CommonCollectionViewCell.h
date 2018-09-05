//
//  CommonCollectionViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/11.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
@protocol CommonCollectionViewCellDelegate <NSObject>

- (void)selectproItemClick:(UIButton*)sender;

@end

#import <UIKit/UIKit.h>


@interface CommonCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *prictLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectImgBtn;
- (IBAction)selectClick:(id)sender;
//block声明
@property (weak,nonatomic)id<CommonCollectionViewCellDelegate> delegate;
//block声明
@property (nonatomic, copy) void (^transVaule)(BOOL isClick);

@end
