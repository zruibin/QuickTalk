package com.creactism.quicktalk.services.user;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.userpost.adapter.UserPostAdapter;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class MyFragment extends BaseFragment {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<String> dataList;
    private PlainListAdapter plainListAdapter;


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_my, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.recommend_recyclerview);
        this.dataList = new ArrayList<String >();
        for (int i=0; i<30;i++) {
            this.dataList.add(String.valueOf(i));
        }

        this.initSubView(view);

        return view;
    }

    private void initSubView(View view) {
        this.recyclerView = (RecyclerView) view.findViewById(R.id.my_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));
        this.plainListAdapter = new PlainListAdapter();


        this.plainListAdapter.openLoadAnimation(); // 一行代码搞定（默认为渐显效果）
        this.recyclerView.setAdapter(this.plainListAdapter);

        this.plainListAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {

            }
        });

        this.loadData();
    }

    protected void loadData() {
        this.plainListAdapter.setNewData(this.dataList);
    }





    public class PlainListAdapter extends BaseQuickAdapter<String, BaseViewHolder> {

        public PlainListAdapter() {
            super(R.layout.frag_my_item, null);
        }

        @Override
        protected void convert(BaseViewHolder helper, String item) {
            helper.setText(R.id.frag_my_text, item);
        }

        @Override
        public void onBindViewHolder(BaseViewHolder holder, int position) {
            super.onBindViewHolder(holder, position);
            DLog.info(String.valueOf(position));
        }
    }


}
