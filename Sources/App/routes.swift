import Vapor
import Leaf
import Fluent
import FluentSQLite
import SwiftyJSON

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("covid19") { (req) -> Future<View> in
        return try! req.client().get("https://api.covid19india.org/data.json").flatMap(to: View.self, { (res) -> EventLoopFuture<View> in
            //1
            let decorder = JSONDecoder()
            var stateWiseDate = try JSON(res.http.body.data!)["statewise"]
                .arrayValue
                .map {
                try decorder.decode(StateWiseData.self, from: try $0.rawData())
            }
            
            //2
            let totalData = stateWiseDate.removeFirst()
            
            //3
            struct PageData: Content {
                var totalCase: StateWiseData
                var stateData: [StateWiseData]
            }
            let context = PageData(totalCase: totalData, stateData: stateWiseDate)
            return try req.view().render("heathData", context).catch({ (error) in
                print(error.localizedDescription)
            })
        })
    }
    
    router.get("api/covid19") { (req) -> Future<HealthResponse> in
        return try! req.client().get("https://api.covid19india.org/data.json").map {
            res -> HealthResponse in
            let json = JSON(res.http.body.data!)["statewise"]
            return HealthResponse(code: res.http.status.code, data: json, message: "Success")
        }
    } 
}
