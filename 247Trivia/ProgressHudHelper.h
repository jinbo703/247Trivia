//
//  ProgressHudHelper.h
//  247Trivia
//
//  Created by John Nik on 6/30/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ProgressHudHelper : NSObject

+(void)showLoadingHudWithText:(NSString*)loadingMsg;
+(void)hideLoadingHud;

@end
