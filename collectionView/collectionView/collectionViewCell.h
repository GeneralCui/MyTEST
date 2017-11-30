//
//  collectionViewCell.h
//  collectionView
//
//  Created by tzh on 2017/11/28.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface collectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *botlabel;

@property (nonatomic, assign) BOOL inEditState; //是否处于编辑状态

@end
