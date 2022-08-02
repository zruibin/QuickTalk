package com.creactism.quicktalk.services.userpost;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;

import java.util.List;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class RecommendUserPostFragment extends UserPostListFragment {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

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
        UserPostModel.requestRecommendUserPostData(index, userUUID, new UserPostModel.CompleteHandler() {
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
