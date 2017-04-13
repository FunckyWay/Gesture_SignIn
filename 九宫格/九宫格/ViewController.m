//
//  ViewController.m
//  九宫格
//
//  Created by hoptech on 17/3/24.
//  Copyright © 2017年 hoptech. All rights reserved.
//

#import "ViewController.h"
#import "MYView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MYView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    
    [self setupImage];
    
    self.passwordView.passwordBlock = ^(NSString *pwd)
    {
        
        
        
        if([pwd isEqualToString:@"012"])
            return YES;
        else
            return NO;
    };
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setupImage
{
    UIImage *image = [UIImage imageNamed:@"5ee372ff039073317a49af5442748071"];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    //在指定区域内画一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    //裁剪
    CGContextClip(ctx);//裁剪作用时渲染时候仅仅渲染规定的区域
    [image drawInRect:rect];//先把图片放到上下文上同时渲染，此时就是一个圆形图片
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.imageView.image = newimage;
    
    UIGraphicsEndImageContext();

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
