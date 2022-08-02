package com.creactism.quicktalk.modules;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public final class Dispatch extends Object {

    private Dispatch() {}

    private final static Handler mainHandler = new Handler(Looper.getMainLooper()) { //主线程
        @Override
        public void handleMessage(Message msg) {
            DispatchBlock block = (DispatchBlock)msg.obj;
            block.inMainThread();
        }
    };

    public final static Handler DISPATCH_GET_MAIN_QUEUE = Dispatch.mainHandler;

    public static void dispatchAsync(Handler handler, final DispatchBlock block) {
        Message msg = handler.obtainMessage();
        msg.obj = block;
        msg.sendToTarget();
    }

    public abstract static class DispatchBlock {
        public abstract void inMainThread();
    }

}

/*
test
DLog.info("isMainThread1: "
                        + String.valueOf(Looper.getMainLooper().getThread() == Thread.currentThread()));
                Dispatch.dispatchAsync(Dispatch.DISPATCH_GET_MAIN_QUEUE, new Dispatch.DispatchBlock() {
                    @Override
                    public void inMainThread() {
                        DLog.info("isMainThread2: "
                                + String.valueOf(Looper.getMainLooper().getThread() == Thread.currentThread()));
                    }
                });
* */
