package com.creactism.quicktalk.services.userpost.model;

import com.creactism.quicktalk.modules.networking.NetworkingAgent;
import com.creactism.quicktalk.modules.networking.QTResponseObject;
import com.alibaba.fastjson.JSON;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class UserPostModel extends Object {

    public class UserPostLikeModel extends Object {
        private String userId;
        private String avatar;
        private String time;
        private String nickname;

        public String getUserId() {
            return userId;
        }

        public void setUserId(String userId) {
            this.userId = userId;
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

        public String getNickname() {
            return nickname;
        }

        public void setNickname(String nickname) {
            this.nickname = nickname;
        }

        public String getUserUUID() {
            return userUUID;
        }

        public void setUserUUID(String userUUID) {
            this.userUUID = userUUID;
        }

        private String userUUID;
    }

    private int id;
    private String uuid;
    private String title;
    private String content;
    private String userUUID;
    private String userId;
    private String nickname;
    private String avatar;
    private String txt;
    private int commentCount;
    private int readCount;
    private String time;
    private List<String> tagList;
    private List<UserPostLikeModel> likeList;
    private String type;
    private boolean liked;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getUserUUID() {
        return userUUID;
    }

    public void setUserUUID(String userUUID) {
        this.userUUID = userUUID;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getTxt() {
        return txt;
    }

    public void setTxt(String txt) {
        this.txt = txt;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public int getReadCount() {
        return readCount;
    }

    public void setReadCount(int readCount) {
        this.readCount = readCount;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public List<String> getTagList() {
        return tagList;
    }

    public void setTagList(List<String> tagList) {
        this.tagList = tagList;
    }

    public List<UserPostLikeModel> getLikeList() {
        return likeList;
    }

    public void setLikeList(List<UserPostLikeModel> likeList) {
        this.likeList = likeList;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isLiked() {
        return liked;
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
    }


    public abstract static class CompleteHandler extends Object {
        public abstract void completeHanlder (List<UserPostModel> list, Error error);
    }


    public static void requestUserPostData(String userUUID, int index, final CompleteHandler
            completeHandlerObj) {

        Map params = new HashMap();
        params.put("index", String.valueOf(index));

        NetworkingAgent.requestDataForQuickTalkService("/userPost/recommendUserPostList",
                "GET", params, new NetworkingAgent.CompleteHandler() {
                    @Override
                    public void completeHanlder(QTResponseObject responseObject, Error error) {
                        List<UserPostModel> array = null;
                        if (responseObject.getCode() == QTResponseObject.CODE_SUCCESS) {
                            try {
                                String data = String.valueOf(responseObject.getData());
                                array =  JSON.parseArray(data, UserPostModel.class);
                            } catch (Exception e) {
                                ;
                            }
                            completeHandlerObj.completeHanlder(array, null);
                        } else {
                            error = new Error(responseObject.getMessage());
                            completeHandlerObj.completeHanlder(null, error);
                        }

                    }
         });
    }
}
