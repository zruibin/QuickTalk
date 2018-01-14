package com.creactism.quicktalk.services.userpost.model;

import android.os.Handler;
import android.os.Message;

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

        final Handler handler = new Handler(new Handler.Callback() { //主线程
            @Override
            public boolean handleMessage(Message msg) {
                QTResponseObject obj = (QTResponseObject)msg.obj;
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
                return false;
            }
        });

        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(10, TimeUnit.SECONDS).readTimeout(10, TimeUnit.SECONDS).build();
        RequestBody requestBodyPost = new FormBody.Builder()
                .add("index", "1")
                .build();
        Request requestPost = new Request.Builder()
                .url("http://creactism.com/service/quickTalk/userPost/recommendUserPostList")
                .post(requestBodyPost)
                .build();
        client.newCall(requestPost).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {

            }
            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String result = response.body().string();//5.获得网络数据
                DLog.debug(result);

                QTResponseObject obj = QTResponseObject.createInstance(result);
                Message msg = handler.obtainMessage();
                msg.obj = obj;
                msg.sendToTarget(); //异步线程返回数据到主线程
            }
        });
    }
}
