//
//  TagAlertViewController.m
//  CoupleMission
//
//  Created by Jeheon Choi on 2017. 3. 9..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "TagAlertViewController.h"
#import "DataCenter.h"
#import "UIColor+PRJAdditions.h"

@interface TagAlertViewController ()

@end

@implementation TagAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.doneBtn setTitleColor:[UIColor prj_pinkColor] forState:UIControlStateNormal];
    [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.doneBtn.layer setBorderColor:[UIColor prj_pinkColor].CGColor];
    [self.doneBtn.layer setCornerRadius:25];
    [self.doneBtn.layer setBorderWidth:2];
    
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.alpha = 0.5;
    [self setBtnUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setBtnUI {
    
    CGFloat BUTTON_MARGIN = 20;
    CGFloat SINGLE_FONT_SIZE = 10;
    
    CGFloat offsetX = BUTTON_MARGIN;
    CGFloat offsetY = BUTTON_MARGIN;
    
    CGFloat blank = self.scrView.frame.size.width - BUTTON_MARGIN*2;
    
    for (NSInteger i=0 ; i < NumOfMissionTag ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSLog(@"length : %ld, str : %@", [[DataCenter sharedData].tagNameArr[i] length], [DataCenter sharedData].tagNameArr[i]);
        
        NSInteger strLength = [[DataCenter sharedData].tagNameArr[i] length];
        CGFloat btnWidth = BUTTON_MARGIN * 2 + SINGLE_FONT_SIZE * strLength;
        
        if (blank - offsetX < btnWidth) {
            offsetX = BUTTON_MARGIN;
            offsetY += 45;
        }
        

        btn.frame = CGRectMake(offsetX, offsetY, btnWidth, 30);
        btn.tag = i;
        [btn addTarget:self action:@selector(selectedTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 15;
        

        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        // UIControlStateNormal
        [btn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1]];
        [btn setTitle:[DataCenter sharedData].tagNameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        // UIControlStateSelected
        [btn setTitle:[DataCenter sharedData].tagNameArr[i] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
        [self.scrView addSubview:btn];
        
        offsetX += btnWidth + 15;
        
        if ([[[DataCenter sharedData].missionTagStatusArr objectAtIndex:i] boolValue]) {
            [btn setSelected:YES];
            [btn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
        }
    }
    
    [self.scrView setContentSize:CGSizeMake(self.scrView.frame.size.width, offsetY+ 45)];
    
}

- (void)selectedTagBtn:(UIButton *)sender {
    
    NSLog(@"selected %d", sender.selected);
    
    if (!sender.selected) {
        [sender setSelected:YES];
        [sender setBackgroundColor:[UIColor colorWithRed:255/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
        [[DataCenter sharedData].missionTagStatusArr replaceObjectAtIndex:sender.tag withObject:@1];
    } else {
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1]];
        [[DataCenter sharedData].missionTagStatusArr replaceObjectAtIndex:sender.tag withObject:@0];
    }
    
    NSLog(@"Btn tag %ld", sender.tag);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)tagBtnSetDone:(id)sender {
    [[DataCenter sharedData] setMissionListByMissionTagStatusArr];
    
    [self.delegate didTagBtnSetting];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
