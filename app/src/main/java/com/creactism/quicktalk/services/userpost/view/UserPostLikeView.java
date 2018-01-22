package com.creactism.quicktalk.services.userpost.view;

import android.content.Context;
import android.net.Uri;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.GenericDraweeHierarchy;
import com.facebook.drawee.view.SimpleDraweeView;

import java.lang.ref.WeakReference;
import java.util.List;

/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class UserPostLikeView extends ViewGroup {

    public abstract static class OnSingLikeTouchHandler {
        public abstract void onTouchHandler(int index);
    }

    private int countOfEveryLine = 7;
    private int singleWH;
    private int padding;

    private List<UserPostModel.UserPostLikeModel> likeList;
    private OnSingLikeTouchHandler touchHandler;

    public List<UserPostModel.UserPostLikeModel> getLikeList() {
        return likeList;
    }

    public void setTouchHandler(OnSingLikeTouchHandler touchHandler) {
        this.touchHandler = touchHandler;
    }

    public void setLikeList(List<UserPostModel.UserPostLikeModel> likeList) {
        singleWH = DensityUtil.dip2px(28);
        padding = DensityUtil.dip2px(6);

        DisplayMetrics dm = getResources().getDisplayMetrics();
        int wScreen = dm.widthPixels;
        countOfEveryLine = (wScreen-DensityUtil.dip2px(70)) / (singleWH+padding) - 1; //1为红心

        this.likeList = likeList;
    }

    public UserPostLikeView(Context context) {
        this(context,null);
    }

    public UserPostLikeView(Context context, AttributeSet attrs) {
        this(context, attrs,0);

    }

    public UserPostLikeView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        if (this.getLikeList() == null) {
            //保存测量高度
            setMeasuredDimension(widthMeasureSpec, heightMeasureSpec);
            return;
        }

        //测量所有子view的宽高
        measureChildren(widthMeasureSpec, heightMeasureSpec);

        //获取view的宽高测量模式
        int widthMode = MeasureSpec.getMode(widthMeasureSpec);
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);

        int heightMode = MeasureSpec.getMode(heightMeasureSpec);
        int heightSize = MeasureSpec.getSize(heightMeasureSpec);

        //这里的宽度建议使用match_parent或者具体值，
        // 当然当使用wrap_content的时候没有重写的话也是
        // match_parent所以这里的宽度就直接使用测量的宽度
        int width = widthSize;
        int height;

        //判断宽度
        if (heightMode == MeasureSpec.EXACTLY) {
            height = heightSize;
        } else {
            int row = 1;
            int widthSpace = width; //宽度剩余空间
            for (int i = 0; i < getChildCount(); i++) {
                View view = getChildAt(i);
                //获取标签宽度
                int childW = view.getMeasuredWidth();
                //判断剩余宽度是否大于此标签宽度
                if (widthSpace >= childW) {
                    widthSpace -= childW;
                } else {
                    row++;
                    widthSpace = width - childW;
                }
                //减去两边间距
                widthSpace -= padding;
            }
            int childH = getChildAt(0).getMeasuredHeight();

            //测算最终所需要的高度
            height = (childH * row) + (row - 1) * padding;
        }

        //保存测量高度
        setMeasuredDimension(width, height);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        int row = 0;
        int lineCount = 1;
        int right = 0;
        int bottom = 0;
        for(int i = 0; i < getChildCount() ;i++){
            View cView = getChildAt(i);
            int cWidth = cView.getMeasuredWidth();
            int cHeight = cView.getMeasuredHeight();
            right += cWidth;
            bottom = (cHeight + padding) * row + cHeight;
            if(lineCount > countOfEveryLine){
                lineCount = 1;
                row++;
                right = cWidth;
                bottom =  (cHeight + padding) * row + cHeight;
            }
            cView.layout(right - cWidth, bottom - cHeight,right,bottom);
            right += padding;
            lineCount++;
        }
    }

    public void makeSubViews() {
        this.removeAllViews();
        if (this.getLikeList() == null) { return; }

        for (int index=0; index<this.likeList.size(); ++index) {
            SimpleDraweeView icon = new SimpleDraweeView(getContext());
            icon.setId(index);
            icon.setLayoutParams(new LayoutParams(singleWH, singleWH));
            addView(icon);

            GenericDraweeHierarchy hierarchy = icon.getHierarchy();
            hierarchy.setPlaceholderImage(R.drawable.avatar_default, ScalingUtils.ScaleType.CENTER_CROP);
            hierarchy.setFailureImage(R.drawable.avatar_default, ScalingUtils.ScaleType.CENTER_CROP);
            hierarchy.setOverlayImage(getContext().getResources().getDrawable(R.drawable.ripple_avatar_bg));
            hierarchy.setActualImageScaleType(ScalingUtils.ScaleType.CENTER_CROP);
            icon.setHierarchy(hierarchy);


            UserPostModel.UserPostLikeModel model = this.likeList.get(index);
            icon.setImageURI(Uri.parse(model.getAvatar()));
            icon.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    touchHandler.onTouchHandler(v.getId());
                }
            });
        }
    }

}
