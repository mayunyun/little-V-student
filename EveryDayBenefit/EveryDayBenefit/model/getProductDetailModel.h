//
//  getProductDetailModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface getProductDetailModel : BaseModel

@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* bad;          //差评
@property (nonatomic,strong)NSString* collection;   //收藏 1,已收藏
@property (nonatomic,strong)NSString* good;         //好评
@property (nonatomic,strong)NSString* Id;           //产品id
@property (nonatomic,strong)NSString* middle;       //好评
@property (nonatomic,strong)NSString* note;         //商品信息
@property (nonatomic,strong)NSString* price;        //价格
@property (nonatomic,strong)NSString* productaddress;   //生产地址
@property (nonatomic,strong)NSString* proname;      //商品名
@property (nonatomic,strong)NSString* prosale;      //产品销量
@property (nonatomic,strong)NSString* picname;      //图片
@property (nonatomic,strong)NSString* mainunitname; //主单位名称
@property (nonatomic,strong)NSString* mainunitid;   //主单位id
@property (nonatomic,strong)NSString* specification;//规格
@property (nonatomic,strong)NSString* prono;        //编号

@property (nonatomic,strong)NSString* pickupway;    //是否自取


/*
 bad = 1;
 collection = 0;
 good = 1;
 id = 36;
 mainunitid = 49;
 middle = 1;
 note = "???";
 picname = "1474618161336861473389743.png";
 price = 12;
 productaddress = "\U6d4e\U5357";
 proname = 7777;
 prono = 201609050002;
 prosale = 10;
 specification = 77777;
 */

@end
