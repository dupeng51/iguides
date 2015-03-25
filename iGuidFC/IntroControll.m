#import "IntroControll.h"
#import "HomeVC.h"
#import "MusicViewController.h"

@implementation IntroControll


- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray email:(BOOL)isEmail
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        
        //Initial Background images
        
        self.backgroundColor = [UIColor blackColor];
        
        backgroundImage1 = [[UIImageView alloc] initWithFrame:frame];
        if (isEmail) {
            [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
        } else {
            [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
        }
        [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage1];

        backgroundImage2 = [[UIImageView alloc] initWithFrame:frame];
        if (isEmail) {
            [backgroundImage2 setContentMode:UIViewContentModeScaleAspectFill];
        } else {
            [backgroundImage2 setContentMode:UIViewContentModeScaleAspectFill];
        }
        
        [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage2];
        
        //Initial shadow
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
        shadowImageView.frame = CGRectMake(0, frame.size.height-300, frame.size.width, 300);
        [self addSubview:shadowImageView];
        
        //Initial ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = pagesArray.count;
        [pageControl sizeToFit];
        [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-50)];
        pageControl.hidden = YES;
        [self addSubview:pageControl];
        
        //Create pages
        pages = pagesArray;
        
        scrollView.contentSize = CGSizeMake(pages.count * frame.size.width, frame.size.height);
        
        currentPhotoNum = -1;
        
        //insert TextViews into ScrollView
        for(int i = 0; i <  pages.count; i++) {
            IntroView *view;
            //当最后一个照片，并且为图片浏览主页使用时，显示Email,作为音乐播放背景时不显示Email
            if ((i == pages.count -1) && isEmail) {
                view = [[IntroView alloc] initWithFrame:frame model:[pages objectAtIndex:i] showEmail:YES];
            } else {
                view = [[IntroView alloc] initWithFrame:frame model:[pages objectAtIndex:i]];
            }
            view.frame = CGRectOffset(view.frame, i*frame.size.width, 0);
            [scrollView addSubview:view];
        }
            
        //start timer
//        timer =  [NSTimer scheduledTimerWithTimeInterval:3.0
//                        target:self
//                        selector:@selector(tick)
//                        userInfo:nil
//                        repeats:YES];
        
        [self initShow];
    }
    
    return self;
}

- (void)dealloc
{
    backgroundImage1.image = nil;
    backgroundImage1 = nil;
    backgroundImage2.image = nil;
    backgroundImage2 = nil;
    
    scrollView.delegate = nil;
    scrollView = nil;
    pageControl = nil;
    pages = nil;
}

- (void) tick {
    [scrollView setContentOffset:CGPointMake((currentPhotoNum+1 == pages.count ? 0 : currentPhotoNum+1)*self.frame.size.width, 0) animated:YES];
}

- (void) initShow {
    int scrollPhotoNumber = MAX(0, MIN(pages.count-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
    
    if(scrollPhotoNumber != currentPhotoNum) {
        currentPhotoNum = scrollPhotoNumber;
        
        //backgroundImage1.image = currentPhotoNum != 0 ? [(IntroModel*)[pages objectAtIndex:currentPhotoNum-1] image] : nil;
//        backgroundImage1.image = nil;
        IntroModel *model = (IntroModel*)[pages objectAtIndex:currentPhotoNum];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:model.imageName ofType:model._type];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        backgroundImage1.image = [UIImage imageWithData:imageData];
//        backgroundImage1.image = [(IntroModel*)[pages objectAtIndex:currentPhotoNum] image];
        
//        backgroundImage2.image = nil;
        if (currentPhotoNum +1 != [pages count]) {
            IntroModel *model1 = (IntroModel*)[pages objectAtIndex:currentPhotoNum+1];
            NSString *filePath1 = [[NSBundle mainBundle] pathForResource:model1.imageName ofType:model1._type];
            NSData *imageData1 = [NSData dataWithContentsOfFile:filePath1];
            backgroundImage2.image = [UIImage imageWithData:imageData1];
        } else {
            backgroundImage2.image = nil;
        }
        
//        backgroundImage2.image = currentPhotoNum+1 != [pages count] ? [UIImage imageWithData:imageData1] : nil;
        
//        backgroundImage2.image = currentPhotoNum+1 != [pages count] ? [(IntroModel*)[pages objectAtIndex:currentPhotoNum+1] image] : nil;
    }
    
    float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
    
    
    //left
    if(offset < 0) {
        pageControl.currentPage = 0;
        
        offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
        backgroundImage2.alpha = 0;
        backgroundImage1.alpha = (offset / self.frame.size.width);
    
    //other
    } else if(offset != 0) {
        //last
        if(scrollPhotoNumber == pages.count-1) {
            pageControl.currentPage = pages.count-1;
            
            backgroundImage1.alpha = 1.0 - (offset / self.frame.size.width);
        } else {
            
            pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
            
            backgroundImage2.alpha = offset / self.frame.size.width;
            backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
        }
    //stable
    } else {
        pageControl.currentPage = currentPhotoNum;
        backgroundImage1.alpha = 1;
        backgroundImage2.alpha = 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    [self initShow];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    //播放下一首或上一首
    [self updatePlayState];
    
    [self initShow];
    
}

- (void)scrollTo:(int) currentNum
{
    [scrollView setContentOffset:CGPointMake(self.frame.size.width * currentNum, 0) animated:YES];
    [self initShow];
}

#define 播放控制
- (void) updatePlayState {
    if ([[self viewController] isKindOfClass: [MusicViewController class]] ) {
        MusicViewController *musicVC = [self viewController];
        [musicVC playWithIndex:currentPhotoNum];
    }
    
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
