//
//  OpenGLTextureDynamicViewController.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/23.
//

#import "OpenGLTextureDynamicViewController.h"

@interface GLKEffectPropertyTexture (AGLKAdditions)
- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture(AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value{
    glBindTexture(self.target, self.name);
    glTexParameteri(self.target, parameterID, value);
}

@end

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoord;
}SceneVertex;

//顶点
static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

//默认顶点
static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};


//move结构体
static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

@interface OpenGLTextureDynamicViewController (){
    GLuint vertextBufferID;
}


@property (nonatomic,strong)GLKBaseEffect *baseEffect;



@property (nonatomic,assign)BOOL shouldUseLineFilter;
@property (nonatomic,assign)BOOL shouldAnimate;
@property (nonatomic,assign)BOOL shouldRepeatTexture;
@property (nonatomic,assign)GLfloat sCoordinateOffset;

@end

@implementation OpenGLTextureDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    self.shouldUseLineFilter = NO;
    
    UISwitch *animation = [[UISwitch alloc] initWithFrame:CGRectMake(0, 70, 100, 100)];
    animation.on = self.shouldAnimate;
    [animation addTarget:self action:@selector(takeShouldAnimateFrom:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:animation];
    
    UISwitch *repeat = [[UISwitch alloc] initWithFrame:CGRectMake(0, 110, 100, 100)];
    repeat.on = self.shouldRepeatTexture;
    [repeat addTarget:self action:@selector(takeShouldRepeatTextureFrom:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:repeat];
    
    
    UISwitch *useLinear = [[UISwitch alloc] initWithFrame:CGRectMake(0, 150, 100, 100)];
    useLinear.on = self.shouldUseLineFilter;
    [useLinear addTarget:self action:@selector(takeShouldUseLinearFilterFrom:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:useLinear];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 190, 300, 100)];
    slider.value = 0.5;
    [slider addTarget:self action:@selector(takeSCoordinateOffsetFrom:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.preferredFramesPerSecond = 60;
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's is not a GLKView");
    
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    //顶点缓存和纹理
    [self loadVertexBuffer];
    [self loadTexture];
}


- (void)loadVertexBuffer{
    glGenBuffers(1, &vertextBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    //GL_DYNAMIC_DRAW 动态渲染
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}


- (void)loadTexture{
    //绑定图片纹理
    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}


- (void)updateTextureParameters{
    
    glBindTexture(self.baseEffect.texture2d0.target, self.baseEffect.texture2d0.name);
    
    //配置每个绑定的纹理,以便使OpenGLES知道怎么处理可用纹素的数量与需要被着色的片元的数量之间的不匹配
    glTexParameterf(self.baseEffect.texture2d0.target, GL_TEXTURE_WRAP_S, (self.shouldRepeatTexture) ? GL_REPEAT : GL_CLAMP_TO_EDGE);
    
    /*
     GL_TEXTURE_MIN_FILTER:.
     GL_LINEAR 出现多个纹素对应一个片元时,从相配的多个纹素中取样颜色,然后使用线性内插法来混合这些颜色以得到片元的颜色,产生的片元颜色可能是一个纹理中挺不存在的颜色;
     GL_NEAREST 与片元的UV坐标最接近的纹素的颜色会被取样,取样模式会拾取其中的一个纹素或者另一个
     例如: 一个纹理是由交替的黑色和白色纹素组成的,线性取样会混合纹素的颜色,因此片元最终是灰色,而GL_NEAREST 最终的片元要么是白色的,要么是黑色的
     
     
     GL_TEXTURE_MAG_FILTER:
     用于在没有足够的可用纹素来唯一性地映射一个或者多个纹素到每个片元上时配置取样.
     GL_LINEAR 告诉OpenGLES混合附近纹素的颜色来计算片元的颜色,会有一个放大纹理的效果,并会让它模糊地出现在渲染的三角形上;
     GL_NEAREST 仅仅会拾取与片元的UV位置接近的纹素的颜色,并放大纹理,这会使它有点像素化地出现在渲染的三角形上
     */
    glTexParameterf(self.baseEffect.texture2d0.target, GL_TEXTURE_MAG_FILTER, (self.shouldUseLineFilter) ? GL_LINEAR : GL_NEAREST);
    
    
//    //Category设置和上面代码一致
//    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S value:(self.shouldRepeatTexture) ? GL_REPEAT : GL_CLAMP_TO_EDGE];
}

- (void)updateAnimateVertexPositions{
    if (_shouldAnimate) {
        
        int i;
        
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x > 1.0f ||
                vertices[i].positionCoords.x < -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f ||
               vertices[i].positionCoords.y <= -1.0f)
            {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f ||
               vertices[i].positionCoords.z <= -1.0f)
            {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
        
        
        
    }
    else{
        
        int i;
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x =
            defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y =
            defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z =
            defaultVertices[i].positionCoords.z;
        }
    
    }
    
    {  // Adjust the S texture coordinates to slide texture and
        // reveal effect of texture repeat vs. clamp behavior
        int    i;  // 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].textureCoord.s =
            (defaultVertices[i].textureCoord.s +
             _sCoordinateOffset);
        }
    }
}


/// 调用来自于 -[GLKViewController _updateAndDraw]
- (void)update{
    
    //更新动画顶点位置
    [self updateAnimateVertexPositions];

    //更新纹理参数设置
    [self updateTextureParameters];

    //刷新vertexBuffer
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);

    //设置vertex偏移指针
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),NULL + offsetof(SceneVertex, positionCoords));
    
    
    //设置textureCoords偏移指针
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),NULL + offsetof(SceneVertex, textureCoord));
    
    //Draw
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender {
    self.shouldAnimate = [sender isOn];
}
- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender {
    self.sCoordinateOffset = [sender value];
}
- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender {
    self.shouldUseLineFilter = [sender isOn];
}

@end
