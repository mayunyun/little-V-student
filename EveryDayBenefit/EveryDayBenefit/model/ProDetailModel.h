//
//  ProDetailModel.h
//  lx
//
//  Created by 联祥 on 16/1/20.
//  Copyright © 2016年 lx. All rights reserved.
//

#import "BaseModel.h"

@interface ProDetailModel : BaseModel
@property(nonatomic,retain)NSString *folder;
@property(nonatomic,retain)NSString *Id;
@property(nonatomic,retain)NSString *picname;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *proid;
@property(nonatomic,strong)NSString *proname;
@property(nonatomic,strong)NSString *propicurl;
@property(nonatomic,strong)NSString *rn;
@property(nonatomic,strong)NSString *prosale;

@property(nonatomic,strong)NSString *specification;
@property(nonatomic,strong)NSString *prounitid;
@property(nonatomic,strong)NSString *prounitname;
@property(nonatomic,strong)NSString *pickupway;
@property(nonatomic,strong)NSString *prono;



//@property(nonatomic,strong)NSString* prohotsale;


/*
 folder = "tmp/";
 id = 41;
 picname = "14750386281683311.jpg";
 price = "0.01";
 proid = 41;
 proname = "\U85af\U7247";
 propicurl = "\U8fbe\U5229\U56ed";
 prosale = 3;
 rn = 1;
 */

@end
