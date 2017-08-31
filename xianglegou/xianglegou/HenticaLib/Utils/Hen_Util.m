//
//  HTC_Util.h
//  CRM
//
//  Created by mini2 on 16/5/25.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_Util.h"
#import "MSSBrowseDefine.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>

@implementation Hen_Util

static Hen_Util *_util = nil;

+ (Hen_Util *)getInstance
{
    //初始化一个只执行一次的线程
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _util = [[self alloc] init];
    });
    return _util;
}

///获取系统日期
-(NSString*)getSystemDate{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date = [dateformatter stringFromDate:senddate];
    
    return date;
}

///获取系统时间
-(NSString*)getSystemTime{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *time = [dateformatter stringFromDate:senddate];
    
    return time;
}
///获取系统日期时间
-(NSString*)getSystemDateTime
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateTime = [dateformatter stringFromDate:senddate];
    
    return dateTime;
}

///日期字符串转Date
-(NSDate*)dateStringToDate:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    return [dateFormatter dateFromString:dateString];
}

///时间字符串转Date
-(NSDate*)timeStringToDate:(NSString*)timeString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    return [dateFormatter dateFromString:timeString];
}
///日期时间字符串转Date
-(NSDate*)dateTimeToDateTime:(NSString*)dateTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [dateFormatter dateFromString:dateTimeString];
}


/// date转日期字符串
- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}
/// date转时间字符串
- (NSString *)timeToString:(NSDate *)timeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    return [dateFormatter stringFromDate:timeDate];
}

/// date转日期时间字符串
- (NSString *)dateTimeToString:(NSDate *)dateTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:dateTime];
}

/// 比较日期大小默认会比较到秒
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

/// 时间戳转换
- (NSString *)timeStampToString:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue / 1000];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}

/// 时间戳转换（含 年月日 时分）
- (NSString *)dateTimeStampToString:(NSString *)dateTimeStamp
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:dateTimeStamp.doubleValue / 1000];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:dateTime];
}

/// 日期 转 时间戳
- (NSString *)dateTimeSecondStampToString:(NSString *)dateTimeSecondString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
     NSDate *datenow = [dateFormatter dateFromString:dateTimeSecondString];
    
    
    NSString *timeSp = [NSString stringWithFormat:@"%.f", [datenow timeIntervalSince1970] * 1000];
    
    return timeSp;
}


//把中文转换成英文
- (NSString *)changeChineseToEnglishBy:(NSString *)string {
    if ([[string substringToIndex:1] isEqualToString:@" "]) {
        string = [string substringFromIndex:1];
    }
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString,NULL,kCFStringTransformToLatin,false);
    
    mutableString = (NSMutableString
                     *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale
                                                                                                      currentLocale]];
    return [[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
}

///获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentViewController{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

//查找viewcontroller
-(UIViewController*) findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

/// 计算字符串宽度
- (CGFloat)calculateWidthForString:(NSString *)string andTextHeight:(CGFloat)height anFont:(UIFont*)font
{
    if(string.length <= 0){
        return 0;
    }
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(CGFLOAT_MAX,height);
    
    //获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.width;

}

///计算字符串高度
-(CGFloat)calculationHeightForString:(NSString *)string anTextWidth:(CGFloat)widthText anFont:(UIFont*)font
{
    if(string.length <= 0){
        return 0;
    }
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(widthText,CGFLOAT_MAX);
    
    //获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.height;
}

///计算字符串高度
-(CGFloat)calculationHeightForString:(NSString *)string anTextWidth:(CGFloat)widthText anRowHeight:(CGFloat)rowHeight anFont:(UIFont*)font
{
    if(string.length <= 0){
        return 0;
    }
    
    NSString *stirngTemp = string;
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(widthText,CGFLOAT_MAX);
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:rowHeight];
    //获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle1,NSParagraphStyleAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[stirngTemp boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.height;
}

///图片缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(CGSize)scaleSize
{
    CGSize oSize = image.size;
    
    if (scaleSize.width > oSize.width || scaleSize.height > oSize.height) {
        return image;
    }
    
    CGFloat scalex = scaleSize.width/oSize.width;
    CGFloat scaley = scaleSize.height/oSize.height;
    CGFloat scale = oSize.width > oSize.height ? scaley : scalex;
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scale, image.size.height*scale)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

///图片缩放
- (UIImage *)scaleImage:(UIImage *)image maxEdge:(CGFloat)maxEdge
{
    CGSize oSize = image.size;
    
    if (oSize.width <= maxEdge && oSize.height <= maxEdge) {
        return image;
    }
    
    //缩放后宽
    CGFloat scaleWidth = 0;
    //缩放后高
    CGFloat scaleHeight = 0;
    
    if(oSize.width > oSize.height){
        scaleWidth = maxEdge;
        scaleHeight = (maxEdge / oSize.width) * oSize.height;
    }else{
        scaleHeight = maxEdge;
        scaleWidth = (maxEdge / oSize.height) * oSize.width;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaleWidth, scaleHeight));
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

///图片旋转
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/// 拉伸图片 top > 顶端盖高度 bottom > 底端盖高度 left > 左端盖宽度 right > 右端盖宽度
- (UIImage *)stretchImageWithImage:(UIImage *)originalImage
                               top:(CGFloat)top
                            bottom:(CGFloat)bottom
                              left:(CGFloat)left
                             right:(CGFloat)right {
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage * newImage = [originalImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}

// 根据图片url获取图片尺寸
-(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
-(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
-(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
-(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//获取视频封面，本地视频，网络视频都可以用
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL
{
    // 根据视频的URL创建AVURLAsset
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    // 根据AVURLAsset创建AVAssetImageGenerator对象
    AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset: asset];
    gen.appliesPreferredTrackTransform = YES;
    
    // 定义获取0帧处的视频截图
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    // 获取time处的视频截图
    CGImageRef  image = [gen  copyCGImageAtTime: time actualTime: &actualTime error:&error];
    // 将CGImageRef转换为UIImage
    UIImage *thumb = [[UIImage alloc] initWithCGImage: image];
    CGImageRelease(image);
    
    return  thumb;
}

///自定UIImage长宽
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

///异步加载
-(void)asynchronousLoadingBlock:(void(^)())loadBlock finishBlock:(void(^)())finishBlock
{
    //异步加载数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         解释下这个函数的意思
         dispatch_async 函数会将传入的block块放入指定的queue里运行，这个函数是异步的，这就意味着它会立即返回而不管block是否运行结束。因此，我们可以在block里面运行各种耗时操作（如网络请求）而同时不会阻塞UI线程。
         dispatch_get_global_queue 会获取一个全局队列，我们姑且理解为系统为我们开启的一些全局线程。我们用priority指定队列的优先级，而flag作为保留字段备用（一般为0）
         */
        if(loadBlock){
            loadBlock();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //dispatch_get_main_queue 会返回主队列，也就是UI队列。它一般用于在其他队列中异步完成一些工作后，需要在UI队列中更新界面
            if(finishBlock){
                finishBlock();
            }
        });
    });
}

///点击显示大图
-(void)clickShowBigPicture:(NSMutableArray*)imageArray forView:(UIView*)view  andCurrentTouch:(NSInteger)item;
{
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(NSInteger i = 0;i < imageArray.count; i++)
    {
        //UIImageView *imageView = [view viewWithTag:i + Base_Tag];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImage = [imageArray objectAtIndex:i];// 大图
        //browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseViewController *bvc = [[MSSBrowseViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:item];
    [bvc showBrowseViewController];
}

///跳转到appStroe
- (void)toAppStore:(NSDictionary*)appInfo appId:(NSString*)appId
{
    if(appInfo){
        NSString *iTunesLink = appInfo[@"trackViewUrl"];
    
        BOOL canOpenUrl = YES;
    
        canOpenUrl = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    
        if (canOpenUrl) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",appId]]];
        }
    }
}

///客服电话
-(void)customerPhone:(NSString *)phone
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

///获取显示字符串后面位数
- (NSString*)getStringLastThree:(NSString*)string andCharNum:(NSInteger)charNum
{
    NSString *result = @"";
    if(string){
        if(string.length > charNum){
            NSString *lastString = [string substringWithRange:NSMakeRange(string.length-charNum,charNum)];
            
            for(NSInteger i = 0; i < string.length - charNum; i++){
                result = [result stringByAppendingString:@"*"];
            }
            return [result stringByAppendingString:lastString];
        }
        return string;
    }
    return result;
}

///获取显示字符串前5位
- (NSString*)getStringBeforeFive:(NSString*)string
{
    NSString *result = @"";
    if(string){
        if(string.length > 5){
            NSString *beforeString = [string substringWithRange:NSMakeRange(0,5)];
            result = [result stringByAppendingString:beforeString];
            
            for(NSInteger i = 5; i < string.length; i++){
                result = [result stringByAppendingString:@"*"];
            }
            return result;
        }
        return string;
    }
    return result;
}

///字符串显示小数
- (NSString *)string:(NSString *)string showDotNumber:(NSInteger)dot
{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int valInt;
    float valFloat;
    if([scan scanFloat:&valFloat] && [scan isAtEnd]){
        double decFloat = [string doubleValue];
        if(dot == 0){
            return [NSString stringWithFormat:@"%.0f", decFloat];
        }else if(dot == 1){
             return [NSString stringWithFormat:@"%.1f", decFloat];
        }else if(dot == 2){
            return [NSString stringWithFormat:@"%.2f", decFloat];
        }else if(dot == 4){
            return [NSString stringWithFormat:@"%.4f", decFloat];
        }
    }
    if([scan scanInt:&valInt] && [scan isAtEnd]){
        double decFloat = [string doubleValue];
        if(dot == 0){
            return [NSString stringWithFormat:@"%.0f", decFloat];
        }else if(dot == 1){
            return [NSString stringWithFormat:@"%.1f", decFloat];
        }else if(dot == 2){
            return [NSString stringWithFormat:@"%.2f", decFloat];
        }else if(dot == 4){
            return [NSString stringWithFormat:@"%.4f", decFloat];
        }
    }
    return string;
}



///小数点格式化：如果有两位小数不为0则保留两位小数，如果有一位小数不为0则保留一位小数，否则显示整数
- (NSString *)formatFloat:(float)f
{
    if(fmodf(f, 1)==0) {//显示整数
        return [NSString stringWithFormat:@"%.0f",f];
    }else if(fmodf(f*10, 1)==0){//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    }else{//如果有两位小数点
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

///字符串替换
- (NSString *)replaceString:(NSString *)replaceString replaceedString:(NSString *)replaceedString resourceString:(NSString *)resourceString
{
    return [resourceString stringByReplacingOccurrencesOfString:replaceedString withString:replaceString];
}


///判断是否纯数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

///判断是否是几位小数
-(BOOL)isFourMath:(NSString *)string len:(NSString *)len{

    NSRange range = [string rangeOfString:@"."];
    if(range.length==0){
     return true;
    }
    NSString *str = [string substringFromIndex:range.location+1];
    if(str.length>len.intValue){
        return false;
    }
    
    return true;
}


-(BOOL)judgeStr:(NSString *)str1 with:(NSString *)str2

{
    int a = [str1 intValue];
    
    double s1 = [str2 doubleValue];
    int s2 = [str2 intValue];

    if (s1 / a - s2 / a > 0) {
        return NO;
        
    }

    return YES;
    
}




#pragma mark -- getter, setter

- (Hen_Configure *)configure
{
    if (!_configure) {
        _configure = [[Hen_Configure alloc] init];
    }
    return _configure;
}

@end
