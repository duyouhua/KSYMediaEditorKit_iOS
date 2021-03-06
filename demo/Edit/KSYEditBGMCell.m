//
//  KSYEditBGMCell.m
//  demo
//
//  Created by sunyazhou on 2017/7/13.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import "KSYEditBGMCell.h"

#import <KYAnimatedPageControl/KYAnimatedPageControl.h>

#import "KSYBgmCell.h"
#import "KSYBgmLayout.h"
#import "KSYBgMusicModel.h"

@interface KSYEditBGMCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) IBOutlet UICollectionView *bgmusicCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *originalSoundLabel; //原声
@property (weak, nonatomic) IBOutlet UISlider *originSoundSlider;
@property (weak, nonatomic) IBOutlet UILabel *bgMucisLabel; //配乐
@property (weak, nonatomic) IBOutlet UISlider *bgMusicSlider;
@property (weak, nonatomic) IBOutlet UILabel *changeToneLabel; //变调
//@property (weak, nonatomic) IBOutlet UISlider *changeToneSlider;
@property (nonatomic, strong) NSMutableArray<KSYBgMusicModel *> *models;
@property (nonatomic, strong) NSIndexPath    *lastSelectedIndexPath;

@property (strong, nonatomic) KYAnimatedPageControl *levelControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pageControlCollectionView;
@property (nonatomic, strong) NSArray *levels; //变调级别
@end

@implementation KSYEditBGMCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    [self configSubviews];
    [self setupModels];
    
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.bgmusicCollectionView reloadData];
}

- (void)setupModels{
    if (self.models == nil) {
        self.models = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.models removeAllObjects];
    
    NSArray *songNames = @[@"",@"Faded", @"Immortals", @"加州旅馆"];
    NSArray *images = @[@"关闭效果",@"Faded",@"Immortals",@"CA_hotel"];
    
    NSString *song1 = [[NSBundle mainBundle] pathForResource:@"faded_out" ofType:@"mp3"];
    NSString *song2 = [[NSBundle mainBundle] pathForResource:@"Immortals_out" ofType:@"mp3"];
    NSString *song3 = [[NSBundle mainBundle] pathForResource:@"Hotel_California_out2" ofType:@"mp3"];
    NSArray *songs = @[@"",song1,song2,song3];
    
    for (int i = 0; i < songs.count; i++) {
        KSYBgMusicModel *model = [[KSYBgMusicModel alloc] init];
        model.bgmName = [songNames objectAtIndex:i];
        model.bgmImageName = [images objectAtIndex:i];
        model.bgmPath = [songs objectAtIndex:i];
        if (i == 0) {
            model.isSelected = YES;
        } else {
            model.isSelected = NO;
        }
        [self.models addObject:model];
    }
    
    
    self.levels = @[@"-3",@"-2",@"-1",@"0",@"1",@"2",@"3"];
    self.levelControl = [[KYAnimatedPageControl alloc]
                              initWithFrame:CGRectMake(31 + 12 + 50, 180-31 - 10, kScreenWidth - 31 -31- 12- 50, 31)];
    self.levelControl.selectedPage = 2;
    self.levelControl.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.levelControl.selectedColor = [UIColor redColor];
    self.levelControl.shouldShowProgressLine = NO;
    self.levelControl.indicatorStyle = IndicatorStyleGooeyCircle;
    self.levelControl.indicatorSize = 20;
    self.levelControl.swipeEnable = YES;
    self.levelControl.pageCount = self.levels.count;
    self.levelControl.hidden = YES;
    @weakify(self)
    
    self.levelControl.didSelectIndexBlock = ^(NSInteger index) {
        @strongify(self)
        if ([self.audioEffectDelegate respondsToSelector:@selector(audioEffectType:andValue:)]) {
            [self.audioEffectDelegate audioEffectType:KSYMEAudioEffectTypeChangeTone andValue:index];
        }
        
        
    };
    self.levelControl.bindScrollView = self.pageControlCollectionView;
    [self addSubview:self.levelControl];
    
    
    CGFloat wh = self.levelControl.width/self.levels.count;
    for (NSUInteger i = 0; i < self.levels.count; i++) {
        UILabel *itemView = [self generateNewAttachmentLabelWithContent:self.levels[i]];
        [self.levelControl addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@(wh));
            make.centerY.equalTo(self.levelControl.mas_centerY).offset(15);
            make.centerX.equalTo(self.levelControl.mas_right).multipliedBy(((CGFloat)i + 1) / ((CGFloat)self.levels.count + 1)).offset(0);
        }];
    }
}

- (void)configSubviews{
    
    //背景音乐选择
    
    [self.bgmusicCollectionView registerNib:[UINib nibWithNibName:[KSYBgmCell className] bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[KSYBgmCell className]];
    KSYBgmLayout *layout = [[KSYBgmLayout alloc] initSize:CGSizeMake(63, 63)];
    self.bgmusicCollectionView.collectionViewLayout = layout;
    [self.bgmusicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(31);
        make.right.equalTo(self).offset(-31);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@63);
    }];
    
    //原声
    [self.originalSoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgmusicCollectionView.mas_left);
        make.top.mas_equalTo(self.bgmusicCollectionView.mas_bottom).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
    }];
    [self.originSoundSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.originalSoundLabel.mas_right).offset(12);
        make.right.equalTo(self.bgmusicCollectionView.mas_right);
        make.centerY.equalTo(self.originalSoundLabel.mas_centerY);
    }];
    
    //配乐
    [self.bgMucisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.originalSoundLabel);
        make.top.mas_equalTo(self.originalSoundLabel.mas_bottom).offset(16);
        
    }];
    [self.bgMusicSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.originSoundSlider);
        make.centerY.mas_equalTo(self.bgMucisLabel.mas_centerY);
    }];
    
    
    //变调
    [self.changeToneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.bgMucisLabel);
        make.top.mas_equalTo(self.bgMucisLabel.mas_bottom).offset(16);
        
    }];
    self.changeToneLabel.hidden = YES;
//    [self.changeToneSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.bgMusicSlider);
//        make.centerY.mas_equalTo(self.changeToneLabel.mas_centerY);
//    }];

    
    [self.pageControlCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kKSYEditTimeCollectionViewCell"];
    [self.pageControlCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@0);
    }];
}


#pragma mark -
#pragma mark - UICollectionView Delegate代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.pageControlCollectionView) {
        return self.levels.count;
    }
    return self.models.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.pageControlCollectionView) {
        static NSString *identify = @"kKSYEditTimeCollectionViewCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UICollectionViewCell alloc] init];
        }
        return cell;
    }
    KSYBgmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KSYBgmCell className] forIndexPath:indexPath];
    cell.model = [self.models objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.pageControlCollectionView) { return; }
    KSYBgMusicModel *lastModel = [self.models objectAtIndex:self.lastSelectedIndexPath.row];
    KSYBgMusicModel *selectedModel = [self.models objectAtIndex:indexPath.row];
    if (self.lastSelectedIndexPath == indexPath) {
        //选择同一个cell
        selectedModel.isSelected = !selectedModel.isSelected;
    } else {
        lastModel.isSelected = NO;
        [collectionView reloadItemsAtIndexPaths:@[self.lastSelectedIndexPath]];
        selectedModel.isSelected = YES;
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    self.lastSelectedIndexPath = indexPath;
    [collectionView scrollToItemAtIndexPath:self.lastSelectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(bgMusicView:songFilePath:)]) {
        [self.delegate bgMusicView:self songFilePath:selectedModel.bgmPath];
    }
}

- (IBAction)originSoundValueChange:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(bgMusicView:audioVolumnType:andValue:)]) {
        [self.delegate bgMusicView:self audioVolumnType:KSYMEAudioVolumnTypeMicphone andValue:sender.value];
    }
}

- (IBAction)bgmusicValueChange:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(bgMusicView:audioVolumnType:andValue:)]) {
        [self.delegate bgMusicView:self audioVolumnType:KSYMEAudioVolumnTypeBgm andValue:sender.value];
    }
}


- (IBAction)toneValueChange:(UISlider *)sender {
    if ([self.audioEffectDelegate respondsToSelector:@selector(audioEffectType:andValue:)]) {
        [self.audioEffectDelegate audioEffectType:KSYMEAudioEffectTypeChangeTone andValue:(NSInteger)sender.value];
    }
}



- (UILabel *)generateNewAttachmentLabelWithContent:(NSString *)content {
    UILabel *label = [UILabel new];
    
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 2.0f;
    
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    label.text = content;
    [label sizeToFit];
    
    return label;
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.pageControlCollectionView) { return; }
    // Indicator动画
    [self.levelControl.indicator animateIndicatorWithScrollView:scrollView
                                                        andIndicator:self.levelControl];
    
    if (scrollView.dragging || scrollView.isDecelerating || scrollView.tracking) {
        //背景线条动画
        [self.levelControl.pageControlLine
         animateSelectedLineWithScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.pageControlCollectionView) { return; }
    self.levelControl.indicator.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.pageControlCollectionView) { return; }
    [self.levelControl.indicator
     restoreAnimation:@(1.0 / self.levelControl.pageCount)];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView != self.pageControlCollectionView) { return; }
    self.levelControl.indicator.lastContentOffset = scrollView.contentOffset.x;
}

@end
