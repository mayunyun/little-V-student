//
//  MineNewCollectTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

@protocol MineNewCollectTableViewCellDelegate <NSObject>

- (void)addBuyCarClick:(UIButton*)sender;

@end


#import <UIKit/UIKit.h>
#import "ProCollModel.h"
@interface MineNewCollectTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyCarBtn;
- (IBAction)addBuyCarClick:(id)sender;
@property (nonatomic,weak)id<MineNewCollectTableViewCellDelegate> delegate;
@property (nonatomic,strong)ProCollModel* model;


@end
