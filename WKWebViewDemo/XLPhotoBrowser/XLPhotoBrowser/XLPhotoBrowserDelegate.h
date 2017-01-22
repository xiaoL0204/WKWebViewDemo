//
//  XLPhotoBrowserDelegate.h
//  
//
//  Created by xiaoL on 16/11/30.
//  Copyright © 2016年 xiaolin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLPhotoBrowserAdapterDelegate <NSObject>
-(NSString *)fetchImageUrl;
-(NSString *)fetchImgDescrition;
@end


@protocol XLPhotoBrowserTapDelegate <NSObject>
@optional
-(void)handleTapPhotoViewWithItem:(id<XLPhotoBrowserAdapterDelegate>)item;
@end

