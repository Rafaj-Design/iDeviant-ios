
#import "JCOIssue.h"

@implementation JCOIssue

@synthesize key = _key, status = _status, title = _title, description = _description,
            comments = _comments, hasUpdates = _hasUpdates, lastUpdated = _lastUpdated,
            dateCreated = _dateCreated;

- (void) dealloc {
    self.key, self.status, self.title, self.description, self.comments, self.lastUpdated= nil;
    self.dateCreated = nil;
    [super dealloc];
}

- (JCOComment *) latestComment {
    return [self.comments count] > 0 ? ((JCOComment *)[self.comments lastObject]) : nil;
}

-(NSDate *) dateFromNumber:(NSNumber *)number {
    return [NSDate dateWithTimeIntervalSince1970:[number longLongValue]/1000];
}


- (id) initWithDictionary:(NSDictionary*)map {
	if ((self = [super init])) {
		self.key = [map objectForKey:@"key"];
        self.status = [map objectForKey:@"status"];
        self.title = [map objectForKey:@"title"];
        self.description = [map objectForKey:@"description"];
        self.dateCreated = [self dateFromNumber:[map objectForKey:@"dateCreated"]];
        self.lastUpdated = [self dateFromNumber:[map objectForKey:@"lastUpdated"]];

        if (!self.key)
        {
            self.key = @"(no issue key)";
        }
        if (!self.status)
        {
            self.status = @"(no status)";
        }
        if (!self.title)
        {
            self.title = @"(no title)";
        }
        if (!self.description)
        {
            self.description = @"(no description)";
        }
        
        NSArray* commentDataArray = [map objectForKey:@"comments"];
        if (commentDataArray)
        {
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:[commentDataArray count]];
            for (NSDictionary* data in commentDataArray)
            {
                NSString* author = [data objectForKey:@"username"];
                if (!author)
                {
                    author = @"(no author)";
                }
                NSString* body = [data objectForKey:@"text"];
                if (!body)
                {
                    body = @"(no body)";
                }
                NSNumber* msSinceEpoch = [data objectForKey:@"date"];
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:[msSinceEpoch longLongValue]/1000];
                NSNumber* value = (NSNumber*)[data objectForKey:@"systemUser"];
                JCOComment * comment = [[JCOComment alloc] initWithAuthor:author systemUser:[value boolValue] body:body date:date];
                [array addObject:comment];
                [comment release];
            }
            self.comments = array;
            [array release];
        }
    }

	return self;
}

@end
