package com.creactism.quicktalk.components.tableview;

import com.chad.library.adapter.base.entity.SectionEntity;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class SectionTableEntity<T> extends SectionEntity<T> {

    public static class IndexPath {
        public static int SECTION = -1;
        public int section;
        public int row;

        public IndexPath(int section, int row) {
            this.section = section;
            this.row = row;
        }
    }

    private T obj;
    private IndexPath indexPath;


    public SectionTableEntity(boolean isHeader, String header, IndexPath indexPath) {
        super(isHeader, header);
        indexPath.row = IndexPath.SECTION;
        this.indexPath = indexPath;
    }

    public SectionTableEntity(T o, IndexPath indexPath) {
        super(o);
        this.obj = o;
        this.indexPath = indexPath;
    }

    public T getObj() {
        return obj;
    }

    public void setObj(T obj) {
        this.obj = obj;
    }

    public IndexPath getIndexPath() {
        return indexPath;
    }

    public void setIndexPath(IndexPath indexPath) {
        this.indexPath = indexPath;
    }
}
