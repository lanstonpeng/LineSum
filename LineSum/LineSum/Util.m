//
//  Util.m
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "Util.h"

@implementation Util
+ (NSDictionary*)generateNumbers:(NSUInteger)count{
    NSDictionary* dic = [[NSDictionary alloc]init];
    NSMutableArray* result = [[NSMutableArray alloc]init];
    NSMutableArray* candidate = [[NSMutableArray alloc]initWithArray:@[@1,@2,@3,@4,@5,@6,@7,@8,@9]];
    int sum = 0;
    while (count) {
        int idx = arc4random()% [candidate count];
        [result addObject:candidate[idx]];
        sum += [candidate[idx] integerValue];
        [candidate removeObject:candidate[idx]];
        candidate = [Util shrinkArray:candidate];
        count--;
    }
    dic = @{
            @"sequence":result,
            @"sum":[NSNumber numberWithInt:sum]
            };
    return dic;
}
+ (NSMutableArray*)shrinkArray:(NSMutableArray*)origin{
    NSMutableArray* target = [[NSMutableArray alloc]init];
    int i = 0;
    for(;i < [origin count];i++){
        if(origin[i]){
            [target addObject:origin[i]];
        }
    }
    return target;
}
+(UIColor*)randomColor{
    switch (arc4random()%6) {
        case 0: return UIColorFromRGB(0x50ecb3);
        case 1: return UIColorFromRGB(0xb350ec);
        case 2: return UIColorFromRGB(0x50ec65);
        case 3: return UIColorFromRGB(0xecb350);
        case 4: return UIColorFromRGB(0xec5089);
        case 5: return UIColorFromRGB(0x50d7ec);
    }
    return UIColorFromRGB(0xec5089);
}
@end
