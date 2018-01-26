package com.creactism.quicktalk.services.user.adapter;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.user.model.UserModel;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.DrawableUtil;
import com.facebook.drawee.view.SimpleDraweeView;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class UserStarOrFansAdapter extends BaseQuickAdapter <UserModel, BaseViewHolder>  {

    public static class OnUserItemHandler {
        public void onActionHandler(UserModel model) {};
    }

    private Activity activity;
    private boolean hiddenRelation = false;
    private OnUserItemHandler itemHandler;

    public void setHiddenRelation(boolean hiddenRelation) {
        this.hiddenRelation = hiddenRelation;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    public void setItemHandler(OnUserItemHandler itemHandler) {
        this.itemHandler = itemHandler;
    }

    public UserStarOrFansAdapter() {
        super(R.layout.frag_user_item, null);
    }

    @Override
    protected void convert(BaseViewHolder helper, final UserModel model) {
        SimpleDraweeView imageView = helper.getView(R.id.frag_user_item_image);
        TextView textView = helper.getView(R.id.frag_user_item_text);
        Button actionButton = helper.getView(R.id.frag_user_item_action);

        if (model.getAvatar() != null) {
            DLog.warn(model.getAvatar());
            imageView.setImageURI(Uri.parse(model.getAvatar()));
        }
        textView.setText(model.getNickname());

        if (this.hiddenRelation) {
            actionButton.setVisibility(View.GONE);
        } else {
            actionButton.setVisibility(View.VISIBLE);
            if (model.getRelation() == UserModel.UserRelationDefault) { //未关注
                actionButton.setText("关注");
                int color = activity.getResources().getColor(R.color.QuickTalk_MAIN_COLOR);
                actionButton.setTextColor(color);
                actionButton.setBackground(activity.getResources().getDrawable(R.drawable.user_button_style1, null));
            } else { //已关注，即相互关注了
                actionButton.setText("相互关注");
                int color = activity.getResources().getColor(R.color.QuickTalk_SECOND_FONT_COLOR);
                actionButton.setTextColor(color);
                actionButton.setBackground(activity.getResources().getDrawable(R.drawable.user_button_style2, null));
            }
        }
        actionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onActionHandler(model);
            }
        });

        if (model.getUuid().equals(UserInfo.sharedInstance().getUuid())) {
            actionButton.setVisibility(View.GONE);
        }
    }

    @Override
    public void onBindViewHolder(BaseViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
    }
}
