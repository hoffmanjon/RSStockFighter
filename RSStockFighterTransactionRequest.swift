//
//  RSTransactionRequest.swift
//  RSNetworkSample
//
//  Created by Jon Hoffman on 7/25/14.
//  Copyright (c) 2014 Jon Hoffman. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

///Function to make sure we have a proper URL string
private func urlEncode(s: String) -> String? {
    return s.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
}

/**
This type will contains the methods that will send the request to the Stock Fighter API.  The requests are made asynchronously and the results are returned through clousures (completion handlers)
*/
struct RSStockFighterTransactionRequest {
    ///The default root key to use if we need to build a dictionary to return
    let defaultKey = "results"
    
    ///Type alias to define the completion handler when we return a NSData object for our response
    private typealias dataFromRSTransactionCompletionClosure = ((NSURLResponse!, NSData!, NSError!) -> Void)
    
    ///Type alias to define the completion handler when we return a NSDictionary object for our response
    typealias dictionaryFromRSTransactionCompletionClosure = ((NSURLResponse!, NSDictionary!, NSError!) -> Void)
    
    /** 
    This method will determine if the request is a GET or POST request and call the appropriate method to make the request.  The results from the request are returned as NSData objects.  The dictionaryFromRSTransaction() method uses this method to make its request.
    
    - parameters:
        - transaction:  The instance of the RSStockFighterTransaction type that represents the transaction
        - completionHandler:  The completion handler to call when the server responds to the request
    */
    private func dataFromRSTransaction(transaction: RSStockFighterTransaction, completionHandler handler: dataFromRSTransactionCompletionClosure)
    {
        if (transaction.transactionType == RSTransactionType.GET) {
            dataFromRSTransactionGetDelete(transaction, completionHandler: handler);
        } else if(transaction.transactionType == RSTransactionType.POST) {
            dataFromRSTransactionPost(transaction, completionHandler: handler);
        } else if(transaction.transactionType == RSTransactionType.DELETE) {
            dataFromRSTransactionGetDelete(transaction, completionHandler: handler);
        }
    }
    
    /**
    This method performs a POST request to the correct Stock Fighter API.  The results are returned a NSData object
    
    - parameters:
        - transaction:  The instance of the RSStockFighterTransaction type that represents the transaction
        - completionHandler:  The completion handler to call when the server responds to the request
    */
    private func dataFromRSTransactionPost(transaction: RSStockFighterTransaction, completionHandler handler: dataFromRSTransactionCompletionClosure)
    {
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlString = transaction.getFullURLString()
        let url: NSURL = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL:url)
        request.addValue(SF_API_KEY, forHTTPHeaderField: "X-StarFighter-Authorization")
        request.HTTPMethod = "POST"
        if let transType = transaction.transType as? StockFighterPostRequestType {
            let params = transType.getJsonString()
    
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        urlSession.dataTaskWithRequest(request, completionHandler: {(responseData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            handler(response,responseData,error)
        }).resume()
    }
    
    /**
    This method performs a GET or DELETE request to the correct Stock Fighter API.  The results are returned a NSData object

    - parameters:
        - transaction:  The instance of the RSStockFighterTransaction type that represents the transaction
        - completionHandler:  The completion handler to call when the server responds to the request
    */
    private func dataFromRSTransactionGetDelete(transaction: RSStockFighterTransaction, completionHandler handler: dataFromRSTransactionCompletionClosure)
    {
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlString = transaction.getFullURLString()
        let url: NSURL = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL:url)
        request.addValue(SF_API_KEY, forHTTPHeaderField: "X-StarFighter-Authorization")
        request.HTTPMethod = transaction.transactionType.rawValue
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        urlSession.dataTaskWithRequest(request, completionHandler: {(responseData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            handler(response,responseData,error)
        }).resume()
    }
    
    /**
    This method will take an instance of the RSStockFighterTransaction type and send the requested transaction to the Stock Fighter API.  This the server responds, the completion handler will be called.
    - parameters:
        - transaction:  The instance of the RSStockFighterTransaction type that represents the transaction
        - completionHandler:  The completion handler to call when the server responds to the request
    */
    func dictionaryFromRSTransaction(transaction: RSStockFighterTransaction, completionHandler handler: dictionaryFromRSTransactionCompletionClosure) {
        dataFromRSTransaction(transaction, completionHandler: {(response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            var resultDictionary = NSMutableDictionary()
            var jsonResponse : AnyObject?
            do {
                jsonResponse  = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
            } catch {}
            
            if let jsonResponse = jsonResponse {
                switch jsonResponse {
                case is NSDictionary:
                    resultDictionary = jsonResponse as! NSMutableDictionary
                case is NSArray:
                    resultDictionary[self.defaultKey] = jsonResponse
                default:
                    resultDictionary[self.defaultKey] = ""
                }
            } else {
                resultDictionary[self.defaultKey] = ""
            }
            handler(response,resultDictionary.copy() as! NSDictionary,error)
        })
    }
}
