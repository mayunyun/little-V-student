//
//  BowseHistoryModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface BowseHistoryModel : BaseModel

@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* brand;            //商标
@property (nonatomic,strong)NSString* creatorid;        //用户
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* fenxiaomoney;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* ishot;
@property (nonatomic,strong)NSString* isspecial;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* jinbi;
@property (nonatomic,strong)NSString* life;             //保质期
@property (nonatomic,strong)NSString* mainunitid;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* productid;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* prono;
@property (nonatomic,strong)NSString* propicurl;
@property (nonatomic,strong)NSString* prosale;
@property (nonatomic,strong)NSString* protypeid;
@property (nonatomic,strong)NSString* protypename;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* saleprice;
@property (nonatomic,strong)NSString* sendermoney;
@property (nonatomic,strong)NSString* sendtime;
@property (nonatomic,strong)NSString* singleprice;
@property (nonatomic,strong)NSString* specification;
@property (nonatomic,strong)NSString* titlemoney;
@property (nonatomic,strong)NSString* villagemoney;
@property (nonatomic,strong)NSString* price;            //产品显示价格
@property (nonatomic,strong)NSString* warncount;        //数量提醒
@property (nonatomic,strong)NSString* isselect;
@property (nonatomic,strong)NSString* isgolds;


/*
{"areaid":1,"brand":"美国","cityid":1,"creatorid":61,"fenxiaomoney":350,"folder":"tmp/","id":145,"ishot":1,"isspecial":1,"isvalid":1,"jinbi":100,"life":10,"mainunitid":55,"note":"手机7","picname":"147598355723246shouji1.jpg","productid":49,"proid":49,"proname":"iphone7","prono":"i001","propicurl":"美国","prosale":1,"protypeid":59,"protypename":"数码极客","provinceid":1,"rn":1,"saleprice":7000,"sendermoney":130,"sendtime":11,"singleprice":1380,"specification":"台","titlemoney":580,"villagemoney":100,"warncount":0}
 */
@end
