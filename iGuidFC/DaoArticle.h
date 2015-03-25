//
//  DaoArticle.h
//  AMSlideMenu
//
//  Created by dampier on 14-3-4.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaoArticle : NSObject

- (NSArray *)findAllArticleSectionsByID: (NSNumber *) masterID;

- (NSArray *)findAllSpotsByLineNo:(int) lineNo;

//获取tabeletype为ChinaThing的数据
//- (NSArray *)getArticleByType:(NSString *) tableType;
- (NSArray *)getAllTips;
- (NSArray *)getAllSpots;
- (NSArray *)getAllSpots1;
- (NSArray *)getAllChinaThing;
- (NSArray *)getAllArea;
- (NSArray *)getAllMysteries;
- (NSArray *)getAllToilet;
- (NSArray *)getAllAtm;
- (NSArray *)getAllTaxi;
- (NSArray *)getAllTicket;
- (NSArray *)getAllSubway;
- (NSArray *)getAllAbout;
- (NSArray *)getAllDavid;
- (NSArray *)getAllShop;

- (NSArray *)getArticleByID:(NSString *) articleID;

@end
