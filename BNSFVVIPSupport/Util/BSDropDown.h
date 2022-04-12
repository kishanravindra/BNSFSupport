//
//  BSDropDown.h
//  DropDownExample
//
//  Created by Bisma on 22/03/2017.
//  Copyright © 2017 Bisma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSDropDownDelegate <NSObject>
@required
-(void)dropDownView:(UIView*)ddView AtIndex:(NSInteger)selectedIndex ;
@end

@interface BSDropDown : UIView<UITableViewDelegate,UITableViewDataSource>

- (id) initWithWidth:(float)width withHeightForEachRow:(float)height originPoint:(CGPoint)originPoint withOptions:(NSArray*)options;

@property (nonatomic) NSInteger selectedIndex;
@property (weak,nonatomic) id<BSDropDownDelegate> delegate;

-(void)addAsSubviewTo:(UIView*)parentView;

-(void)setDropDownFont:(UIFont*)font;
-(void)setDropDownBGColor:(UIColor*)color;
-(void)setDropDownTextColor:(UIColor*)color;

@end
