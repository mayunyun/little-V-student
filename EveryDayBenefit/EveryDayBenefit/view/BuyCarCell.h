//
//  BuyCarCell.h
//  lx
//
//  Created by 邱 德政 on 16/1/19.
//  Copyright © 2016年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyCarModel.h"
@interface BuyCarCell : UITableViewCell
@property(nonatomic,retain)UIImageView *imgView;  // 产品图片
@property(nonatomic,retain)UILabel *titleLabel;   //标题图片
@property(nonatomic,retain)UILabel *specLabel;     //规格
@property(nonatomic,retain)UILabel *priceLabel;    //价格
@property(nonatomic,retain)UILabel *moneyLabel;    //小计 金额
@property(nonatomic,retain)UILabel *activeLabel;   //参与的活动
@property(nonatomic,retain)UIImageView *selectImg;  //是否被选中的图片
@property(nonatomic,retain)UILabel *pickupLabel;

@property(nonatomic,retain)BuyCarModel *model;

@end
