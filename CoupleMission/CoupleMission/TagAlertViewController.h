//
//  TagAlertViewController.h
//  CoupleMission
//
//  Created by Jeheon Choi on 2017. 3. 9..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagAlertViewControllerDelegate <NSObject>

- (void)didTagBtnSetting;

@end

@interface TagAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrView;

@property (nonatomic, weak) id <TagAlertViewControllerDelegate> delegate;

@end
