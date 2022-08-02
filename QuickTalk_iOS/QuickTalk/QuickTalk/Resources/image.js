/*
 * image.js
 *
 * Created by ruibin.chow on 2017/09/03.
 * Copyright (c) 2017年 ruibin.chow All rights reserved.
 */

function setImageClickFunction(){ 
    var imgs = document.getElementsByTagName('img'); 
    for(var i=0;i<imgs.length;i++) {
        var src = imgs[i].src;
        imgs[i].setAttribute('onClick', 'getImg(src)');
    }
}

function getImg(src) { 
    var url = src; 
    url = url.replace('http', 'image'); 
    document.location = url; 
}