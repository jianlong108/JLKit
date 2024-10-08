//
//  BLNewMusicListTableViewCell.h
//  BLCommunityModule
//
//  Created by JL on 2023/5/10.
//

#import <UIKit/UIKit.h>


@interface BLNewMusicListTableViewCellModel : NSObject
@property (nonatomic, assign) BOOL cellIsPlaying;
@end

@class BLNewMusicListTableViewCell;
@protocol BLNewMusicListTableViewCellDelegate <NSObject>

- (void)newMusicListCellDidClickPlayButton:(BLNewMusicListTableViewCell *)cell model:(BLNewMusicListTableViewCellModel *)model;


@end

@interface BLNewMusicListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLNewMusicListTableViewCellDelegate> delegate;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isInUse;
@property (nonatomic, strong) BLNewMusicListTableViewCellModel *model;
+ (CGFloat)rowHeight;
/// override by subclass
- (BOOL)hiddenGoOriginSoundEntranceView;
- (BOOL)hiddenFavoriteEntranceView;

@end

