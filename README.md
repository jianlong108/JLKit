# JLKit
## JLBothSidesBtn
两面均可点击,都可以设置自己的UI,注册自己的点击方法.支持系统自带的多种动画.

  - (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bothSidesView  =[[JLBothSidesBtn alloc]initWithFrame:CGRectMake(100, 100, 44, 44)];
    [self.view addSubview:_bothSidesView];
    _bothSidesView.autoTransition = NO;
    
    // Do any additional setup after loading the view.
    
    [_bothSidesView.positiveBtn addTarget:self action:@selector(dbtn1) forControlEvents:UIControlEventTouchUpInside];
    [_bothSidesView.oppositeBtn addTarget:self action:@selector(dbtn2) forControlEvents:UIControlEventTouchUpInside];
  }
  -(void)dbtn1{
    NSLog(@"positiveBtn");
    
  }
  -(void)dbtn2{
    NSLog(@"oppositeBtn");
  }
  
![image](https://github.com/jianlong108/JLKit/blob/master/JLKitDemo/JLKitDemo/ezgif.com-video-to-gif.gif)

