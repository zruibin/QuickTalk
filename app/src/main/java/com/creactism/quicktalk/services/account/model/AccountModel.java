package com.creactism.quicktalk.services.account.model;

import com.alibaba.fastjson.JSONObject;
import com.creactism.quicktalk.modules.networking.NetworkingAgent;
import com.creactism.quicktalk.modules.networking.QTResponseObject;
import com.creactism.quicktalk.util.StringUtil;

import com.alibaba.fastjson.JSON;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class AccountModel {

    private String id;
    private String uuid;
    private String qq;
    private String weibo;
    private int gender;
    private String detail;
    private String area;
    private String phone;
    private String wechat;
    private String avatar;
    private String password;
    private String nickname;
    private String email;
    private String token;

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

    public String getWeibo() {
        return weibo;
    }

    public void setWeibo(String weibo) {
        this.weibo = weibo;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getWechat() {
        return wechat;
    }

    public void setWechat(String wechat) {
        this.wechat = wechat;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }


    public static class CompleteHandler extends Object {
        public void completeHanlder (AccountModel accountModel, Error error){};
    }

    public static void requestLogin(String account, String password, String type, final CompleteHandler completeHandler) {
        Map params = new HashMap();
        params.put("account", account);
        params.put("type", type);
        params.put("password", password);

        NetworkingAgent.requestDataForAccountService("/login", NetworkingAgent.SERVICE_REQUEST_POST, params,
                new NetworkingAgent.CompleteHandler() {
            @Override
            public void completeHanlder(QTResponseObject responseObject, Error error) {
                if (error != null) {
                    completeHandler.completeHanlder(null, error);
                } else {
                    AccountModel model = null;
                    if (responseObject.getCode() == QTResponseObject.CODE_SUCCESS) {
                        try {
                            String data = String.valueOf(responseObject.getData());
                            model = JSONObject.parseObject(data, AccountModel.class);
                        } catch (Exception e) {
                            ;
                        }
                        completeHandler.completeHanlder(model, null);
                    } else {
                        error = new Error(responseObject.getMessage());
                        completeHandler.completeHanlder(null, error);
                    }
                }
            }
        });
    }

    public static void requestRegisterUser(String account, String password, String type, final CompleteHandler completeHandler) {
        Map params = new HashMap();
        params.put("account", account);
        params.put("type", type);
        params.put("password", password);
        NetworkingAgent.requestDataForAccountService("/register", NetworkingAgent.SERVICE_REQUEST_POST, params,
                new NetworkingAgent.CompleteHandler() {
                    @Override
                    public void completeHanlder(QTResponseObject responseObject, Error error) {
                        if (error != null) {
                            completeHandler.completeHanlder(null, error);
                        } else {
                            AccountModel model = null;
                            if (responseObject.getCode() == QTResponseObject.CODE_SUCCESS) {
                                try {
                                    String data = String.valueOf(responseObject.getData());
                                    model = JSONObject.parseObject(data, AccountModel.class);
                                } catch (Exception e) {
                                    ;
                                }
                                completeHandler.completeHanlder(model, null);
                            } else {
                                error = new Error(responseObject.getMessage());
                                completeHandler.completeHanlder(null, error);
                            }
                        }
                    }
                });

    }


}
