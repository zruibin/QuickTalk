package com.creactism.quicktalk.modules.networking;

import com.google.gson.Gson;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public final class QTResponseObject extends Object {

    private int code;
    private String message;
    private Object data;

    public static QTResponseObject createInstance(String string) {
        Gson gson = new Gson();
        Map<String, Object> map = new HashMap<String, Object>();
        map = gson.fromJson(string, map.getClass());

        QTResponseObject obj = new QTResponseObject();
        obj.code = new Double((Double)map.get("code")).intValue();
        obj.message = (String) map.get("message");
        obj.data = map.get("data");

        return obj;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
