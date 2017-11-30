//
//  wkwebViewController.m
//  collectionView
//
//  Created by tzh on 2017/11/29.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import "wkwebViewController.h"
#import <WebKit/WebKit.h>

@interface wkwebViewController ()<UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UITextField *addressBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic) NSString *currentURL;

@property (nonatomic, strong) NSURLRequest *tmpRequest;
@property (nonatomic, assign) BOOL isStaff;

@property (nonatomic, strong) UIButton *cellButton;
@end

@implementation wkwebViewController

- (void)setCurrentURL:(NSString *)currentURL {
    self.addressBar.text = currentURL;
    _currentURL = currentURL;
}
- (NSString*)getCurrentURL {
    return _currentURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    NSLog(@"webview base loaded.");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isStaff = NO;
    [self setCurrentURL:@"http://www.google.com"];
    
    // wkWebView
    self.wkWebView = [[WKWebView alloc] init];
    self.wkWebView.frame = CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height - 66);
    self.wkWebView.allowsBackForwardNavigationGestures = YES;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentURL]]];
    [self.view addSubview:self.wkWebView];
    [self.wkWebView reload];
    // addressBar
    self.addressBar = [[UITextField alloc]init];
    self.addressBar.frame = CGRectMake(8 + 32 + 8 + 32 + 8, 32, self.view.frame.size.width - (8 + 32 + 8 + 32 + 8) - 8, 32);
    self.addressBar.keyboardType = UIKeyboardTypeWebSearch;
    self.addressBar.borderStyle = UITextBorderStyleRoundedRect;
    self.addressBar.text = [NSString stringWithString:self.currentURL];
    self.addressBar.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.6];
    self.addressBar.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    self.addressBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.addressBar.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.addressBar.textColor = [UIColor blackColor];
    self.addressBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressBar.delegate = self;
    [self.view addSubview:self.addressBar];
    
    [self loadRequest];
    
    // Buttons
    self.backButton = [[UIButton alloc]init];
    self.backButton.frame = CGRectMake(8, 32, 32, 32);
    self.backButton.alpha = 0.3;
    [self.view addSubview:self.backButton];
    [self.backButton setTitle:@"←" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.forwardButton = [[UIButton alloc]init];
     self.forwardButton.frame = CGRectMake(8 + 32 + 8, 32, 32, 32);
    self.forwardButton.alpha = 0.3;
    [self.view addSubview:self.forwardButton];
    [self.forwardButton setTitle:@"→" forState:UIControlStateNormal];
    [self.forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(clickToForward) forControlEvents:UIControlEventTouchUpInside];
    
    self.clearButton = [[UIButton alloc]init];
    self.clearButton.frame = CGRectMake(self.view.frame.size.width - (48 + 8), self.view.frame.size.height - (48 + 8), 48, 48);
    self.clearButton.layer.cornerRadius = 24;
    self.clearButton.layer.masksToBounds = YES;
    self.clearButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self.view addSubview:self.clearButton];
    [self.clearButton setTitle:@"x" forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clickToCleanCache) forControlEvents:UIControlEventTouchUpInside];
    
    self.cellButton = [[UIButton alloc]initWithFrame:CGRectMake(8, self.view.frame.size.height - (48 + 8), 48, 48)];
    self.cellButton.layer.cornerRadius = 24;
    self.cellButton.layer.masksToBounds = YES;
    self.cellButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self.view addSubview:self.cellButton];
    [self.cellButton setTitle:@"<<" forState:UIControlStateNormal];
    [self.cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cellButton addTarget:self action:@selector(clickToCell) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickToCell{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)loadRequest {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [[NSURL alloc] initWithString:self.addressBar.text];
    if (![url.absoluteString hasPrefix:@"http"] && ![url.absoluteString hasPrefix:@"https"] ) {
        NSString *newURL = [@"http://" stringByAppendingString:url.absoluteString];
        url = [NSURL URLWithString:[newURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.wkWebView loadRequest:request];
}

// ------------------ イベント -------------------
-(void)clickToBack{
    
    [self.wkWebView goBack];
}

-(void)clickToForward{
    
    [self.wkWebView goForward];
}

-(void)clickToCleanCache{
    // for UIWebView
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // fow WKWebView
    //    NSSet *websiteDataTypes = [NSSet setWithArray:@[
    //                            WKWebsiteDataTypeDiskCache,
    //                            WKWebsiteDataTypeOfflineWebApplicationCache,
    //                            WKWebsiteDataTypeMemoryCache,
    //                            WKWebsiteDataTypeLocalStorage,
    //                            WKWebsiteDataTypeCookies,
    //                            WKWebsiteDataTypeSessionStorage,
    //                            WKWebsiteDataTypeIndexedDBDatabases,
    //                            WKWebsiteDataTypeWebSQLDatabases
    //                            ]];
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // do nothing
    }];
    NSLog(@"cache cleaned.");
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)addressBar {
    if ([addressBar.text isEqualToString:@""]) {
        addressBar.text = self.currentURL;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)addressBar {
    // make address textField blur
    [self loadRequest];
    [addressBar endEditing:YES];
    return YES;
}

- (void)showPasswordPrompt:(void (^)(WKNavigationActionPolicy))decisionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作禁止" message:@"端末をスタッフに返してください。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        //textField.placeholder = defaultText;
        textField.text = @"";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        if ([input isEqualToString:@"1234"]) {
            self.isStaff = YES;
            // UIWebView
            
            decisionHandler(WKNavigationActionPolicyAllow);
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"認証失敗";
            alert.message = @"入力したパスワードは正しくありません。";
            [alert addButtonWithTitle:@"確認"];
            [alert show];
            if (decisionHandler != nil) {
                decisionHandler(WKNavigationActionPolicyCancel);
            }
        }
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

// ------------------ UIWebView -------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString rangeOfString:@"/save"].location != NSNotFound && self.isStaff == NO){
        self.tmpRequest = request;
        [self showPasswordPrompt:nil];
        return NO;
    } else {
        self.isStaff = NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.currentURL = webView.request.URL.absoluteString;
    if (self.wkWebView.canGoBack == YES) {
        self.backButton.enabled = YES;
        self.backButton.alpha = 1;
    } else {
        self.backButton.enabled = NO;
        self.backButton.alpha = 0.3;
    }
    if (self.wkWebView.canGoForward == YES) {
        self.forwardButton.enabled = YES;
        self.forwardButton.alpha = 1;
    } else {
        self.forwardButton.enabled = NO;
        self.forwardButton.alpha = 0.3;
    }
}

// ------------------ WKWebView -------------------
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.currentURL = webView.URL.absoluteString;
    if (self.wkWebView.canGoBack == YES) {
        self.backButton.enabled = YES;
        self.backButton.alpha = 1;
    } else {
        self.backButton.enabled = NO;
        self.backButton.alpha = 0.3;
    }
    if (self.wkWebView.canGoForward == YES) {
        self.forwardButton.enabled = YES;
        self.forwardButton.alpha = 1;
    } else {
        self.forwardButton.enabled = NO;
        self.forwardButton.alpha = 0.3;
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"/save"].location != NSNotFound && self.isStaff == NO){
        [self showPasswordPrompt: decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
        self.isStaff = NO;
    }
}

@end

