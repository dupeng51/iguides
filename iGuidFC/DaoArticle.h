//
//  DaoArticle.h
//  AMSlideMenu
//
//  Created by dampier on 14-3-4.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POCity.h"
#import "POSpot.h"

@interface DaoArticle : NSObject

- (NSArray *)findAllArticleSectionsByID: (NSNumber *) masterID;

- (NSArray *)findAllSpotsByLineNo:(int) lineNo;

//获取tabeletype为ChinaThing的数据
//- (NSArray *)getArticleByType:(NSString *) tableType;
- (NSArray *)getAllSpotsWithSpotid:(NSString *) spotid;
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
- (NSArray *)getAllCheckpoint;

- (NSArray *)getArticleByID:(NSString *) articleID;

-(NSArray *) getAllCitys;
-(POCity *) getCityWithID:(NSString *) cityid;

-(NSArray *) getAllBigSpot;
-(NSArray *) getDownloadBigSpot;
-(BOOL) setBigSpotWithDownloadStatus:(int) downloadStatus spotid:(NSString *) spotid;
-(NSArray *) getBigSpotWithCityID:(NSString *) cityid;
-(POSpot *) getBigSpotWithID:(NSString *) spotid;


@end
