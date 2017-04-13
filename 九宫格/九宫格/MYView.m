//
//  MYView.m
//  九宫格
//
//  Created by hoptech on 17/3/24.
//  Copyright © 2017年 hoptech. All rights reserved.
//

#import "MYView.h"
#import "SVProgressHUD.h"
@interface MYView ()


@property (nonatomic , strong ) NSMutableArray *buttonArray;

@property (nonatomic , strong) NSMutableArray *lineArray;

@property (nonatomic , assign ) CGPoint currentPoint;

@property (nonatomic , assign) BOOL change;

@end

@implementation MYView

-(NSMutableArray *)lineArray
{
    if(_lineArray == nil)
    {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}



-(NSMutableArray *)buttonArray
{
    if(_buttonArray == nil)
    {
        _buttonArray = [NSMutableArray array];
        
        for (int i = 0; i<9; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [button setUserInteractionEnabled:NO];
            [self addSubview:button];
            
            [_buttonArray addObject:button];
            
        }
    
    }

    return _buttonArray;
}


-(void)layoutSubviews
{
    CGFloat width = 74;
    CGFloat height = 74;
    CGFloat margin = (self.frame.size.width - 3*width)/4;
    
    
    
    for (int i = 0;i<self.buttonArray.count;i++) {
        CGFloat x = (i%3)*(margin +width)+margin;
        CGFloat y = (i/3)*(margin + height) + margin;
        
        [self.buttonArray[i] setFrame:CGRectMake(x, y, width, height)];
    }


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t = touches.anyObject;
    
    CGPoint p =  [t locationInView:t.view];
    
    for (int i = 0;i<self.buttonArray.count;i++) {
        UIButton *button =self.buttonArray[i];
        
        if(CGRectContainsPoint(button.frame, p))
        {
            button.selected = YES;
            [self.lineArray addObject:button];
        
        }
        
    }


}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t = touches.anyObject;
    
    CGPoint p =  [t locationInView:t.view];
    
    self.currentPoint = p;
    
    for (int i = 0;i<self.buttonArray.count;i++) {
        UIButton *button =self.buttonArray[i];
        
        if(CGRectContainsPoint(button.frame, p))
        {
            button.selected = YES;
            
            if(![self.lineArray containsObject:button])
            {
                [self.lineArray addObject:button];
            }
            
            
        }
        
    }
    [self setNeedsDisplay];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.lineArray.count)
        return;
    
    self.currentPoint = [[self.lineArray lastObject] center];
    [self setNeedsDisplay];
    
    [self setUserInteractionEnabled:NO];
    
    NSString *passwrod = @"";
    for (int i = 0; i<self.lineArray.count; i++) {
        UIButton *button = self.lineArray[i];
        
        passwrod = [passwrod stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        
    }
    if(self.passwordBlock)
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        if(self.passwordBlock(passwrod))
            [SVProgressHUD showSuccessWithStatus:@"密码正确"];
        else{
            [SVProgressHUD showErrorWithStatus:@"密码错误！"];
            self.change = YES;
            [self setNeedsDisplay];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUserInteractionEnabled:YES];
        [SVProgressHUD dismiss];
         [self clearView];
        self.change = NO;
    });
    
   
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


-(void)clearView
{
    for (int i = 0;i<self.buttonArray.count;i++) {
        UIButton *button =self.buttonArray[i];
        button.selected = NO;
        
    }
    [self.lineArray removeAllObjects];
    [self setNeedsDisplay];

}




- (void)drawRect:(CGRect)rect {
    
    if(!self.lineArray.count)
        return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0 ; i<self.lineArray.count; i++) {
        UIButton *button = self.lineArray[i];
        if(i== 0)
            [path moveToPoint:button.center];
        else
        {
            [path addLineToPoint:button.center];
        }
    }
    
    [path addLineToPoint:self.currentPoint];
    
    [path setLineWidth:10];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [[UIColor whiteColor] setStroke];
    if(self.change)
       [[UIColor redColor] setStroke];
    
    [path stroke];

    
    // Drawing code
}


@end
