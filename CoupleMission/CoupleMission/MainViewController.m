//
//  ViewController.m
//  0308 CoupleMission
//
//  Created by katniss on 2017. 3. 8..
//  Copyright © 2017년 katniss. All rights reserved.
//

#import "MainViewController.h"
#import "TableViewCell.h"
#import "DataCenter.h"
#import "TagAlertViewController.h"
#import "MissionViewController.h"
#import "UIColor+PRJAdditions.h"


@interface MainViewController ()
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TagAlertViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *arrayList;
@property (strong, nonatomic) NSDictionary *tableList1;
@property (weak, nonatomic) IBOutlet UIView *btView;
@property (weak, nonatomic) IBOutlet UITextField *btTextField;
@property (weak, nonatomic) IBOutlet UIButton *btDone;
@property (weak, nonatomic) IBOutlet UIButton *missionSendBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"시작");
    
    
    // missionSendBtn 세팅
    [self.missionSendBtn setTitleColor:[UIColor prj_pinkColor] forState:UIControlStateNormal];
    [self.missionSendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.missionSendBtn.layer setBorderColor:[UIColor prj_pinkColor].CGColor];
    [self.missionSendBtn.layer setCornerRadius:self.missionSendBtn.frame.size.height/2];
    [self.missionSendBtn.layer setBorderWidth:2];
    

    // TagAlertView
    [self willTagAlertView];
    
    
    
    // btTextField delegate
    self.btTextField.delegate = self;
    
    // myTableView delegate
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.myTableView.layer.cornerRadius = 8;
    
    
    //profile img 넣기
    self.myProfileImg.image = [UIImage imageNamed:@"bitmap2.png"];
    
    self.connectImg.image = [UIImage imageNamed:@"like.png"];
    
    self.yourProfileImg.image = [UIImage imageNamed:@"bitmap.png"];
    
    
    //bound
    self.myProfileImg.layer.cornerRadius = 32;
    self.myProfileImg.layer.masksToBounds = YES;
    
    self.yourProfileImg.layer.cornerRadius = 32;
    self.yourProfileImg.layer.masksToBounds = YES;
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

//1.section*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//2.row* - tablelist
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataCenter sharedData].realMissionList.count;
}

//3. uitableview cell*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld", indexPath.row);
    
    //4. dequeue* 하고 identifier*
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hello" forIndexPath:indexPath];
    
    
    //5.dictionary* -> array*에서 indext.row*
    NSDictionary *dictemp = [[DataCenter sharedData].realMissionList objectAtIndex:indexPath.row];
    
    
    //6.table cell에 list 넣어주기
    cell.missionLable.text = [dictemp objectForKey:@"Name"];
    
    
    return cell;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)addBtnClick:(id)sender {
    
    [self.btTextField becomeFirstResponder];
    
    self.btView.center = CGPointMake(self.view.center.x, self.view.frame.size.height + self.btView.frame.size.height/2);
    
    [self.btView setHidden:NO];
    
    [UIView animateWithDuration:1 animations:^{
        self.btView.center = CGPointMake(self.view.center.x, self.view.center.y);
    }];
    
    
    
    
}

- (IBAction)hiddenView:(id)sender {
    
    [self.btView setHidden:YES];
    NSLog(@"%@", self.btTextField.text);
    [[DataCenter sharedData] addMissionListWithMissionName:self.btTextField.text];
    
    self.btTextField.text = @"";
    
    [self.btTextField resignFirstResponder];
    [self.myTableView reloadData];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didTagBtnSetting {
    [self.myTableView reloadData];
}


// TagAlertView 
- (IBAction)showTagAlertView:(id)sender {
    [self willTagAlertView];
}

- (void)willTagAlertView {
    TagAlertViewController *tagAlertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagAlertViewController"];
    
    [self addChildViewController:tagAlertVC];
    tagAlertVC.view.frame = self.view.frame;
    tagAlertVC.delegate = self;
    
    [self.view addSubview:tagAlertVC.view];
}


// MissionView
- (IBAction)showMissionView:(id)sender {
    
    NSLog(@"realMissionList : %@", [DataCenter sharedData].realMissionList);
    
    if (![DataCenter sharedData].realMissionList.count) {
        // 예외처리 문제있음.
        [[DataCenter sharedData].currentMission setObject:@"미션이 없습니다." forKey:@"Name"];
        
        NSLog(@"%@", [DataCenter sharedData].currentMission);
    } else {
        NSInteger random = arc4random() % [DataCenter sharedData].realMissionList.count;
        
        [DataCenter sharedData].currentMission = [DataCenter sharedData].realMissionList[random];
    }

    MissionViewController *missionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MissionViewController"];
    [self presentViewController:missionVC animated:YES completion:nil];
}

@end
