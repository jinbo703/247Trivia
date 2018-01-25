//
//  ProgressHudHelper.m
//  247Trivia
//
//  Created by John Nik on 6/30/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ProgressHudHelper.h"

@implementation ProgressHudHelper

+(void)showLoadingHudWithText:(NSString*)loadingMsg
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = loadingMsg;

    hud.alpha = 1.0;
    hud.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    hud.bezelView.color = [UIColor clearColor];
}

+(void)hideLoadingHud
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

@end
