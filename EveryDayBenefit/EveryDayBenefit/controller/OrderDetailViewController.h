//
//  OrderDetailViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

//ui隐藏
typedef enum {
    typeOrderAddress = 0,
    typeOrderpayCar = 1,
}	typeOrderDetail;

#import "BaseViewController.h"
#import "getProductDetailModel.h"


@interface OrderDetailViewController : BaseViewController

@property (nonatomic,assign)typeOrderDetail typeOrder;
//立即支付
@property (nonatomic,strong)getProductDetailModel* nowProdetailModel;
@property (nonatomic,assign)NSInteger nowProcount;
//从购物车跳转
@property (nonatomic,strong)NSArray* dataIdArray;
//从积分商城中
@property (nonatomic,strong)NSString* golds;
//从分线上商品还是线下商品
@property (nonatomic,strong)NSString* upline;

//
@property (nonatomic,strong)NSString* type;
@end
