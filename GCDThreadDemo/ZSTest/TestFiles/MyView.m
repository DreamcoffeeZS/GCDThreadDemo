//
//  MyView.m
//  ZSTest
//
//  Created by Bjmsp on 2018/3/16.
//  Copyright © 2018年 zhoushuai. All rights reserved.
//

#import "MyView.h"

@implementation MyView

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)dealloc{
    
}

#pragma mark - private Methods
- (void)addSubViews{
    
}

- (void)updateUI{
    
}


#pragma mark - Handle Data
//@property (nonatomic, strong) NSDictionary *dataDic;
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic !=  dataDic) {
        _dataDic = dataDic;
    }
    [self updateUI];

}





@end
