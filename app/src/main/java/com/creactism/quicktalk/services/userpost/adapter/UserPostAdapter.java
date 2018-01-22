package com.creactism.quicktalk.services.userpost.adapter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.services.userpost.view.UserPostLikeView;
import com.creactism.quicktalk.util.BitmapUtil;
import com.creactism.quicktalk.util.ColorUtil;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.StringUtil;
import com.donkingliang.labels.LabelsView;
import com.facebook.drawee.view.SimpleDraweeView;


/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class UserPostAdapter extends BaseQuickAdapter<UserPostModel, BaseViewHolder> {

    public static class OnUserPostItemHandler {
        public void onInfoHandler(UserPostModel model) {};
        public void onArrowHandler(UserPostModel model) {};
        public void onHrefHandler(UserPostModel model) {};
        public void onLikeActionHandler(UserPostModel model) {};
        public void onCommentHandler(UserPostModel model) {};
        public void onTagActionHandler(UserPostModel model, int tagIndex) {};
        public void onLikeIconActionHandler(UserPostModel model, int likeIndex) {};
    }

    private Activity activity;
    private OnUserPostItemHandler itemHandler;

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    public void setItemHandler(OnUserPostItemHandler itemHandler) {
        this.itemHandler = itemHandler;
    }

    public UserPostAdapter() {
        super(R.layout.frag_userpost_list_item, null);
    }

    @Override
    protected void convert(BaseViewHolder helper, final UserPostModel model) {
        SimpleDraweeView avatarButton = helper.getView(R.id.userpost_list_item_avatar);
        Button nicknameButton = helper.getView(R.id.userpost_list_item_nickname);
        TextView timeView = helper.getView(R.id.userpost_list_item_time);
        TextView readView = helper.getView(R.id.userpost_list_item_read);
        ImageButton arrowButton = helper.getView(R.id.userpost_list_item_arrow);
        TextView detailView = helper.getView(R.id.userpost_list_item_detail);
        Button hrefButton = helper.getView(R.id.userpost_list_item_href);
        LabelsView tagView = helper.getView(R.id.userpost_list_item_tag);
        ImageButton likeButton = helper.getView(R.id.userpost_list_item_like);
        ImageButton commentButton = helper.getView(R.id.userpost_list_item_comment);
        LinearLayout likeLayout = helper.getView(R.id.userpost_list_item_like_layout);
        UserPostLikeView likeView = helper.getView(R.id.userpost_list_item_likeView);

        avatarButton.setImageURI(Uri.parse(model.getAvatar()));
        avatarButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onInfoHandler(model);
            }
        });
        nicknameButton.setText(model.getNickname());
        nicknameButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onInfoHandler(model);
            }
        });

        timeView.setText(StringUtil.formatDate(model.getTime()));
        readView.setText("|  " + StringUtil.countTransition(model.getReadCount()) + "人阅读");

        Bitmap bitmap = BitmapFactory.decodeResource(this.activity.getResources(), R.mipmap.arrow);
        bitmap = BitmapUtil.roateBitmap(bitmap, -90);
        bitmap = BitmapUtil.tintBitmap(bitmap,
                ColorUtil.getResourcesColor(this.activity.getBaseContext(), R.color.QuickTalk_SECOND_FONT_COLOR));
        arrowButton.setImageBitmap(bitmap);
        arrowButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onArrowHandler(model);
            }
        });

        if (model.getTxt() == null) {
            detailView.setVisibility(View.GONE);
        } else {
            detailView.setText(model.getTxt());
            detailView.setVisibility(View.VISIBLE);
        }
        hrefButton.setText(model.getTitle());
        hrefButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onHrefHandler(model);
            }
        });

        tagView.setLabels(model.getTagList(), new LabelsView.LabelTextProvider<String>() {
            @Override
            public CharSequence getLabelText(TextView label, int position, String data) {
                return data;
            }
        });
        tagView.setSelectType(LabelsView.SelectType.NONE);
        tagView.setOnLabelClickListener(new LabelsView.OnLabelClickListener() {
            @Override
            public void onLabelClick(TextView label, Object data, int position) {
                DLog.info(String.valueOf(position) + "->" + model.getTagList().get(position));
                itemHandler.onTagActionHandler(model, position);
            }
        });

        if (model.isLiked()) {
            Bitmap bp = BitmapFactory.decodeResource(this.activity.getResources(), R.mipmap.like);
            likeButton.setImageBitmap(bp);
        } else {
            Bitmap bp = BitmapFactory.decodeResource(this.activity.getResources(), R.mipmap.unlike);
            bp = BitmapUtil.tintBitmap(bp,
                    ColorUtil.getResourcesColor(this.activity.getBaseContext(), R.color.QuickTalk_SECOND_FONT_COLOR));
            likeButton.setImageBitmap(bp);
        }
        likeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onLikeActionHandler(model);
            }
        });
        commentButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemHandler.onCommentHandler(model);
            }
        });

        likeView.setLikeList(model.getLikeList());
        likeView.makeSubViews();
        if (model.getLikeList() == null) {
            likeLayout.setVisibility(View.GONE);
        } else {
            likeLayout.setVisibility(View.VISIBLE);
        }
        likeView.setTouchHandler(new UserPostLikeView.OnSingLikeTouchHandler() {
            @Override
            public void onTouchHandler(int index) {
                DLog.info("likeIndex->" + String.valueOf(index));
                itemHandler.onLikeIconActionHandler(model, index);
            }
        });

    }
}
