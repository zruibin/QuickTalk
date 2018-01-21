package com.creactism.quicktalk.components;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 21/01/2018.
 */

public class NavigationBar extends RelativeLayout {

    private RelativeLayout rootlayout;
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
        rootlayout = (RelativeLayout)findViewById(R.id.layout_navigationbar_rootlayout);

        leftItem = (Button)findViewById(R.id.navigationbar_left_item);
        rightItem = (Button)findViewById(R.id.navigationbar_right_item);
        titleView = (TextView)findViewById(R.id.navigationbar_title_item);

    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
    }

    public void setTintColor(int tintColor) {
        leftItem.setTextColor(tintColor);
        rightItem.setTextColor(tintColor);
        titleView.setTextColor(tintColor);
    }

    public void setItemBackground(Drawable drawable) {
        if (leftItem.getVisibility() == VISIBLE) {
            leftItem.setBackground(drawable.getConstantState().newDrawable());
        }
        if (rightItem.getVisibility() == VISIBLE) {
            rightItem.setBackground(drawable.getConstantState().newDrawable());
        }
    }

}
