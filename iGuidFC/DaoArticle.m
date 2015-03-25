//
//  DaoArticle.m
//  AMSlideMenu
//
//  Created by dampier on 14-3-4.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "DaoArticle.h"
#import "AppDelegate.h"
#import "POArticle.h"
#import "POSection.h"
#import "FCMapController.h"

@implementation DaoArticle

#define TableTypeTips   @"tips"
#define TableTypeAbout @"about"
#define TableTypeDavid @"david"
#define TableTypeChinaThing   @"ChinaThing"
#define TableTypeSpot   @"spot"
#define TableTypeArea   @"area"
#define TableTypeMysteries   @"Mysteries"
#define TableTypeToilet @"toilet"
#define TableTypeAtm @"atm"
#define TableTypeTaxi @"taxi"
#define TableTypeTicket @"ticket"
#define TableTypeSubway @"subway"
#define TableTypeShop @"shop"

//根据文章ID读取所有文章的段落集合
- (NSArray *)findAllArticleSectionsByID: (NSNumber *) masterID;
{
    NSMutableArray *data;
    sqlite3 *db = [AppDelegate openDB];
    NSString *strID = [masterID stringValue];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_articlesection where masterid = %@ order by orderno", strID];
    strID = nil;
    //[sqlQuery stringByAppendingString:  [masterID stringValue]];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        data = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            POSection *po = [[POSection alloc]init];
            
            int pid = sqlite3_column_int(statement, 0);
            po.primaryid  = [NSNumber numberWithInt:pid];
            
            char *type = (char*)sqlite3_column_text(statement, 2);
            po.type = [[NSString alloc]initWithUTF8String:type];
            
            char *content = (char*)sqlite3_column_text(statement, 3);
            if (content != NULL) {
                po.textcontent = [[NSString alloc]initWithUTF8String:content];
            }
            
            int bytes = sqlite3_column_bytes(statement, 4);
            Byte * image = (Byte*)sqlite3_column_blob(statement, 4);
            if (bytes !=0 && image != NULL)
            {
                NSData * data = [NSData dataWithBytes:image length:bytes];
                UIImage * img = [UIImage imageWithData:data];
                
                po.imagecontent = img;
                
            }
            
            po.positionx = sqlite3_column_double(statement, 5);
            po.positiony = sqlite3_column_double(statement, 6);
            
            char *imageName = (char*)sqlite3_column_text(statement, 7);
            if (imageName != NULL) {
                po.imagename = [[NSString alloc]initWithUTF8String:imageName];
            }
            
            char *startTime = (char*)sqlite3_column_text(statement, 9);
            if (startTime) {
                double startTime_ = sqlite3_column_double(statement, 9);
                po.starttime = [NSNumber numberWithDouble:startTime_];
            }

            char *endTime = (char*)sqlite3_column_text(statement, 10);
            if (endTime) {
                double endTime_ = sqlite3_column_double(statement, 10);
                po.endtime =[NSNumber numberWithDouble:endTime_];
            }
            
            char *startTime1 = (char*)sqlite3_column_text(statement, 11);
            if (startTime1) {
                double startTime_ = sqlite3_column_double(statement, 11);
                po.starttime1 = [NSNumber numberWithDouble:startTime_];
            }

            char *endTime1 = (char*)sqlite3_column_text(statement, 12);
            if (endTime1) {
                double endTime_ = sqlite3_column_double(statement, 12);
                po.endtime1 =[NSNumber numberWithDouble:endTime_];
            }
            
            [data addObject:po];
//            NSLog(@"name:%d",po.primaryid);
        }
    }
    sqlite3_close(db);
    
    return data;
}
//读取所有景点
- (NSArray *)findAllSpotsByLineNo:(int) lineNo;
{
    NSString *sqlQuery;
    switch (lineNo) {
        case 0:
        {
            sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_article where type = '%@' order by orderno", TableTypeSpot];
            break;
        }
        case 1:
        {
            sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_article where type = '%@' and line1no<>'null' order by line1no", TableTypeSpot];
            break;
        }
        case 2:
        {
            sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_article where type = '%@' and line2no<>'null' order by line2no", TableTypeSpot];
            break;
        }
        case 3:
        {
            sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_article where type = '%@' and line3no<>'null' order by line3no", TableTypeSpot];
            break;
        }
        default:
            break;
    }
    
    return [self queryArticleWithSQL:sqlQuery];
}

- (NSArray *)getAllSpots
{
    return [self getArticleByType:TableTypeSpot];
}
- (NSArray *)getAllTips
{
    return [self getArticleByType:TableTypeTips];
}
- (NSArray *)getAllAbout
{
    return [self getArticleByType:TableTypeAbout];
}
- (NSArray *)getAllDavid
{
    return [self getArticleByType:TableTypeDavid];
}
- (NSArray *)getAllChinaThing
{
    return [self getArticleByType:TableTypeChinaThing];
}
- (NSArray *)getAllArea
{
    return [self getArticleByType:TableTypeArea];
}
- (NSArray *)getAllMysteries
{
    return [self getArticleByType:TableTypeMysteries];
}
- (NSArray *)getAllToilet
{
    return [self getArticleByType:TableTypeToilet];
}
- (NSArray *)getAllAtm
{
    return [self getArticleByType:TableTypeAtm];
}

- (NSArray *)getAllShop
{
    return [self getArticleByType:TableTypeShop];
}

- (NSArray *)getAllTaxi
{
    return [self getArticleByType:TableTypeTaxi];
}
- (NSArray *)getAllTicket
{
    return [self getArticleByType:TableTypeTicket];
}
- (NSArray *)getAllSubway
{
    return [self getArticleByType:TableTypeSubway];
}

- (NSArray *)getAllSpots1 {
    NSString *sqlQuery = @"SELECT * FROM fc_article where type = 'spot' and line2no <> '' order by orderno";
    return [self queryArticleWithSQL:sqlQuery];
}

- (NSArray *)getArticleByType:(NSString *) tableType
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_article where type = '%@' order by orderno", tableType] ;
    return [self queryArticleWithSQL:sqlQuery];
}

- (NSArray *)getArticleByID:(NSString *) articleID
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fc_article where id = '%@'", articleID] ;
    return [self queryArticleWithSQL:sqlQuery];
}

- (NSArray *) queryArticleWithSQL:(NSString *) sqlQuery
{
    NSMutableArray *data;
    sqlite3 *db = [AppDelegate openDB];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        data = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            POArticle *poarticle = [[POArticle alloc]init];
            
            poarticle.primaryid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            
            char *name = (char*)sqlite3_column_text(statement, 1);
            if (name) {
                poarticle.title = [[NSString alloc]initWithUTF8String:name];
                name = nil;
            }
            
            poarticle.orderno = sqlite3_column_int(statement, 2);
            
            CLLocationCoordinate2D pos = [FCMapController offsetCoordinate:CLLocationCoordinate2DMake(sqlite3_column_double(statement, 3), sqlite3_column_double(statement, 4))];
#ifdef LT
            pos = CLLocationCoordinate2DMake(sqlite3_column_double(statement, 3), sqlite3_column_double(statement, 4));
#endif
            poarticle.positionx = pos.latitude;
            poarticle.positiony = pos.longitude;
            
            char *type = (char*)sqlite3_column_text(statement, 5);
            if (type) {
                poarticle.type = [[NSString alloc]initWithUTF8String:type];
                type = nil;
            }
            
            char *voicename = (char*)sqlite3_column_text(statement, 6);
            if (voicename) {
                poarticle.voice_filename = [[NSString alloc]initWithUTF8String:voicename];
                voicename = nil;
            }
            char *voicetype = (char*)sqlite3_column_text(statement, 7);
            if (voicetype) {
                poarticle.voice_filetype = [[NSString alloc]initWithUTF8String:voicetype];
                voicetype = nil;
            }
            
            char *remark = (char*)sqlite3_column_text(statement, 8);
            if (remark) {
                poarticle.remark = [[NSString alloc]initWithUTF8String:remark];
                remark = nil;
            }
            poarticle.line1no = sqlite3_column_int(statement, 9);
            poarticle.line2no = sqlite3_column_int(statement, 10);
            poarticle.line3no = sqlite3_column_int(statement, 11);
            
            char *imagename = (char*)sqlite3_column_text(statement, 12);
            if (imagename) {
                poarticle.imagename = [[NSString alloc]initWithUTF8String:imagename];
                imagename = nil;
            }
            
            char *link = (char*)sqlite3_column_text(statement, 13);
            if (link) {
                poarticle.link = [[NSString alloc]initWithUTF8String:link];
            }
            
            char *caption = (char*)sqlite3_column_text(statement, 14);
            if (caption) {
                poarticle.caption = [[NSString alloc]initWithUTF8String:caption];
            }
            
            char *picture = (char*)sqlite3_column_text(statement, 15);
            if (picture) {
                poarticle.picture = [[NSString alloc]initWithUTF8String:picture];
            }
            
            char *voice_filename1 = (char*)sqlite3_column_text(statement, 16);
            if (voice_filename1) {
                poarticle.voice_filename1 = [[NSString alloc]initWithUTF8String:voice_filename1];
            }
            
            [data addObject:poarticle];
            
            //            NSLog(@"name:%@", poarticle.title);
            poarticle = nil;
        }
    }
    statement = nil;
    sqlite3_close(db);
    db = nil;
    return data;
}

@end
