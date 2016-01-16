//
//  StockFighterResponseTypes.swift
//  StockFighter1
//
//  Created by Jon Hoffman on 1/9/16.
//  Copyright © 2016 Jon Hoffman. All rights reserved.
//

import Foundation

/**
This protocol is implemented by all Stock Fighter types that are used to parse responses from the Stock Fighter API.  The responses are returned as NSDictionary types therefore all types must have an initalizer that parses a NSDictionary object.  This protocol specifies one computed property and one initializer

    ----
    
    __Parameters__
    *ok - Is a boolean value that specifies if the request did what was expected

    ----

    __Initializers__
    *init(dict: NSDictionary) - Should parse the NSDictionary object that represents the response from the server.


*/
protocol StockFighterResponseType {
    var ok: Bool? {get}
    init(dict: NSDictionary)
}

/**
    This type will parse the response returned from the _StockFighterAPIStatus_ request.  This request checks to make sure that the Stock Fighter API is up and functioning properly.
*/
struct StockFighterAPIStatusResponse: StockFighterResponseType {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///Will contain any error message
    let error: String?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        error = dict.valueForKey(SFKeys.ERROR) as? String
    }
}

/**
    This type will parse the response returned form the _StockFighterVenueStatus_ request.  This request checks to see if the venue defined by the global _SF_VENUE_ constant is up and functioning property
*/
struct StockFighterVenueStatusResponse: StockFighterResponseType {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///The venue that was checked
    let venue: String?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        venue = dict.valueForKey(SFKeys.VENUE) as? String
    }
}

/**
    This type will parse the response returned from the _StockFighterStocksOnVenue_ request.  This request return a list of stocks on the venue defined by the global _SF_VENUE_ constant
*/
struct StockFighterStocksOnVenueResponse: StockFighterResponseType {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///This list of stocks on the venue
    let stocks: [StockFighterStock]?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        let arr = dict.valueForKey(SFKeys.SYMBOLS) as? [NSDictionary]
        if let arr = arr {
            stocks = [StockFighterStock]()
            for item in arr {
                stocks?.append(StockFighterStock(dict: item))
            }
        } else {
            stocks = nil
        }
    }
}

/**
    This type will parse the response returned form the _StockFighterOrder_ request.  This request will make a new order for a stock
*/
struct StockFighterOrderResponse: StockFighterResponseType {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///The symbol of the stock we are purchasing or selling
    let symbol: String?
    
    ///The venue we are placing the order on
    let venue: String?
    
    ///Specifies if the order was a purchase or sell order
    let direction: String?
    
    ///The quantity requested
    let originalQty: Int?
    
    ///The quantity remaining on the order
    let qty: Int?
    
    ///The price that the shares were purchased or sold at
    let price: Double?
    
    ///What type of order this was (Limit, Market, FOK or IOC
    let type: String?
    
    ///The id assigned to the order
    let id: Int?
    
    ///What account the order was placed on
    let account: String?
    
    ///The timestamp of the order
    let ts: String?
    
    ///Lists the fill orders that show how the order was filled
    let fills: [StockFighterFill]?
    
    ///Lists the total shares that were bought or sold
    let totalFill: Int?
    
    ///Is a boolean value that specifies if the order is still open or not.
    let open: Bool?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        symbol = dict.valueForKey(SFKeys.SYMBOL) as? String
        venue = dict.valueForKey(SFKeys.VENUE) as? String
        direction = dict.valueForKey(SFKeys.DIRECTION) as? String
        originalQty = dict.valueForKey(SFKeys.ORIGINAL_QTY) as? Int
        qty = dict.valueForKey(SFKeys.QTY) as? Int
        price = dict.valueForKey(SFKeys.PRICE) as? Double
        type = dict.valueForKey(SFKeys.TYPE) as? String
        id = dict.valueForKey(SFKeys.ID) as? Int
        account = dict.valueForKey(SFKeys.ACCOUNT) as? String
        ts = dict.valueForKey(SFKeys.TIMESTAMP) as? String
        if let arr = dict.valueForKey(SFKeys.FILLS) as? [NSDictionary] {
            fills = [StockFighterFill]()
            for item in arr {
                fills?.append(StockFighterFill(dict: item))
            }
        } else {
            fills = nil
        }
        
        totalFill = dict.valueForKey(SFKeys.TOTAL_FILLED) as? Int
        open = dict.valueForKey(SFKeys.OPEN) as? Bool
    }
}

/**
This type will parse the response returned form the _StockFighterQueryOrder_ request.  This request will check the status of an order from the venue defined by the global _SF_VENUE_ constant
*/
struct StockFighterQueryOrderResponse: StockFighterResponseType {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///Is the symbol of the stock from the order
    let symbol: String?
    
    ///Is the venue that the order was placed on
    let venue: String?
    
    ///If the order was a buy or sell order
    let direction: String?
    
    ///Was the original quantity to purchase or sell
    let originalQty: Int?
    
    ///The quantity remaining on the order
    let qty: Int?
    
    ///The price on the order
    let price: Double?
    
    ///What type of order this was (Limit, Market, FOK or IOC
    let type: String?
    
    ///The ID of the order
    let id: Int?
    
    ///What account the order was place on
    let account: String?
    
    ///The timestamp the order was placed
    let ts: String?
    
    ///Lists the fill orders that show how the order was filled
    let fills: [StockFighterFill]?
    
    ///Lists the total shares that were bought or sold
    let totalFill: Int?
    
    ///If the order is till open or not
    let open: Bool?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        symbol = dict.valueForKey(SFKeys.SYMBOL) as? String
        venue = dict.valueForKey(SFKeys.VENUE) as? String
        direction = dict.valueForKey(SFKeys.DIRECTION) as? String
        originalQty = dict.valueForKey(SFKeys.ORIGINAL_QTY) as? Int
        qty = dict.valueForKey(SFKeys.QTY) as? Int
        price = dict.valueForKey(SFKeys.PRICE) as? Double
        type = dict.valueForKey(SFKeys.TYPE) as? String
        id = dict.valueForKey(SFKeys.ID) as? Int
        account = dict.valueForKey(SFKeys.ACCOUNT) as? String
        ts = dict.valueForKey(SFKeys.TIMESTAMP) as? String
        if let arr = dict.valueForKey(SFKeys.FILLS) as? [NSDictionary] {
            fills = [StockFighterFill]()
            for item in arr {
                fills?.append(StockFighterFill(dict: item))
            }
        } else {
            fills = nil
        }
        totalFill = dict.valueForKey(SFKeys.TOTAL_FILLED) as? Int
        open = dict.valueForKey(SFKeys.OPEN) as? Bool
    }
}

/**
This type will parse the response returned form the _StockFighterCancelOrder_ request.  This request will return the status of the order cancelled from the venue defined by the global _SF_VENUE_ constant
*/
struct StockFighterCancelOrderResponse: StockFighterResponseType {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///Is the symbol of the stock from the order
    let symbol: String?
    
    ///Is the venue that the order was placed on
    let venue: String?
    
    ///If the order was a buy or sell order
    let direction: String?
    
    ///Was the original quantity to purchase or sell
    let originalQty: Int?
    
    ///The quantity remaining on the order
    let qty: Int?
    
    ///The price on the order
    let price: Double?
    
    ///What type of order this was (Limit, Market, FOK or IOC
    let type: String?
    
    ///The ID of the order
    let id: Int?
    
    ///What account the order was place on
    let account: String?
    
    ///The timestamp the order was placed
    let ts: String?
    
    ///Lists the fill orders that show how the order was filled
    let fills: [StockFighterFill]?
    
    ///Lists the total shares that were bought or sold
    let totalFill: Int?
    
    ///If the order is till open or not
    let open: Bool?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        symbol = dict.valueForKey(SFKeys.SYMBOL) as? String
        venue = dict.valueForKey(SFKeys.VENUE) as? String
        direction = dict.valueForKey(SFKeys.DIRECTION) as? String
        originalQty = dict.valueForKey(SFKeys.ORIGINAL_QTY) as? Int
        qty = dict.valueForKey(SFKeys.QTY) as? Int
        price = dict.valueForKey(SFKeys.PRICE) as? Double
        type = dict.valueForKey(SFKeys.TYPE) as? String
        id = dict.valueForKey(SFKeys.ID) as? Int
        account = dict.valueForKey(SFKeys.ACCOUNT) as? String
        ts = dict.valueForKey(SFKeys.TIMESTAMP) as? String
        if let arr = dict.valueForKey(SFKeys.FILLS) as? [NSDictionary] {
            fills = [StockFighterFill]()
            for item in arr {
                fills?.append(StockFighterFill(dict: item))
            }
        } else {
            fills = nil
        }
        totalFill = dict.valueForKey(SFKeys.TOTAL_FILLED) as? Int
        open = dict.valueForKey(SFKeys.OPEN) as? Bool
    }
}



/**
This type will parse the response returned form the _StockFighterOrderBook_ request.  This request will check the orderbook from the venue defined by the global _SF_VENUE_ constant
*/
struct StockFighterOrderBookResponse {
    ///Is a boolean value that specifies if the request did what was expected
    let ok: Bool?
    
    ///Is the symbol of the stock we requested the order book for
    let symbol: String?
    
    ///The venue the orderbook is from
    let venue: String?
    
    ///A list of bids for the stock
    let bids: [StockFighterOrderBids]?
    
    ///A list of asks for the stock
    let asks: [StockFighterOrderBids]?
    
    ///The timestamp the book was grabbed at
    let ts: String?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        ok = dict.valueForKey(SFKeys.STATUS) as? Bool
        symbol = dict.valueForKey(SFKeys.SYMBOL) as? String
        venue = dict.valueForKey(SFKeys.VENUE) as? String
        
        let arrBids = dict.valueForKey(SFKeys.BIDS) as? [NSDictionary]
        if let arr = arrBids {
            bids = [StockFighterOrderBids]()
            for item in arr {
                bids?.append(StockFighterOrderBids(dict: item))
            }
        } else {
            bids = nil
        }
        
        let arrAsks = dict.valueForKey(SFKeys.ASKS) as? [NSDictionary]
        if let arr = arrAsks {
            asks = [StockFighterOrderBids]()
            for item in arr {
                asks?.append(StockFighterOrderBids(dict: item))
            }
        } else {
            asks = nil
        }
        ts = dict.valueForKey(SFKeys.TIMESTAMP) as? String
    }
}

/**
This is a type that represents a fill request
*/
struct StockFighterFill {
    ///The price the order was filled at
    let price: Double?
    
    ///The quantity filled
    let qty: Int?
    
    ///The timestamp of the fill
    let ts: String?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        price = dict.valueForKey(SFKeys.PRICE) as? Double
        qty = dict.valueForKey(SFKeys.QTY) as? Int
        ts = dict.valueForKey(SFKeys.TIMESTAMP) as? String
    }
}

/**
This is a type that represents a stock
*/
struct StockFighterStock {
    ///The name of the stock
    let name: String?
    
    ///The ksymbol of the stock
    let symbol: String?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        name = dict.valueForKey(SFKeys.NAME) as? String
        symbol = dict.valueForKey(SFKeys.SYMBOL) as? String
    }
}

/**
This is a type that represents a order bid
*/
struct StockFighterOrderBids {
    ///The price on the bid
    let price: Double?
    
    ///The quantity of the bid
    let qty: Int?
    
    ///True if it is a buy bid
    let isBuy: Bool?
    
    ///Will parse the NSDictionary object that represents the response from the server.
    init(dict: NSDictionary) {
        price = dict.valueForKey(SFKeys.PRICE) as? Double
        qty = dict.valueForKey(SFKeys.QTY) as? Int
        isBuy = dict.valueForKey(SFKeys.IS_BUY) as? Bool
    }

}
