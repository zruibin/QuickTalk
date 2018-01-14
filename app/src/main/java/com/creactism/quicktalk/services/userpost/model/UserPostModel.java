package com.creactism.quicktalk.services.userpost.model;

import android.os.Handler;
import android.os.Message;

import com.creactism.quicktalk.modules.networking.Networking;
import com.creactism.quicktalk.modules.networking.QTResponseObject;
import com.creactism.quicktalk.util.DLog;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class UserPostModel extends Object {


    public abstract static class CompleteHandler extends Object {
        public abstract void completeHanlder (List list, Error error);
    }


    public static void requestUserPostData(String userUUID, final CompleteHandler completeHandlerObj) {

        Map params = new HashMap();
        params.put("index", "1");

        String url = "http://creactism.com/service/quickTalk/userPost/recommendUserPostList";
        Networking.handleRequest(url, "POST", params, new Networking.Success(){
            @Override
            public void success(String responseString)  {
                DLog.debug(responseString);
                QTResponseObject obj = QTResponseObject.createInstance(responseString);
                DLog.info("code: " + String.valueOf(obj.getCode()));
                DLog.info("message: " + obj.getMessage());
                List list = (List)obj.getData();
                List callBackList = new ArrayList();
                for (int i = 0; i < list.size(); i++) {
                    Map temp = (Map) list.get(i);
                    DLog.debug((String)temp.get("title"));
                    callBackList.add((String)temp.get("title"));
                }
                completeHandlerObj.completeHanlder(callBackList, null);
            }
        }, new Networking.Failure(){
            @Override
            public void failure(IOException error) {

            }
        });
    }
}
