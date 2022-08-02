package com.creactism.quicktalk.components;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 21/01/2018.
 */

public class NavigationBar extends RelativeLayout {

    private RelativeLayout rootlayout;
    public ImageButton backItem;
    public Button leftItem;
    public Button rightItem;
    public TextView titleView;

    public NavigationBar(Context context) {
        this(context, null);
        initViews(context);
    }

    public NavigationBar(Context context, AttributeSet attrs) {
        super(context, attrs);
        initViews(context);
    }

    public NavigationBar(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initViews(context);
    }

    private void initViews(Context context) {

        LayoutInflater.from(context).inflate(R.layout.layout_navigationbar, this, true);
        this.rootlayout = (RelativeLayout)findViewById(R.id.layout_navigationbar_rootlayout);

        this.backItem = (ImageButton)findViewById(R.id.navigationbar_back_item);
        this.leftItem = (Button)findViewById(R.id.navigationbar_left_item);
        this.rightItem = (Button)findViewById(R.id.navigationbar_right_item);
        this.titleView = (TextView)findViewById(R.id.navigationbar_title_item);

        this.showBack(false);
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
    }

    public void setItemBackground(Drawable drawable) {
        this.backItem.setBackground(drawable.getConstantState().newDrawable());
        if (this.leftItem.getVisibility() == VISIBLE) {
            this.leftItem.setBackground(drawable.getConstantState().newDrawable());
        }
        if (this.rightItem.getVisibility() == VISIBLE) {
            this.rightItem.setBackground(drawable.getConstantState().newDrawable());
        }
    }

    public void showBack(boolean show) {
        if (show) {
            this.backItem.setVisibility(VISIBLE);
            this.leftItem.setVisibility(GONE);
        } else {
            this.backItem.setVisibility(GONE);
            this.leftItem.setVisibility(VISIBLE);
        }
    }

    public void setBackAction(final OnClickListener listener) {
        this.backItem.setOnClickListener(listener);
    }

    public void setDefaultBackAction(final Activity activity) {
        this.showBack(true);
        this.setBackAction(new OnClickListener() {
            @Override
            public void onClick(View v) {
                activity.finish();
            }
        });
    }

    public void setLeftAction(final OnClickListener listener) {
        this.leftItem.setOnClickListener(listener);
    }

    public void setRightAction(final OnClickListener listener) {
        this.rightItem.setOnClickListener(listener);
    }

}
