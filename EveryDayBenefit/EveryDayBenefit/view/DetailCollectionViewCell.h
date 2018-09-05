//
//  DetailCollectionViewCell.h
//  lx
//
//  Created by 联祥 on 16/1/7.
//  Copyright © 2016年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailModel.h"
@interface DetailCollectionViewCell : UICollectionViewCell
@property(nonatomic,retain)UIImageView *imgView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *specLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UIButton *buyCarImg;

@property (nonatomic,retain)UIButton* downBtn;
@property (nonatomic,retain)UILabel* countLabel;
@property (nonatomic,retain)UIButton* UpBtn;
@property (nonatomic,retain)UIButton* rightNowBtn;
@property (nonatomic,retain)UIButton* joinShopCarBtn;
@property (nonatomic,strong)void(^downBtnBlock)();
@property (nonatomic,strong)void(^upBtnBlock)();
@property (nonatomic,strong)void(^rightNowBtnBlock)();
@property (nonatomic,strong)void(^joinShopCarBtnBlock)();


@property(nonatomic,strong)ProDetailModel *model;

//block声明
@property (nonatomic, copy) void (^transVaule)(UIButton* sender);


@end
