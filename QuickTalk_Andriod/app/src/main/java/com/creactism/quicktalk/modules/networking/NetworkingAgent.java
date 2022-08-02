package com.creactism.quicktalk.modules.networking;

import com.creactism.quicktalk.UserInfo;

import java.io.IOException;
import java.util.Map;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class NetworkingAgent extends Object {

//    public final static String QuickTalk_SERVICE_HOST = "http://192.168.0.116/service";
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
        if (UserInfo.sharedInstance().isLogin &&
                UserInfo.sharedInstance().getToken() != null &&
                UserInfo.sharedInstance().getToken().length() > 0) {
            params.put("token", UserInfo.sharedInstance().getToken());
        }
        String fullURL = NetworkingAgent.appendHostURL(serviceURL);
        Networking.handleRequest(fullURL, method, params, new Networking.Success(){
            @Override
            public void success(String responseString)  {
                QTResponseObject responseObject = QTResponseObject.createInstance(responseString);
                if (responseObject == null) {
                    handler.completeHanlder(null, new Error("网络开了点小差，请稍后再试!"));
                } else {
                    handler.completeHanlder(responseObject, null);
                }
            }
        }, new Networking.Failure(){
            @Override
            public void failure(IOException error) {
                handler.completeHanlder(null, new Error("网络开了点小差，请稍后再试!"));
            }
        });
    }

    public static void requestDataForAccountService(String serviceURL, String method,
                                                      Map<String, String> params, final CompleteHandler
                                                              handler) {
        String urlString = "/account" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

    public static void requestDataForStarService(String serviceURL, String method,
                                                    Map<String, String> params, final CompleteHandler
                                                            handler) {
        String urlString = "/star" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

    public static void requestDataForUserService(String serviceURL, String method,
                                                 Map<String, String> params, final CompleteHandler
                                                         handler) {
        String urlString = "/user" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

    public static void requestDataForSearchService(String serviceURL, String method,
                                                 Map<String, String> params, final CompleteHandler
                                                         handler) {
        String urlString = "/search" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

    public static void requestDataForUserPostService(String serviceURL, String method,
                                                   Map<String, String> params, final CompleteHandler
                                                           handler) {
        String urlString = "/userPost" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

    public static void requestDataForCollectionService(String serviceURL, String method,
                                                     Map<String, String> params, final CompleteHandler
                                                             handler) {
        String urlString = "/collection" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

    public static void requestDataForLikeService(String serviceURL, String method,
                                                       Map<String, String> params, final CompleteHandler
                                                               handler) {
        String urlString = "/like" + serviceURL;
        requestDataForQuickTalkService(urlString, method, params, handler);
    }

}
