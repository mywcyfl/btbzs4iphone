//
//  BTChinaMarketAdaptor.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "BTCChinaMarketAdaptor.h"

@implementation BTCChinaMarketAdaptor

/*
 * Override
 */
+ (MarketEnum)MarketIdentify {
    return kBTCCMarket;
}

/*
 * Override
 */
+ (NSString*)marketName {
    return @"BTCC(比特币中国)";
}

/*
 * Override
 */
+ (NSString*)marketMainPageUri {
    return @"https://www.btcc.com/";
}

@end
