#RSStockFighter#
StockFighter is a really nice (and free) online coding challenge where you need to solve a series of problems by using your coding skills.   You can read about [StockFigher here](https://starfighter.readme.io). 
RSStockFighter is a framework designed to make interacting with the StockFighter API incredibly easy so you can focus on solving the individual levels rather than the back end code.  You can read about how this framework is designed [here]()

#Setting up RSStockFighter#
The first thing you need to do is to add the six RSStockFighter files to your project.  These files are:
- StockFighterInfo
- StockFighterKeys
-	StockFighterRequestTypes
-	StockFighterResponseTypes
-	RSStockFighterTransactionRequest
-	RSStockFighterTransaction

Edit the StockFighterInfo file to set the following constants:
- SF_API_KEY: Your API ley
-	SF_VENUE: The venue you are using for this challenge
-	SF_ACCOUNT:  The account you are using for this challenge
-	SF_STOCK_SYMBOL:  The symbol of the stock you are using for this challenge

Now you are set to use the framework

#Using RSStockFighter#
We use the static *sendStockFighterTransaction()* method from the *StockFighterHelper* type to make a request to the StockFighter API.  The *sendStockFighterTransaction()* method has three parameters which are:
-	transType:  An instance of a type that conforms to the *StockFigherRequestType* protocol which contains the information for our request.  
-	success:   A completion handler that will be called if the StockFighter API call was successful
-	failure:  A completion handler that will be called if the StockFigher API call failed.

There are seven types that confrom to the *StockFigherRequestType* protocol which can be used with the *sendStockFighterTransaction()* method.  Each type represents a StockFighter API call.  These types are:
-	StockFighterAPIStatus
-	StockFighterVenueStatus
-	StockFighterStocksOnVenue
-	StockFighterOrder
-	StockFighterOrderBook
-	StockFighterQueryOrder
-	StockFighterCancelOrder

To make a request to the StockFighter API we would begin by creating an instance of one of the seven Stockfighter Request types and then use it with the *sendStockFighterTransaction()* method.  For example the following code would request the API status from the StockFighter API:

```
let request = StockFighterAPIStatus()
        
StockFighterHelper.sendStockFighterTransaction(request, success: {
   (dict:NSDictionary!) -> Void in
    	  self.checkStatusResponse(dict)
    }, failure: {
    (str: String) -> Void in
        print("Error:  \(str)")
    }
)
```
In the previous code we created an instance of the *StockFighterAPIStatus* type and then used it to call the *sendStockFighterTransaction()* method.  The *sendStockFighterTransaction()* method also has two completion handlers one named success which is called if the API call was successful and one named failure which is called if the API call failed.  In this example, we call the *checkStatusResponse()* method id the call was successful or print out the error message if the call failed.

For each of the seven Stockfighter Request types we have a corresponding StockFighter response type.  These response types will take the NSDictionary that is returned from the API request and parse it.  These seven StockFighter response type are:
-	StockFighterAPIStatusResponse
-	StockFighterVenueStatusResponse
-	StockFighterStocksOnVenueResponse
-	StockFighterOrderResponse
-	StockFighterOrderBookResponse
-	StockFighterQueryOrderResponse
-	StockFighterCancelOrderResponse

To parse the API status response from our last example we would create a *checkStatusResponse()* method like this:
```
func checkStatusResponse(dict: NSDictionary) {
    let response = StockFighterAPIStatusResponse(dict: dict)
    print("StockFighter is up:  \(response.ok)")
}
```

If we wanted to use the StockFighterOrder type to place an order, we would do it like this:
```
let order = StockFighterOrder(symbol:SF_STOCK_SYMBOL, price:95.00,qty: 100,direction:SF_OrderDirection.Buy,orderType:SF_OrderTypes.Limit.rawValue)
        
StockFighterHelper.sendStockFighterTransaction(order, success: {
    (dict:NSDictionary!) -> Void in
        self.checkOrderResponse(dict)
}, failure: {(str: String) -> Void in
        print(str)
})
```
The previous code creates an instance of the *StockFighterOrder* type and then uses it to call the *sendStockFighterTransaction()* method.  The *StockFighterOrder* initializer takes five parameters which are: 
-	symbol:  The stock symbol for the stock to place the order for
-	price:  The price to maximum price to buy or minimum price to sell the stock at
-	qty:  The quantity to buy or sell
-	direction:  Specifies if this is a buy or a sell order
-	orderType:  The order type

We would then parse the response like this:
```
func checkOrderResponse(dict: NSDictionary) {
    let response = StockFighterOrderResponse(dict: order)
}
````

There are two enumerations defined in this framework that you will be working with.  These are the SF_OrderTypes and SF_OrderDirection enumerations.  The SF_OrderTypes enumeration defines the type of order we are placing (You can read more about order types in the StockFighter help pages) and has the following values:
-	Limit - Immediately matches any order on the books that has an offer price as good or better than the one listed on the order.  This order type is good until cancelled
-	Market - Immediately matches any order.  Do not use this type.
-	FOK - Fill or Kill:  Immediately fills the whole order.  If it cannot fill the whole order immediately then the whole order is killed
-	IOC - Immediate or Cancel:  Immediately fills or partially fills the whole order and then cancels any shares that remains.

The SF_OrderDirection is used to define if the order is a buy or sell order and have the following values:
-	Buy - The order is a purchase shares
-	Sell - The order is to sell shares


#Questions#
*Is using RSStockFighter cheating at the challenge?*  Personally I do not think so.  I see using RSStockFighter like using any other third party framework (like the Alamofire framework) in our applications.  We use third party frameworks in our day to day development work to make our lives easier so we can focus on the business logic, why not use them to make challenges like this easier so we can focus on the business logic. 

