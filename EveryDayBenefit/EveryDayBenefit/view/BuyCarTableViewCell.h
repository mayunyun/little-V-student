//
//  BuyCarTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/13.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//
@protocol BuyCarTableViewCellDelegate <NSObject>
//选择
- (void)selectAction:(UIButton *)btn;
//删除
- (void)del:(UIButton *)btn;
//添加
- (void)addClick:(UIButton *)button;
//减少
- (void)reduceClick:(UIButton*)sender;

@end


#import <UIKit/UIKit.h>
#import "BuyCarModel.h"

@interface BuyCarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
- (IBAction)delClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *pickupLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
- (IBAction)reduceClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addClick:(id)sender;

@property (nonatomic,strong)BuyCarModel* model;
@property (nonatomic,weak)id<BuyCarTableViewCellDelegate> delegate;


@end
