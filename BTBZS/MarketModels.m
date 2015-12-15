//
//  MarketModels.m
//  BTBZS
//
//  Created by wcyfl on 15/11/28.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketModels.h"

@implementation TradeInfo

+(instancetype)fromNetJson:(NSDictionary*) netTradeInfo {
    if (![netTradeInfo isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    TradeInfo* info = [[TradeInfo alloc] init];
    
    info.name       = [netTradeInfo objectForKey:@"key"];
    info.highest    = [self fixFloat:netTradeInfo key:@"high"];
    info.lowest     = [self fixFloat:netTradeInfo key:@"low"];
    info.firstBuy   = [self fixFloat:netTradeInfo key:@"buy"];
    info.firstSell  = [self fixFloat:netTradeInfo key:@"sell"];
    info.lastPrice  = [self fixFloat:netTradeInfo key:@"last"];
    info.volume     = [self fixFloat:netTradeInfo key:@"vol"];
    info.updateTime = [self fixLong:netTradeInfo key:@"stamp"];
    
    return info;
}

+(NSNumber*)fixFloat:(NSDictionary*)dic key:(NSString*)key {
    NSNumber* ret = nil;
    if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
        ret = [NSNumber numberWithFloat:[[dic objectForKey:key] floatValue]];
    } else {
        ret = [dic objectForKey:key];
    }
    
    return ret;
}

+(NSNumber*)fixLong:(NSDictionary*)dic key:(NSString*)key {
    NSNumber* ret = nil;
    if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
        ret = [NSNumber numberWithLongLong:[[dic objectForKey:key] longLongValue]];
    } else {
        ret = [dic objectForKey:key];
    }
    
    return ret;
}

@end