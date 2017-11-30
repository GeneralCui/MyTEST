//
//  collectionViewCell.m
//  collectionView
//
//  Created by tzh on 2017/11/28.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import "collectionViewCell.h"
#import "collectionView.h"

@interface collectionViewCell ()

@end

@implementation collectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.botlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor blueColor];
        _botlabel.font = [UIFont systemFontOfSize:15];
        _botlabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_botlabel];

        _button = [[UIButton alloc] init];
        [_button setTitle:@"-" forState:UIControlStateNormal];
        _button.frame = CGRectMake(-5, -5, 18, 18);
        _button.layer.cornerRadius = 9;
        _button.backgroundColor = [UIColor redColor];
        self.button.hidden = YES;
        [self addSubview:_button];
        
    }
    
    return self;
}


#pragma mark - 是否处于编辑状态 (VC调用)

- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState){
        self.button.hidden = NO;
    } else {
        self.button.hidden = YES;
    }
}

@end
