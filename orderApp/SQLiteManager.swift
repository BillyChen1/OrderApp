//
//  SQLiteManager.swift
//  orderApp
//
//  Created by chenqiming on 2020/5/1.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import Foundation

class SQLiteManager : NSObject {
    private var dbPath:String!
    private var database:OpaquePointer? = nil
    
    static var sharedInstance:SQLiteManager {
        return SQLiteManager()
    }
    
    override init() {
        super.init()
        
        let dirpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        dbPath = dirpath.appendingPathComponent("app.sqlite").path
        //print(dbPath!)
    }
    
    //open databse
    func openDB() -> Bool {
        let result = sqlite3_open(dbPath, &database)
        if result != SQLITE_OK {
            print("fail to open db")
            return false
        }
        return true
    }
    
    //close db
    func closeDB() {
        sqlite3_close(database)
    }
    
    //execute the statement: create, insert, update, delete
    func execNoneQuerySQL(sql:String) -> Bool {
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let cSql = sql.cString(using: String.Encoding.utf8)
        /*
         参数
         1. db：OpaquePointer! 已打开数据库句柄
         2. sql：执行的sql
         3. callback：回调函数
         4. 自定义指针，回传递到函数内
         5. errmsg：错误信息
         */
        if sqlite3_exec(database, cSql, nil, nil, &errMsg) == SQLITE_OK {
            return true
        }
        let msg = String.init(cString: errMsg!)
        print(msg)
        return false
    }
    
    //select
    func execQuerySQL(sql:String) -> [[String: AnyObject]]? {
        let cSql = sql.cString(using: String.Encoding.utf8)!
        var statement:OpaquePointer? = nil
        
        /*
         参数
         1. db：打开的数据库
         2. zSql：要执行的SQL语句
         3. nByte：以字节为单位的sql语句长度，-1自动计算
         4. ppStmt：语句句柄，据此获取查询结果
            需要调用 sqlite3_finalize释放
         5. —— pzTail：未使用的指针地址，通常传入nil
         */
        if sqlite3_prepare_v2(database, cSql, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            
            print("执行\(sql)错误\n")
            let errmsg = sqlite3_errmsg(database)
            if errmsg != nil {
                print(errmsg!)
            }
            return nil
        }
        
        var rows = [[String:AnyObject]]()
        
        while sqlite3_step(statement) == SQLITE_ROW {
            rows.append(record(stmt: statement!))
        }
        
        sqlite3_finalize(statement)
        
        return rows
    }
    
    private func record(stmt:OpaquePointer) -> [String:AnyObject] {
        var row = [String:AnyObject]()
        
        //遍历所有列，获取每一列的信息
        for col in 0 ..< sqlite3_column_count(stmt) {
            let cName = sqlite3_column_name(stmt, col) //获取列名
            let name = String(cString: cName!, encoding: String.Encoding.utf8)
            
            var value: AnyObject?
            
            switch (sqlite3_column_type(stmt, col)) {
            case SQLITE_FLOAT:
                value = sqlite3_column_double(stmt, col) as AnyObject
            case SQLITE_INTEGER:
                value = sqlite3_column_int(stmt, col) as AnyObject
            case SQLITE_TEXT:
                let cText = sqlite3_column_text(stmt, col)
                value = String.init(cString:cText!) as AnyObject
            case SQLITE_NULL:
                value = NSNull()
            case SQLITE_BLOB:
                value = sqlite3_column_blob(stmt, col) as AnyObject
            default:
                print("不支持的数据类型")
            }
            row[name!] = value ?? NSNull()
        }
        return row
    }
    
    func execSaveBlob(sql:String, blob:NSData) {
        let csql = sql.cString(using: .utf8)
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, csql, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            print("Prepare error:\(sql)")
            return
        }
        let paramsCnt = sqlite3_bind_parameter_count(statement)
        if paramsCnt != 1 {
            print("need only 1 parameter:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        /*BLOB绑定函数
         int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
         sqlite2_stmt --
            准备语句指针
         int -- 要绑定的BLOB下标，从1开始
         const void*    -- BLOB数据的指针
         int n  --BLOB数据长度
         void()(void)   -- 析构回调函数，一般默认为空
         */
        if sqlite3_bind_blob(statement, 1, blob.bytes, Int32(blob.length), nil) != SQLITE_OK {
            print("bind blob error:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        //执行
        let rslt = sqlite3_step(statement)
        if rslt != SQLITE_OK && rslt != SQLITE_DONE {
            print("execute blob error:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        sqlite3_finalize(statement)
        return
    }
    
    func execLoadBlob(sql:String) -> Data? {
        let csql = sql.cString(using: String.Encoding.utf8)
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, csql, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            print("执行\(sql)错误\n")
            if let errmsg = sqlite3_errmsg(database) {
                print(errmsg)
            }
            return nil
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            if let dataBlob = sqlite3_column_blob(statement, 0) {
                let dataBlobLength = sqlite3_column_bytes(statement, 0)
                let data = Data(bytes:dataBlob, count:Int(dataBlobLength))
                sqlite3_finalize(statement)
                return data
            }
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
}

