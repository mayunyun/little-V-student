//
//  getHotProductModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface getHotProductModel : BaseModel

@property (nonatomic,strong)NSString* brand;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* ishot;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* life;
@property (nonatomic,strong)NSString* mainunitid;
@property (nonatomic,strong)NSString* mainunitname;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;              //产品名称
@property (nonatomic,strong)NSString* prono;                //产品编码
@property (nonatomic,strong)NSString* propicurl;            //图片链接
@property (nonatomic,strong)NSString* protypeid;            //产品类型id
@property (nonatomic,strong)NSString* protypename;          //
@property (nonatomic,strong)NSString* price;                //价格------处理后的
@property (nonatomic,strong)NSString* prosale;              //销量
//@property (nonatomic,strong)NSString* proHotSale;
@property (nonatomic,strong)NSString* saleprice;            //产品统一销售价格
@property (nonatomic,strong)NSString* singleprice;          //分区价格，如果这个为空就显示统一价格，不为空就显示该价格
@property (nonatomic,strong)NSString* specification;        //产品规格
@property (nonatomic,strong)NSString* warncount;            //预警数量
@property (nonatomic,strong)NSString* pickupway;            //是否自取。1自取0配送。



/*
 brand = 2222;
 folder = "tmp/";
 id = 38;
 ishot = 1;
 isspecial = 0;
 isvalid = 1;
 life = 22;
 mainunitid = 48;
 mainunitname = "?";
 picname = "147364757547459banner4.jpg";
 proid = 38;
 proname = 22;
 prono = 222;
 propicurl = 0;
 protypeid = 56;
 protypename = "\U751f\U6d3b\U7528\U54c1";
 saleprice = 222;
 singleprice = 10;
 specification = 222;
 warncount = 1;
 */

@end
