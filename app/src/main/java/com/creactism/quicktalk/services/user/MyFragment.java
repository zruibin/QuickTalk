package com.creactism.quicktalk.services.user;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.Tools;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class MyFragment extends BaseFragment {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<TableEntity> dataList;
    private TableListAdapter sectionTableListAdapter;


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_my, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.recommend_recyclerview);
        this.dataList = new ArrayList<TableEntity>();
        this.loadData();
        this.initSubView(view);

        return view;
    }

    private void initSubView(View view) {
        this.recyclerView = (RecyclerView) view.findViewById(R.id.my_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));

        this.sectionTableListAdapter = new MyAdapter(this.dataList);
        this.recyclerView.setAdapter(this.sectionTableListAdapter);
    }

    protected void loadData() {
//        this.dataList.add(new TableEntity(true, "", new TableEntity.IndexPath(0, 0)));
//        this.dataList.add(new TableEntity("Section0-- item 1", new TableEntity.IndexPath(0, 0)));
//
//        this.dataList.add(new TableEntity(true, "", new TableEntity.IndexPath(1, 0)));
        this.dataList.add(new TableEntity("Section1-- item 1", new TableEntity.IndexPath(1, 0)));
        this.dataList.add(new TableEntity("Section1-- item 2", new TableEntity.IndexPath(1, 1)));
        this.dataList.add(new TableEntity("Section1-- item 3", new TableEntity.IndexPath(1, 2)));
        this.dataList.add(new TableEntity("Section1-- item 4", new TableEntity.IndexPath(1, 3)));
        this.dataList.add(new TableEntity("Section1-- item 5", new TableEntity.IndexPath(1, 4)));

//        this.dataList.add(new TableEntity(true, "", new TableEntity.IndexPath(2, 0)));
//        this.dataList.add(new TableEntity("Section3-- item 1--", new TableEntity.IndexPath(2, 0)));
    }


    private class MyAdapter extends TableListAdapter {

        public MyAdapter(List<TableEntity> data) {
            super(data);
        }

        @Override
        public void cellForRowAtIndexPath(final BaseViewHolder helper, final TableEntity item, final TableEntity
                .IndexPath indexPath) {
            DLog.debug("section:" + String.valueOf(indexPath.section) + " row:" + String.valueOf(indexPath.row));

            LinearLayout linearLayout = helper.getView(this.table_layout_id);
            LinearLayout.LayoutParams lp;
            if (item.getIndexPath().section == 0 && item.getIndexPath().row == 0) {
                lp = new LinearLayout.LayoutParams(LinearLayout
                        .LayoutParams.MATCH_PARENT, DensityUtil.dip2px(80));

            } else {
                lp = new LinearLayout.LayoutParams(LinearLayout
                        .LayoutParams.MATCH_PARENT, DensityUtil.dip2px(40));
            }
            linearLayout.setLayoutParams(lp);

            final SimpleDraweeView imageView = helper.getView(this.table_image_id);
            ViewTreeObserver vto2 = imageView.getViewTreeObserver();
            vto2.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                @Override
                public void onGlobalLayout() {
                    DLog.debug("width:"+String.valueOf(imageView.getWidth())+" height:"+String.valueOf(imageView.getHeight()));
                    imageView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    RelativeLayout.LayoutParams imageLP = (RelativeLayout.LayoutParams)imageView.getLayoutParams();
                    imageLP.width = imageView.getHeight();
                    imageLP.height = imageView.getHeight();
                    if (indexPath.section != 0) {
                        int margins = DensityUtil.dip2px(2);
                        imageLP.setMargins(margins, margins, margins, margins);
                    }
                    imageView.setLayoutParams(imageLP);
                }
            });
            imageView.setImageURI(Tools.getResoucesUri(R.mipmap.my_unselect));


            TextView textView = helper.getView(this.table_text_id);
            textView.setText((String)item.getObj());

            ImageView indicator = helper.getView(table_indicator_id);
            if (indexPath.section == 1 && indexPath.row == 4) {
                indicator.setVisibility(View.GONE);
            }

        }

        @Override
        public void didSelectRowAtIndexPath(final TableEntity item, final TableEntity.IndexPath indexPath) {
            DLog.debug("section: "+String.valueOf(indexPath.section)+" row:"+String.valueOf(indexPath.row));
        }
    }

}
