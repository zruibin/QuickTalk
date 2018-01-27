package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.services.user.UserActivity;
import com.creactism.quicktalk.services.userpost.adapter.UserPostAdapter;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class UserPostListFragment extends BaseFragment {

    private LinearLayoutManager layoutManager;
    protected RecyclerView recyclerView;
    protected SwipeRefreshLayout refreshLayout;
    protected List<UserPostModel> dataList;
    protected UserPostAdapter userPostAdapter;
    protected int index = 1;
    protected boolean showHeader = false;
    protected boolean showFooter = false;
    protected View headerView = null;
    protected View footerView = null;

    @Override
    public void onDestroy() {
        super.onDestroy();
        DLog.error("UserPostListFragment->onDestroy...");

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_userpost_list, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.frag_userpost_list_recyclerview);
        this.refreshLayout = (SwipeRefreshLayout)view.findViewById(R.id.frag_userpost_list_refresh);
        this.dataList = new ArrayList<UserPostModel>();

        initSubView(view);

        return view;
    }

    private void initSubView(View view) {
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
//        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getActivity(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));
        this.refreshLayout.setColorSchemeColors(this.getActivity().getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR));
        this.refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            public void onRefresh() {
                userPostAdapter.setEnableLoadMore(false);//这里的作用是防止下拉刷新的时候还可以上拉加载
                index = 1;
                dataList.clear();
                loadData();
            }
        });

        this.userPostAdapter = new UserPostAdapter();
        this.userPostAdapter.setActivity(this.getActivity());
        if (this.showHeader) {
            this.headerView = getHeaderView();
            this.userPostAdapter.addHeaderView(this.headerView);
        }
        if (this.showFooter) {

        }
        this.userPostAdapter.setItemHandler(new UserPostAdapter.OnUserPostItemHandler() {
            public void onInfoHandler(UserPostModel model) {
                DLog.debug(model.getNickname());
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserActivity.class);
                intent.putExtra("userUUID", model.getUserUUID());
                intent.putExtra("nickname", model.getNickname());
                startActivity(intent);
            }
            public void onArrowHandler(UserPostModel model) {
                DLog.debug(model.getAvatar());
            }
            public void onHrefHandler(UserPostModel model) {
                DLog.debug(model.getTitle());
            }
            public void onLikeActionHandler(UserPostModel model) {
                DLog.debug(model.getTitle());
            }
            public void onCommentHandler(UserPostModel model) {
                DLog.debug(model.getTitle());
            }
            public void onTagActionHandler(UserPostModel model, int tagIndex) {
                DLog.debug(model.getTagList().get(tagIndex));
            }
            public void onLikeIconActionHandler(UserPostModel model, int likeIndex) {
                UserPostModel.UserPostLikeModel likeModel = model.getLikeList().get(likeIndex);
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserActivity.class);
                intent.putExtra("userUUID", likeModel.getUserUUID());
                intent.putExtra("nickname", likeModel.getNickname());
                startActivity(intent);
            }
        });

        this.userPostAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.userPostAdapter.openLoadAnimation(); // 一行代码搞定（默认为渐显效果）
        // 默认提供5种方法（渐显、缩放、从下到上，从左到右、从右到左）
//        this.userPostAdapter.openLoadAnimation(BaseQuickAdapter.SLIDEIN_LEFT);
        this.recyclerView.setAdapter(this.userPostAdapter);
        this.userPostAdapter.disableLoadMoreIfNotFullPage();

        this.userPostAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {

            }
        });

        this.recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
//                DLog.debug("offsetY: " + String.valueOf(recyclerView.computeVerticalScrollOffset()));
            }
        });

        this.refreshLayout.setRefreshing(true);
        loadData();
    }

    protected void loadData() {}

    private View getHeaderView() {
        /**haderView中子类不能是View类型*/
        View headerView = getLayoutInflater().
                inflate(R.layout.frag_userpost_list_header, (ViewGroup)this.recyclerView.getParent(), false);
        return headerView;
    }


}


