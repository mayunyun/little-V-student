//
//  YoulikeModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface YoulikeModel : BaseModel

@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* prosale;
@property (nonatomic,strong)NSString* rownum;
@property (nonatomic,strong)NSString* s;
@property (nonatomic,strong)NSString* singleprice;

/*
 {"folder":null,"id":69,"picname":null,"proid":69,"proname":"华为mate9","prosale":11,"rownum":1,"s":12,"singleprice":6000}
 */

@end
