#import <UIKit/UIKit.h>
#import "IntroModel.h"

@interface IntroView : UIView
- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model;
- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model showEmail:(BOOL)isShow;
@end
