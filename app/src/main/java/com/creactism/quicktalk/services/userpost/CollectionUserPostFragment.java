package com.creactism.quicktalk.services.userpost;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.Toast;

import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;

import java.util.List;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class CollectionUserPostFragment extends UserPostListFragment {

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.refreshLayout.setRefreshing(true);
        loadData();
    }

    @Override
    protected void loadData() {
        super.loadData();
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestCollectionData(userUUID, index, "1", new UserPostModel.CompleteHandler() {
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
