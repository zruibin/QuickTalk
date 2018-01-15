package com.creactism.quicktalk.modules.networking;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import com.creactism.quicktalk.modules.Dispatch;
import com.creactism.quicktalk.util.DLog;

import java.io.IOException;
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

public class Networking extends Object {

    public static OkHttpClient httpClient() {
        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(10, TimeUnit.SECONDS).readTimeout(10, TimeUnit.SECONDS).build();
        return client;
    }

    public static Request requestURL(String baseURL, String method, Map<String, String> params) {
        if (method.length() == 0) {
            method = "GET";
        }

        Request request = null;
        if (method.equalsIgnoreCase("GET")) {
            StringBuffer stringBuffer = new StringBuffer();
            for (String key : params.keySet()) {
                String value = params.get(key);
                stringBuffer.append(key + "=" + value + "&");
            }
            String url = baseURL + "?" + stringBuffer.toString();
            request = new Request.Builder().url(url).get().build();
        } else {
            FormBody.Builder builder = new FormBody.Builder();
            for (String key : params.keySet()) {
                String value = params.get(key);
                builder.add(key, value);
            }

            RequestBody requestBodyPost = builder.build();
            request = new Request.Builder()
                    .url(baseURL)
                    .post(requestBodyPost)
                    .build();
        }
        return request;
    }

    public static void handleRequest (String url, String method, Map<String, String>params,
                                      final Success success, final Failure failure) {
        final Handler handler = new Handler(Looper.getMainLooper()) { //主线程
            @Override
            public void handleMessage(Message msg) {
                switch (msg.what) {
                    case 1:
                        failure.failure((IOException)msg.obj);
                        break;
                    case 2:
                        String responseString = (String)msg.obj;
                        success.success(responseString);
                        break;
                }
            }
        };

        OkHttpClient client = Networking.httpClient();
        Request requestPost = Networking.requestURL(url, method, params);
        client.newCall(requestPost).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Message msg = handler.obtainMessage();
                msg.what = 1;
                msg.obj = e;
                msg.sendToTarget(); //异步线程返回数据到主线程
            }
            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String responseString = response.body().string();
                Message msg = handler.obtainMessage();
                msg.what = 2;
                msg.obj = responseString;
                msg.sendToTarget(); //异步线程返回数据到主线程
            }
        });
    }

    public abstract static class Success {
        public abstract void success(String responseString);
    }

    public abstract static class Failure {
        public abstract void failure(IOException error);
    }
}
