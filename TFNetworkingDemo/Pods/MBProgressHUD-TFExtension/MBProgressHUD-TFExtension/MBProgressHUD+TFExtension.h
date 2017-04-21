

#import "MBProgressHUD.h"

@interface MBProgressHUD (TFExtension)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (void)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+(void)hideHUDAnimated:(BOOL)animated;

/*可换行的hud*/

+ (void)showMultiLineSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showMultiLineError:(NSString *)error toView:(UIView *)view;

+ (void)showMultiLineMessage:(NSString *)message toView:(UIView *)view;
+ (void)showMultiLineSuccess:(NSString *)success;
+ (void)showMultiLineError:(NSString *)error;
+ (void)showMultiLineMessage:(NSString *)message;

@end
