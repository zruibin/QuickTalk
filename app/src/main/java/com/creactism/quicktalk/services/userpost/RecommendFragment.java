package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.chad.library.adapter.base.listener.OnItemClickListener;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.components.RecycleViewDivider;
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

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        DLog.debug(    "RecommendFragment on onCreateView: .....");
        View view = inflater.inflate(R.layout.frag_recommend, null);
        ButterKnife.bind(this, view);

        this.initSubView(view);
        this.initData();

        return view;
    }

    protected void initSubView (View view) {
        Navigationbar navigationbar = (Navigationbar)view.findViewById(R.id.recommend_navigationbar);
        navigationbar.setTitle("第二项");
        navigationbar.setTitleSize(16);
        navigationbar.setTitleColor(Color.BLACK);
        navigationbar.setCenterClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity().getApplicationContext(), "第二项", Toast.LENGTH_SHORT).show();
            }
        });

        navigationbar.setActionTextColor(Color.BLACK);
        navigationbar.addAction(new Navigationbar.TextAction("发布") {
            @Override
            public void performAction(View view) {
                Toast.makeText(getActivity().getApplicationContext(), "点击了发布", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent();
                intent.setClass(getActivity().getApplicationContext(), AddUserPostActivity.class);
                startActivity(intent);
            }
        });
        
        this.recyclerView = (RecyclerView)view.findViewById(R.id.recommend_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new RecycleViewDivider(
                getActivity().getApplicationContext(), LinearLayoutManager.VERTICAL, 10, getResources().getColor(R.color
                .gray)));

        this.refreshLayout.setColorSchemeColors(Color.YELLOW);
        this.refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener(){
            public void onRefresh() {
                UserPostModel.requestUserPostData("", index, new UserPostModel.CompleteHandler
                        () {
                    @Override
                    public void completeHanlder(List list, Error error) {
                        mDatas = list;
                        mAdapter.setNewData(mDatas);
                        refreshLayout.setRefreshing(false);
                    }
                });
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
                UserPostModel.requestUserPostData("", index, new UserPostModel.CompleteHandler() {
                    @Override
                    public void completeHanlder(List list, Error error) {
                        mDatas.addAll(list);
                        mAdapter.addData(list);
                        refreshLayout.setRefreshing(false);
                        mAdapter.loadMoreComplete();
                        ++index;
                    }
                });
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
        this.mAdapter.notifyItemChanged(2);
//        this.mAdapter.notifyDataSetChanged();

        this.recyclerView.addOnItemTouchListener(new OnItemClickListener() {
            @Override
            public void onSimpleItemClick(final BaseQuickAdapter adapter, final View view, final int position) {
                DLog.debug(mDatas.get(position));
                Toast.makeText(getActivity(), mDatas.get(position), Toast.LENGTH_SHORT).show();
            }
        });
    }

    protected void initData() {
        mDatas = new ArrayList<String>();
        for (int i = 'A'; i < 'H'; i++) {
            mDatas.add("" + (char) i);
        }
        this.mAdapter.setNewData(mDatas);
    }


    public class RecommendAdapter extends BaseQuickAdapter {

        public RecommendAdapter() {
            super(R.layout.frag_recommend_item, null);
        }

        @Override
        protected void convert(BaseViewHolder helper, Object text) {
            helper.setText(R.id.recommend_recyclerview_item_num, (String)text);
            helper.setText(R.id.recommend_recyclerview_item_num2, "aaa");
        }
    }

}


