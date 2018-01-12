package com.creactism.quicktalk;

import android.app.Application;
import android.content.res.Configuration;

import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public final class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        DLog.info("App onCreate...");
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
