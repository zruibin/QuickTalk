package com.creactism.quicktalk.services.user;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
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

public class UserFansFragment extends BaseFragment {

    private String userUUID;
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
        this.adapter.setActivity(getActivity());
        this.adapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                DLog.error("UserFansFragment->onLoadMoreRequested...");
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.adapter.openLoadAnimation();
        this.recyclerView.setAdapter(this.adapter);
        this.adapter.disableLoadMoreIfNotFullPage();

        this.adapter.setItemHandler(new UserStarOrFansAdapter.OnUserItemHandler(){
            @Override
            public void onActionHandler(UserModel model) {
                super.onActionHandler(model);
                starOrUnStarAction(model);
            }
        });
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
        String relationUserUUID = UserInfo.sharedInstance().getUuid();
        UserModel.requestForFans(this.userUUID, this.index, relationUserUUID, new UserModel.CompleteHandler(){
            @Override
            public void completeHanlder(List<UserModel> list, Error error) {
                super.completeHanlder(list, error);
                refreshLayout.setRefreshing(false);
                adapter.loadMoreComplete();
                if (error != null) {
                    QTToast.makeText(getActivity(), error.getMessage());
                } else {
                    for (UserModel model: list) {
                        if (model.getRelation() == UserModel.UserRelationStar) {
                            model.setRelation(UserModel.UserRelationStarAndBeStar);
                        } else {
                            model.setRelation(UserModel.UserRelationDefault);
                        }
                    }
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

    private void starOrUnStarAction(final UserModel model) {
        String action = Marcos.STAR_ACTION_FOR_STAR;
        if (model.getRelation() == UserModel.UserRelationStarAndBeStar) {
            action = Marcos.STAR_ACTION_FOR_UNSTAR;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserModel.requestForStarOrUnStar(userUUID, model.getUuid(), action,
                new UserModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (error != null) {
                    QTToast.makeText(getActivity(), error.getMessage());
                } else {
                    if (model.getRelation() == UserModel.UserRelationDefault) {
                        model.setRelation(UserModel.UserRelationStarAndBeStar);
                    } else {
                        model.setRelation(UserModel.UserRelationDefault);
                    }
                }
                adapter.notifyDataSetChanged();
            }
        });
    }


}
