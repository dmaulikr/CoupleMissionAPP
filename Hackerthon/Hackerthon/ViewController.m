//
//  ViewController.m
//  Hackerthon
//
//  Created by SSangGA on 2017. 3. 8..
//  Copyright © 2017년 ysm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) NSString *txt;
@property (nonatomic) UILabel *label;
@property (nonatomic) NSUInteger num;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    랜덤버튼
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, self.view.frame.size.width*30/100, self.view.frame.size.height*20/100)];
    [btn setTitle:@"Random" forState:UIControlStateNormal];
    [btn setTitle:@"Random" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    숫자 Label
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 150, self.view.frame.size.width*30/100, self.view.frame.size.height*20/100)];
    self.label.text = @"버튼 눌러";
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
}

- (void)btnClicked:(UIButton *)sender
{
    int random = arc4random() % (50);
    NSString *temp = [NSString stringWithFormat:@"%d",random];
    NSLog(@"버튼클릭");
    self.label.text = temp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
