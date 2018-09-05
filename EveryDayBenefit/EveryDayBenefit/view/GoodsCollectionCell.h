//
//  GoodsCollectionCell.h
//  EveryDayBenefit
//
//  Created by 钱龙 on 2018/2/24.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassDetailModel.h"
@interface GoodsCollectionCell : UICollectionViewCell
@property(nonatomic,retain)UIImageView *imgView;

@property(nonatomic,retain)UILabel *titleLabel;

@property (nonatomic,retain)UILabel* saleCountLabel;

@property (nonatomic,retain)UILabel* priceLabel;

@property (nonatomic,retain)UIButton* downBtn;
@property (nonatomic,retain)UILabel* countLabel;
@property (nonatomic,retain)UIButton* UpBtn;
@property (nonatomic,retain)UIButton* rightNowBtn;
@property (nonatomic,retain)UIButton* joinShopCarBtn;

@property (nonatomic,strong)void(^downBtnBlock)();
@property (nonatomic,strong)void(^upBtnBlock)();
@property (nonatomic,strong)void(^rightNowBtnBlock)();
@property (nonatomic,strong)void(^joinShopCarBtnBlock)();
@property(nonatomic,retain)ClassDetailModel *model;
@end
