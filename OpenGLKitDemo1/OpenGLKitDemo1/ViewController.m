//
//  ViewController.m
//  OpenGLKitDemo1
//
//  Created by 智衡宋 on 2017/9/22.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<GLKViewDelegate>
@property (nonatomic,strong) EAGLContext *sContext;
@property (nonatomic,strong) GLKBaseEffect *mEffect;
@property (nonatomic,strong) GLKView *glKitView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self szh_setupOpenGLESContext];
    [self szh_setupVertexData];
    [self szh_setupTextureData];
}


#pragma mark ----------- 设置OpenGLES 上下文

- (void)szh_setupOpenGLESContext {
    self.sContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //2.0，还有1.0和3.0
    
    //渲染视图
    _glKitView = [[GLKView alloc]initWithFrame:self.view.bounds]; //storyboard记得添加
    _glKitView.delegate = self;
    _glKitView.context = self.sContext;
    _glKitView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    [self.view addSubview:_glKitView];
    [EAGLContext setCurrentContext:self.sContext];
}

#pragma mark ----------- 设置顶点数据

- (void)szh_setupVertexData {
    
    //顶点数据，前三个是顶点坐标，后面两个是纹理坐标
    GLfloat squareVertexData[] =
    {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);

    
}


#pragma mark ----------- 设置纹理数据

- (void)szh_setupTextureData {
    
    //纹理贴图
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"jpg"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    //着色器
    _mEffect = [[GLKBaseEffect alloc]init];
    _mEffect.texture2d0.enabled = GL_TRUE;
    _mEffect.texture2d0.name = textureInfo.name;
    
}

#pragma mark ----------- 绘图

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
