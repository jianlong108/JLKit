//
//  UIWebViewController.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBaseViewController.h"

@interface UIWebViewController : JLBaseViewController

@property(nonatomic,readonly) UIWebView *webView;

- (instancetype)initWithURL:(NSURL *)url;

@end
