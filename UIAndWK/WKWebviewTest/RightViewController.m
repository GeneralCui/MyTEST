//
//  RightViewController.m
//  WKWebviewTest
//
//  Created by tzh on 2017/11/17.
//  Copyright © 2017年 mirroon. All rights reserved.
//

#import "RightViewController.h"
#import <WebKit/WebKit.h>

@interface RightViewController ()<UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, strong) UIProgressView *progressView; // 进度条
@property (nonatomic) NSString *currentURL; // URL

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
	[self setCurrentURL:@"http://www.google.com"];

	// webView
	self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
	self.webView.allowsBackForwardNavigationGestures = YES;
	self.webView.navigationDelegate = self;
	[self.view addSubview:self.webView];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.getCurrentURL]]];
	
	// textfield
	self.textField = [[UITextField alloc]initWithFrame:CGRectMake(8, 65, self.view.bounds.size.width - 16, 30)];
	self.textField.keyboardType = UIKeyboardTypeWebSearch;
	self.textField.borderStyle = UITextBorderStyleRoundedRect;
	self.textField.text = [NSString stringWithString:self.currentURL];
	self.textField.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
	// 关闭首字母大写
	self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.textField.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:0.5];
	self.textField.font = [UIFont fontWithName:@"Arial" size:20.0f];
	self.textField.textColor = [UIColor blackColor];
	self.textField.clearButtonMode = UITextFieldViewModeAlways;
	self.textField.delegate = self;
	
	[self.view addSubview:self.textField];
	
	self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 640, 100, 40)];
	[self.view addSubview:self.backButton];
	[self.backButton setTitle:@"上一页" forState:UIControlStateNormal];
	[self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	self.backButton.backgroundColor = [UIColor blueColor];
	
	[self.backButton addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
	
	self.forwardButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 640, 100, 40)];
	[self.view addSubview:self.forwardButton];
	self.forwardButton.backgroundColor = [UIColor blueColor];
	[self.forwardButton setTitle:@"下一页" forState:UIControlStateNormal];
	[self.forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
	[self.forwardButton addTarget:self action:@selector(clickToForward) forControlEvents:UIControlEventTouchUpInside];
	
	self.clearButton = [[UIButton alloc]initWithFrame:CGRectMake(300, 640, 100, 40)];
	[self.view addSubview:self.clearButton];
	self.clearButton.backgroundColor = [UIColor blueColor];
	[self.clearButton setTitle:@"清空缓存" forState:UIControlStateNormal];
	[self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
	[self.clearButton addTarget:self action:@selector(clickToCleanCache) forControlEvents:UIControlEventTouchUpInside];
	
	self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(8, 90, [[UIScreen mainScreen] bounds].size.width - 16, 2)];
	self.progressView.backgroundColor = [UIColor blueColor];
	self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	[self.view addSubview:self.progressView];
	
	[self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)clickToBack{
	[self.webView goBack];
	NSLog(@"点击上一页");
}

-(void)clickToForward{
	[self.webView goForward];
	NSLog(@"点击下一页");
}

-(void)clickToCleanCache{
	
	NSLog(@"点击清除");
}

#pragma mark - 监听 kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"estimatedProgress"]) {
		self.progressView.progress = self.webView.estimatedProgress;
		if (self.progressView.progress == 1) {
			__weak typeof (self)weakSelf = self;
			[UIView animateWithDuration:0.2f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
				weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
			} completion:^(BOOL finished) {
				weakSelf.progressView.hidden = YES;
			}];
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	self.textField.text = [NSString stringWithFormat:@"%@", webView.URL.absoluteString];
	
	self.progressView.hidden = NO;
	[self.view bringSubviewToFront:self.progressView];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	
	// 页面开始返回时
	NSLog(@"didCommitNavigation");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	// 页面加载完成后
	NSLog(@"didFinishNavigation");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSLog(@"url = %@", navigationAction.request.URL.absoluteString);
//    NSDictionary *requestHeaders = navigationAction.request.allHTTPHeaderFields;
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSURL *url = [[NSURL alloc] initWithString:self.textField.text];
	if (![url.absoluteString hasPrefix:@"http"] && ![url.absoluteString hasPrefix:@"https"] ) {
		NSString *newURL = [@"http://" stringByAppendingString:url.absoluteString];
		url = [NSURL URLWithString:[newURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[self.webView loadRequest:request];
	
	return YES;
}

- (void)setCurrentURL:(NSString *)currentURL {
	self.textField.text = currentURL;
	_currentURL = currentURL;
}

- (NSString*)getCurrentURL {
	return _currentURL;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
