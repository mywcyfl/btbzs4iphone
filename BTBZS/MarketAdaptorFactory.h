//
//  MarketAdaptorFactory.h
//  BTBZS
//
//  Created by wcyfl on 15/11/15.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceProtocol.h"
#import "BaseAdaptorProtocol.h"

@interface MarketAdaptorFactory : NSObject<ServiceProtocol>

/*
 * 获得所有的Adaptor
 */
+(NSDictionary*)GetAllMarketAdaptor;

/*
 * 获得指定的Adaptor
 */
+(id<BaseAdaptorProtocol>)GetAdaptorById:(MarketEnum)marketId;

@end
