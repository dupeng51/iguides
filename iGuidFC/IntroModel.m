#import "IntroModel.h"

@implementation IntroModel

@synthesize titleText, descriptionText, imageName, _type;
//@synthesize image;

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText type:(NSString*) type{
    self = [super init];
    if(self != nil) {
        titleText = title;
        descriptionText = desc;
        imageName = imageText;
        _type = type;
//        image = [UIImage imageNamed:imageText];
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:imageText ofType:type];
//        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//        image = [UIImage imageWithData:imageData];
    }
    return self;
}

- (void)dealloc
{
    titleText = nil;
    descriptionText = nil;
    imageName = nil;
    _type = nil;
}

@end
