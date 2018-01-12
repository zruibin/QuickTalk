package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

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

//    @BindView(R.id.recommend_recyclerview)
    public RecyclerView recyclerView;
    private List<String> mDatas;
    private RecommendAdapter mAdapter;

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

        View view = inflater.inflate(R.layout.fragment_recommend, container, false);
//        ButterKnife.bind(view);

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


        initData();
        this.recyclerView = (RecyclerView)view.findViewById(R.id.recommend_recyclerview);
        this.recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        this.recyclerView.setAdapter(mAdapter = new RecommendAdapter());
        this.recyclerView.addItemDecoration(new RecycleViewDivider(
                getActivity().getApplicationContext(), LinearLayoutManager.VERTICAL, 10, getResources().getColor(R.color
                .gray)));
        this.mAdapter.notifyItemChanged(2);

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


    protected void initData()
    {
        mDatas = new ArrayList<String>();
        for (int i = 'A'; i < 'z'; i++)
        {
            mDatas.add("" + (char) i);
        }
    }

    class RecommendAdapter extends RecyclerView.Adapter<RecommendAdapter.MyViewHolder>
    {
        @Override
        public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            MyViewHolder holder = new MyViewHolder(LayoutInflater.from(
                    getActivity()).inflate(R.layout.fragment_recommend_item, parent,
                    false));
            return holder;
        }

        @Override
        public void onBindViewHolder(MyViewHolder holder, int position) {
            holder.tv.setText(mDatas.get(position));
            holder.tv.setTag(new Integer(position));
        }

        @Override
        public int getItemCount() {
            return mDatas.size();
        }

        class MyViewHolder extends RecyclerView.ViewHolder {
            TextView tv;
            public MyViewHolder(View view) {
                super(view);
                tv = (TextView)view.findViewById(R.id.id_num);
                tv.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Integer index = (Integer)v.getTag();
                        String indexStr = "item: " + String.valueOf(index.intValue());
                        DLog.info(indexStr);
                        Toast.makeText(getActivity().getApplicationContext(), indexStr, Toast
                                .LENGTH_SHORT).show();
                    }
                });
            }
        }
    }
}
