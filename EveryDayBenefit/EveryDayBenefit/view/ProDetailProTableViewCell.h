//
//  ProDetailProTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProDetailProTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *collectionLabel;
@property (strong, nonatomic) IBOutlet UIButton *collBtnImgView;
@property (strong, nonatomic) IBOutlet UILabel *pickupwayLabel;

- (IBAction)collImgViewBtnClick:(id)sender;

//block声明
@property (nonatomic, copy) void (^transVaule)(BOOL isClick);

@end
