package com.creactism.quicktalk.services.user.adapter;

import android.net.Uri;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.user.model.UserModel;
import com.creactism.quicktalk.util.DLog;
import com.facebook.drawee.view.SimpleDraweeView;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class UserStarOrFansAdapter extends BaseQuickAdapter <UserModel, BaseViewHolder>  {

    public class OnUserPostItemHandler {
        public void onActionHandler(UserModel model) {};
    }

    private boolean hiddenRelation = false;

    public void setHiddenRelation(boolean hiddenRelation) {
        this.hiddenRelation = hiddenRelation;
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
        }
    }

    @Override
    public void onBindViewHolder(BaseViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
    }
}
