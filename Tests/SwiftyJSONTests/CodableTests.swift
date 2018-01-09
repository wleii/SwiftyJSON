//  CodableTests.swift
//
//  Created by Lei Wang on 2018/1/9.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
import SwiftyJSON

class CodableTests: XCTestCase {

    func testListCoder() {
        
        let jsonString = """
        [1,"false","3",true]
        """
        var data = jsonString.data(using: .utf8)!

        let json = try! JSONDecoder().decode(JSON.self, from: data)
        XCTAssertEqual(json.arrayValue.count, 4)
        XCTAssertEqual(json.arrayValue.first?.int, 1)
        XCTAssertEqual(json[1].bool, nil)
        XCTAssertEqual(json[1].string, "false")
        XCTAssertEqual(json[2].string, "3")
        XCTAssertEqual(json.arrayValue[0].bool, nil)
        XCTAssertEqual(json.array!.last!.bool, true)
        
        let jsonList = try! JSONDecoder().decode([JSON].self, from: data)
        XCTAssertEqual(jsonList.count, 4)
        XCTAssertEqual(jsonList.first?.int, 1)
        XCTAssertEqual(jsonList.last!.bool, true)
        
        data = try! JSONEncoder().encode(jsonList)
        let encodeJsonString = String.init(data: data, encoding: .utf8)!
        XCTAssertEqual(encodeJsonString, jsonString)
    }
   
    
    func testDictCoder() {
        let dictionary = [
            "number": 9823.212,
            "name": "NAME",
            "list": [1234, 4.212],
            "object": ["sub_number": 877.2323, "sub_name": "sub_name"],
            "bool": true] as [String : Any]

        var data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        let json = try! JSONDecoder().decode(JSON.self, from: data)
        
        XCTAssertNotNil(json.dictionary)
        XCTAssertEqual(json["number"].float, 9823.212)
        XCTAssertEqual(json["list"].arrayObject is [Float], true)
        XCTAssertEqual(json["object"]["sub_number"].float, 877.2323)
        XCTAssertEqual(json["bool"].bool, true)
        
        let jsonDict = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(jsonDict["number"]?.int, 9823)
        XCTAssertEqual(jsonDict["object"]?["sub_name"], "sub_name")


        data = try! JSONEncoder().encode(json)
        var encoderDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        XCTAssertEqual(encoderDict["list"] as! [Float], dictionary["list"] as! [Float])
        
        data = try! JSONEncoder().encode(jsonDict)
        encoderDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        XCTAssertEqual(encoderDict["name"] as! String, dictionary["name"] as! String)

    }
    
    func testCodableModel() {
        
    }
    
   
    
}
