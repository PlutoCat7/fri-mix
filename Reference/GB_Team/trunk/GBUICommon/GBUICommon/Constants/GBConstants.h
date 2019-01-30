//
//  GBConstants.h
//  GBUICommon
//
//  Created by weilai on 16/9/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#ifndef GBConstants_h
#define GBConstants_h

// block
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#define BLOCK_EXEC_SetNil(block, ...) if (block) { block(__VA_ARGS__); block = nil;};
// ls
#define LS(key) NSLocalizedString(key, nil)

#define STRING_VALUE(obj, default) DICT_VALUE_IS_NOTNULL(obj) ? (DICT_VALUE_IS_NUMBER(obj) ? [obj stringValue] : (DICT_VALUE_IS_STRING(obj) ? obj : default)) : default
#define INTEGER_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj integerValue] : default)
#define FLOAT_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj floatValue] : default)
#define DOUBLE_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj doubleValue] : default)
#define BOOL_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj boolValue] : default)

#endif /* GBConstants_h */
