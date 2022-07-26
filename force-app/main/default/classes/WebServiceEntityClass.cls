/**
 * Description: web service help class
 * 
 * CHANGE HISTORY
 * =========================================
 * Date         Developer       Description
 * 2022-7-11    Xueqiang Duan   Create
 */
global with sharing class WebServiceEntityClass {

    global static string successCode = '200';
    global static string errorCode = '400';
    global static string successStatus='Success';
    global static string failureStatus = 'Failed';

    /** 
     * @description : This is the class to structure the response Array
     */    
    global class Response
    { 
        global string status;
        global string statusMsg;
        global string statusCode;
    }

    /********************************************************************************************************
    *  @description  responseMethod - This is the main method to handle the response  
    *  @return WebServiceEntityClass.response : this is a return statement and having return result as failure or success  
    *  @param statusCode - expected the statusCode parameters 
    *  @param statusMsg - expected the statusMsg parameters 
    *  @param status - expected the product status parameters 
    *********************************************************************************************************/
   
    global static WebServiceEntityClass.response responseMethod(String statusCode, String statusMsg, String status){
        WebServiceEntityClass.response res = new WebServiceEntityClass.response();
        res.statusCode = statusCode;
        res.statusMsg = statusMsg;
        res.status = status;
        return res;
    }

}