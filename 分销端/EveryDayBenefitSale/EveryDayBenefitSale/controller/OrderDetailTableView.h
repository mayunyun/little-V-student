//
//  OrderDetailTableView.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTableView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray* dataArray;
@property (nonatomic,strong)UITableView *tableView;

@end
