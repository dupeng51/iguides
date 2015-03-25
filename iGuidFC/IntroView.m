#import "IntroView.h"
#import "HomeVC.h"

@implementation IntroView
{
    UIButton *emailBtn;
}

- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model showEmail:(BOOL)isShow
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:model.titleText];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(1, 1)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel sizeToFit];
        [titleLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height-145)];
        [self addSubview:titleLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setText:model.descriptionText];
        [descriptionLabel setFont:[UIFont systemFontOfSize:16]];
        [descriptionLabel setTextColor:[UIColor whiteColor]];
        [descriptionLabel setShadowColor:[UIColor blackColor]];
        [descriptionLabel setShadowOffset:CGSizeMake(1, 1)];
        [descriptionLabel setNumberOfLines:3];
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
        
        CGSize s = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        //three lines height
        CGSize three = [@"1 \n 2 \n 3" sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        descriptionLabel.frame = CGRectMake((self.frame.size.width-s.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+25,s.width, MIN(s.height, three.height));
        
        NSLog(@"%f", s.height);
        
        [self addSubview:descriptionLabel];
    }
    if (isShow) {
        [self addButton];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        int fontSize = 0;
        int titleY = 0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            // Some code for iPhone
            fontSize = 16;
            titleY = 165;
        } else {
            fontSize = 26;
            titleY = 200;
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:model.titleText];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(1, 1)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel sizeToFit];
        [titleLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height-titleY)];
        [self addSubview:titleLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setText:model.descriptionText];
        
        [descriptionLabel setTextColor:[UIColor whiteColor]];
        [descriptionLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [descriptionLabel setShadowColor:[UIColor blackColor]];
        [descriptionLabel setShadowOffset:CGSizeMake(1, 1)];
        [descriptionLabel setNumberOfLines:3];
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
        
        CGSize s = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        //three lines height
        CGSize three = [@"1 \n 2 \n 3" sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        descriptionLabel.frame = CGRectMake((self.frame.size.width-s.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+4,s.width, MIN(s.height, three.height));
        
        
        NSLog(@"%f", s.height);

        [self addSubview:descriptionLabel];
    }
    return self;
}

- (void) addButton
{
    // 创建定位按钮
    emailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // 确定宽、高、X、Y坐标
    CGRect frame;
    frame.size.width = 50;
    frame.size.height = 50;
    
    frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.frame.size.height - 80;
    [emailBtn setFrame:frame];
    [emailBtn setBackgroundImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
    //    emailBtn.tintColor = [UIColor redColor];
//    emailBtn.backgroundColor = [UIColor whiteColor];
//    emailBtn.alpha = 0.8;
    
    // 设置圆角半径
//    emailBtn.layer.masksToBounds = YES;
//    emailBtn.layer.cornerRadius = 8;
    //还可设置边框宽度和颜色
//    emailBtn.layer.borderWidth = 1;
    emailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [emailBtn addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emailBtn];
}

-(void) sendEmail:(id)sender
{
    HomeVC *viewController = (HomeVC *)[self viewController];
    [viewController sendPhoto];
}

- (UIViewController*)viewController {
    UIViewController *currentViewController;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
        nextResponder = nil;
    }
    return currentViewController;
}
@end
