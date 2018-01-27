package com.creactism.quicktalk.services.userpost;

import android.widget.Toast;

import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;

import java.util.List;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class LikeUserPostFragment extends UserPostListFragment {

    private String userUUID;

    public void setUserUUID(String userUUID) {
        this.userUUID = userUUID;
    }

    @Override
    protected void loadData() {
        super.loadData();
        String mineUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestUserForUserPostLikeData(this.userUUID, index, mineUUID, new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(List<UserPostModel> list, Error error) {
                refreshLayout.setRefreshing(false);
                userPostAdapter.loadMoreComplete();
                if (error != null) {
                    Toast.makeText(getActivity(), error.getMessage(), Toast.LENGTH_SHORT).show();
                    return;
                }
                if (index == 1) {
                    userPostAdapter.setNewData(list);
                } else {
                    userPostAdapter.addData(list);
                }
                if (list.size() < 10) {
                    userPostAdapter.loadMoreEnd();
                }
                dataList.addAll(list);
            }
        });
    }
}
