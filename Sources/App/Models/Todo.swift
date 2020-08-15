import FluentSQLite
import Vapor
import SwiftyJSON

//Model for API
struct HealthResponse: Content {
    var code: UInt
    var data: JSON
    var message: String
}

//Model for Web App
struct StateWiseResponse: Content {
    var states: [StateWiseData]
}

struct StateWiseData: Content {
    var deaths, statecode, deltadeaths, active: String
    var lastupdatedtime, statenotes, deltarecovered, confirmed: String
    var deltaconfirmed, state, recovered: String
}
