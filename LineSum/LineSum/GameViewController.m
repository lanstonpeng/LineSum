//
//  GameViewController.m
//  LineSum
//
//  Created by Sun Xi on 5/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameboardView;

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNumbers];
}

- (void)initNumbers {
    for (int i = 0; i < 5; i++) {
        for(int j = 0; j < 5; j++) {
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            view.backgroundColor = [UIColor redColor];
            view.layer.cornerRadius = 25;
            [view setClipsToBounds:YES];
            [view setCenter:CGPointMake(40 + j*60, 40+i*60)];
            [view setTag:(i*5+j+1)];
            [_gameboardView addSubview:view];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
