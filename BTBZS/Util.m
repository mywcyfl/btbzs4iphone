//
//  Util.m
//  BTBZS
//
//  Created by wcyfl on 15/11/23.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "Util.h"

@interface Util ()
@property (assign, nonatomic) CGSize    designSize;
@property (assign, nonatomic) CGSize    actualSize;
@property (assign, nonatomic) CGFloat   scaleX;
@property (assign, nonatomic) CGFloat   scaleY;
@end

@implementation Util

+(instancetype)sharedInstance {
    static Util* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[Util alloc] init];
        instance.designSize = CGSizeMake(360, 568);
        instance.actualSize = CGSizeMake(360, 568);
        instance.scaleX = instance.actualSize.width / instance.designSize.width;
        instance.scaleY = instance.actualSize.height / instance.designSize.height;
    });
    
    return instance;
}

+ (CGSize) appDesignSize {
    return [Util sharedInstance].designSize;
}

+ (CGFloat) scaleRatioX {
    return [Util sharedInstance].scaleX;
}
+ (CGFloat) scaleRatioY {
    return [Util sharedInstance].scaleY;
}

@end
