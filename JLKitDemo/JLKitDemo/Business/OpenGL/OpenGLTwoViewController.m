//
//  OpenGLTwoViewController.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/23.
//

#import "OpenGLTwoViewController.h"

//顶点数据
typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

//矩形的六个顶点 以三角形为单元 所以是六个点
//static const SceneVertex vertices[] = {
//    {{1, -0.8, 0.0f,},{1.0f,0.0f}}, //右下
//    {{1, 0.8,  0.0f},{1.0f,1.0f}}, //右上
//    {{-1, 0.8, 0.0f},{0.0f,1.0f}}, //左上
//
//    {{1, -0.8, 0.0f},{1.0f,0.0f}}, //右下
//    {{-1, 0.8, 0.0f},{0.0f,1.0f}}, //左上
//    {{-1, -0.8, 0.0f},{0.0f,0.0f}}, //左下
//};
static SceneVertex vertices[] = {
    {{1, -0.6, 0.0f,},{0.75f,0.25f}}, //右下
    {{1, 0.6,  0.0f},{0.75f,0.75f}}, //右上
    {{-1, 0.6, 0.0f},{0.25f,0.75f}}, //左上
    
    {{1, -0.6, 0.0f},{0.75f,0.25f}}, //右下
    {{-1, -0.6, 0.0f},{0.25f,0.25f}}, //左下
    {{-1, 0.6, 0.0f},{0.25f,0.75f}}, //左上
};
@interface OpenGLTwoViewController (){
    GLuint vertextBufferID;
}

@property (nonatomic,strong)GLKBaseEffect *baseEffect;
@property (nonatomic, assign) CGFloat texValue;

@end

@implementation OpenGLTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //新建OpenGLES 上下文
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc]initWithAPI: kEAGLRenderingAPIOpenGLES2];
    //设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    //填充VertexArray
    [self fillTexture];
    
    //填充纹理
    [self fillVertexArray];
    _texValue = 0.75f;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 40, 300, 100)];
    slider.value = _texValue;
    
    [slider addTarget:self action:@selector(texValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.preferredFramesPerSecond = 60;
}

- (void)texValueChange:(UISlider *)sender
{
    _texValue = sender.value;
}

- (void)fillVertexArray{
    glGenBuffers(1, &vertextBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID); //绑定指定标识符的缓存为当前缓存
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); //顶点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoords));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));
    
}


- (void)fillTexture{
    //获取图片
    CGImageRef imageRef = [[UIImage imageNamed:@"d.png"] CGImage];
    
    //通过图片数据产生纹理缓存
    //GLKTextureInfo封装了纹理缓存的信息，包括是否包含MIP贴图
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:options error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)update
{
    for (int i = 0; i < sizeof(vertices)/sizeof(SceneVertex); i++) {
        int index = i % 3;
//        NSLog(@"%d %d %d", i,index,sizeof(vertices)/sizeof(SceneVertex));
        if (index == 0) {
            vertices[i].textureCoords.x = _texValue;
            vertices[i].textureCoords.y = 1 - _texValue;
        } else if (index == 2) {
            vertices[i].textureCoords.x = 1 - _texValue;
            vertices[i].textureCoords.y = _texValue;
        } else { //index == 1
            if (i == 1) {
                vertices[i].textureCoords.x = _texValue;
                vertices[i].textureCoords.y = _texValue;
            } else {
                vertices[i].textureCoords.x = 1 - _texValue;
                vertices[i].textureCoords.y = 1 - _texValue;
            }
            
        }
    }
    
//    vertices[0].textureCoords.x = _texValue;
//    vertices[0].textureCoords.y = 1 - _texValue;
//
//    vertices[1].textureCoords.x = _texValue;
//    vertices[1].textureCoords.y = _texValue;
//
//    vertices[2].textureCoords.x = 1 - _texValue;
//    vertices[2].textureCoords.y = _texValue;
//
//    vertices[3].textureCoords.x = _texValue;
//    vertices[3].textureCoords.y = 1 - _texValue;
//
//    vertices[4].textureCoords.x = 1 - _texValue;
//    vertices[4].textureCoords.y = 1 - _texValue;
//
//    vertices[5].textureCoords.x = 1 - _texValue;
//    vertices[5].textureCoords.y = _texValue;
    
    //刷新vertexBuffer
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    //清除背景色
    glClearColor(0.0f,0.0f,0.0f,1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SceneVertex));
}


- (void)dealloc{
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
