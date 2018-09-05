//
//  YouLikeCollectionViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/13.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoulikeModel.h"

@interface YouLikeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,strong)YoulikeModel* model;

@end
