//
//  MissionTagViewController.m
//  PingPong
//
//  Created by Jeheon Choi on 2017. 3. 12..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MissionTagViewController.h"

@interface MissionTagViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation MissionTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialLayoutSetting];
    [self setBtnUI];
}




// 초기 세팅 메서드 ---------------------------------------//

- (void)initialLayoutSetting {
    
    [self.doneBtn.layer setCornerRadius:self.doneBtn.frame.size.height/2];
    [self.doneBtn.layer setBorderColor:[UIColor prj_peachyPinkColor].CGColor];
    [self.doneBtn.layer setBorderWidth:1];
    
    [self.shadowView.layer setShadowColor:[UIColor prj_veryLightPinkColor].CGColor];
    [self.shadowView.layer setShadowOpacity:1.0];
    [self.shadowView.layer setShadowOffset:CGSizeMake(0, -50)];
    [self.shadowView.layer setShadowRadius:18];
    [self.shadowView.layer setMasksToBounds:NO];
    
}


// Tag Btns 세팅

- (void)setBtnUI {
    
    CGFloat BUTTON_MARGIN = 16;
    CGFloat SINGLE_FONT_SIZE = 6.5;
    CGFloat IMAGE_SIZE = 16;
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    
    CGFloat blank = self.view.frame.size.width-32;        // 스토리보드로 UI설정하니 self.scrView.frame.size.width 값이 다른게 나와서 이렇게 해결
    
    for (NSInteger i=0 ; i < [DataCenter sharedData].tagTextList.count ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSLog(@"length : %ld, str : %@", [[DataCenter sharedData].tagTextList[i] length], [DataCenter sharedData].tagTextList[i]);
        
        NSInteger characterCnt = 0;
        
        for (NSInteger j = 0; j < [[DataCenter sharedData].tagTextList[i] length]; j++) {
            if ([[DataCenter sharedData].tagTextList[i] characterAtIndex:j] <= 'z') {   // 영문 대소문자, 숫자, 띄어쓰기
                characterCnt += 1;
            } else {    // 한글
                characterCnt += 2;  // 길이 두배
            }
        }
        
        CGFloat btnWidth = BUTTON_MARGIN * 2 + SINGLE_FONT_SIZE * characterCnt + IMAGE_SIZE;
        
        
        if (blank - offsetX < btnWidth) {
            offsetX = 0;
            offsetY += 52;
        }
        
        
//        //test
//        UIView *testView1 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, BUTTON_MARGIN, 40)];
//        [testView1 setBackgroundColor:[UIColor colorWithRed:66/255.0 green:230/255.0 blue:66/255.0 alpha:0.3]];
//        UIView *testView2 = [[UIView alloc] initWithFrame:CGRectMake(offsetX + BUTTON_MARGIN, offsetY, SINGLE_FONT_SIZE * characterCnt, 40)];
//        [testView2 setBackgroundColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:0.3]];
//        UIView *testView3 = [[UIView alloc] initWithFrame:CGRectMake(offsetX + BUTTON_MARGIN + SINGLE_FONT_SIZE * characterCnt, offsetY, IMAGE_SIZE, 40)];
//        [testView3 setBackgroundColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:237/255.0 alpha:0.3]];
//        UIView *testView4 = [[UIView alloc] initWithFrame:CGRectMake(offsetX + BUTTON_MARGIN + SINGLE_FONT_SIZE * characterCnt + IMAGE_SIZE, offsetY, BUTTON_MARGIN, 40)];
//        [testView4 setBackgroundColor:[UIColor colorWithRed:66/255.0 green:230/255.0 blue:66/255.0 alpha:0.3]];
        
        
        btn.frame = CGRectMake(offsetX, offsetY, btnWidth, 40);
        btn.tag = i;
        [btn addTarget:self action:@selector(selectedTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = btn.frame.size.height/2;
        
        
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        // UIControlStateNormal
        [btn setBackgroundColor:[UIColor prj_backGrayColor]];
        [btn setTitle:[DataCenter sharedData].tagTextList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        // UIControlStateSelected
        [btn setTitle:[DataCenter sharedData].tagTextList[i] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
        // image set
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(13, btnWidth - 32, 13, 0)];
        
        [btn setImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checkMark"] forState:UIControlStateSelected];
        
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -38, 0, 0)];
        
        
        [self.scrView addSubview:btn];
        
//        [self.scrView addSubview:testView1];
//        [self.scrView addSubview:testView2];
//        [self.scrView addSubview:testView3];
//        [self.scrView addSubview:testView4];

        offsetX += btnWidth + 12;
        
    
        if ([[DataCenter sharedData].missionList indexOfObject:[DataCenter sharedData].tagTextList[i]] <= [DataCenter sharedData].missionList.count) {
            [btn setSelected:YES];
            [btn setBackgroundColor:[UIColor prj_salmonColor]];
        }
    
    }
    
    [self.scrView setContentSize:CGSizeMake(self.view.frame.size.width-32, offsetY+100)];
    
}

// 태그 버튼 Selector 메서드

- (void)selectedTagBtn:(UIButton *)sender {

    NSLog(@"%ld Btn : %@", sender.tag, [DataCenter sharedData].tagTextList[sender.tag]);

    if (!sender.selected) {
        [sender setSelected:YES];
        [sender setBackgroundColor:[UIColor prj_pinkColor]];
        
        [[DataCenter sharedData] addMissionByMissionTag:sender.tag];
    } else {
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor prj_backGrayColor]];
        [[DataCenter sharedData] deleteMissionByMissionTag:sender.tag];
    }

}



// 선택완료
- (IBAction)tagSelectionDone:(id)sender {
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.view.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     } completion:^(BOOL finished) {
                         [self.delegate didSelectedDoneBtn];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
