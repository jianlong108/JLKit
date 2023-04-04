//
//  OpenGLOneViewController.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/23.
//

#import "OpenGLOneViewController.h"

typedef struct{
    GLKVector3 positionCoords;
}sceneVertex;

//三角形的三个顶点
/*
    1(a)
    11
    111
    1111
 (c)11111(b)
 
static const sceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0}},//c
    {{0.5f,-0.5f,0.0}},//b
    {{-0.5f,0.5f,0.0}},//a
};
 */

static const sceneVertex vertices[] = {
   {{-1.f,0.5f,0.0}},//c
   {{0.0f,0.0f,0.0}},//b
   {{-1.f,0.0f,0.0}},//a
    
//渲染两个三角形
    {{1.f,-0.5f,0.0}},//c
    {{0.0f,-0.5f,0.0}},//b
    {{0.f,-1.f,0.0}},//a
};


@interface OpenGLOneViewController () {
    GLuint vertextBufferID;
}

//GLKBaseEffect 提供了不依赖于所使用的OpenGLES版本的控制渲染的方法
@property (nonatomic,strong)GLKBaseEffect *baseEffect;

@end

@implementation OpenGLOneViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view  = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[JLGLKView class]], @"ViewController's View is Not A JLGLKView");
    //创建OpenGL ES2.0上下文
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    // 绘制的颜色
    self.baseEffect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    
    //设置背景色
    glClearColor(1.0f,0.0f,0.0f,1.0f);
    

    //申请一个标识符
    glGenBuffers(1, &vertextBufferID);

    /* 绑定指定标识符的缓存为当前缓存
     2.0只支持GL_ARRAY_BUFFER和 GL_ELEMENT_ARRAY_BUFFER
     
     第一个参数:指定要绑定哪一种类型的缓存
     第二个参数:告诉要绑定的缓存的标识符
     */
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    /*复制顶点数据从CPU到GPU
     第一个参数:指定要更新当前上下文中所绑定的是哪一个缓存
     第二个参数:告诉复制进这个缓存的字节数量
     第三个参数:告诉复制进这个缓存的字节地址
     第四个参数 GL_STATIC_DRAW: 告诉上下文,缓存中的内容适合复制到GPU控制的内存,因为很少对其进行修改
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)glkView:(JLGLKView *)view drawInRect:(CGRect)rect
//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    //Clear Frame Buffer 设置当前绑定的 帧缓存 的像素颜色 渲染缓存 中的每一个像素的颜色为前面使用glclearColor()设置的值
    glClear(GL_COLOR_BUFFER_BIT);
    
    //enable 开启对应的顶点缓存属性:是位置属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //设置指针 从顶点数组中读取数据
    glVertexAttribPointer(GLKVertexAttribPosition,//指示当前绑定的缓存属于每个顶点的位置信息
                          3,//每个位置有三个部分
                          GL_FLOAT,//每个部分都保存为一个浮点类型的值
                          GL_FALSE, //小数点固定数据是否被改变
                          sizeof(sceneVertex),//步幅:指定了GPU从一个顶点的内存开始位置转到下一个顶点的内存开始位置需要跳过的字节数
                          NULL);  //从开始位置
    //绘图
    glDrawArrays(GL_TRIANGLES, //怎么处理在绑定的顶点缓存内的顶点数据
                 0, //渲染的第一个顶点的位置(索引)
                 sizeof(vertices)/sizeof(sceneVertex) //需要渲染顶点的数量
                 );
    
}

//释放掉缓存数据
- (void)dealloc
{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertextBufferID) {
        glDeleteBuffers(1,
                        &vertextBufferID);
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
}


@end
