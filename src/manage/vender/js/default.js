/**
  * default.js
  * zruibin.cc
  *
  * Created by Ruibin.Chow on 15/10/17.
  * Copyright (c) 2015年 Ruibin.Chow. All rights reserved.
  */

/*
 * 传递函数给RBReady()
 * 当文档解析完毕且为操作准备就绪时，函数作为document的方法调用
 */
var RBReady = (function() { //这个函数返回whenReady()函数
    var funcs = []; //当获得事件时，要运行的函数
    var ready = false; //当触发事件处理程序时,切换为true
    
    //当文档就绪时,调用事件处理程序
    function handler(e) {
        if(ready) return; //确保事件处理程序只完整运行一次
        
        //如果发生onreadystatechange事件，但其状态不是complete的话,那么文档尚未准备好
        if(e.type === 'onreadystatechange' && document.readyState !== 'complete') {
            return;
        }
        
        //运行所有注册函数
        //注意每次都要计算funcs.length
        //以防这些函数的调用可能会导致注册更多的函数
        for(var i=0; i<funcs.length; i++) {
            funcs[i].call(document);
        }
        //事件处理函数完整执行,切换ready状态, 并移除所有函数
        ready = true;
        funcs = null;
    }
    //为接收到的任何事件注册处理程序
    if(document.addEventListener) {
        document.addEventListener('DOMContentLoaded', handler, false);
        document.addEventListener('readystatechange', handler, false);            //IE9+
        window.addEventListener('load', handler, false);
    }else if(document.attachEvent) {
        document.attachEvent('onreadystatechange', handler);
        window.attachEvent('onload', handler);
    }
    //返回whenReady()函数
    return function whenReady(fn) {
        if(ready) { fn.call(document); }
        else { funcs.push(fn); }
    }
})();

//--------------------- test -----
//  function t1() {
//     console.log('t1');
// }
// function t2() {
//     console.log('t2');
// }
// // t2-t1-t2
// RBReady(t1);
// t2();
// RBReady(t2);

var pwdEncode = '8f745a395b26da39fdb869508511ad0df2d3f8c3';
var host = "http://creactism.com/";
// var host = "http://localhost/";

var cookieName = "the_cookie";


function checkingBackup() {
    var cookiePwd = getCookie(cookieName); // 读取 cookie
    if (cookiePwd === pwdEncode) {
        return true;
    } else {
        return false;
    }
}

function checkingAuth() {
    if (checkingBackup() == false) {
        window.location.href = "index.html";
    } 
}


function setCookie(name,value) { 
    var exp = new Date(); 
    exp.setTime(exp.getTime() + 60*60*1000); //一个小时
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString(); 
} 

function getCookie(name) { 
    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
    if(arr=document.cookie.match(reg))
        return unescape(arr[2]); 
    else 
        return null; 
} 

function deleteCookie(name) {
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval = getCookie(name);
    if(cval != null)
    document.cookie= name + "="+cval+";expires="+exp.toGMTString();
    window.location.href = "index.html";
}

function getQueryString(name) { 
    var url = location.search; //获取url中"?"符后的字串 
    // console.log('url: ' + url);
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
    var r = window.location.search.substr(1).match(reg); 
    if (r != null) return unescape(r[2]); return null; 
} 

function stringReplace(text) {
    text = text.replace(/<p>\&nbsp;<\/p>/g, "<br />");
    text = text.replace(/&quot;/g, '"');
    text = text.replace(/&lt;/g, '<');
    text = text.replace(/&gt;/g, '>');
    text = text.replace(/&rdquo;/g, '');
    console.log(text);
    return text;
}


function headerAction() {
    var nav = '<nav class="navbar navbar-default" role="navigation"> \
                <div class="navbar-header"> \
                <a class="navbar-brand" href="topicList.html">话题列表</a> \
                <a class="navbar-brand" href="addTopic.html">新增话题</a> \
                <a class="navbar-brand" href="log.html">日志</a> \
                <a class="navbar-brand" onclick="deleteCookie(cookieName);">退出</a> \
                </div> \
            </nav>';
    $("body:first").before(nav);//
}






