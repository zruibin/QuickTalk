package com.creactism.quicktalk.modules;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ruibin.chow on 17/01/2018.
 */

public final class NotificationCenter extends Object {

    private static NotificationCenter instance = new NotificationCenter();

    private NotificationCenter(){}

    public static NotificationCenter defaultCenter(){
        return instance;
    }

    private Map<String, Map> notificationMap = new HashMap<String, Map>();

    public abstract static class SelectorHandler extends Object {
        public abstract void handler(Object object);
    }

    /**
     *
     * @param observer observer
     * @param aName name of the observer
     * @param selectorHandler handler
     *
     *  must in Main Looper to add the observer
     */

    public void addObserver(Object observer, String aName, SelectorHandler selectorHandler) {
        if (observer == null) { return;}
        if (aName == null) { return;}
        if (selectorHandler == null) { return;}

//        WeakReference<Object> weakReference = new WeakReference<Object>(observer);

        String observerHashCodeKey = String.valueOf(observer.hashCode());

        Map<String, List> observerMap = null;
        List<SelectorHandler> selectorHandlerList = null;

        if (this.notificationMap.containsKey(aName)) {
            observerMap = (Map<String, List>)this.notificationMap.get(aName);

            selectorHandlerList = (List<SelectorHandler>)observerMap.get(observerHashCodeKey);
            if (selectorHandlerList == null) {
                selectorHandlerList = new ArrayList<SelectorHandler>();
            }
        } else {
            observerMap = new HashMap<String, List>();
            selectorHandlerList = new ArrayList<SelectorHandler>();
        }

        selectorHandlerList.add(selectorHandler);
        observerMap.put(String.valueOf(observer.hashCode()), selectorHandlerList);
        this.notificationMap.put(aName, observerMap);
    }

    /**
     *
     * @param aName name of the observer
     * @param object the carry of object
     *
     *  must in Main Looper to post the notification
     */
    public void postNotification(String aName, Object object) {
        if (this.notificationMap.containsKey(aName) == false) { return;}

        Map<String, List> observerMap = (Map<String, List>)this.notificationMap.get(aName);
        for (String observerHashCode : observerMap.keySet()) {
            if (observerHashCode == null) { continue;}
            List<SelectorHandler> selectorHandlerList = (List<SelectorHandler>)observerMap.get(observerHashCode);
            for (SelectorHandler selectorHandler : selectorHandlerList) {
                selectorHandler.handler(object);;
            }
        }
    }

    /**
     *
     * @param aName name of the observer
     *
     *  must in Main Looper to post the notification
     */
    public void postNotification(String aName) {
        this.postNotification(aName, null);
    }

    /**
     *
     * @param observer observer
     * @param aName name of the observer
     *
     *  must in Main Looper to remove the observer
     */
    public void  removeObserver(Object observer, String aName) {
        if (observer == null) { return;}
        if (aName == null) { return;}
//        WeakReference<Object> weakReference = new WeakReference<Object>(observer);

        Map observerMap = (Map)this.notificationMap.get(aName);
        if (observerMap == null) {return;}
        observerMap.remove(observer);
    }
}
