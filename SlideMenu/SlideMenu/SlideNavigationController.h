//
//  SlideNavigationController.h
//  SlideMenu
//
//  Created by csh on 16/5/25.
//  Copyright © 2016年 csh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


typedef enum{
    MenuLeft = 1,
    MenuRight = 2
}Menu;
@protocol SlideNavigationContorllerAnimator;

@interface SlideNavigationController : UINavigationController

extern NSString  *const SlideNavigationControllerDidOpen;
extern NSString  *const SlideNavigationControllerDidClose;
extern NSString  *const SlideNavigationControllerDidReveal;

@property (nonatomic, strong) UIViewController *rightMenu;
@property (nonatomic, strong) UIViewController *leftMenu;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, assign) CGFloat menuRevealAnimationDuration;
@property (nonatomic, assign) UIViewAnimationOptions menuRevealAnimationOption;
@property (nonatomic, assign) CGFloat landscapeSlideOffset;
@property (nonatomic, assign) CGFloat portraitSlideOffset;
@property (nonatomic, strong) id <SlideNavigationContorllerAnimator> menuRevealAnimator;

+ (SlideNavigationController *)sharedInstance;

- (void)toggleLeftMenu;

- (void)toggleRightMenu;
@end
