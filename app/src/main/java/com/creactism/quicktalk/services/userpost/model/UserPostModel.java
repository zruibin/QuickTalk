package com.creactism.quicktalk.services.userpost.model;

import com.creactism.quicktalk.modules.networking.NetworkingAgent;
import com.creactism.quicktalk.modules.networking.QTResponseObject;
import com.creactism.quicktalk.util.DLog;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class UserPostModel extends Object {


    public abstract static class CompleteHandler extends Object {
        public abstract void completeHanlder (List list, Error error);
    }


    public static void requestUserPostData(String userUUID, int index, final CompleteHandler
            completeHandlerObj) {

        Map params = new HashMap();
        params.put("index", String.valueOf(index));

        NetworkingAgent.requestDataForQuickTalkService("/userPost/recommendUserPostList",
                "GET", params, new NetworkingAgent.CompleteHandler() {
                    @Override
                    public void completeHanlder(QTResponseObject responseObject, Error error) {
                        DLog.info("code: " + String.valueOf(responseObject.getCode()));
                        DLog.info("message: " + responseObject.getMessage());
                        List list = (List)responseObject.getData();
                        List callBackList = new ArrayList();
                        for (int i = 0; i < list.size(); i++) {
                            Map temp = (Map) list.get(i);
                            DLog.debug((String)temp.get("title"));
                            callBackList.add((String)temp.get("title"));
                        }
                        completeHandlerObj.completeHanlder(callBackList, error);
                    }
         });
    }
}
