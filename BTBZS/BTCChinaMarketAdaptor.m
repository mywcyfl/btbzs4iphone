//
//  BTChinaMarketAdaptor.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "BTCChinaMarketAdaptor.h"

static NSString* url = @"https://www.btcc.com/";

@implementation BTCChinaMarketAdaptor

/*
 * Override
 */
+ (MarketAdaptorEnum)MarketIdentify {
    return kBTCCMarketAdaptor;
}

/*
 * Override
 */
- (NSString*)marketName {
    return @"BTCC(比特币中国)";
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
