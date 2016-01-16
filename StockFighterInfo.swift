//
//  StockFighterInfo.swift
//  StockFighter1
//
//  Created by Jon Hoffman on 1/8/16.
//  Copyright © 2016 Jon Hoffman. All rights reserved.
//

import Foundation

/*
    These are Global constants that our API will use
*/

/**
    SF_API_KEY is our StockFighter API key
    - Important:
    __This only changes when we create a new key__
*/
let SF_API_KEY = "0d28db6889c31c49cadaa2583bd536e05261ebff"

/**
    SF_VENUE is the venue that we are currently using for this challenge
    - Important:
    __This changes everytime we start or restart a challenge__
*/
let SF_VENUE = "ESTMEX"

/**
    SF_ACCOUNT is the account that we are currently using for this challenge
    - Important:
    __This changes everytime we start or restart a challenge__
*/
let SF_ACCOUNT = "LMB56027543"

/**
    SF_STOCk_SYMBOL is the symbol of the stock for this challenge
    - Important:
    __This changes everytime we start or restart a challenge__
*/
let SF_STOCK_SYMBOL = "LTL"

/**
    SF_BASE_URL is the base URL to access the API
    - Important:
    __Hopefully this will not change__
*/
let SF_BASE_URL = "https://api.stockfighter.io/ob/api"

/**
    The SF_OrderTypes is the types of orders we can place
    
    Values
    * Limit - Immediately matches any order on the books that has an offer price as good or better than the one listed on the order.  This order type is good until cancelled
    * Market - Immediately matches any order.  Do not use this type.
    * FOK - Fill or Kill:  Immediately fills the whole order.  If it cannot fill the whole order immediately then the whole order is killed
    * IOC - Immediate or Cancel:  Immediately fills or partially fills the whole order and then cancels any shares that remains.
*/
enum SF_OrderTypes: String {
    case Limit
    case Market
    case FOK
    case IOC
}

/**
    The SF_OrderDirection is used to specify whether our order is a buy order or a sell order

    values
    * Buy - The order is a purchase shares
    * Sell - The order is to sell shares
*/
enum SF_OrderDirection: String {
    case Buy = "buy"
    case Sell = "sell"
}

/**
    This completion handler will be called if there was an issue with with the API call

    The String value will contain a message specifing what went wrong
*/
typealias FailureReceivedCompletionHandler = (String)->Void

/**
    This completion handler will be called if we received a valid response back from our API call

    The NSDictionary value will contain the results of the response.  We use the NSDictionary type because it represents JSON data better than the Swift Dictionary type.
*/
typealias ResponseReceivedCompletionHandler = (NSDictionary!)->Void


/**
    This class will contains methods to help us make requests to the Stock Fighter API

    ----

    Methods:
    * _sendStockFighterTransaction_ - This method will send a request to the Stock Fighter API
*/
struct StockFighterHelper {
    
    /**
    The method will send a request to the Stock Fighter API.  This method is designed to hide the complexity of using the _RSStockFighterTransactionRequest_ and the _RSStockFighterTransaction_ types.  You can by pass this method if you prefer to use those _RSStockFighterTransactionRequest_ and the _RSStockFighterTransaction_ types.
        
    - parameters:
        - transType:  This parameter accepts an instance of the StockFighterRequestType type that represents the transaction to send
        - success:  This parameter is of the ResonseReceivedCompletionHander type and will receive the response if the API call was successful
        - failure: This parameter is of the FailureReceivedCompletionHandler type and will receive the error message if the API call was not successful
    */
    static func sendStockFighterTransaction(transType: StockFighterRequestType, success: ResponseReceivedCompletionHandler, failure: FailureReceivedCompletionHandler) {
        let rsRequest = RSStockFighterTransactionRequest()
        //Create the initial request
        let rsTransPost = RSStockFighterTransaction(transactionType: transType.requestType, baseURL: transType.url, path: "", transType: transType)
        rsRequest.dictionaryFromRSTransaction(rsTransPost, completionHandler: {(response : NSURLResponse!, responseDictionary: NSDictionary!, error: NSError!) -> Void in
            if let error = error {
                failure("Error: \(error)")
            } else {
                if let ok = responseDictionary["ok"] where ok as! NSObject == true {
                    success(responseDictionary)
                } else {
                    failure("Failure resonse \(responseDictionary)")
                }
            }
        })
    }
    
}