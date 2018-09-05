//
//  OrderManageListModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface OrderManageListModel : BaseModel

//@property (nonatomic,strong)NSString* Id;
//@property (nonatomic,strong)NSString* orderno;
//@property (nonatomic,strong)NSString* custid;
//@property (nonatomic,strong)NSString* custname;
//@property (nonatomic,strong)NSString* createtime;
//@property (nonatomic,strong)NSString* custphone;
//@property (nonatomic,strong)NSString* receiveraddr;
//@property (nonatomic,strong)NSString* orderstatus;
//@property (nonatomic,strong)NSString* ordercount;
//@property (nonatomic,strong)NSString* ordermoney;
//@property (nonatomic,strong)NSString* paytype;
//@property (nonatomic,strong)NSString* custaccountid;
//@property (nonatomic,strong)NSString* custaccount;
//@property (nonatomic,strong)NSString* regionid;
//@property (nonatomic,strong)NSString* regionname;

/*
 *id
 orderno
 custid
 custname
 createtime
 custphone
 receiveraddr
 orderstatus
 ordercount
 ordermoney
 custaccountid
 custaccount
 regionid
 regionname
 */

@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaprofit;
@property (nonatomic,strong)NSString* centerprofit;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* custphone;
@property (nonatomic,strong)NSString* distributeid;
@property (nonatomic,strong)NSString* distributeprofit;
@property (nonatomic,strong)NSString* Id;               //订单列表的id
@property (nonatomic,strong)NSString* isbudget;         //是否预结算
@property (nonatomic,strong)NSString* isvalid;          //订单是否关闭
@property (nonatomic,strong)NSString* ordercount;       //订单数量
@property (nonatomic,strong)NSString* ordermoney;       //订单金额
@property (nonatomic,strong)NSString* orderno;          //订单编号
@property (nonatomic,strong)NSString* orderstatus;      //订单状态
@property (nonatomic,strong)NSString* partprofit;
@property (nonatomic,strong)NSString* platprofit;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* receiveraddr;
@property (nonatomic,strong)NSString* regionprofit;
@property (nonatomic,strong)NSString* senderprofit;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* pickupway;
@property (nonatomic,strong)NSString* isgolds;
@property (nonatomic,strong)NSString* online1;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSArray* prolist;


//订单详情中多返回的字段
@property (nonatomic,strong)NSString* prono;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* money;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* saleprice;
@property (nonatomic,strong)NSString* prostatus;
@property (nonatomic,strong)NSString* sendtime;
@property (nonatomic,strong)NSString* warntime;

//退货单中多填数据
@property (nonatomic,strong)NSString* specification;
@property (nonatomic,strong)NSString* prounitname;
@property (nonatomic,strong)NSString* prounitid;

@property (nonatomic,strong)NSString* sendstatus;
@property (nonatomic,strong)NSString* paymethod;
@property (nonatomic,strong)NSString* endsendtime;
@property (nonatomic,strong)NSString* beginsendtime;


//超时预警中添加
@property (nonatomic,strong)NSString* sendername;
@property (nonatomic,strong)NSString* distributename;

/*
 {"areaid":1,"areaprofit":5.04,"centerprofit":8.4,"cityid":1,"createtime":1475914650000,"custid":63,"custname":"三","custphone":"18310640957","distributeid":22,"distributeprofit":3.36,"id":53,"isbudget":0,"isvalid":1,"ordercount":2,"ordermoney":24,"orderno":"dd201610080006","orderstatus":0,"partprofit":3.36,"platprofit":8.4,"provinceid":1,"receiveraddr":"北京市北京市东城区11二成小区默认地址","regionprofit":6.72,"senderprofit":5.04,"serviceid":18,"villageid":13
 */


@end
