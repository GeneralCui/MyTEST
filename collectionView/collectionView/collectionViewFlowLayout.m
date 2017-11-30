//
//  collectionViewFlowLayout.m
//  collectionView
//
//  Created by tzh on 2017/11/28.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import "collectionViewFlowLayout.h"
#import "collectionView.h"


@implementation collectionViewFlowLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self configureObserver];
//        [self prepareLayout];
    }
    return self;
}

#pragma mark - 添加观察者

- (void)configureObserver
{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark - 处于编辑状态

- (void)setInEditState:(BOOL)inEditState
{
    if (_inEditState != inEditState) {
        //通过代理方法改变处于编辑状态的cell
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeEditState:)]) {
            [_delegate didChangeEditState:inEditState];
        }
    }
    _inEditState = inEditState;
}





@end
