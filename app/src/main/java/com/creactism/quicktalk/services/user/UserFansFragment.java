package com.creactism.quicktalk.services.user;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.services.user.adapter.UserStarOrFansAdapter;
import com.creactism.quicktalk.services.user.model.UserModel;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class UserFansFragment extends BaseFragment {

    private RecyclerView recyclerView;
    private SwipeRefreshLayout refreshLayout;
    private LinearLayoutManager layoutManager;
    private List<UserModel> dataList;
    private UserStarOrFansAdapter adapter;
    private int index = 1;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view =  inflater.inflate(R.layout.frag_user_fans, container, false);

        this.refreshLayout = (SwipeRefreshLayout)view.findViewById(R.id.frag_user_fans_refresh);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.frag_user_fans_recyclerview);

        this.dataList = new ArrayList<UserModel>();

        initViews(view);
        return view;
    }

    private void initViews(View view) {
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getActivity(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));

        this.refreshLayout.setColorSchemeColors(this.getActivity().getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR));
        this.refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            public void onRefresh() {
                adapter.setEnableLoadMore(false);//这里的作用是防止下拉刷新的时候还可以上拉加载
                index = 1;
                dataList.clear();
                loadData();
            }
        });

        this.adapter = new UserStarOrFansAdapter();
//        this.adapter.setActivity(this.getActivity());


        this.adapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.adapter.openLoadAnimation();
        this.recyclerView.setAdapter(this.adapter);


        this.adapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {

            }
        });


        this.refreshLayout.setRefreshing(true);
        loadData();
    }

    private void loadData() {
//        this.adapter.setNewData(this.dataList);
        refreshLayout.setRefreshing(false);
        adapter.loadMoreComplete();
    }


}
