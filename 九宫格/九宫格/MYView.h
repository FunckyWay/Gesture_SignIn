//
//  MYView.h
//  九宫格
//
//  Created by hoptech on 17/3/24.
//  Copyright © 2017年 hoptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYView : UIView


@property (nonatomic , copy ) BOOL(^passwordBlock)(NSString *str);

@end
