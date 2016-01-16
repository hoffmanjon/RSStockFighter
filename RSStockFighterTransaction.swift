//
//  RSTransaction.swift
//  RSNetworkSample
//
//  Created by Jon Hoffman on 7/25/14.
//  Copyright (c) 2014 Jon Hoffman. All rights reserved.
//

import Foundation

/**
The enumeration defines the type of HTTP request to make.  The possible values are:
- GET
- POST
- UNKNOWN

- Note:  A transaction with a value of UNKNOWN is normally rejected and should only be used for testing purposes
*/
enum RSTransactionType: String{
    case GET
    case POST
    case DELETE
    case UNKNOWN
}

/**
This class encapsulates all of the information needed to send a transaction to the Stock Fighter API.  The StockFighterTransactionRequest type requires an instance of this class to make the request.
*/
class RSStockFighterTransaction {
    ///The transacation type.  This should be either GET or POST
    var transactionType = RSTransactionType.UNKNOWN
    
    ///The base URL for the request
    var baseURL: String
    
    ///Additional path elements
    var path: String
    
    ///An instance of a type that conforms to the StockFighterRequestType protocol.  This instance should contain the information that the API needs to respond to the request
    var transType: StockFighterRequestType?
    
    /**
    Initialize the type with the information needed to properly initiate it
    
    - parameters:
        - transactionType:  This parameter accepts an instance of the RSTransactionType type that represents the transaction to send
        - baseURL:  The base URL for the request
        - path:  Additional path elements
        - transType:  An instance of a type that conforms to the StockFighterRequestType protocol.  This instance should contain the information that the API needs to respond to the request
    
    - author:  Jon Hoffman
    
    */
    init(transactionType: RSTransactionType, baseURL: String,  path: String, transType: StockFighterRequestType?) {
        self.transactionType = transactionType
        self.baseURL = baseURL
        self.path = path
        self.transType = transType
    }
    
    /**
    Get the full path to make the request
    - returns: A String instance that represents the full path
    */
    func getFullURLString() -> String {
        return removeSlashFromEndOfString(removeSlashFromEndOfString(self.baseURL) + "/" + removeSlashFromStartOfString(self.path))
    }
    
    /**
    Clean up the URL string by removing any hanging slashes.
    
    - parameters:
        - string:  The string to remove the slashes from
    - returns:  A String instance that represents the string without any slashes at the end
    */
    private func removeSlashFromEndOfString(string: String) -> String
    {
        if string.hasSuffix("/") {
            return string.substringToIndex(string.endIndex.predecessor())
        } else {
            return string
        }
        
    }
    
    /**
    Clean up the URL string by removing any slashes from the beginning of the string.
    
    - parameters:
        - string:  The string to remove the slashes from
    - returns:  A String instance that represents the string without any slashes at the beginning
    */
    private func removeSlashFromStartOfString(string : String) -> String {
        if string.hasPrefix("/") {
            return string.substringFromIndex(string.startIndex.successor())
        } else {
            return string
        }
    }
}
