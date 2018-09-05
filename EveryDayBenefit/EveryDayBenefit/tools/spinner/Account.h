//
//  Account.h
//  TableListDemo
//
//  Created by albeeert on 10/8/16.
//  Copyright © 2016 albeeert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

/**
 *  账号
 */
@property (nonatomic, copy) NSString *account;

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

@end
