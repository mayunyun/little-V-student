//
//  ProCollectionViewCell.h
//  lx
//
//  Created by 联祥 on 16/1/25.
//  Copyright © 2016年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoulikeModel.h"
@interface ProCollectionViewCell : UICollectionViewCell

@property(nonatomic,retain)UIImageView *imgView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *specLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)YoulikeModel *model;

@end
