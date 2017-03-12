//
//  MissionTagViewController.h
//  PingPong
//
//  Created by Jeheon Choi on 2017. 3. 12..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MissionTagViewControllerDelegate <NSObject>

- (void)didSelectedDoneBtn;

@end



@interface MissionTagViewController : UIViewController

@property (nonatomic, weak) id <MissionTagViewControllerDelegate> delegate;

@end

