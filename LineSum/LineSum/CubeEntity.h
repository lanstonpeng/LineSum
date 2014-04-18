//
//  CubeEntity.h
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CubeEntity : NSObject
@property (strong,nonatomic)UIView* cubeView;
@property (strong,nonatomic)NSNumber* x;
@property (strong,nonatomic)NSNumber* y;

-(instancetype)initWithView:(UIView*)cubeView x:(int)x y:(int)y;
@end
