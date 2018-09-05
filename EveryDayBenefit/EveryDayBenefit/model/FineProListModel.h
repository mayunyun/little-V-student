//
//  FineProListModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface FineProListModel : BaseModel
@property (nonatomic,strong)NSString* bad;          //差评
@property (nonatomic,strong)NSString* collection;   //收藏
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
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* folder;


/*
 {"folder":"tmp/","id":49,"picname":"147598355723246shouji1.jpg","price":8500,"proname":"iphone7","propicurl":"美国","prosale":1}
 */



@end
