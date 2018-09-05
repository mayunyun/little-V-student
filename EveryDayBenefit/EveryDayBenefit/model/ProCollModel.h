//
//  ProCollModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ProCollModel : BaseModel

@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *picname;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *proname;
@property(nonatomic,copy)NSString *prosale;
@property(nonatomic,copy)NSString *isselect;
@property(nonatomic,copy)NSString *proid;
@property(nonatomic,copy)NSString *folder;
@property(nonatomic,copy)NSString *isgolds;
@property(nonatomic,copy)NSString* prono;
@property(nonatomic,copy)NSString* specification;
@property(nonatomic,copy)NSString* mainunitid;
@property(nonatomic,copy)NSString* mainunitname;



/*
收藏列表查询返回str{"list":[{"folder":"tmp/","id":179,"picname":"148055923997562ip7.png","price":7890,"proid":68,"proname":"iphone7plurs","prosale":4,"rn":1}
 */

@end
