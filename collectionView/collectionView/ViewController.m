//
//  ViewController.m
//  collectionView
//
//  Created by tzh on 2017/11/28.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import "ViewController.h"
#import "collectionView.h"
#import "collectionViewCell.h"
#import "collectionViewFlowLayout.h"
#import "wkwebViewController.h"


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIGestureRecognizerDelegate,collectionViewDataSource,collectionViewDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) collectionView *collectionView;
@property (nonatomic, strong) collectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, assign) BOOL inEditState; //是否处于编辑状态


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    for ( int i  = 0; i <= 5; i ++) {
        [self.dataArray addObject:[NSString stringWithFormat:@" %d",i]];
    }
  
     [self initCollectionView];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height-50.0f, self.view.frame.size.width, 50.0f)] ;
    toolBar.barStyle=UIBarStyleBlackTranslucent;
    toolBar.translucent=YES;
    toolBar.tintColor=[UIColor whiteColor];
    [self.view addSubview:toolBar];

    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAddButton:)];
    
    UIBarButtonItem *finishButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickFinishButton:)];

    toolBar.items=@[
                    addButtonItem,
                    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                    
                    finishButtonItem,];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
   
}

- (void)clickAddButton:(id)action {
    NSLog(@"add Button");
    [self.collectionView appendItem];

}
- (void)clickFinishButton:(id)action {
    NSLog(@"finish Button");
    for (collectionViewCell *cell in self.collectionView.visibleCells) {
        cell.button.hidden = YES;
    }
    
}


- (void)initCollectionView {

//    self.collectionView = [[collectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];

    CGFloat itemWidth = (self.view.frame.size.width - 50) / 3;
    self.flowLayout = [[collectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(itemWidth, itemWidth)];
    [self.flowLayout setMinimumInteritemSpacing:10];
    [self.flowLayout setMinimumLineSpacing:10];
    [self.flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 0, 10)];
    self.collectionView = [[collectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    
    // 注册collectionViewCell
    [self.collectionView registerClass:[collectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    // 代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
    UILongPressGestureRecognizer  *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    longPressGr.delegate = self;
    longPressGr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:longPressGr];
    
   
}

#pragma mark collectionView代理方法
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    collectionViewCell *cell = (collectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.botlabel.text = [NSString stringWithFormat:@"[%ld]",(long)indexPath.row];
    
    [cell.button addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor yellowColor];
   
//    cell.cellContentView = collectionView;
//
//    // webView
//    self.webView = [[WKWebView alloc] initWithFrame:cell.frame];
//    //        self.webView.navigationDelegate = self;
//    [cell.cellContentView addSubview:self.webView];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    
    
    return cell;
}


//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionViewCell *cell = (collectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.frame = self.view.bounds;
    NSString *msg = cell.botlabel.text;
    NSLog(@"%@",msg);
    
    wkwebViewController *wkVC = [[wkwebViewController alloc] init];
    [wkVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:wkVC animated:YES];
}

// 删除按钮;
- (void)btnClick:(UIButton *)sender event:(id)event
{
    NSLog(@"sssss");
    self.inEditState = YES;
    //获取点击button的位置
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:currentPoint];
    NSLog(@"%@",indexPath);
    if (indexPath != nil) { //点击移除
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.dataArray removeObjectAtIndex:indexPath.row]; //删除
            
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
    }
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        
        for (collectionViewCell *cell in self.collectionView.visibleCells) {
            cell.button.hidden = NO;
        }
    }
    
}

#pragma mark collectionViewDataSource
///追加数据
-(void)willAppendItemInCollectionView:(collectionView *)collectionView{
    [_dataArray addObject:@"new button"];
}
///删除数据
-(void)collectionView:(collectionView *)collectionView willRemoveCellAtIndexPath:(NSIndexPath *)indexPath{
    [_dataArray removeObjectAtIndex:indexPath.row];
}

#pragma mark - FlowLayoutDelegate

////处于编辑状态
//- (void)didChangeEditState:(BOOL)inEditState
//{
//    self.inEditState = inEditState;
//
//    for (collectionViewCell *cell in self.collectionView.visibleCells) {
//        cell.inEditState = inEditState;
//    }
//}

//改变数据源中model的位置
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath
{
//    SYLifeManagerModel *model = self.dataArray[formPath.row];
//    //先把移动的这个model移除
//    [self.dataArray removeObject:model];
//    //再把这个移动的model插入到相应的位置
//    [self.dataArray insertObject:model atIndex:toPath.row];
}

@end
