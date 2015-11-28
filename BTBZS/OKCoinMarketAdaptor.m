//
//  OKCoinMarkAdaptor.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "OKCoinMarketAdaptor.h"

@implementation OKCoinMarketAdaptor

/*
 * Override
 */
+ (MarketEnum)MarketIdentify {
    return kOKCoinMarket;
}

/*
 * Override
 */
+ (NSString*)marketName {
    return @"OKCoin";
}

/*
 * Override
 */
+ (NSString*)marketMainPageUri {
    return @"https://www.okcoin.cn/";
}

@end
