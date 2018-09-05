//
//  OrderDetailProTbViewModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface OrderDetailProTbViewModel : BaseModel

@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* price;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* isgolds;
@property (nonatomic,strong)NSString* sendtime;

/*
 @property (strong, nonatomic) IBOutlet UIImageView *imgView;
 @property (strong, nonatomic) IBOutlet UILabel *titleLabel;
 @property (strong, nonatomic) IBOutlet UILabel *priceLabel;
 @property (strong, nonatomic) IBOutlet UILabel *countLabel;
 */

@end
