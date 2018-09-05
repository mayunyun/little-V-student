//
//  ExiteDetailModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/14.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ExiteDetailModel : BaseModel

@property (nonatomic,strong)NSString* exitecount;
@property (nonatomic,strong)NSString* exiteid;
@property (nonatomic,strong)NSString* exitemoney;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* prono;
@property (nonatomic,strong)NSString* prounitid;
@property (nonatomic,strong)NSString* prounitname;
@property (nonatomic,strong)NSString* saleprice;
@property (nonatomic,strong)NSString* specification;

@property (nonatomic,strong)NSString* isgolds;

/*
 [{"exitecount":1,"exiteid":"30","exitemoney":8000,"folder":"tmp/","id":43,"picname":"1477449862418115.jpg","proid":49,"proname":"iphone7","prono":"i001","prounitid":55,"prounitname":"台","saleprice":8000,"specification":"(null)"}
 */

@end
