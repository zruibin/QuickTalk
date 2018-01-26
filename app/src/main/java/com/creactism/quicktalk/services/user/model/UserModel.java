package com.creactism.quicktalk.services.user.model;

import com.alibaba.fastjson.JSONObject;
import com.creactism.quicktalk.modules.networking.NetworkingAgent;
import com.creactism.quicktalk.modules.networking.QTResponseObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ruibin.chow on 26/01/2018.
 */

public class UserModel {

    private String id;
    private String uuid;
    private String qq;
    private String wechat;
    private String weibo;
    private String nickname;
    private Object area;
    private int gender;
    private Object detail;
    private String phone;
    private String avatar;
    private String time;
    private String email;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getWechat() {
        return wechat;
    }

    public void setWechat(String wechat) {
        this.wechat = wechat;
    }

    public String getWeibo() {
        return weibo;
    }

    public void setWeibo(String weibo) {
        this.weibo = weibo;
    }

    public String getNickname() {
        if (this.nickname == null) {
            this.nickname = "用户"+this.id;
        }
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public Object getArea() {
        return area;
    }

    public void setArea(Object area) {
        this.area = area;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public Object getDetail() {
        return detail;
    }

    public void setDetail(Object detail) {
        this.detail = detail;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public static class CompleteHandler extends Object {
        public void completeHanlder (List<UserModel> list, Error error){};
        public void completeHanlder (boolean action, Error error){};

    }


    public static void requestForStarUser(String userUUID, int index, final CompleteHandler completeHandler) {
        Map params = new HashMap();
        params.put("user_uuid", userUUID);
        params.put("index", String.valueOf(index));

        NetworkingAgent.requestDataForStarService("/queryStarUser", NetworkingAgent.SERVICE_REQUEST_POST, params,
                new NetworkingAgent.CompleteHandler() {
            @Override
            public void completeHanlder(QTResponseObject responseObject, Error error) {
                if (error != null) {
                    completeHandler.completeHanlder(null, error);
                } else {
                    List<UserModel> list = new ArrayList<UserModel>();
                    if (responseObject.getCode() == QTResponseObject.CODE_SUCCESS) {
                        try {
                            String data = String.valueOf(responseObject.getData());
                            list = JSONObject.parseArray(data, UserModel.class);
                        } catch (Exception e) {
                            ;
                        }
                        completeHandler.completeHanlder(list, null);
                    } else {
                        error = new Error(responseObject.getMessage());
                        completeHandler.completeHanlder(null, error);
                    }
                }
            }
        });
    }


}
