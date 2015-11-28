//
//  BaseAdaptorProtocol.h
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol BaseAdaptorProtocol <NSObject>

// 市场枚举值
@required
+ (MarketEnum)MarketIdentify;

// 市场名
@required
+ (NSString*)marketName;

// 市场主页地址
@required
+ (NSString*)marketMainPageUri;

@end
