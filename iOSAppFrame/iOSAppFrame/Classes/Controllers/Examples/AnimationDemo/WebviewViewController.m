//
//  WebviewViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/9/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "WebviewViewController.h"
#import "WebviewProgressLine.h"
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>

@interface WebviewViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate> {
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic,strong) UIWebView *webview;
@property (nonatomic,strong) WebviewProgressLine *progressLine;
@end

@implementation WebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    //self.webview.delegate = self;
    [self.view addSubview:self.webview];
    
//    self.progressLine = [[WebviewProgressLine alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 3)];
//    self.progressLine.lineColor = [UIColor blueColor];
//    [self.view addSubview:self.progressLine];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self.progressLine startLoadingAnimation];
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self.progressLine endLoadingAnimation];
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [self.progressLine endLoadingAnimation];
//}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
