package com.creactism.quicktalk.services.userpost;


import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.user.UserActivity;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.List;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class StarUserPostFragment extends UserPostListFragment {

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        DLog.debug(  "StarUserPostFragment onCreateView: .....");
        this.showHeader = true;
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        RelativeLayout userPostHeaderLayout = (RelativeLayout)this.headerView.findViewById(R.id.frag_userpost_list_header_layout);
        userPostHeaderLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserActivity.class);
                intent.putExtra("userUUID", UserInfo.sharedInstance().getUuid());
                intent.putExtra("nickname", UserInfo.sharedInstance().getNickname());
                startActivity(intent);
            }
        });

        this.refreshLayout.setRefreshing(true);
        loadData();
    }

    @Override
    public void onResume() {
        super.onResume();
        DLog.info("StarUserPostFragment onResume....");
    }

    @Override
    protected void loadData() {
        super.loadData();
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestStarUserPostData(userUUID, index, userUUID, new UserPostModel.CompleteHandler() {
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
