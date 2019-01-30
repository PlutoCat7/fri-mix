//
//  YYHDiskCache.m
//  YYHCacheDemo
//
//  Created by 王时温 on 16/1/21.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "YYHDiskCache.h"

#define YYHDiskCachePrefix @"YYHCache"
static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@interface YYHDiskCache ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSURL *cacheURL;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, assign) NSInteger maxCacheAge;

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) dispatch_queue_t asyncQueue;;

@end

@implementation YYHDiskCache

- (instancetype)init {
    
    NSAssert(0, @"initWithName: or initWithName: rootPath:");
    return nil;
}

- (instancetype)initWithName:(NSString *)name {
    
    return [self initWithName:name rootPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
}

- (instancetype)initWithName:(NSString *)name rootPath:(NSString *)rootPath {
    
    if (!name) {
        name = @"";
    }
    if (!rootPath) {
        rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    if (self = [super init]) {
        
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        _autoTrimInterval = 10*60;  //10 miminute
        NSString *pathComponent = [[NSString alloc] initWithFormat:@"%@.%@", YYHDiskCachePrefix, name];
        _cacheURL = [NSURL fileURLWithPathComponents:@[rootPath, pathComponent]];
        _fileManager = [NSFileManager new];
        
        if (![_fileManager fileExistsAtPath:[_cacheURL path]]) {
            [_fileManager createDirectoryAtURL:_cacheURL
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        _lock = [NSLock new];
        _asyncQueue = dispatch_queue_create("com.yahua.diskCache", DISPATCH_QUEUE_CONCURRENT); //并行队列
        
        //清除过期的缓存文件
        [self p_trimRecurrence];
    }
    
    return self;
}

#pragma mark - Public

- (BOOL)containsObjectForKey:(NSString *)key {
    
    if (!key) return NO;
    BOOL bContains = NO;
    NSString *path = [[self p_fileNameWithKey:key] path];
    
    [_lock lock];
    bContains = [_fileManager fileExistsAtPath:path];
    [_lock unlock];
    
    return bContains;
}

- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL bContains))block {
    
    if (!block) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_asyncQueue, ^{
        __strong __typeof(weakSelf)self = weakSelf;
        BOOL bContains = [self containsObjectForKey:key];
        block(key, bContains);
    });
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    
    if (!key) {
        return nil;
    }
    id<NSCoding> object = nil;
    [_lock lock];
    NSData *data = [NSData dataWithContentsOfURL:[self p_fileNameWithKey:key]];
    if (!data) {
        [_lock unlock];
        return nil;
    }
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSAssert(0, @"不是NSCoding");
    }
    [_lock unlock];
    
    return object;
}

- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block {
    
    if (!block) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_asyncQueue, ^{
        __strong __typeof(weakSelf)self = weakSelf;
        id<NSCoding> object = [self objectForKey:key];
        block(key, object);
    });
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    
    if (!key) return;
    
    if (!object) {
        [self removeObjectForKey:key];
    }else {
        [_lock lock];
        NSData *value;
        @try {
            value = [NSKeyedArchiver archivedDataWithRootObject:object];
        }
        @catch (NSException *exception) {
            NSAssert(0, @"不是NSCoding");
        }

        [value writeToURL:[self p_fileNameWithKey:key] atomically:NO];
        [_lock unlock];
    }
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
    if (!block) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_asyncQueue, ^{
        __strong __typeof(weakSelf)self = weakSelf;
        [self setObject:object forKey:key];
        block(key);
    });
}

- (void)removeObjectForKey:(NSString *)key {
    
    if (!key) return;
    
    NSError *error= nil;
    NSURL *path = [self p_fileNameWithKey:key];
    [_lock lock];
    [_fileManager removeItemAtURL:path error:&error];
    [_lock unlock];
    if (error) {
        NSAssert(0, @"文件移除失败");
    }
}

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
    if (!block) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_asyncQueue, ^{
        __strong __typeof(weakSelf)self = weakSelf;
        [self removeObjectForKey:key];
        block(key);
    });
}

- (void)removeAllObjects {
    
    NSError *error = nil;
    [_lock lock];
    [_fileManager removeItemAtURL:_cacheURL error:&error];
    [_lock unlock];
    if (error) {
        NSAssert(0, @"文件移除失败");
    }
}

- (void)removeAllObjectsWithBlock:(void(^)())block {
    
    if (!block) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_asyncQueue, ^{
        __strong __typeof(weakSelf)self = weakSelf;
        [self removeAllObjects];
        block();
    });
}

- (void)cacheSize:(void(^)(NSUInteger size))block; {
    
    if (!block) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(self.asyncQueue, ^{
        __strong __typeof(weakSelf)self = weakSelf;
        NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:[self.cacheURL path]];
        NSUInteger size = 0;
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [[self.cacheURL path] stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
        block(size);
    });
}

#pragma mark - Private

- (NSURL *)p_fileNameWithKey:(NSString *)key {
    
    NSAssert(key, @"key 不能为nil");
    return [_cacheURL URLByAppendingPathComponent:key];
}

- (void)p_trimRecurrence {  //循环调用
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __strong __typeof(weakSelf)self = weakSelf;
        if (!self) return;
        [self p_trimInBackGround];
        [self p_trimRecurrence];
    });
}

- (void)p_trimInBackGround { //清楚过期缓存
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_asyncQueue, ^{
        
        __strong __typeof(weakSelf)self = weakSelf;
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        [self lock];
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:_cacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];

        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        [self.lock unlock];
    });
}

@end
