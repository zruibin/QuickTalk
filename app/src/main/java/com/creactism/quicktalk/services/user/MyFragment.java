package com.creactism.quicktalk.services.user;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseSectionQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.chad.library.adapter.base.entity.SectionEntity;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class MyFragment extends BaseFragment {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<PlainListEntity> dataList;
    private PlainListAdapter plainListAdapter;


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_my, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.recommend_recyclerview);
        this.dataList = new ArrayList<PlainListEntity >();
        this.loadData();
        this.initSubView(view);

        return view;
    }

    private void initSubView(View view) {
        this.recyclerView = (RecyclerView) view.findViewById(R.id.my_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));
        this.plainListAdapter = new PlainListAdapter(R.layout.frag_my_item, R.layout.frag_my_section, this.dataList);

        this.plainListAdapter.openLoadAnimation(); // 一行代码搞定（默认为渐显效果）
        this.recyclerView.setAdapter(this.plainListAdapter);

        this.plainListAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {

            }
        });

    }

    protected void loadData() {
        this.dataList.add(new PlainListEntity(true, "", 0));
        this.dataList.add(new PlainListEntity("Section1-- item 1", 0, 0));
        this.dataList.add(new PlainListEntity(true, "", 1));
        this.dataList.add(new PlainListEntity("Section2-- item 1", 0, 1));
        this.dataList.add(new PlainListEntity("Section2-- item 2", 1, 1));
        this.dataList.add(new PlainListEntity("Section2-- item 3", 2, 1));
        this.dataList.add(new PlainListEntity("Section2-- item 4", 3, 1));
        this.dataList.add(new PlainListEntity("Section2-- item 5", 4, 1));
        this.dataList.add(new PlainListEntity(true, "", 2));
        this.dataList.add(new PlainListEntity("Section3-- item 1", 1, 2));
    }



    public class PlainListEntity extends SectionEntity<String> {

        private String text;
        private int section;
        private int row;

        public String getText() {
            return text;
        }

        public int getSection() {
            return section;
        }

        public int getRow() {
            return row;
        }

        public PlainListEntity(boolean isHeader, String header, int section) {
            super(isHeader, header);
        }

        public PlainListEntity(String text, int row, int section) {
            super(text);
            this.text = text;
            this.row = row;
            this.section = section;
        }
    }



    public class PlainListAdapter extends BaseSectionQuickAdapter<PlainListEntity, BaseViewHolder> {

        public PlainListAdapter(int layoutResId, int sectionHeadResId, List data) {
            super(layoutResId, sectionHeadResId, data);
        }

        @Override
        protected void convertHead(BaseViewHolder helper, final PlainListEntity item) {
//            helper.setText(R.id.header, item.header);
//            helper.setVisible(R.id.more, item.isMore());
//            helper.addOnClickListener(R.id.more);
        }

        @Override
        protected void convert(BaseViewHolder helper, final PlainListEntity item) {
//            helper.setText(R.id.frag_my_text, item);
            LinearLayout linearLayout = helper.getView(R.id.my_item_layout);
            linearLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    DLog.info("section->"+String.valueOf(item.section)+" row->"+String.valueOf(item.row));
                }
            });

            TextView textView = helper.getView(R.id.frag_my_text);
            textView.setText(item.text);
            textView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    DLog.debug(item.getText());
                }
            });


            LinearLayout.LayoutParams lp;
            if (item.section == 0 && item.row == 0) {
                lp = new LinearLayout.LayoutParams(LinearLayout
                        .LayoutParams.MATCH_PARENT, DensityUtil.dip2px(80));
            } else {
                lp = new LinearLayout.LayoutParams(LinearLayout
                        .LayoutParams.MATCH_PARENT, DensityUtil.dip2px(40));
            }
            linearLayout.setLayoutParams(lp);

        }


    }


}
