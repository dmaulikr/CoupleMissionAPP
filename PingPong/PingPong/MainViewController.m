//
//  MainViewController.m
//  PingPong
//
//  Created by Jeheon Choi on 2017. 3. 11..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MainViewController.h"
#import "MissionTagViewController.h"
#import "MissionViewController.h"

@interface MainViewController ()
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MissionTagViewControllerDelegate, DataCenterDelegate>

@property (weak, nonatomic) IBOutlet UIButton *me;
@property (weak, nonatomic) IBOutlet UIButton *you;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

@property (weak, nonatomic) IBOutlet UITableView *missionTableView;

@property (weak, nonatomic) IBOutlet UIButton *addCustomMissionBtn;     // + & x 버튼

@property (weak, nonatomic) IBOutlet UITextField *missionTextField;
@property (weak, nonatomic) IBOutlet UIButton *missionAddBtn;       // 추가 버튼
@property (nonatomic) BOOL showTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendMissionBtn;      // 미션 보내기 버튼
@property (weak, nonatomic) IBOutlet UIButton *missionTagBtn;   // 미션 태그 선택 버튼
@property (weak, nonatomic) IBOutlet UIImageView *missionAlert; // Bell 옆에 미션왔음을 알리는 imageView

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initialSetting];

}



// 초기 세팅 메서드 ---------------------------------------//

- (void)initialSetting {
    
    [DataCenter sharedData].delegate = self;        // 미션 받기를 위한 델리게이트 메소드 포함함
    
    self.me.layer.cornerRadius = self.me.bounds.size.height/2;
    self.you.layer.cornerRadius = self.you.bounds.size.height/2;
    self.sendMissionBtn.layer.cornerRadius = self.sendMissionBtn.bounds.size.height/2;

    // UITableView Frame setting
    
    self.missionTableView.frame = CGRectMake(0, self.view.frame.size.width*176/375 + 20, self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.width*176/375 + 20) - 119);
    
    [self.missionTextField addTarget:self action:@selector(editMissionTextField:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self hasSendedMission:![DataCenter sharedData].didReceivedMissionDone];    // 보낸 미션 상태 동기화
    [self hasReceivedMission:![DataCenter sharedData].didReceivedMissionDone];  // 받은 미션 상태 동기화
    
}


// Status Bar

- (BOOL)prefersStatusBarHidden {
    // LaunchScreen에서 Hidden 후, StatusBar 다시 노출
    return NO;
}



// TableView DataSource delegate Methods --------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [DataCenter sharedData].missionList.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *missionCell = [tableView dequeueReusableCellWithIdentifier:@"mission" forIndexPath:indexPath];
    
    [missionCell.textLabel setText:[DataCenter sharedData].missionList[indexPath.row]];
    [missionCell.textLabel setTextColor:[UIColor prj_greyishBrownTwoColor]];
    [missionCell.textLabel setFont:[UIFont prj_missionListCellTextStyleFont]];
    
    // 셀 선택시, 배경색 설정
    missionCell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    missionCell.selectedBackgroundView.backgroundColor = [UIColor prj_veryLightPinkColor];
    
    return missionCell;
}



// 커스텀 미션 입력, TextField 관련 메서드 --------------------//

- (IBAction)clickAddCustomMissionBtn:(id)sender {
    
    [self toggleCustomMissionTextField];
}

// TextField 토글, TableView 위치 조정 메서드

- (void)toggleCustomMissionTextField {
    
    self.showTextField = !self.showTextField;
    
    if (self.showTextField) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.missionTextField setText:@""];
            [self.missionAddBtn setEnabled:NO];     // 초기 missionAddBtn tf nil이기에 사용불가
            [self.addCustomMissionBtn setSelected:YES];
            [self.missionTextField becomeFirstResponder];
            
            self.missionTableView.frame = CGRectMake(0, self.missionTableView.frame.origin.y+56, self.missionTableView.frame.size.width, self.missionTableView.frame.size.height-56);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.addCustomMissionBtn setSelected:NO];
            [self.missionTextField resignFirstResponder];
            
            self.missionTableView.frame = CGRectMake(0, self.missionTableView.frame.origin.y-56, self.missionTableView.frame.size.width, self.missionTableView.frame.size.height+56);
        }];
    }
}


// TextField 옆 미션 추가 버튼 액션

- (IBAction)missionAdd:(id)sender {
    
    [[DataCenter sharedData] addMissionWithMissionText:self.missionTextField.text];
    [self.missionTextField setText:nil];
    [self.missionTextField resignFirstResponder];
    [self toggleCustomMissionTextField];
    
    [self.missionTableView reloadData];
}

// 키보드 리턴 처리

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

// 커스텀 미션 추가할 텍스트 없을 때, 미션 추가 버튼 Disabled

- (void)editMissionTextField:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        [self.missionAddBtn setEnabled:NO];
    } else {
        [self.missionAddBtn setEnabled:YES];
    }
}


// 다른 곳 터치할 때, TextField First Responder 해제

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.missionTextField isFirstResponder] && [touch view] != self.missionTextField) {
        [self.missionTextField resignFirstResponder];
    }
}


// 미션태그 ViewController ------------------------------//

- (IBAction)clickMissionTagBtn:(id)sender {
    
    MissionTagViewController *missionTagVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MissionTagViewController"];
    [self.missionTagBtn setEnabled:NO]; // 버튼 여러번 눌림 방지
    
    [self addChildViewController:missionTagVC];
    [self.view addSubview:missionTagVC.view];
    missionTagVC.delegate = self;
    
    missionTagVC.view.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        missionTagVC.view.frame = self.view.frame;
    }];

}


// MissionTagVC에서 선택완료(Done)버튼 눌렀을 때 불리는 Delegate Method

- (void)didSelectedDoneBtn {
    [self.missionTagBtn setEnabled:YES]; // 버튼 다시 활성화

    [self.missionTableView reloadData];
}


// 미션 보내기&받기 관련 메서드 ------------------------------//

// 미션 보내기 버튼 액션 메서드

- (IBAction)clickSendMissionBtn:(id)sender {
    
    if ([DataCenter sharedData].missionList.count == 0) {
        
    } else {
        NSInteger random = arc4random() % [DataCenter sharedData].missionList.count;
        
        [[DataCenter sharedData] sendMissionWithIndex:random];
    }
}


// DataCenter Mission 여부 delegate 메소드들


// 보낸 미션 처리

- (void)hasSendedMission:(BOOL)hasSendedMission {
    
    if (hasSendedMission) {
        [self.sendMissionBtn setEnabled:NO];
        [self.sendMissionBtn setTitle:@"미션을 보냈습니다" forState:UIControlStateDisabled];
        [self.sendMissionBtn setBackgroundColor:[UIColor prj_pinkishGrey]];
    } else {
        [self.sendMissionBtn setEnabled:YES];
        [self.sendMissionBtn setBackgroundColor:[UIColor prj_salmonColor]];
        [self.missionTableView reloadData];
    }
}

// 받은 미션 처리

- (void)hasReceivedMission:(BOOL)hasReceivedMission {
    
    if (hasReceivedMission) {
        [self.missionAlert setHidden:NO];
    } else {
        [self.missionAlert setHidden:YES];
    }
}



// 미션 뷰 ViewController (bell 버튼 액션) ----------------//

- (IBAction)enterMissionView:(id)sender {
    
    MissionViewController *missionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MissionViewController"];
    
    [self presentViewController:missionVC animated:YES completion:nil];
    
}


@end
