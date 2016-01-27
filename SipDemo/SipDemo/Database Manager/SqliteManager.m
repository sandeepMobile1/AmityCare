//
//  SqliteManager.m
//  Amity-Care
//
//  Created by Vijay Kumar on 05/08/14.
//
//

#import "SqliteManager.h"
#import "ContactD.h"
#import <sqlite3.h>

@implementation SqliteManager

static SqliteManager *sharedInstance = nil;


+ (SqliteManager *)sharedManager
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance =[[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        
		BOOL success;
		databaseName = @"recentcalldb.sql";
		
        // Get the path to the documents directory and append the databaseName
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
        
		databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
		// Create a FileManager object, we will use this to check the status
		// of the database and to copy it over if required
        
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		// Check if the database has already been created in the users filesystem
		success = [fileManager fileExistsAtPath:databasePath];
		
		// If the database already exists then return without doing anything
		if(!success) {
			NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
			
			// Copy the database from the package to the users filesystem
			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
			//[fileManager release];
			
		}
		// If not then proceed to copy the database from the application to the users filesystem
		// Get the path to the database in the application package
		
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			NSLog(@"database open");
		}
	}
	sqlite3_exec(database, "PRAGMA synchronous = FULL;", NULL, NULL, NULL);
	return self;
}

-(BOOL)addContact:(ContactD*)contact
{
    NSString *tempStr = @"INSERT INTO Contact (contact_id,online,request_status,\
    sipipaddress,sippassword,sipusername,\
    user_id,user_img,username) VALUES \
    (?, ?, ?,\
    ?, ?, ? ,\
    ?, ?, ?)";
	sqlite3_stmt *sqlStatement = nil;

    NSLog(@"QUERY =%@",tempStr);
    const char *sql = [tempStr UTF8String];
	if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
	{
        sqlite3_bind_text(sqlStatement, 1, [contact.contact_id UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 2, [contact.isOnline?@"Yes":@"No" UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 3, [contact.request_status UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 4, [contact.sip.ipAddress UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 5, [contact.sip.password UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 6, [contact.sip.username UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 7, [contact.userid UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 8, [contact.image UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 9, [contact.userName UTF8String], -1,SQLITE_TRANSIENT);
	}
    
	int i = sqlite3_step(sqlStatement);
    sqlite3_finalize(sqlStatement);

	if(SQLITE_DONE != i){
       // NSString *temp = [NSString stringWithFormat:@"%d = %s",i, sqlite3_errmsg(database)];
		//NSAssert1(0, @"Error while inserting into Contacts. '%s'", [temp UTF8String]);
        return false;
	}
    
    return TRUE;
}

-(NSMutableArray*)contactsList
{
    NSMutableArray *contactsArray = nil;
    
    sqlite3_stmt *sqlStatement = nil;
    NSString *tempQuery=[NSString stringWithFormat:@"SELECT * FROM Contact"];
    const char *sql = [tempQuery UTF8String];
    
	if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
        contactsArray = [[NSMutableArray alloc] init];
		while (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
            ContactD *cData=[[ContactD alloc]  init];
            cData.contact_id=(((char *)sqlite3_column_text(sqlStatement, 0)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 0)];
            cData.isOnline=(((char *)sqlite3_column_text(sqlStatement, 1)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
            cData.request_status=(((char *)sqlite3_column_text(sqlStatement, 2)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
            cData.sip.ipAddress=(((char *)sqlite3_column_text(sqlStatement, 3)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)];
            cData.sip.password=(((char *)sqlite3_column_text(sqlStatement, 4)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
            cData.sip.username=(((char *)sqlite3_column_text(sqlStatement, 5)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 5)];
            cData.userid=(((char *)sqlite3_column_text(sqlStatement, 6)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 6)];
            
            cData.image=(((char *)sqlite3_column_text(sqlStatement, 7)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 7)];
            cData.userName=(((char *)sqlite3_column_text(sqlStatement, 8)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 8)];
            
            [contactsArray addObject:cData];
            [cData release];
        }
        
    }
	sqlite3_finalize(sqlStatement);
    return contactsArray;
}

-(NSString*)contactDisplayName:(NSString*)callId{

    NSString *strResult = callId;
    sqlite3_stmt *sqlStatement = nil;
    NSString *tempQuery=[NSString stringWithFormat:@"SELECT username FROM Contact WHERE sipusername =%@",callId];
    const char *sql = [tempQuery UTF8String];
    
	if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
        
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
            strResult=(((char *)sqlite3_column_text(sqlStatement, 0)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 0)];
        }
    }
	sqlite3_finalize(sqlStatement);
    return strResult;
}

-(NSString*)contactImage:(NSString*)callId{
    NSString *strResult = callId;
    sqlite3_stmt *sqlStatement = nil;
    NSString *tempQuery=[NSString stringWithFormat:@"SELECT user_img FROM Contact WHERE sipusername =%@",callId];
    const char *sql = [tempQuery UTF8String];
    
	if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
        
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
            strResult=(((char *)sqlite3_column_text(sqlStatement, 0)) == nil)? @"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 0)];
        }
    }
	sqlite3_finalize(sqlStatement);
    return strResult;
}

-(BOOL)checkRecordExists:(ContactD*)contact
{
    
    int count =0;
    sqlite3_stmt *sqlStatement = nil;
    NSString *tempQuery=[NSString stringWithFormat:@"SELECT COUNT(*) FROM Contact WHERE sipusername =%@",contact.sip.username];
    
    const char *sql = [tempQuery UTF8String];
    
	if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
        
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
            count = sqlite3_column_int(sqlStatement, 0);
            NSLog(@"Contact Count %d",count);
        }
    }
    return count;
}

-(BOOL)deleteContact:(NSString *)callid
{
    sqlite3_stmt *sqlStatement = nil;
    NSString *deleteQry =@"";
    deleteQry = [NSString stringWithFormat:@"Delete FROM Contact WHERE sipusername=%@",callid];
    const char *sql = [deleteQry UTF8String];
    BOOL returnValue = NO;
	if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
		
        if(sqlite3_step(sqlStatement)==SQLITE_DONE)
            returnValue = YES;
    }
    
	sqlite3_finalize(sqlStatement);
    return returnValue;
}

@end
