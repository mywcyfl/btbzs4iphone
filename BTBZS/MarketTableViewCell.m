//
//  MarketTableViewCell.m
//  BTBZS
//
//  Created by wcyfl on 15/11/16.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketTableViewCell.h"

@interface MarketTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel*    marketNameLabel;
@property (strong, nonatomic) IBOutlet UILabel*    currencyLabel;
@property (strong, nonatomic) IBOutlet UILabel*    currentPriceCNYLabel;
@property (strong, nonatomic) IBOutlet UILabel*    currenPriceUSDLabel;
@property (strong, nonatomic) IBOutlet UIImageView*trendImg;
@property (strong, nonatomic) IBOutlet UILabel*    volumeLabel;
@property (strong, nonatomic) IBOutlet UILabel*    rateLabel;
@property (strong, nonatomic) IBOutlet UILabel*    buyFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel*    sellFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel*    hightestPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel*    lowestPriceLabel;
@end

@implementation MarketTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        /*
//         * 第一行
//         */
//        // 币种
//        CGRect rect = CGRectMake(120, ROW_ONE_Y, 50, 20);
//        _currencyLabel = [[UILabel alloc] initWithFrame:rect];
//        _currencyLabel.textAlignment = NSTextAlignmentLeft;
//        _currencyLabel.font = CURRENCY_FONT;
//        [_currencyLabel setNumberOfLines:0];
//        [self.contentView addSubview:_currencyLabel];
//        [self setCurrency:@"RMB"];
//        
//        // 市场名
//        rect = CGRectMake(TO_LEFT, ROW_ONE_Y, 100, 20);
//        _marketNameLabel = [[UILabel alloc] initWithFrame:rect];
//        _marketNameLabel.textAlignment = NSTextAlignmentLeft;
//        _marketNameLabel.font = MARKET_NAME_FONT;
//        [_marketNameLabel setNumberOfLines:0];
//        [self.contentView addSubview:_marketNameLabel];
//        [self setMarketName:@"交易市场"];
//        
//        // 人民币价格
//        rect = CGRectMake(240, ROW_ONE_Y, 100, 20);
//        _currentPriceCNYLabel = [[UILabel alloc] initWithFrame:rect];
//        _currentPriceCNYLabel.textAlignment = NSTextAlignmentLeft;
//        _currentPriceCNYLabel.font = RMB_PRICE_FONT;
//        [_currentPriceCNYLabel setNumberOfLines:0];
//        [self.contentView addSubview:_currentPriceCNYLabel];
//        [self setCurPriceRMB:@(0.00)];
//        
//        /*
//         * 第二行
//         */
//        // 成交量
//        rect = CGRectMake(TO_LEFT, ROW_TWO_Y, 100, 20);
//        _volumeLabel = [[UILabel alloc] initWithFrame:rect];
//        _volumeLabel.textAlignment = NSTextAlignmentLeft;
//        _volumeLabel.font = VOLUME_FONT;
//        [_volumeLabel setNumberOfLines:0];
//        [self.contentView addSubview:_volumeLabel];
//        [self setVolume:@(0)];
//        
//        // 外币价格
//        rect = CGRectMake(TO_LEFT, ROW_TWO_Y, 100, 20);
//        _volumeLabel = [[UILabel alloc] initWithFrame:rect];
//        _volumeLabel.textAlignment = NSTextAlignmentLeft;
//        _volumeLabel.font = VOLUME_FONT;
//        [_volumeLabel setNumberOfLines:0];
//        [self.contentView addSubview:_volumeLabel];
//        [self setVolume:@(0)];
//    }
//    
//    return self;
//}

+ (NSString*)reusedIdentifier {
    return @"MarketTableViewCell";
}

+ (NSUInteger)rowHeight {
    return 82;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMarketName:(NSString *)marketName {
    if (![_marketName isEqualToString:marketName]) {
        _marketName = [marketName copy];
        _marketNameLabel.text = _marketName;
        
        CGSize newSize = [_marketName boundingRectWithSize:CGSizeMake(1000, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:_marketNameLabel.font}
                                                   context:nil].size;
        CGRect oldFrame = _marketNameLabel.frame;
        CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, newSize.width, newSize.height);
        _marketNameLabel.frame = newFrame;
        
        // marketNameLabel长度变化后，需要重新布局
        [self resoveLayout];
    }
}

- (void)setCurrency:(NSString *)currency {
    if (![_currency isEqualToString:currency]) {
        _currency = [currency copy];
        _currencyLabel.text = _currency;
        
        CGSize newSize = [_currency boundingRectWithSize:CGSizeMake(1000, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:_currencyLabel.font}
                                                   context:nil].size;
        CGRect oldFrame = _currencyLabel.frame;
        CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, newSize.width, newSize.height);
        _currencyLabel.frame = newFrame;
    }
}

- (void)setCurPriceRMB:(NSNumber *)curPriceRMB {
    if (![_curPriceRMB isEqualToNumber:curPriceRMB]) {
        _curPriceRMB = curPriceRMB;
        _currentPriceCNYLabel.text = [NSString stringWithFormat:@"￥%@", [_curPriceRMB stringValue]];
    }
}

- (void)setCurPriceUSD:(NSNumber *)curPriceUSD {
    if (![_curPriceUSD isEqualToNumber:curPriceUSD]) {
        _curPriceUSD = curPriceUSD;
        
        _currenPriceUSDLabel.text = [NSString stringWithFormat:@"$%@", [_curPriceUSD stringValue]];
    }
}

- (void)setVolume:(NSNumber*)volume {
    if (_volume != volume) {
        _volume = volume;
        _volumeLabel.text = [NSString stringWithFormat:@"成交量 %@", [_volume stringValue]];
    }
}

- (void)setBuyFirstPrice:(NSNumber *)buyFirstPrice {
    if (![_buyFirstPrice isEqualToNumber:buyFirstPrice]) {
        _buyFirstPrice = buyFirstPrice;
        
        _buyFirstLabel.text = [_buyFirstPrice stringValue];
    }
}

- (void)setSellFirstPrice:(NSNumber *)sellFirstPrice {
    if (![_sellFirstPrice isEqualToNumber:sellFirstPrice]) {
        _sellFirstPrice = sellFirstPrice;
        
        _sellFirstLabel.text = [_sellFirstPrice stringValue];
    }
}

- (void)setHighestPrice:(NSNumber *)highestPrice {
    if (![_highestPrice isEqualToNumber:highestPrice]) {
        _highestPrice = highestPrice;
        
        _hightestPriceLabel.text = [_highestPrice stringValue];
    }
}

- (void)setLowestPrice:(NSNumber *)lowestPrice {
    if (![_lowestPrice isEqualToNumber:lowestPrice]) {
        _lowestPrice = lowestPrice;
        
        _lowestPriceLabel.text = [_lowestPrice stringValue];
    }
}

- (void)setRate:(NSNumber *)rate {
    if (![_rate isEqualToNumber:rate]) {
        _rate = rate;
        
        _rateLabel.text = [_rate stringValue];
    }
}

- (void)setTrend:(NSInteger)trend {
    if (_trend != trend) {
        _trend = trend;
        
        
    }
}

/*
 * 重新适应布局，当一些影响布局的因素发生后调用
 */
- (void)resoveLayout {
    // currencyLabel必须在marketNameLabel 的右边10像素
    CGRect marketNameFrame = _marketNameLabel.frame;
    
    CGRect currencyFrame = _currencyLabel.frame;
    _currencyLabel.frame = CGRectMake(marketNameFrame.origin.x + marketNameFrame.size.width + 5,
                                      marketNameFrame.origin.y + marketNameFrame.size.height - currencyFrame.size.height,
                                      currencyFrame.size.width,
                                      currencyFrame.size.height);
}

@end
