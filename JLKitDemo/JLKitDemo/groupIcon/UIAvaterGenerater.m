//
//  UIAvaterGenerater.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/2.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "UIAvaterGenerater.h"
#import "GlobalFunction.h"
#import "UIImage+JL.h"


NSString * const MTAvaterGeneraterSize = @"MTAvaterGeneraterSize";
NSString * const MTAvaterGeneraterOuterMargin = @"MTAvaterGeneraterBackgroundOuterMargin";
NSString * const MTAvaterGeneraterInnerMargin = @"MTAvaterGeneraterBackgroundInnerMargin";
NSString * const MTAvaterGeneraterInnerCornerRadious = @"MTAvaterGeneraterBackgroundInnerCornerRadious";
NSString * const MTAvaterGeneraterOuterCornerRadious = @"MTAvaterGeneraterBackgroundOuterCornerRadious";
NSString * const MTAvaterGeneraterBackgroundColorAttributeName = @"MTAvaterGeneraterBackgroundColorAttributeName";

@implementation UIAvaterGenerater


#pragma mark - interface

+ (void)generateGroupImageWithImages:(NSArray <UIImage *>*)images completion:(void (^)(UIImage *image))completion{
    NSDictionary *dic = [self getAllPorpertyDicWith:nil];
    [self generateGroupImageWithImages:images attributes:dic completion:completion];
}

+ (void)generateGroupImageWithImages:(NSArray <UIImage *>*)images attributes:(NSDictionary *)attributeDic completion:(void (^)(UIImage *image))completion{
    NSDictionary *dic = [self getAllPorpertyDicWith:attributeDic];
    NSMutableDictionary *imagesIndexDic = [NSMutableDictionary dictionaryWithCapacity:images.count];
    for (UIImage *img in images) {
        NSUInteger index = [images indexOfObject:img];
        [imagesIndexDic setObject:img forKey:@(index)];
    }
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        UIImage *groupIcon = nil;
        NSData *imageData = [self createMultiImageData:imagesIndexDic attributes:dic];
        groupIcon = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(groupIcon);
            }
        });
    });
}

+ (void)generateGroupImageWithTop9UserIds:(NSArray <NSString *>*)top9UserIds
                               completion:(void (^)(UIImage *image))completion{
    NSDictionary *dic = [self getAllPorpertyDicWith:nil];
    [self generateGroupImageWithTop9UserIds:top9UserIds attributes:dic completion:completion];
}

+ (void)generateGroupImageWithTop9UserIds:(NSArray <NSString *>*)top9UserIds attributes:(NSDictionary *)attributeDic
                               completion:(void (^)(UIImage *image))completion{
    NSDictionary *dic = [self getAllPorpertyDicWith:attributeDic];
    [self generateGroupIconWithUsers:top9UserIds attributes:attributeDic completion:completion];
}

+ (void)generateGroupIconWithUsers:(NSArray<NSString *> *)users  attributes:(NSDictionary *)attributeDic completion:(void (^)(UIImage *))completion {
    NSMutableDictionary *imagesIndexDic = [NSMutableDictionary dictionaryWithCapacity:users.count];
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < users.count; i++) {
        NSString *userid = users[i];
//        NSURL *url = [[MTUserManager sharedInstance] avatarURLWithUID:userid];
        NSURL *url = [NSURL URLWithString:userid];
        if (url) {
            dispatch_group_enter(group);
//            [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:nil
//                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                                              dispatch_group_leave(group);
//                                                              if (!image) {
//                                                                  XMLogError(@"avatar downloader failed:%@",userid);
//                                                                  image = [MTUser defaultRoundedAvatar];
//                                                              }
//                                                              [imagesIndexDic setObject:image forKey:@(i).stringValue];
//                                                          }];
        }
    }
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        UIImage *groupIcon = nil;
        NSData *imageData = [self createMultiImageData:imagesIndexDic attributes:attributeDic];
        groupIcon = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(groupIcon);
            }
        });
    });
}

#pragma mark - draw

+ (NSData*)createMultiImageData:(NSDictionary*)imagesIndexDic attributes:(NSDictionary *)attributeDic
{
    float scale = [UIScreen mainScreen].scale;
    
    NSNumber *sizeNum = [attributeDic objectForKey:MTAvaterGeneraterSize];
    CGSize size = sizeNum.CGSizeValue;
    
    UIColor *backGroundColor = [attributeDic objectForKey:MTAvaterGeneraterBackgroundColorAttributeName];
    CGFloat outerCornerRadious = [[attributeDic objectForKey:MTAvaterGeneraterOuterCornerRadious] floatValue];
    CGFloat outerMargin = [[attributeDic objectForKey:MTAvaterGeneraterOuterMargin] floatValue];
    CGFloat innerCornerRadious = [[attributeDic objectForKey:MTAvaterGeneraterInnerCornerRadious] floatValue];
    
    outerCornerRadious *= scale;
    innerCornerRadious *= scale;
    outerMargin *= scale;
    
    int w = size.width * scale;
    int h = size.height * scale;
    
    // 画板.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, w, h) cornerRadius:outerCornerRadious];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextSaveGState(context);
    
    CGImageRef bgImageRef = [self createRoundedRectImage:[UIImage imageWithUIColor:backGroundColor] rect:CGRectMake(0,0,w,h) radius:outerCornerRadious].CGImage;
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), bgImageRef);
    CGContextSaveGState(context);
    
    NSInteger nums = [imagesIndexDic count];
    for (int i = 0; i < imagesIndexDic.count; i++) {
        UIImage *image = [imagesIndexDic objectForKey:@(i).stringValue];
        CGRect rect = [self elementRectForIndex:i style:nums attributes:attributeDic];
        
        rect = CGContextConvertRectToUserSpace(context, rect);
        if (image) {
            CGContextDrawImage(context, rect, image.CGImage);
        }
    }
    
    // 生成
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    UIImage *srcImg = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUpMirrored];
    CGImageRelease(imageMasked);
    
    NSData *imgData = UIImagePNGRepresentation(srcImg);
    
    return imgData;
}

#pragma mark - layout

+ (CGRect)elementRectForIndex:(int)i style:(int)styleNum attributes:(NSDictionary *)attributeDic{
    
    float scale = [UIScreen mainScreen].scale;
    
    CGFloat outerMargin = [[attributeDic objectForKey:MTAvaterGeneraterOuterMargin] floatValue];
    CGFloat innerMargin = [[attributeDic objectForKey:MTAvaterGeneraterInnerMargin] floatValue];
    outerMargin *= scale;
    innerMargin *= scale;
    
    NSNumber *sizeNum = [attributeDic objectForKey:MTAvaterGeneraterSize];
    CGSize size = sizeNum.CGSizeValue;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    width *= scale;
    height *= scale;
    
    
    int rowCount = 1;
    int columnCount = 1;
    if (styleNum < 3) {
        rowCount = 1;
        columnCount = styleNum;
    } else if (styleNum <= 4){
        rowCount = 2;
        columnCount = 2;
    } else {
        rowCount = styleNum/3 + (styleNum % 3 == 0?0:1);
        columnCount = 3;
    }
    
    CGFloat unitWidth = (width-(columnCount-1)*innerMargin - 2*outerMargin)/(columnCount == 1 ? 2 : columnCount);
    CGFloat unitHeight = (height-(rowCount-1)*innerMargin - 2*outerMargin)/(rowCount == 1 ? 2 : columnCount);//图片尺寸
    
    
    int rowNum = i / rowCount;
    int columnNum = i % columnCount;
    
    int t_center = (height + innerMargin)/2;//中间位置以下的顶点（有宫格间距）
    int b_center = (height - innerMargin)/2;//中间位置以上的底部（有宫格间距）
    int l_center = (width + innerMargin)/2;//中间位置以右的左部（有宫格间距）
    int r_center = (width - innerMargin)/2;//中间位置以左的右部（有宫格间距）
    
    int centerY = (height - unitHeight)/2;//中间位置以上顶部（无宫格间距）
    int centerX = (width - unitWidth)/2;//中间位置以上顶部（无宫格间距）
    
    int x = unitWidth * columnNum + innerMargin * columnNum + outerMargin;
    int y = unitWidth * rowNum + innerMargin * rowNum + outerMargin;
    switch (styleNum) {
        case 1:
        {
            return CGRectMake(centerX, centerY, unitWidth, unitHeight);
        }
            break;
        case 2:
        {
            return CGRectMake(x, centerY, unitWidth, unitHeight);
        }
            break;
        case 3:
        {
            if (i == 0) {
                return CGRectMake(centerX, y, unitWidth, unitHeight);
            } else {
                return CGRectMake(outerMargin + innerMargin* (i-1) +unitWidth * (i - 1), t_center, unitWidth, unitHeight);
            }
        }
            break;
        case 4:
        case 9:
        {
            return CGRectMake(x, y, unitWidth, unitHeight);
        }
            break;
        case 5:
        {
            if (i == 0) {
                return CGRectMake(r_center - unitWidth, r_center - unitWidth, unitWidth, unitHeight);
            } else if (i == 1) {
                return CGRectMake(l_center, r_center - unitWidth, unitWidth, unitHeight);
            } else {
                return CGRectMake(outerMargin + innerMargin * (i - 2) + unitWidth * (i - 2), t_center, unitWidth, unitHeight);
            }
        }
            break;
        case 6:
        {
            if(i < 3) {
                return CGRectMake(outerMargin + innerMargin * i +unitWidth * i, b_center - unitWidth, unitWidth, unitHeight);
            }else{
                return CGRectMake(outerMargin + innerMargin * (i - 3) +unitWidth * (i-3), t_center, unitWidth, unitHeight);
            }
        }
            break;
        case 7:
        {
            if (i == 0) {
                return CGRectMake(centerY, outerMargin, unitWidth, unitHeight);
            } else if (i > 0 && i < 4) {
                return CGRectMake(outerMargin + innerMargin * (i - 1) +unitWidth * (i - 1), centerY, unitWidth, unitHeight);
                
            } else {
                return CGRectMake(outerMargin + innerMargin * (i - 4) + unitWidth * (i - 4), t_center+unitHeight/2+innerMargin/2, unitWidth, unitHeight);
            }
        }
            break;
        case 8:
        {
            if (i == 0) {
                return CGRectMake(r_center - unitWidth, outerMargin, unitWidth, unitHeight);
            } else if (i == 1) {
                return CGRectMake(l_center, outerMargin, unitWidth, unitHeight);
            } else if (i > 1 && i < 5) {
                return CGRectMake(outerMargin + innerMargin * (i - 2) +unitWidth * (i - 2), centerY, unitWidth, unitHeight);
            } else {
                return CGRectMake(outerMargin + innerMargin * (i - 5) +unitWidth * (i - 5), t_center+unitHeight/2+innerMargin/2, unitWidth, unitHeight);
            }
        }
            break;
        default:
            return CGRectZero;
            break;
    }
    
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)createRoundedRectImage:(UIImage*)image rect:(CGRect)rect radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = CGRectGetWidth(rect);
    int h = CGRectGetHeight(rect);
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

+ (NSDictionary *)getAllPorpertyDicWith:(NSDictionary *)dic{
    NSMutableDictionary *dic_m = [NSMutableDictionary dictionary];
    
    NSNumber *sizeNumber = [dic objectForKey:MTAvaterGeneraterSize];
    if (sizeNumber) {
        [dic_m setObject:sizeNumber forKey:MTAvaterGeneraterSize];
    }else{
        [dic_m setObject:@(CGSizeMake(90 , 90)) forKey:MTAvaterGeneraterSize];
    }
    
    UIColor *backgroundColor = [dic objectForKey:MTAvaterGeneraterBackgroundColorAttributeName];
    if (backgroundColor) {
        [dic_m setObject:backgroundColor forKey:MTAvaterGeneraterBackgroundColorAttributeName];
    }else{
        [dic_m setObject:UIColorFromRGB(0xd8d8d8) forKey:MTAvaterGeneraterBackgroundColorAttributeName];
    }
    
    NSNumber *outerMarginNumber = [dic objectForKey:MTAvaterGeneraterOuterMargin];
    if (outerMarginNumber) {
        [dic_m setObject:outerMarginNumber forKey:MTAvaterGeneraterOuterMargin];
    }else{
        [dic_m setObject:@(1.5) forKey:MTAvaterGeneraterOuterMargin];
    }
    
    NSNumber *innerMarginNumber = [dic objectForKey:MTAvaterGeneraterInnerMargin];
    if (innerMarginNumber) {
        [dic_m setObject:innerMarginNumber forKey:MTAvaterGeneraterInnerMargin];
    }else{
        [dic_m setObject:@(1) forKey:MTAvaterGeneraterInnerMargin];
    }
    
    NSNumber *innerCornerRadious = [dic objectForKey:MTAvaterGeneraterInnerCornerRadious];
    if (innerCornerRadious) {
        [dic_m setObject:innerCornerRadious forKey:MTAvaterGeneraterInnerCornerRadious];
    }else{
        [dic_m setObject:@(7) forKey:MTAvaterGeneraterInnerCornerRadious];
    }
    
    NSNumber *outerCornerRadious = [dic objectForKey:MTAvaterGeneraterOuterCornerRadious];
    if (outerCornerRadious) {
        [dic_m setObject:outerCornerRadious forKey:MTAvaterGeneraterOuterCornerRadious];
    }else{
        [dic_m setObject:@(7) forKey:MTAvaterGeneraterOuterCornerRadious];
    }
    
    return [dic_m copy];
}

#pragma mark - 图片裁剪增加圆环 暂时保留

//+ (UIImage*)circleImageWithClip:(UIImage*)image offsetX:(float)offsetX offsetY:(float)offsetY
//{
//    UIGraphicsBeginImageContext(image.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    float width = image.size.width;
//    float height = image.size.height;
//    CGRect rect = CGRectMake(0, 0, width, height);
//
//    CGContextAddArc(context, width/2, height/2, width/2, 0, 2 * M_PI, 1);
//    CGContextClip(context);
//
//    CGContextAddArc(context, width/2+offsetX, height/2+offsetY, width/2, 0, 2 * M_PI, 1);
//    CGContextAddRect(context, CGContextGetClipBoundingBox(context));
//    CGContextEOClip(context);
//
//    [image drawInRect:rect];
//
//    CGContextSetLineWidth(context,[UIScreen mainScreen].scale*4);
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextAddEllipseInRect(context, rect);
//    CGContextStrokePath(context);
//
//    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newimg;
//}


//+ (UIImage*) circleImage:(UIImage*) image {
//    if (!image) {
//        return nil;
//    }
//    UIGraphicsBeginImageContext(image.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
//
//    [image drawInRect:rect];
//
//    CGContextSetLineWidth(context, [UIScreen mainScreen].scale*4);
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextAddEllipseInRect(context, rect);
//    CGContextStrokePath(context);
//
//    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newimg;
//}
@end
