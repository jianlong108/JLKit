//
//  UIWebViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()

@property(nonatomic,strong) UIWebView *webView;

@property(nonatomic,strong) NSURL *url;

@end

@implementation UIWebViewController

- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
}


@end
