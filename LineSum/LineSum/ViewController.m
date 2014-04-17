//
//  ViewController.m
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong,nonatomic)NSArray* sequence;
@property (nonatomic)NSUInteger sum;
@property (strong,nonatomic)NSMutableArray* cubeViews;
@property (strong,nonatomic)UILabel* currentSum;
@property (strong,nonatomic)NSMutableArray* usedIndexArray;
@end


#define GRID_WIDTH 4
#define GRID_HEIGHT 5
#define UP_PADDING 100
#define CUBE_WIDTH 80
#define CUBE_LINE_COUNT 4
#define LUCKY_NUM 806
@implementation ViewController

- (NSMutableArray *)usedIndexArray{
    if(!_usedIndexArray){
        _usedIndexArray = [[NSMutableArray alloc]init];
    }
    return  _usedIndexArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDictionary* dic = [Util generateNumbers:4];
    self.sequence = [dic objectForKey:@"sequence"];
    self.sum = (NSUInteger)[dic objectForKey:@"sum"];
    UILabel* sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 120, 40)];
    sumLabel.text = [[dic objectForKey:@"sum"] stringValue];
    self.currentSum = [[UILabel alloc]initWithFrame:CGRectMake(150, 50, 50, 40 )];
    [self.currentSum setBackgroundColor:[Util randomColor]];
    self.currentSum.text = @"0";
    /*
    for(;i< [self.sequence count]; i++){
        UIView* cubeView =[self generateCube:CGRectMake( i * 80 % 320, UP_PADDING + (i / 4 ) * 80, 80, 80) withNum:self.sequence[i]];
        [self.view addSubview:cubeView];
    }
     */
    [self generateGrid:self.sequence];
    [self.view addSubview:sumLabel];
    [self.view addSubview:self.currentSum];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
}
- (void)handleTap:sender
{
    NSLog(@"start taping");
}
-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    //NSLog(@"start paning x %f",[sender translationInView:self.view].x );
    
    double pointerX = [sender locationInView:self.view].x;
    double pointerY = [sender locationInView:self.view].y - UP_PADDING;
    
    int x =  pointerX / (GRID_WIDTH * CUBE_WIDTH ) * GRID_WIDTH;
    int y = pointerY / (GRID_HEIGHT * CUBE_WIDTH) * GRID_HEIGHT;
    
    int idx =(x+ 4 * y + 1);
    
    if(![self.usedIndexArray containsObject:[NSNumber numberWithInt:idx ]]){
        [self.usedIndexArray addObject:[NSNumber numberWithInt:idx ]];
        UIView* currentView =[self.view viewWithTag:idx];
        UILabel* numLabel = (UILabel*)[currentView viewWithTag:LUCKY_NUM];
        int num = [numLabel.text intValue];
    //    NSLog(@"%d %d",x,y);
    //    NSLog(@"paning on %@", [self.view viewWithTag:(x+ 4 * y + 1)]);
        [currentView setBackgroundColor:[UIColor whiteColor]];
        self.currentSum.text = [NSString stringWithFormat:@"%d",[self.currentSum.text intValue] + num];
    }
    
}
- (UIView*)generateCube:(CGRect)frame withNum:(id)currentNum{
    UIView* cubeView = [[UIView alloc]initWithFrame:frame];
    [cubeView setBackgroundColor:[Util randomColor]];
    NSNumber* num = currentNum;
    UILabel* numLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 50, 50)];
    numLabel.text = [NSString stringWithFormat:@"%d",[num intValue]];
    [numLabel setTag:LUCKY_NUM];
    [cubeView addSubview:numLabel];
    /*
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [cubeView addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [cubeView addGestureRecognizer:panGesture];
     */
    return cubeView;
}
- (void)generateGrid:(NSArray*)sequence{
    int i = 0;
    for(;i< GRID_WIDTH * GRID_HEIGHT; i++){
        UIView* cubeView =[self generateCube:CGRectMake( i * CUBE_WIDTH % (int)IPHONE_SCREEN_WIDTH, UP_PADDING + (i / CUBE_LINE_COUNT) * CUBE_WIDTH, CUBE_WIDTH, CUBE_WIDTH) withNum:[NSNumber numberWithInt:i ]];
        [cubeView setTag:i+1];
        [self.view addSubview:cubeView];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
