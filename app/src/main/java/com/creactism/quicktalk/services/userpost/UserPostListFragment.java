package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.modules.NotificationCenter;
import com.creactism.quicktalk.services.account.ChangeAvatarActivity;
import com.creactism.quicktalk.services.userpost.adapter.UserPostAdapter;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class UserPostListFragment extends BaseFragment {

    private RecyclerView recyclerView;
    private SwipeRefreshLayout refreshLayout;
    private LinearLayoutManager layoutManager;
    private List<UserPostModel> dataList;
    private UserPostAdapter userPostAdapter;
    private int testNum = 0;
    private int index = 1;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        NotificationCenter.defaultCenter().addObserver(this, "testNotification", new NotificationCenter.SelectorHandler(){
            @Override
            public void handler(Object object) {
                DLog.warn("NotificationCenter handler2: " + (String)object);
            }
        });
    }

    @Override
    public void onDetach() {
        super.onDetach();
        NotificationCenter.defaultCenter().removeObserver(this.getActivity(), "testNotification");

    }

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
        DLog.debug("UserPostListFragment on onCreateView: .....");
        this.getActivity().setTitle("Recommend....");

        View view = inflater.inflate(R.layout.frag_recommend, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.recommend_recyclerview);
        this.refreshLayout = (SwipeRefreshLayout)view.findViewById(R.id.recommend_refresh);
        this.dataList = new ArrayList<UserPostModel>();
        index = 1;
        this.initSubView(view);

        return view;
    }

    private void initSubView(View view) {

        this.recyclerView = (RecyclerView) view.findViewById(R.id.recommend_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
//        this.recyclerView.addItemDecoration(new RecycleViewDivider(
//                getActivity().getBaseContext(), LinearLayoutManager.VERTICAL,
//                20, Color.parseColor("#1C1C1C")));
        /**系统自带的*/
        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));

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
        this.userPostAdapter.setItemHandler(new UserPostAdapter.OnUserPostItemHandler() {
            public void onInfoHandler(UserPostModel model) {
                DLog.debug(model.getNickname());
            }
            public void onArrowHandler(UserPostModel model) {
                DLog.debug(model.getAvatar());
            }
            public void onHrefHandler(UserPostModel model) {
                DLog.debug(model.getContent());
            }
            public void onLikeActionHandler(UserPostModel model) {
                DLog.debug(model.getTitle());
            }
            public void onCommentHandler(UserPostModel model) {
                DLog.debug(model.getAvatar());
            }
            public void onTagActionHandler(UserPostModel model, int tagIndex) {
                DLog.debug(model.getTagList().get(tagIndex));
            }
            public void onLikeIconActionHandler(UserPostModel model, int likeIndex) {
                UserPostModel.UserPostLikeModel likeModel = model.getLikeList().get(likeIndex);
                DLog.debug(likeModel.getNickname());
            }
        });

        this.userPostAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                /*
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if (testNum < 3) {
//                            mAdapter.setNewData(data);
                            for (int i = 0; i < 6; i++) {
                                mAdapter.addData("嘿，我是“上拉刷新”生出来的: " + String.valueOf(i));
                            }
                            mAdapter.loadMoreComplete();
                            ++testNum;
                        }
                        DLog.debug(String.valueOf(testNum));
                        if (testNum == 2) {
                            //第一页如果不够一页就不显示没有更多数据布局
                            mAdapter.loadMoreFail();
                        }
                        if (testNum == 3) {
                            //第一页如果不够一页就不显示没有更多数据布局
                            mAdapter.loadMoreEnd();
                        }

                    }
                },1000);
                */
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.userPostAdapter.openLoadAnimation(); // 一行代码搞定（默认为渐显效果）
        this.recyclerView.setAdapter(this.userPostAdapter);
//        this.mAdapter.notifyItemChanged(2);
//        this.mAdapter.notifyDataSetChanged();

        this.userPostAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {
//                DLog.debug(mDatas.get(position));
//                Toast.makeText(getActivity(), mDatas.get(position), Toast.LENGTH_SHORT).show();
//                if (position == 1) {
//                    Intent intent = new Intent();
//                    intent.setClass(getActivity().getApplicationContext(), ChangeAvatarActivity.class);
//                    startActivity(intent);
//                }
//                if (position == 2) {
//                    Intent intent = new Intent();
//                    intent.setClass(getActivity().getApplicationContext(), AddUserPostActivity.class);
//                    startActivity(intent);
//                }
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
        this.loadData();
    }

    protected void loadData() {
        UserPostModel.requestUserPostData("", index, new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(List<UserPostModel> list, Error error) {
                dataList.addAll(list);
                if (index == 1) {
                    userPostAdapter.setNewData(list);
                } else {
                    userPostAdapter.addData(list);
                }
                refreshLayout.setRefreshing(false);
                userPostAdapter.loadMoreComplete();
            }
        });
    }



}


