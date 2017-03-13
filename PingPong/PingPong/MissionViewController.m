//
//  MissionViewController.m
//  PingPong
//
//  Created by Jeheon Choi on 2017. 3. 12..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MissionViewController.h"
#import "DataCenter.h"


@interface MissionViewController () <TimerDelegate>

@property (weak, nonatomic) IBOutlet UIView *timeBackBar;
@property (weak, nonatomic) IBOutlet UIView *timeBar;
@property (weak, nonatomic) IBOutlet UILabel *missionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *missionCompleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *completeImg;


@end

@implementation MissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataCenter sharedData] missionTimerStart];        // 미션 보낸사람이 보내기 버튼 눌렀을 때부터 24시간
    [self missionViewSetting];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//// Status Bar
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}


// 미션뷰 세팅
- (void)missionViewSetting {
    
    [DataCenter sharedData].timerDelegate = self;        // 시간 받기를 위한 델리게이트 메소드 포함함
    
    self.missionCompleteBtn.layer.cornerRadius = self.missionCompleteBtn.bounds.size.height/2;
    
    if ([[DataCenter sharedData].currentReceivedMission isEqualToString:@""]) {
        // 미션 없는 상황
        [self.missionLabel setText:@"받은 미션이 없습니다"];
        
        [self.missionCompleteBtn setEnabled:NO];
        [self.missionCompleteBtn setTitle:@"미션이 없습니다" forState:UIControlStateDisabled];
        [self.missionCompleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.missionCompleteBtn setBackgroundColor:[UIColor prj_pinkishGrey]];
        
    } else {
        
        [self.missionLabel setText:[DataCenter sharedData].currentReceivedMission];
        
        [self.timeLabel setText:[DataCenter sharedData].restTimeStr];
        self.timeBar.frame = CGRectMake(0, 0, (self.view.frame.size.width - 61) * [DataCenter sharedData].percent, 2);
        
        
        if ([DataCenter sharedData].didReceivedMissionDone) {
            if ([DataCenter sharedData].missionFailed) {
                // 미션 실패한 상황
                [self.missionCompleteBtn setEnabled:NO];
                [self.missionCompleteBtn setTitle:@"미션 실패했습니다" forState:UIControlStateDisabled];
                [self.missionCompleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [self.missionCompleteBtn setBackgroundColor:[UIColor prj_pinkishGrey]];
                
            } else {
                // 미션 정상 완료된 상황
                [self.completeImg setHidden:NO];
                
                [self.missionCompleteBtn setEnabled:NO];
                [self.missionCompleteBtn setTitle:@"미션 완료했습니다" forState:UIControlStateDisabled];
                [self.missionCompleteBtn setTitleColor:[UIColor prj_salmonColor] forState:UIControlStateDisabled];
                [self.missionCompleteBtn setBackgroundColor:[UIColor clearColor]];
                [self.missionCompleteBtn.layer setBorderColor:[UIColor prj_peachyPinkColor].CGColor];
                [self.missionCompleteBtn.layer setBorderWidth:1];
            }
        }
    }
}


- (void)timeUpdate:(NSString *)timeStr withPercent:(CGFloat)percent {
    
    [self.timeLabel setText:timeStr];
    
    self.timeBar.frame = CGRectMake(0, 0, (self.view.frame.size.width - 61) * percent, 2);
    
}



- (IBAction)exitMissionView:(id)sender {
    
    [[DataCenter sharedData] missionTimerStop];     // 타이머 종료
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)missionComplete:(id)sender {
    
    [[DataCenter sharedData] completeMission];
    
    [self.completeImg setHidden:NO];
    
    [self.missionCompleteBtn setEnabled:NO];
    [self.missionCompleteBtn setTitle:@"미션 완료했습니다" forState:UIControlStateDisabled];
    [self.missionCompleteBtn setTitleColor:[UIColor prj_salmonColor] forState:UIControlStateDisabled];
    [self.missionCompleteBtn setBackgroundColor:[UIColor clearColor]];
    [self.missionCompleteBtn.layer setBorderColor:[UIColor prj_peachyPinkColor].CGColor];
    [self.missionCompleteBtn.layer setBorderWidth:1];
    
    [[DataCenter sharedData] missionTimerStop];
}


@end
