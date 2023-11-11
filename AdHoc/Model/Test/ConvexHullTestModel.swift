//
//  ConvexHullTestModel.swift
//  AdHoc
//
//  Created by 藤田一旗 on 2023/11/09.
//

import Foundation
import NearbyInteraction

class ConvexHullTestModel: NSObject, ObservableObject {
    var testConv: ConvexHullModel
    var testNIVecList: [NIVectorModel] = [
        NIVectorModel(x:9.7627 ,y: 0 , z:43.0379),
        NIVectorModel(x:20.5527 ,y: 0 , z:8.9766),
        NIVectorModel(x:-15.2690 ,y: 0 , z:29.1788),
        NIVectorModel(x:-12.4826 ,y: 0 , z:78.3546),
        NIVectorModel(x:92.7326 ,y: 0 , z:-23.3117),
        NIVectorModel(x:58.3450 ,y: 0 , z:5.7790),
        NIVectorModel(x:13.6089 ,y: 0 , z:85.1193),
        NIVectorModel(x:-85.7928 ,y: 0 , z:-82.5741),
        NIVectorModel(x:-95.9563 ,y: 0 , z:66.5240),
        NIVectorModel(x:55.6314 ,y: 0 , z:74.0024),
        NIVectorModel(x:95.7237 ,y: 0 , z:59.8317),
        NIVectorModel(x:-7.7041 ,y: 0 , z:56.1058),
        NIVectorModel(x:-76.3451 ,y: 0 , z:27.9842),
        NIVectorModel(x:-71.3293 ,y: 0 , z:88.9338),
        NIVectorModel(x:4.3697 ,y: 0 , z:-17.0676),
        NIVectorModel(x:-47.0889 ,y: 0 , z:54.8467),
        NIVectorModel(x:-8.7699 ,y: 0 , z:13.6868),
        NIVectorModel(x:-96.2420 ,y: 0 , z:23.5271),
        NIVectorModel(x:22.4191 ,y: 0 , z:23.3868),
        NIVectorModel(x:88.7496 ,y: 0 , z:36.3641)
    ]
    
    var testConv2: ConvexHullModel
    var testNIVecList2: [NIVectorModel] = [
        NIVectorModel(x:9.7627 ,y: 0 , z:43.0379),
        NIVectorModel(x:20.5527 ,y: 0 , z:8.9766),
        NIVectorModel(x:-15.2690 ,y: 0 , z:29.1788),
        NIVectorModel(x:-12.4826 ,y: 0 , z:78.3546),
        NIVectorModel(x:92.7326 ,y: 0 , z:-23.3117),
        NIVectorModel(x:58.3450 ,y: 0 , z:5.7790),
        NIVectorModel(x:13.6089 ,y: 0 , z:85.1193),
        NIVectorModel(x:-85.7928 ,y: 0 , z:-82.5741),
        NIVectorModel(x:-95.9563 ,y: 0 , z:66.5240),
        NIVectorModel(x:55.6314 ,y: 0 , z:74.0024),
        NIVectorModel(x:95.7237 ,y: 0 , z:59.8317),
        NIVectorModel(x:-7.7041 ,y: 0 , z:56.1058),
        NIVectorModel(x:-76.3451 ,y: 0 , z:27.9842),
        NIVectorModel(x:-71.3293 ,y: 0 , z:88.9338),
        NIVectorModel(x:4.3697 ,y: 0 , z:-17.0676),
        NIVectorModel(x:-47.0889 ,y: 0 , z:54.8467),
        NIVectorModel(x:-8.7699 ,y: 0 , z:13.6868),
        NIVectorModel(x:-96.2420 ,y: 0 , z:23.5271),
        NIVectorModel(x:22.4191 ,y: 0 , z:23.3868),
        NIVectorModel(x:88.7496 ,y: 0 , z:36.3641),
        NIVectorModel(x:-28.0984 ,y: 0 , z:-12.5936),
        NIVectorModel(x:39.5262 ,y: 0 , z:-87.9549),
        NIVectorModel(x:33.3533 ,y: 0 , z:34.1276),
        NIVectorModel(x:-57.9235 ,y: 0 , z:-74.2147),
        NIVectorModel(x:-36.9143 ,y: 0 , z:-27.2578),
        NIVectorModel(x:14.0394 ,y: 0 , z:-12.2797),
        NIVectorModel(x:97.6748 ,y: 0 , z:-79.5910),
        NIVectorModel(x:-58.2246 ,y: 0 , z:-67.7381),
        NIVectorModel(x:30.6217 ,y: 0 , z:-49.3417),
        NIVectorModel(x:-6.7378 ,y: 0 , z:-51.1149),
        NIVectorModel(x:-68.2061 ,y: 0 , z:-77.9250),
        NIVectorModel(x:31.2659 ,y: 0 , z:-72.3634),
        NIVectorModel(x:-60.6835 ,y: 0 , z:-26.2550),
        NIVectorModel(x:64.1986 ,y: 0 , z:-80.5797),
        NIVectorModel(x:67.5890 ,y: 0 , z:-80.7803),
        NIVectorModel(x:95.2919 ,y: 0 , z:-6.2698),
        NIVectorModel(x:95.3522 ,y: 0 , z:20.9691),
        NIVectorModel(x:47.8527 ,y: 0 , z:-92.1624),
        NIVectorModel(x:-43.4386 ,y: 0 , z:-75.9607),
        NIVectorModel(x:-40.7720 ,y: 0 , z:-76.2545),
        NIVectorModel(x:-36.4034 ,y: 0 , z:-17.1474),
        NIVectorModel(x:-87.1705 ,y: 0 , z:38.4944),
        NIVectorModel(x:13.3203 ,y: 0 , z:-46.9221),
        NIVectorModel(x:4.6496 ,y: 0 , z:-81.2119),
        NIVectorModel(x:15.1893 ,y: 0 , z:85.8592),
        NIVectorModel(x:-36.2862 ,y: 0 , z:33.4821),
        NIVectorModel(x:-73.6404 ,y: 0 , z:43.2654),
        NIVectorModel(x:-42.1188 ,y: 0 , z:-63.3617),
        NIVectorModel(x:17.3026 ,y: 0 , z:-95.9785),
        NIVectorModel(x:65.7880 ,y: 0 , z:-99.0609),
        NIVectorModel(x:35.5633 ,y: 0 , z:-45.9984),
        NIVectorModel(x:47.0388 ,y: 0 , z:92.4377),
        NIVectorModel(x:-50.2494 ,y: 0 , z:15.2315),
        NIVectorModel(x:18.4084 ,y: 0 , z:14.4504),
        NIVectorModel(x:-55.3837 ,y: 0 , z:90.5498),
        NIVectorModel(x:-10.5749 ,y: 0 , z:69.2817),
        NIVectorModel(x:39.8959 ,y: 0 , z:-40.5126),
        NIVectorModel(x:62.7596 ,y: 0 , z:-20.6989),
        NIVectorModel(x:76.2206 ,y: 0 , z:16.2546),
        NIVectorModel(x:76.3471 ,y: 0 , z:38.5063),
        NIVectorModel(x:45.0509 ,y: 0 , z:0.2649),
        NIVectorModel(x:91.2167 ,y: 0 , z:28.7980),
        NIVectorModel(x:-15.2290 ,y: 0 , z:21.2786),
        NIVectorModel(x:-96.1614 ,y: 0 , z:-39.6850),
        NIVectorModel(x:32.0347 ,y: 0 , z:-41.9845),
        NIVectorModel(x:23.6031 ,y: 0 , z:-14.2463),
        NIVectorModel(x:-72.9052 ,y: 0 , z:-40.3435),
        NIVectorModel(x:13.9930 ,y: 0 , z:18.1746),
        NIVectorModel(x:14.8650 ,y: 0 , z:30.6402),
        NIVectorModel(x:30.4207 ,y: 0 , z:-13.7163),
        NIVectorModel(x:79.3093 ,y: 0 , z:-26.4876),
        NIVectorModel(x:-12.8270 ,y: 0 , z:78.3847),
        NIVectorModel(x:61.2388 ,y: 0 , z:40.7777),
        NIVectorModel(x:-79.9546 ,y: 0 , z:83.8965),
        NIVectorModel(x:42.8483 ,y: 0 , z:99.7694),
        NIVectorModel(x:-70.1103 ,y: 0 , z:73.6252),
        NIVectorModel(x:-67.5014 ,y: 0 , z:23.1119),
        NIVectorModel(x:-75.2360 ,y: 0 , z:69.6016),
        NIVectorModel(x:61.4638 ,y: 0 , z:13.8201),
        NIVectorModel(x:-18.5633 ,y: 0 , z:-86.1666),
        NIVectorModel(x:39.4858 ,y: 0 , z:-9.2915),
        NIVectorModel(x:44.4111 ,y: 0 , z:73.2765),
        NIVectorModel(x:95.1043 ,y: 0 , z:71.1607),
        NIVectorModel(x:-97.6572 ,y: 0 , z:-28.0044),
        NIVectorModel(x:45.9981 ,y: 0 , z:-65.6741),
        NIVectorModel(x:4.2073 ,y: 0 , z:-89.1324),
        NIVectorModel(x:-60.0007 ,y: 0 , z:-96.2956),
        NIVectorModel(x:58.7395 ,y: 0 , z:-55.2151),
        NIVectorModel(x:-30.9297 ,y: 0 , z:85.6163),
        NIVectorModel(x:40.8829 ,y: 0 , z:-93.6322),
        NIVectorModel(x:-67.0612 ,y: 0 , z:24.2957),
        NIVectorModel(x:15.4457 ,y: 0 , z:-52.4214),
        NIVectorModel(x:86.8428 ,y: 0 , z:22.7932),
        NIVectorModel(x:7.1266 ,y: 0 , z:17.9820),
        NIVectorModel(x:46.0244 ,y: 0 , z:-37.6110),
        NIVectorModel(x:-20.3558 ,y: 0 , z:-58.0313),
        NIVectorModel(x:-62.7614 ,y: 0 , z:88.8745),
        NIVectorModel(x:47.9102 ,y: 0 , z:-1.9082),
        NIVectorModel(x:-54.5171 ,y: 0 , z:-49.1287),
        NIVectorModel(x:-88.3942 ,y: 0 , z:-13.1167)
    ]
    
    override init() {
        self.testConv = ConvexHullModel()
        self.testConv2 = ConvexHullModel()
    }
    
    init(testConv: ConvexHullModel) {
        self.testConv = testConv
        self.testConv2 = testConv
    }
    
    func test(){
        print("Point")
        testConv.niPoints = StackModel(array: [])
        for testNIVec in testNIVecList {
            print( String(testNIVec.vector.x) + ", " + String(testNIVec.vector.y) + ", " + String(testNIVec.vector.z) )
            testConv.appendPoint(niVec: testNIVec)
        }
        
        testConv.calcConvexHull()
        
        print("Conv")
        for test in testConv.niConvexHull.array {
            print( String(test.vector.x) + ", " +  String(test.vector.y) + ", " + String(test.vector.z) )
        }
        
        
    }
    
    func test2(){
        print("Point")
        testConv2.niPoints = StackModel(array: [])
        testConv2.niConvexHull = StackModel(array: [])
        for testNIVec in testNIVecList2 {
            print( String(testNIVec.vector.x) + ", " + String(testNIVec.vector.y) + ", " + String(testNIVec.vector.z) )
            testConv2.appendPoint(niVec: testNIVec)
        }
        
        testConv2.calcConvexHull()
        
        print("Conv")
        self.testConv2.sortConvByX()
        for test in testConv2.niConvexHull.array {
            print( String(test.vector.x) + ", " + String(test.vector.z) )
        }
    }
}
