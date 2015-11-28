//
//  OKCoinMarkAdaptor.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "OKCoinMarketAdaptor.h"

static NSString* url = @"https://www.okcoin.cn/";

@implementation OKCoinMarketAdaptor

/*
 * Override
 */
+ (MarketAdaptorEnum)MarketIdentify {
    return kOKCoinMarketAdaptor;
}

/*
 * Override
 */
- (NSString*)marketName {
    return @"OKCoin";
}

/*
 * Override
 */
- (NSString*)marketMainPageUri {
    return url;
}

/*
 * Override
 */
- (void)queryTradeInfo:(VitualCoinEnum)coinType {
    NSLog(@"Now send request to '%@' to query new tradeInfo", url);
}

@end
