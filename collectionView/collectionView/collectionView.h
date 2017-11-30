//
//  collectionView.h
//  collectionView
//
//  Created by tzh on 2017/11/29.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "collectionViewFlowLayout.h"
#import "collectionViewCell.h"

@class collectionView;
@protocol collectionViewDataSource<UICollectionViewDataSource>

///Called when additional data
-(void)willAppendItemInCollectionView:(collectionView *)collectionView;
@end

@protocol collectionViewDelegate <UICollectionViewDelegate>
@optional
///Return to the original state when the callback
-(void)didDismissFromHightlightOnCollectionView:(collectionView*)collectionView;
@end

@interface collectionView : UICollectionView

@property (nonatomic, strong) collectionViewFlowLayout *layout;

///top offscreen margin
@property (nonatomic,assign) CGFloat topOffScreenMargin;
///duration from normal to highlight state,default is 0.5 second
@property (nonatomic,assign) CGFloat highLightAnimationDuration;
///duration from highlight to nomral state, default is 0.5 second
@property (nonatomic,assign) CGFloat dismisalAnimationDuration;

@property (nonatomic, assign) BOOL inEditState; //是否处于编辑状态

///Additional content
-(void)appendItem;


@end
