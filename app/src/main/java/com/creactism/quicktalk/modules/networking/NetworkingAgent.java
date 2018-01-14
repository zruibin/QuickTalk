package com.creactism.quicktalk.modules.networking;

import java.io.IOException;
import java.util.Map;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class NetworkingAgent extends Object {

//    public final static String QuickTalk_SERVICE_HOST = "http://192.168.0.103/service";
    public final static String QuickTalk_SERVICE_HOST = "http://creactism.com/service";
    public final static String  SERVICE_REQUEST_GET = "GET";
    public final static String  SERVICE_REQUEST_POST = "POST";

    public static String appendHostURL(String subURL) {
        return QuickTalk_SERVICE_HOST + "/quickTalk" + subURL;
    }

    public abstract static class CompleteHandler extends Object {
        public abstract void completeHanlder (QTResponseObject responseObject, Error error);
    }

    public static void requestDataForQuickTalkService(String serviceURL, String method,
                                                      Map<String, String> params, final CompleteHandler
                                                             handler) {
        String fullURL = NetworkingAgent.appendHostURL(serviceURL);
        Networking.handleRequest(fullURL, method, params, new Networking.Success(){
            @Override
            public void success(String responseString)  {
                QTResponseObject responseObject = QTResponseObject.createInstance(responseString);
                handler.completeHanlder(responseObject, null);
            }
        }, new Networking.Failure(){
            @Override
            public void failure(IOException error) {
                handler.completeHanlder(null, new Error(error.getMessage()));
            }
        });
    }

}
