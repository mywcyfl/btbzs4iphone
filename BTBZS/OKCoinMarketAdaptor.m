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
- (void)queryTradeInfo:(VitualCoinEnum)coinType saveOn:(TradeInfo*)tradeInfo withCallback:(StandardCallback)cb {
    NSLog(@"Now send request to '%@' to query new tradeInfo", url);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CALL_STANDARD_CB(cb, nil, nil);
    });
}

@end
