package com.creactism.quicktalk.modules;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public final class Cleaner extends Object {

    private static Cleaner instance = new Cleaner();

    private Cleaner(){}

    public static Cleaner sharedInstance() {
        return instance;
    }

    public String cacheSizeString() {
        return null;
    }

    public void checkingCache() {

    }

    public void asynchronousCleanUpCache() {

    }

}
