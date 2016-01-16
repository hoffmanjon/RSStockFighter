//
//  StockFighterTypes.swift
//  StockFighter1
//
//  Created by Jon Hoffman on 1/8/16.
//  Copyright © 2016 Jon Hoffman. All rights reserved.
//

import Foundation

/**
    This protocol is implemented by all Stock Fighter requests.  Each type that conforms to the this protocol should represent a seperate API in the Stock Fighter system.  If we need additional functionality for Post or Get requests we will use protocol composition to include the requirements from this protocol.

    In order conform to this protocol a type must implement the two computed properties.

    ----

    __Parameters__
    * url - The url computed property is a constant that will represent the url of the request
    * requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
*/
protocol StockFighterRequestType {
    var url: String {get}
    var requestType: RSTransactionType {get}
}

/**
  This protocol takes the requirements from the _StockFighterRequestType_ protocol and adds an additional method that will generate a JSON string which will be used to send the data to the StockFighter API.

    ---

    __Parameters__ (from the _StockFighterRequestType_ protocol)
    * url - The url computed property is a constant that will represent the url of the request
    * requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request

    ----

    __Methods__
    * getJsonString - If the request is a post request then the body needs to contain the data for the request in JSON format.  This function should generate a String value, in JSON format, that contains the data for the request.
*/
protocol StockFighterPostRequestType: StockFighterRequestType {
    func getJsonString() -> String
}

/**
    This API will check to make sure the Stock Fighter API is up and functioning properly.  Use the _StockFighterAPIStatusResponse_ type to parse the response that is returned from this call.
*/
struct StockFighterAPIStatus: StockFighterRequestType {
    /// url - The url computed property is a constant that will represent the url of the request
    var url: String { return "\(SF_BASE_URL)/heartbeat"}
    
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return  RSTransactionType.GET}
}

/**
     This API will check to see if the venue defined by the global _SF_VENUE_ constant is up and functioning property.  This constant is defined in the StockFighterInfo file.  Use the _StockFighterVenueStatusResponse_ type to parse the response from this call.
*/
struct StockFighterVenueStatus: StockFighterRequestType {
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return  RSTransactionType.GET}
    
    ///url - The url computed property is a constant that will represent the url of the request
    var url: String {return  "\(SF_BASE_URL)/venues/\(SF_VENUE)/heartbeat"}
}

/**
    This API will return a list of stocks on the venue defined by the global _SF_VENUE_ constant.  This constant is defined in the StockFighterInfo file.  Use the _StockFighterStocksOnVenueResponse_ type to parse the response from this call.
*/
struct StockFighterStocksOnVenue: StockFighterRequestType {
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return  RSTransactionType.GET}
    
    ///url - The url computed property is a constant that will represent the url of the request
    var url: String {return  "\(SF_BASE_URL)/venues/\(SF_VENUE)/stocks"}
}


/**
    This API will make a new order for a stock.  The order will be placed on the venue defined by the global _SF_VENUE_ constant.  This constant is defined in the StockFighterInfo file.  Use the _StockFighterOrderResponse_ type to parse the response from this call.
*/
struct StockFighterOrder: StockFighterPostRequestType {
    ///Is the Symbol of the stock to purchase or sell
    var symbol: String
    
    ///Is the price to sell or purchase the stock at
    var price: Double
    
    ///The quantity to sell or purchase
    var qty: Int
    
    ///Specifies if the order is a purchase or sell order
    var direction: SF_OrderDirection
    
    ///What type of order (Limit, Market, FOK or IOC
    var orderType: String
    
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return RSTransactionType.POST}
    
    ///url - The url computed property is a constant that will represent the url of the request
    var url: String { return "\(SF_BASE_URL)/venues/\(SF_VENUE)/stocks/\(symbol)/orders" }
    
    /**
        This method will generate a JSON string that represents this order.  This JSON string will be sent in the POST request to the API.
    */
    func getJsonString() -> String {
        let dict = [SFKeys.ACCOUNT:SF_ACCOUNT,SFKeys.ACCOUNT:SF_VENUE,SFKeys.SYMBOL:symbol,SFKeys.PRICE:price * 100,SFKeys.QTY:qty,SFKeys.DIRECTION:direction.rawValue,SFKeys.ORDER_TYPE:orderType]
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            return NSString(data: data,encoding: NSASCIIStringEncoding) as! String
        } catch _ {
            return ""
        }
    }
}

/**
This API will request the orderbook from the venue defined by the global _SF_VENUE_ constant.  This constant is defined in the StockFighterInfo file.  Use the _StockFighterOrderBookResponse_ type to parse the response from this call.
*/
struct StockFighterOrderBook: StockFighterRequestType {
    var symbol: String
    
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return RSTransactionType.GET}
    
    ///url - The url computed property is a constant that will represent the url of the request
    var url:  String { return "\(SF_BASE_URL)/venues/\(SF_VENUE)/stocks/\(symbol)"}
}

/**
This API will request the status of an order from the venue defined by the global _SF_VENUE_ constant.  This constant is defined in the StockFighterInfo file.  Use the _StockFighterQueryOrderResponse_ type to parse the response from this call.
*/
struct StockFighterQueryOrder: StockFighterRequestType {
    var id: Int
    
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return  RSTransactionType.GET}
    
    ///url - The url computed property is a constant that will represent the url of the request
    var url:  String { return "\(SF_BASE_URL)/venues/\(SF_VENUE)/stocks/\(SF_STOCK_SYMBOL)/orders/\(id)"}
}

/**
This API will cancel an order from the venue defined by the global _SF_VENUE_ constant.  This constant is defined in the StockFighterInfo file.  Use the _StockFighterCancelOrderResponse_ type to parse the response from this call.
*/
struct StockFighterCancelOrder: StockFighterRequestType {
    var id: Int
    
    ///requestType - The requestType computed property is a constant that specifies whether the request is a GET or a POST request
    var requestType: RSTransactionType { return  RSTransactionType.DELETE}
    
    ///url - The url computed property is a constant that will represent the url of the request
    var url:  String { return "\(SF_BASE_URL)/venues/\(SF_VENUE)/stocks/\(SF_STOCK_SYMBOL)/orders/\(id)"}
}

