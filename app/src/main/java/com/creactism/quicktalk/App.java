package com.creactism.quicktalk;

import android.app.Activity;
import android.app.Application;
import android.content.res.Configuration;
import android.os.Bundle;

import com.creactism.quicktalk.modules.cache.QTCache;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.squareup.leakcanary.LeakCanary;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public final class App extends Application {

    private int activityCount;//activity的count数
    private boolean isForeground;//是否在前台

    @Override
    public void onCreate() {
        super.onCreate();
        DLog.info("App onCreate...");
        /*初始化缓存库*/
        QTCache.sharedCache().initCache(this.getApplicationContext());
        /*初始化图片缓存库*/
        Fresco.initialize(this);

        if (LeakCanary.isInAnalyzerProcess(this)) {
            // This process is dedicated to LeakCanary for heap analysis.
            // You should not init your app in this process.
            return;
        }
        LeakCanary.install(this);

        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            }

            @Override
            public void onActivityStarted(Activity activity) {
                activityCount++;
            }

            @Override
            public void onActivityResumed(Activity activity) {
            }

            @Override
            public void onActivityPaused(Activity activity) {
            }

            @Override
            public void onActivityStopped(Activity activity) {
                activityCount--;
                if(0==activityCount){
                    isForeground=false;
                }
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
            }
        });
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        DLog.error("App onLowMemory...");
    }

    @Override
    public void onTrimMemory(int level) {
        super.onTrimMemory(level);
        DLog.error("App onTrimMemory...");
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        DLog.info("App onConfigurationChanged...");
    }


}
