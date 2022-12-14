package com.creactism.quicktalk.services.user;

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

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.services.user.adapter.UserStarOrFansAdapter;
import com.creactism.quicktalk.services.user.model.UserModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class UserStarFragment extends BaseFragment {

    private String userUUID;
    private boolean showHeader = false;
    private RecyclerView recyclerView;
    private SwipeRefreshLayout refreshLayout;
    private LinearLayoutManager layoutManager;
    private List<UserModel> dataList;
    private UserStarOrFansAdapter adapter;
    private int index = 1;
    private View emptyView;

    public void setUserUUID(String userUUID) {
        this.userUUID = userUUID;
    }

    public void setShowHeader(boolean showHeader) {
        this.showHeader = showHeader;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view =  inflater.inflate(R.layout.frag_user_star, container, false);

        this.refreshLayout = (SwipeRefreshLayout)view.findViewById(R.id.frag_user_star_refresh);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.frag_user_star_recyclerview);

        this.dataList = new ArrayList<UserModel>();

        initViews(view);
        return view;
    }

    private void initViews(View view) {
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getActivity(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));

        this.emptyView = getLayoutInflater().inflate(R.layout.layout_empty_view, (ViewGroup)this.recyclerView.getParent(), false);
        this.refreshLayout.setColorSchemeColors(this.getActivity().getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR));
        this.refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            public void onRefresh() {
                adapter.setEnableLoadMore(false);//??????????????????????????????????????????????????????????????????
                index = 1;
                dataList.clear();
                loadData();
            }
        });

        this.adapter = new UserStarOrFansAdapter();
        this.adapter.setHiddenRelation(true);
        if (this.showHeader) {
            View headerView = getHeaderView();
            this.adapter.setHeaderView(headerView);
        }

        this.adapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.adapter.openLoadAnimation();
        this.recyclerView.setAdapter(this.adapter);
        adapter.disableLoadMoreIfNotFullPage();

        this.adapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {
                UserModel model = dataList.get(position);
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserActivity.class);
                intent.putExtra("userUUID", model.getUuid());
                intent.putExtra("nickname", model.getNickname());
                startActivity(intent);
            }
        });

//        this.recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
//            @Override
//            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
//                super.onScrolled(recyclerView, dx, dy);
////                DLog.debug("offsetY: " + String.valueOf(recyclerView.computeVerticalScrollOffset()));
//            }
//        });

        this.refreshLayout.setRefreshing(true);
        loadData();
    }

    private void loadData() {
        UserModel.requestForStarUser(this.userUUID, this.index, new UserModel.CompleteHandler(){
            @Override
            public void completeHanlder(List<UserModel> list, Error error) {
                super.completeHanlder(list, error);
                refreshLayout.setRefreshing(false);
                adapter.loadMoreComplete();
                if (error != null) {
                    QTToast.makeText(getActivity(), error.getMessage());
                } else {
                    if (index == 1) {
                        adapter.setNewData(list);
                        if (list.size() == 0) {
                            adapter.setEmptyView(emptyView);
                        }
                    } else {
                        adapter.addData(list);
                    }
                    if (list.size() < 10) {
                        adapter.loadMoreEnd();
                    }
                    dataList.addAll(list);
                }
            }
        });
    }


    private View getHeaderView() {
        /**haderView??????????????????View??????*/
        View headerView = getLayoutInflater().
                inflate(R.layout.frag_user_star_header, (ViewGroup)this.recyclerView.getParent(), false);
        RelativeLayout searchLayout = (RelativeLayout)headerView.findViewById(R.id.frag_user_star_header_search);
        searchLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserSearchActivity.class);
                startActivity(intent);
            }
        });
        RelativeLayout contactLayout = (RelativeLayout)headerView.findViewById(R.id.frag_user_star_header_contact);
        contactLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserContactBookActivity.class);
                startActivity(intent);
            }
        });
        return headerView;
    }


}
