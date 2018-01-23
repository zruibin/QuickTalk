package com.creactism.quicktalk.services.setting;

import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.DrawableUtil;


/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class WelcomeActivity extends BaseActivity {

    private int[] imageIds;
    private ViewGroup vg;//放置圆点
    private ImageView []ivPointArray;
    private Button button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 隐藏状态栏
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        this.statusBar.setVisibility(View.GONE);
        this.navigationBar.setVisibility(View.GONE);
        setContentView(R.layout.activity_welcome);

        imageIds = new int[]{R.mipmap.welcome1, R.mipmap.welcome2, R.mipmap.welcome3};

        this.button = (Button)findViewById(R.id.activity_welcome_Button);
        this.button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
//                overridePendingTransition(0, R.anim.activity_down_close);
                overridePendingTransition(0, android.R.anim.fade_out);
            }
        });

        //获取适配器
        GuideAdapter mGuideAdapter = new GuideAdapter(getApplicationContext(), imageIds);
//        //获取ViewPager控件
        ViewPager mGuideVp = (ViewPager)findViewById(R.id.activity_welcome_viewpager);
        int w = getResources().getDisplayMetrics().widthPixels;
        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(w, (int) (w/1.2));
        lp.setMargins(0, 200, 0, 0);
        mGuideVp.setLayoutParams(lp);

//        //设置适配器
        mGuideVp.setAdapter(mGuideAdapter);
        mGuideVp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                DLog.debug("position: " + position);
                //循环设置当前页的标记图

                for (int i = 0; i<imageIds.length; i++){
                    ivPointArray[position].setBackgroundResource(R.drawable.shape_full_dot);
                    if (position != i){
                        ivPointArray[i].setBackgroundResource(R.drawable.shape_empty_dot);
                    }
                }

                if (position == imageIds.length - 1){
                    scaleButton(false);
                } else {
                    scaleButton(true);
                }
            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        initPoint();
    }

    private void initPoint() {
        //这里实例化LinearLayout
        vg = (ViewGroup) findViewById(R.id.activity_welcome_point);
        //根据ViewPager的item数量实例化数组
        ivPointArray = new ImageView[3];
        //循环新建底部圆点ImageView，将生成的ImageView保存到数组中
        int size = 3;
        for (int i = 0;i<size;i++){
            ImageView imageView = new ImageView(this);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(20,20);
            lp.setMargins(10, 0, 10, 0);
            imageView.setLayoutParams(lp);
            imageView.setPadding(10,0,10,0);//left,top,right,bottom
            ivPointArray[i] = imageView;
            //第一个页面需要设置为选中状态，这里采用两张不同的图片
            if (i == 0){
                imageView.setBackgroundResource(R.drawable.shape_full_dot);
            }else{
                imageView.setBackgroundResource(R.drawable.shape_empty_dot);
            }
            //将数组中的ImageView加入到ViewGroup
            vg.addView(ivPointArray[i]);
        }
    }

    private void scaleButton(boolean scale) {
        RelativeLayout.LayoutParams params;
        if (scale) {
            this.button.setText("跳过");
            this.button.setBackground(DrawableUtil.getBorderDrawable(6, Color.WHITE, 2, Color.GRAY));
            this.button.setTextColor(Color.GRAY);
            params = new RelativeLayout.LayoutParams(DensityUtil.dip2px(60), DensityUtil.dip2px(28));
        } else {
            this.button.setText("进入快言");
            this.button.setBackground(DrawableUtil.getRoundRectRippleDrawable(
                    getResources().getColor(R.color.QuickTalk_MAIN_COLOR, null), 6));
            this.button.setTextColor(Color.WHITE);
            int w = getResources().getDisplayMetrics().widthPixels;
            params = new RelativeLayout.LayoutParams(w-DensityUtil.dip2px(30), DensityUtil.dip2px(40));
        }
        params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        params.addRule(RelativeLayout.CENTER_HORIZONTAL);
        params.setMargins(0, 0, 0, DensityUtil.dip2px(30));
        this.button.setLayoutParams(params);
    }


    private class GuideAdapter extends PagerAdapter {
        //图片资源合集:ViewPager滚动的页面种类
        private int[] mImageId;
        private Context mContext;

        public int[] getImageId() {
            return mImageId;
        }

        public GuideAdapter(Context context, int[] mImageId) {
            super();
            this.mContext = context;
            this.mImageId = mImageId;
        }
        //返回填充ViewPager页面的数量
        @Override
        public int getCount() {
            return mImageId.length;
        }
        //销毁ViewPager内某个页面时调用
        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;//固定是view == object
        }

        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            ImageView imageView = new ImageView(this.mContext);
            //设置背景资源
            imageView.setBackgroundResource(mImageId[position]);
            container.addView(imageView);
            return imageView;
        }


    }
}



