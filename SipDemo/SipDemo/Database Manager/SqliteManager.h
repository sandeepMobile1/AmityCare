//
//  SqliteManager.h
//  Amity-Care
//
//  Created by Vijay Kumar on 05/08/14.
//
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@class ContactD;

@interface SqliteManager : NSObject
{
    sqlite3 *database;
    NSString *databaseName,*databasePath;
}

+(SqliteManager *)sharedManager;

-(BOOL)addContact:(ContactD*)contact;

-(NSMutableArray*)contactsList;

-(NSString*)contactDisplayName:(NSString*)callId;

-(NSString*)contactImage:(NSString*)callId;

-(BOOL)checkRecordExists:(ContactD*)contact;

-(BOOL)deleteContact:(NSString *)callid;
@end
