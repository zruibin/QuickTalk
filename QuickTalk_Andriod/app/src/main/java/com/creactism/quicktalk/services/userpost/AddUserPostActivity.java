package com.creactism.quicktalk.services.userpost;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class AddUserPostActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        DLog.info("AddUserPostActivity onCreate....");
        setContentView(R.layout.activity_add_userpost);
//        this.linearLayout
//        ButterKnife.bind(this);

//        DLog.info("AddUserPostActivity Test Cache: " + QTCache.sharedCache().getString("testCache"));

//        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
//                LinearLayout.LayoutParams.MATCH_PARENT);
//        LinearLayout lineLayout = new LinearLayout(this);
//        lineLayout.setOrientation(LinearLayout.VERTICAL);
//        lineLayout.setLayoutParams(params);
//        lineLayout.setGravity(Gravity.TOP);
//        this.addView(lineLayout);
//        setContentView(lineLayout);
    }


    private void addView(final LinearLayout lineLayout) {

        final Toolbar toolbar = new Toolbar(this);
        toolbar.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));
//        toolbar.setBackgroundColor(this.getResources().getColor(R.color.tuna));
        toolbar.setBackgroundColor(Color.parseColor("#38383C"));
        TypedValue typedValue = new TypedValue();
        this.getTheme().resolveAttribute(R.attr.actionBarSize, typedValue, true);
        DLog.debug("density: " + String.valueOf(typedValue.density));
        toolbar.setMinimumHeight(44);
        toolbar.setPopupTheme(R.style.ThemeOverlay_AppCompat_Light);
        lineLayout.addView(toolbar);


        final TextView showText = new TextView(this);
        showText.setTextColor(Color.GREEN);
        showText.setTextSize(30);
        showText.setId(10001);//?????? id
        showText.setText("??????????????????????????????????????????");
        showText.setBackgroundColor(Color.GRAY);
        // set ????????????
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        //set ????????????
        params.setMargins(10, 10, 10, 10);

        showText.setLayoutParams(params);

        //????????????????????????
        lineLayout.addView(showText);

        //????????????
        Button btn = new Button(this);
        btn.setText("??????????????????");
        btn.setBackgroundColor(Color.GRAY);
        Drawable rippleDrawable = this.getResources().getDrawable(R.drawable.ripple_bg, null);
        btn.setBackground(rippleDrawable);
        LinearLayout.LayoutParams btn_params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        btn_params.setMargins(0, 60, 60, 0);
        btn_params.gravity = Gravity.CENTER_HORIZONTAL;
        btn.setLayoutParams(btn_params);
        // ??????????????????????????????
        lineLayout.addView(btn);

        //???????????? ??????????????????
        btn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                if (null != lineLayout.findViewById(10001)) {
                    lineLayout.removeView(showText);
                } else {
//                    Toast.makeText(AddUserPostActivity.this, "??????????????????", Toast.LENGTH_SHORT).show();
                }
            }
        });

        //??????????????????????????????
        RelativeLayout relaLayout = new RelativeLayout(this);
        relaLayout.setBackgroundColor(Color.BLUE);
        RelativeLayout.LayoutParams lp11 = new RelativeLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, 120);

        relaLayout.setLayoutParams(lp11);
        //????????????????????????
        final TextView RelaText = new TextView(this);
        RelaText.setTextColor(Color.GREEN);
        RelaText.setTextSize(20);
        RelaText.setText("???????????????????????????????????????????????????????????????");
        RelaText.setBackgroundColor(Color.GRAY);

        //?????????????????????
        RelativeLayout.LayoutParams lp2 = new RelativeLayout.LayoutParams(
                ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);

        lp2.addRule(RelativeLayout.CENTER_IN_PARENT, RelativeLayout.TRUE);
        lp2.setMargins(10, 10, 10, 10);
        //?????????????????????????????????
        relaLayout.addView(RelaText, lp2);
        //????????????????????????????????????
        lineLayout.addView(relaLayout);
    }
}
