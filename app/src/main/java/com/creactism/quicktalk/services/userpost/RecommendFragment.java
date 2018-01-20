package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.annotation.RequiresApi;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.chad.library.adapter.base.listener.OnItemClickListener;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.modules.NotificationCenter;
import com.creactism.quicktalk.modules.cache.QTCache;
import com.creactism.quicktalk.services.account.ChangeAvatarActivity;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class RecommendFragment extends BaseFragment {

    @BindView(R.id.recommend_recyclerview)
    public RecyclerView recyclerView;
    @BindView(R.id.recommend_refresh)
    public SwipeRefreshLayout refreshLayout;
    public LinearLayoutManager layoutManager;
    private List<String> mDatas;
    private RecommendAdapter mAdapter;
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

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        DLog.debug("RecommendFragment on onCreateView: .....");

        View view = inflater.inflate(R.layout.frag_recommend, null);
        ButterKnife.bind(this, view);
        this.mDatas = new ArrayList<>();
        index = 1;
        this.initSubView(view);

        return view;
    }

    private void initSubView(View view) {
        Navigationbar navigationbar = (Navigationbar) view.findViewById(R.id.recommend_navigationbar);
        navigationbar.setTitle("第二项");
        navigationbar.setTitleSize(16);
        navigationbar.setDefaulteTheme(getActivity());
        navigationbar.setCenterClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity().getApplicationContext(), "第二项", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent();
                intent.setClass(getActivity().getApplicationContext(), ChangeAvatarActivity.class);
                startActivity(intent);
            }
        });
//        navigationbar.setVisibility(View.GONE);

        navigationbar.addAction(new Navigationbar.TextAction("发布") {
            @Override
            public void performAction(View view) {
                Toast.makeText(getActivity().getApplicationContext(), "点击了发布", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent();
                intent.setClass(getActivity().getApplicationContext(), AddUserPostActivity.class);
                startActivity(intent);
            }
        });

        this.recyclerView = (RecyclerView) view.findViewById(R.id.recommend_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new RecycleViewDivider(
                getActivity().getApplicationContext(), LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color
                .gray)));

        this.refreshLayout.setColorSchemeColors(Color.YELLOW);
        this.refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            public void onRefresh() {
                mAdapter.setEnableLoadMore(false);//这里的作用是防止下拉刷新的时候还可以上拉加载
               index = 1;
               loadData();
            }
        });

        this.mAdapter = new RecommendAdapter();
        this.mAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
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

        this.mAdapter.openLoadAnimation(); // 一行代码搞定（默认为渐显效果）
//        this.mAdapter.openLoadAnimation(BaseQuickAdapter.ALPHAIN); // 默认提供5种方法（渐显、缩放、从下到上，从左到右、从右到左）
//        this.mAdapter.openLoadAnimation(new BaseAnimation() {
//            @Override
//            public Animator[] getAnimators(View view) {
//                return new Animator[]{
//                        ObjectAnimator.ofFloat(view, "scaleY", 1, 1.1f, 1),
//                        ObjectAnimator.ofFloat(view, "scaleX", 1, 1.1f, 1)
//                };
//            }
//        });

        this.recyclerView.setAdapter(this.mAdapter);
//        this.mAdapter.notifyItemChanged(2);
//        this.mAdapter.notifyDataSetChanged();

        this.mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {
                DLog.debug(mDatas.get(position));
                Toast.makeText(getActivity(), mDatas.get(position), Toast.LENGTH_SHORT).show();
            }
        });

        this.recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                DLog.debug("offsetY: " + String.valueOf(recyclerView.computeVerticalScrollOffset()));
            }
        });

        this.refreshLayout.setRefreshing(true);
        this.loadData();
    }

    protected void loadData() {
        UserPostModel.requestUserPostData("", index, new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(List list, Error error) {
                mDatas.addAll(list);
                mAdapter.addData(list);
                refreshLayout.setRefreshing(false);
                mAdapter.loadMoreComplete();
            }
        });
    }


    public class RecommendAdapter extends BaseQuickAdapter {

        public RecommendAdapter() {
            super(R.layout.frag_recommend_item, null);
        }

        @Override
        protected void convert(BaseViewHolder helper, Object text) {
            helper.setText(R.id.recommend_recyclerview_item_num, (String) text);
            helper.setText(R.id.recommend_recyclerview_item_num2, "aaa");

            final int position = helper.getAdapterPosition();
            Button btn = (Button) helper.getView(R.id.recommend_recyclerview_item_btn);
            btn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    DLog.debug("position: " + String.valueOf(position));
                }
            });
        }
    }


}


