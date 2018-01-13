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
import android.widget.TextView;
import android.widget.Toast;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.chad.library.adapter.base.listener.OnItemClickListener;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.util.DLog;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class RecommendFragment extends Fragment {

    @BindView(R.id.recommend_recyclerview)
    public RecyclerView recyclerView;
    @BindView(R.id.recommend_refresh)
    public SwipeRefreshLayout refreshLayout;
    public LinearLayoutManager layoutManager;
    private List<String> mDatas;
    private RecommendAdapter mAdapter;
    private int testNum = 0;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
//        DLog.debug(  "RecommendFragment on onAttach: ......");
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        DLog.debug(  "RecommendFragment on onCreate: ....");
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
//        DLog.debug(    "RecommendFragment on onCreateView: .....");
        View view = inflater.inflate(R.layout.frag_recommend, container, false);
        ButterKnife.bind(this, view);

        this.initSubView(view);
        this.initData();

        return view;
//        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
//        DLog.debug(    "RecommendFragment on onViewCreated: ....");
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        DLog.debug(    "RecommendFragment on onActivityCreated: ...");
    }

    @Override
    public void onStart() {
        super.onStart();
//        DLog.debug(    "RecommendFragment on onStart: ");
    }

    @Override
    public void onResume() {
        super.onResume();
//        DLog.debug(    "RecommendFragment on onResume: ");
    }

    @Override
    public void onPause() {
        super.onPause();
//        DLog.debug(    "RecommendFragment on onPause: ");
    }

    @Override
    public void onStop() {
        super.onStop();
//        DLog.debug(    "RecommendFragment on onStop: ...");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
//        DLog.debug(    "RecommendFragment on onDestroyView: ");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
//        DLog.debug(    "RecommendFragment on onDestroy: ");
    }

    @Override
    public void onDetach() {
        super.onDetach();
//        DLog.debug(    "RecommendFragment on onDetach: ...");
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
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        //我在List最前面加入一条数据
                        mDatas.add(0, "嘿，我是“下拉刷新”生出来的");
                        //数据重新加载完成后，提示数据发生改变，并且设置现在不在刷新
//                        mAdapter.notifyDataSetChanged();
                        mAdapter.setNewData(mDatas);
                        refreshLayout.setRefreshing(false);
                    }
                },2000);
            }
        });

        this.mAdapter = new RecommendAdapter();
        this.mAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
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


