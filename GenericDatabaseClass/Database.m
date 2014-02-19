 


#import "Database.h"
static Database *shareDatabase =nil;

@implementation Database
#pragma mark -
#pragma mark Database


void sqlite_power(sqlite3_context *context, int argc, sqlite3_value **argv) {
    double num = sqlite3_value_double(argv[0]); // get the first arg to the function
    double exp = sqlite3_value_double(argv[1]); // get the second arg
    double res = pow(num, exp);                 // calculate the result
    sqlite3_result_double(context, res);        // save the result
}

-(void) registerPowerFunctionWith:(sqlite3 *)dataBase{
 
    sqlite3_create_function(dataBase, "POWER", 2, SQLITE_UTF8, NULL, &sqlite_power, NULL, NULL);
    //int res = sqlite3_create_function(dataBase, "POWER", 2, SQLITE_UTF8, NULL, &sqlite_power, NULL, NULL);
    
}

+(Database*) shareDatabase{
	
	if(!shareDatabase){
		shareDatabase = [[Database alloc] init];
	}
	
	return shareDatabase;
	
}

#pragma mark -
#pragma mark Get DataBase Path
NSString * const DataBaseName  = @"Investitore.rdb"; // Paas Your DataBase Name Over here

//-(id) init{
//    self = [super init];
//    int res = sqlite3_create_function(databaseObj, "POWER", 2, SQLITE_UTF8, NULL, &sqlite_power, NULL, NULL);
//    return self;
//}

-(void) dealloc{
    [super dealloc];
}

- (NSString *) GetDatabasePath:(NSString *)dbName{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:dbName];
}

+(Database*) newDatabase{
    return [[Database alloc] init];
}

-(BOOL) createEditableCopyOfDatabaseIfNeeded
{
    BOOL success; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DataBaseName];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return success;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DataBaseName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!!" message:@"Failed to create writable database" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
        }
    return success;
}


#pragma mark -
#pragma mark Get All Record

-(NSMutableArray *)SelectAllFromTable:(NSString *)query
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
                        //columnData = [NSString stringWithUTF8String:data];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:currentRow];
			}
		}
		sqlite3_finalize(statement); 
	}
    
	if(sqlite3_close(databaseObj) == SQLITE_OK){
    
    }else{
        /////     *****NSLog( @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return [alldata retain];

}

-(NSMutableArray *)SelectAllFromTableWithLog:(NSString *)query
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
     
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{
				
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:[currentRow retain]];
			}
		}
		sqlite3_finalize(statement);
	}
    
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        /////     *****NSLog( @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return [alldata retain];
    
}


-(NSMutableArray *) getFirstColumnForQuery:(NSString *)query{
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{
				
				NSString *dataValue = @"";
                
                char *data = (char*) sqlite3_column_text(statement, 0);
				
                if(data != nil){
                    dataValue = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
                }
				
				[alldata addObject:dataValue];
			}
		}
		sqlite3_finalize(statement);
	}
    
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        /////     *****NSLog( @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return [alldata retain];
}

-(NSMutableArray *)SelectAllFromTableForBackGround:(NSString *)query
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:[currentRow retain]];
			}
		}
		sqlite3_finalize(statement); 
	}
    
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        /////     *****NSLog( @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return [alldata retain];
    
}

#pragma mark -
#pragma mark Get Record Count

-(int)getCount:(NSString *)query
{
	int m_count=0;
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{	
				m_count= sqlite3_column_int(statement,0);
			}
		}
		sqlite3_finalize(statement); 
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
       //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return m_count;
}

#pragma mark -
#pragma mark Check For Record Present

-(BOOL)CheckForRecord:(NSString *)query
{	
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	int isRecordPresent = 0;
		
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{
				isRecordPresent = 1;
			}
			else {
				isRecordPresent = 0;
			}
		}
	}
	sqlite3_finalize(statement);	
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }	
	return isRecordPresent;
}

#pragma mark -
#pragma mark Insert

- (void)Insert:(NSString *)query 
{	
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement,NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
        else {
            NSAssert1(0, @"Error: inssert is not work  '%s'.", sqlite3_errmsg(databaseObj));
        }
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
       // NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}
- (void)InsertForBackGround:(NSString *)query 
{	
    
    
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement,NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
        else {
            NSAssert1(0, @"Error: inssert is not work  '%s'.", sqlite3_errmsg(databaseObj));
        }
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        // NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}


//Union query
//        INSERT INTO 'tablename'
//        SELECT 'data1' AS 'column1', 'data2' AS 'column2'
//        UNION SELECT 'data3', 'data4'
//        UNION SELECT 'data5', 'data6'
//        UNION SELECT 'data7', 'data8'

//Union query using parameterized query
//        INSERT INTO 'tablename'
//        SELECT ? AS 'column1', ? AS 'column2'
//        UNION SELECT ?, ?
//        UNION SELECT ?, ?
//        UNION SELECT ?, ?

//Add Multiple records in Dictionary of Arrays format (There is limit of insertion of 500 records in one attempt but this method can insert more than 500 records)
- (void)insertMultipleRecordsWithDictionary:(NSMutableDictionary *)dictParameter inTable:(NSString *)tableName {
	sqlite3_stmt *insertStmt = nil;
    
    NSString *path = [self GetDatabasePath:@"SQL.sqlite"];
    
    NSArray *arrTotalField = [dictParameter allKeys];
    
    NSInteger intNumberOfTotalRecords = [[dictParameter valueForKey:[arrTotalField objectAtIndex:0]] count];
    NSInteger intCountOfInsertion = ceil((float)intNumberOfTotalRecords/500);
    NSLog(@"%d",intCountOfInsertion);
        
    int count = 0;
    while (intCountOfInsertion > 0) {
        
        int maximumLimit;
        
        if (intNumberOfTotalRecords > 500*(count+1)) {
            maximumLimit = 500*(count+1);
        }
        else {
            maximumLimit = intNumberOfTotalRecords;
        }
        
        
        if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
        {
            
            NSString *strQuery = [NSString stringWithFormat:@"insert into %@ (%@) select ? as %@",tableName,[arrTotalField componentsJoinedByString:@","],[arrTotalField objectAtIndex:0]];
            
            //For second line of query SELECT 'data1' AS 'column1', 'data2' AS 'column2'
            for (int i = 1; i<[dictParameter count]; i++) {
                strQuery = [strQuery stringByAppendingFormat:@" ,? as %@",[arrTotalField objectAtIndex:i]];
            }
            
            strQuery = [strQuery stringByAppendingFormat:@"\n"];
            
            int intInitialNumber = (500*count)+1;
            //For another union statements
            for (int j = intInitialNumber; j < maximumLimit; j++) {
                
                strQuery = [strQuery stringByAppendingFormat:@"UNION SELECT ?"];
                
                for (int i = 1; i<[dictParameter count]; i++) {
                    
                    strQuery = [strQuery stringByAppendingFormat:@" , ?"];
                }
                strQuery = [strQuery stringByAppendingFormat:@"\n"];
            }
            
            NSLog(@"Query String :%@",strQuery);
            
            const char *sql =  [strQuery UTF8String];
            
            if(sqlite3_prepare_v2(databaseObj, sql, -1, &insertStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(databaseObj));
            
            //For data binding..
            int counter = 1;
            for (int j = intInitialNumber-1; j < maximumLimit; j++) {
                for (int i = 0; i<[dictParameter count]; i++) {
                    
                    NSString *recordValue = [NSString stringWithFormat:@"%@",[[dictParameter valueForKey:[NSString stringWithFormat:@"%@",[arrTotalField objectAtIndex:i]]] objectAtIndex:j]];
                    
                    sqlite3_bind_text(insertStmt, counter, [recordValue UTF8String], -1, SQLITE_TRANSIENT);
                    
                    counter++;
                }
            }
            
            if(SQLITE_DONE != sqlite3_step(insertStmt))
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(databaseObj));

            //Reset the add statement.
            sqlite3_reset(insertStmt);
            
            sqlite3_finalize(insertStmt);
            sqlite3_close(databaseObj);
            
            intCountOfInsertion--;
            count++;
        }
    }
}

//Add Multiple records in Array of Dictionaries format (There is limit of insertion of 500 records in one attempt but this method can insert more than 500 records)
- (void)insertMultipleRecordsWithArray:(NSMutableArray *)arrayParameter inTable:(NSString *)tableName {
    
	sqlite3_stmt *insertStmt = nil;
	
    NSString *path = [self GetDatabasePath:@"SQL.sqlite"];
    
    NSArray *arrTotalField = [[arrayParameter objectAtIndex:0] allKeys];
    
    NSInteger intNumberOfTotalRecords = [arrayParameter count];
    NSInteger intCountOfInsertion = ceil((float)intNumberOfTotalRecords/500);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    int count = 0;
    while (intCountOfInsertion > 0) {
        
        [tempArray removeAllObjects];
        
        int maximumLimit;
        
        if (intNumberOfTotalRecords > 500*(count+1)) {
            maximumLimit = 500*(count+1);
        }
        else {
            maximumLimit = intNumberOfTotalRecords;
        }
        
        for (int i = 500*count ; i<maximumLimit; i++) {
            [tempArray addObject:[arrayParameter objectAtIndex:i]];
        }
        
        if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
        {
            
            NSString *strQuery = [NSString stringWithFormat:@"insert into %@ (%@) select ? as %@",tableName,[arrTotalField componentsJoinedByString:@","],[arrTotalField objectAtIndex:0]];
            
            //For second line of query SELECT 'data1' AS 'column1', 'data2' AS 'column2'
            for (int i = 1; i<[arrTotalField count]; i++) {
                strQuery = [strQuery stringByAppendingFormat:@" ,? as %@",[arrTotalField objectAtIndex:i]];
            }
            
            strQuery = [strQuery stringByAppendingFormat:@"\n"];
            
            //For another union statements
            for (int j = 1; j < [tempArray count]; j++) {
                
                strQuery = [strQuery stringByAppendingFormat:@"UNION SELECT ?"];
                
                for (int i = 1; i<[arrTotalField count]; i++) {
                    
                    strQuery = [strQuery stringByAppendingFormat:@" , ?"];
                }
                strQuery = [strQuery stringByAppendingFormat:@"\n"];
            }
            
            NSLog(@"Query String :%@",strQuery);
            
            const char *sql =  [strQuery UTF8String];
            
            if(sqlite3_prepare_v2(databaseObj, sql, -1, &insertStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(databaseObj));
            
            //For data binding..
            int counter = 1;
            for (int j = 0; j < [tempArray  count]; j++) {
                for (int i = 0; i<[arrTotalField count]; i++) {
                    NSString *recordValue = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:j] valueForKey:[NSString stringWithFormat:@"%@",[arrTotalField objectAtIndex:i]]]];
                    
                    sqlite3_bind_text(insertStmt, counter, [recordValue UTF8String], -1, SQLITE_TRANSIENT);
                    counter++;
                    
                }
            }
            
            if(SQLITE_DONE != sqlite3_step(insertStmt))
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(databaseObj));
            
            //Reset the add statement.
            sqlite3_reset(insertStmt);
            
            sqlite3_finalize(insertStmt);
            sqlite3_close(databaseObj);
            
            intCountOfInsertion--;
            count++;
            
        }
    }
}


#pragma mark -
#pragma mark DeleteRecord

-(void)Delete:(NSString *)query
{
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
       // NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}
-(void)DeleteForBackGround:(NSString *)query
{
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        // NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

#pragma mark -
#pragma mark UpdateRecord

-(void)Update:(NSString *)query
{
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if(sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
		sqlite3_finalize(statement);
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

-(void)UpdateWithPower:(NSString *)query{
    
    sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
        [self registerPowerFunctionWith:databaseObj];
        
		if(sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
		sqlite3_finalize(statement);
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }


}

-(void)UpdateForBackGround:(NSString *)query
{
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if(sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
		sqlite3_finalize(statement);
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}


- (NSMutableArray *)fetchParticularData:(NSString *)query
{
	sqlite3_stmt *statement = nil;
	NSMutableArray *workoutArray = [[NSMutableArray alloc ] init ];
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK ) {

		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK) {
        
            
			while(sqlite3_step(statement) == SQLITE_ROW) {
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}

				
				[workoutArray addObject:[currentRow retain]];
			}
		}
		sqlite3_finalize(statement);
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
       // NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return [workoutArray retain];
}
-(NSString*) getSingleDataValueForQuery:(NSString *)sql{
    
    
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
    NSString* singleValue=@"";
	NSMutableArray *alldata;
	alldata = [NSMutableArray array];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    	NSString *query = sql;
		
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
                char *max = (char*) sqlite3_column_text(statement, 0);
                if (max) {
                    singleValue = [NSString stringWithCString:max encoding:NSUTF8StringEncoding];
                }
                 
                
			}
		}
		sqlite3_finalize(statement); 
	}
	//sqlite3_close(databaseObj);
    if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
    
    return singleValue;
}
-(NSString*) getSingleDataValueForQueryForBackGround:(NSString *)sql{
    
    
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
    NSString* singleValue=@"";
	NSMutableArray *alldata;
	alldata = [NSMutableArray array];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    	NSString *query = sql;
		
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
                char *max = (char*) sqlite3_column_text(statement, 0);
                if (max) {
                    singleValue = [NSString stringWithCString:max encoding:NSUTF8StringEncoding];
                }
                
                
			}
		}
		sqlite3_finalize(statement); 
	}
	//sqlite3_close(databaseObj);
    if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
    
    return singleValue;
}

-(NSInteger) getMaxValueForQuery:(NSString *)sql{
    
    sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	NSInteger intMax = 1;
	NSMutableArray *alldata;
	alldata = [NSMutableArray array];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
    	NSString *query = sql;
		
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
                char *max = (char*) sqlite3_column_text(statement, 0);
                if (max) {
                    NSString *strMax = [NSString stringWithCString:max encoding:NSUTF8StringEncoding];
                    intMax = [strMax intValue];
                }else{
                    intMax=1;
                }
			}
		}
		sqlite3_finalize(statement); 
	}
	sqlite3_close(databaseObj);
    
    return intMax;
}
-(NSInteger) getSumOfValueForQuery:(NSString *)sql{
    
    
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	NSInteger intMax = 1;
	NSMutableArray *alldata;
	alldata = [NSMutableArray array];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    	NSString *query = sql;
		
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
                char *max = (char*) sqlite3_column_text(statement, 0);
                if (max) {
                    NSString *strMax = [NSString stringWithCString:max encoding:NSUTF8StringEncoding];
                    intMax = [strMax intValue];
                }else{
                    intMax=0;
                }
			}
		}
		sqlite3_finalize(statement); 
	}
	sqlite3_close(databaseObj);
    
    return intMax;
}

-(NSString *) getFirstValueForQuery:(NSString *)sql{
    
    
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];

    NSString *strValue = @"";
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    	NSString *query = sql;
		
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
                char *data = (char*) sqlite3_column_text(statement, 0);
                if (data) {
                    strValue = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
                }else{

//                    return nil;// kunal patel
                }
			}
		}
        else {
            /////     *****NSLog(@"Error:  message '%s'. %@ %s", sqlite3_errmsg(databaseObj),sql,__FUNCTION__);
        }
		sqlite3_finalize(statement); 
	}
	sqlite3_close(databaseObj);
    
    return strValue;
}
-(NSString *) getFirstValueForQueryForBackGround:(NSString *)sql{
    
    
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
    
    NSString *strValue = @"";
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    	NSString *query = sql;
		
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
                char *data = (char*) sqlite3_column_text(statement, 0);
                if (data) {
                    strValue = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
                }else{
//                    return nil;  // kunal 
                }
			}
		}
        else {
            /////     *****NSLog(@"Error:  message '%s'. %@ %s", sqlite3_errmsg(databaseObj),sql,__FUNCTION__);
        }
		sqlite3_finalize(statement); 
	}
	sqlite3_close(databaseObj);
    
    return strValue;
}

-(NSMutableDictionary *) getFirstRowForQuery:(NSString *)sql{
 
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
    NSMutableDictionary *currentRow = nil;
	
    if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[sql UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{	
                currentRow = [[NSMutableDictionary alloc] init];
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}
			}
            else {
//                /////     *****NSLog(@"Error:  message '%s'. %@ %s", sqlite3_errmsg(databaseObj),sql,__FUNCTION__);
            }
		}
        else {
            /////     *****NSLog(@"Error:  message '%s'. %@ %s", sqlite3_errmsg(databaseObj),sql,__FUNCTION__);
        }
		sqlite3_finalize(statement); 
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return currentRow;
    
}
-(NSMutableDictionary *) getFirstRowForQueryForBackGround:(NSString *)sql{
    
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
    NSMutableDictionary *currentRow = nil;
	
    if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[sql UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{	
                currentRow = [[NSMutableDictionary alloc] init];
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}
			}
            else {
                //                /////     *****NSLog(@"Error:  message '%s'. %@ %s", sqlite3_errmsg(databaseObj),sql,__FUNCTION__);
            }
		}
        else {
            /////     *****NSLog(@"Error:  message '%s'. %@ %s", sqlite3_errmsg(databaseObj),sql,__FUNCTION__);
        }
		sqlite3_finalize(statement); 
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        //NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return currentRow;
    
}

-(NSInteger) getMaxValueFromTable:(NSString *)strTableName forField:(NSString *)strFieldName{
    NSString *sql = [NSString stringWithFormat:@"select max(%@) from %@",strFieldName,strTableName];
    
    NSInteger maxValue = [[Database shareDatabase] getMaxValueForQuery:sql];
    return maxValue;
}

@end
