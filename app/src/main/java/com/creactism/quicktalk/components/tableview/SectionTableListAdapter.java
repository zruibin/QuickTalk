package com.creactism.quicktalk.components.tableview;

import android.support.annotation.IdRes;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseSectionQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DensityUtil;

import java.util.List;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public abstract class SectionTableListAdapter extends BaseSectionQuickAdapter <SectionTableEntity, BaseViewHolder> {

    private LinearLayout tableLinearLayout;
    protected @IdRes int table_layout_id;
    protected @IdRes int table_image_id;
    protected @IdRes int table_text_id;
    protected @IdRes int table_detail_id;
    protected @IdRes int table_indicator_id;

    public SectionTableListAdapter(List<SectionTableEntity> data) {
        super(R.layout.table_item, R.layout.table_section, data);
    }

    @Override
    protected void convertHead(BaseViewHolder helper, final SectionTableEntity item) {
//            helper.setText(R.id.header, item.header);
//            helper.setVisible(R.id.more, item.isMore());
//            helper.addOnClickListener(R.id.more);
    }

    @Override
    protected void convert(BaseViewHolder helper, final SectionTableEntity item) {
        this.table_layout_id = R.id.table_item_layout;
        this.table_image_id = R.id.table_item_image;
        this.table_text_id = R.id.table_item_text;
        this.table_detail_id = R.id.table_item_detail_text;
        this.table_indicator_id = R.id.table_item_indicator;

        this.tableLinearLayout = helper.getView(this.table_layout_id);
        this.cellForRowAtIndexPath(helper, item, item.getIndexPath());
        this.tableLinearLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                didSelectRowAtIndexPath(item, item.getIndexPath());
            }
        });
    }

    public abstract void cellForRowAtIndexPath(final BaseViewHolder helper, final SectionTableEntity item, final SectionTableEntity.IndexPath indexPath);
    public void didSelectRowAtIndexPath(final SectionTableEntity item, final SectionTableEntity.IndexPath indexPath){};
}
