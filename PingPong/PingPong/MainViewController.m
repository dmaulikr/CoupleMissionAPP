//
//  MainViewController.m
//  PingPong
//
//  Created by Jeheon Choi on 2017. 3. 11..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "MainViewController.h"
#import "DataCenter.h"

@interface MainViewController ()
<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *me;
@property (weak, nonatomic) IBOutlet UIButton *you;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIButton *missionSendBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialLayoutSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////////////

- (void)initialLayoutSetting {
    self.me.layer.cornerRadius = self.me.bounds.size.height/2;
    self.you.layer.cornerRadius = self.you.bounds.size.height/2;
    self.missionSendBtn.layer.cornerRadius = self.missionSendBtn.bounds.size.height/2;
}



// TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"%ld", [DataCenter sharedData].missionList.count);
    
    return [DataCenter sharedData].missionList.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *missionCell = [tableView dequeueReusableCellWithIdentifier:@"mission" forIndexPath:indexPath];
    
    [missionCell.textLabel setText:[DataCenter sharedData].missionList[indexPath.row]];
    [missionCell.textLabel setTextColor:[UIColor prj_greyishBrownTwoColor]];
    [missionCell.textLabel setFont:[UIFont prj_missionListCellTextStyleFont]];
    
    return missionCell;
}


@end


// Custom UITableViewCell

@interface MissionListCell : UITableViewCell

@end

@implementation MissionListCell


@end
