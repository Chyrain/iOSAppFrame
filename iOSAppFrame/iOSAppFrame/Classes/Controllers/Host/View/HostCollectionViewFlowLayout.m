//
//  HostCollectionViewFlowLayout.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/3.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HostCollectionViewFlowLayout.h"

@implementation HostCollectionViewFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewScrollDirection)scrollDirection
{
    return UICollectionViewScrollDirectionVertical;
}

//拉伸放大效果
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    UICollectionView *collectionView = [self collectionView];
    CGPoint offset = [collectionView contentOffset];
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    if (offset.y<0) {
        CGFloat deltaY = fabs(offset.y);
        for (UICollectionViewLayoutAttributes *attrs in attributes ) {
            NSString *kind = [attrs representedElementKind];
            if (kind == UICollectionElementKindSectionHeader) {
                CGSize headerSize = [self headerReferenceSize];
                CGRect headRect = [attrs frame];
                headRect.size.height = headerSize.height + deltaY;
                headRect.size.width = headerSize.width + deltaY;
                headRect.origin.y = headRect.origin.y - deltaY;
                headRect.origin.x = headRect.origin.x - deltaY/2;
                [attrs setFrame:headRect];
                break;
            }
        }
        
    }
    
    return attributes;
}


@end
