/*
 * project.js
 *
 * Created by ruibin.chow on 2017/08/23.
 * Copyright (c) 2017年 ruibin.chow All rights reserved.
 */



var tab = document.getElementById("tab");
var lineTab = document.getElementById("lineTab");

var project = document.getElementById("project");
var journal = document.getElementById("journal");

var showCSS = "display:block;";
var hideCSS = "display:none;";

project.style.cssText = showCSS;
journal.style.cssText = hideCSS;


function showProject() {
    var w = screen.width;
    makeLineLocation(1);
    project.style.cssText = showCSS;
    journal.style.cssText = hideCSS;
}

function showJournal() {
    makeLineLocation(2);
    project.style.cssText = hideCSS;
    journal.style.cssText = showCSS;
}

function makeLineLocation(index) {
    var loc;
    if (index == 1) {
        loc = (tab.offsetWidth/2 - lineTab.offsetWidth) /2;
    } else {
        loc = (tab.offsetWidth*3/2 - lineTab.offsetWidth) /2;
    }
    lineTab.style.cssText = "left:" + loc + "px";
}

function onClick() {
    console.log("onClick");
    window.location.href="index.html"; 
}


/*------------------------------项目------------------------------------*/ 

function memberHtml() {
    var w = tab.offsetWidth;
    num = parseInt(w / (45 + 12));
    // console.log(num)
    content = '<div class="member" onclick="showProject()"> \
          <img src="images/logo.png" alt="" class="avatar"> \
          <div class="nickname">成员成员成员成员</div>  \
    </div>'
    html = '<div id="memberListTitle">成员</div>';
    for (var i=0; i<num; i++) {
        html += content
    }
    var memberList = document.getElementById("memberList");
    memberList.innerHTML = html;
}

function detailHtml(content, tagList) {
    html = '<div id="detailTitle" class="title">简单介绍</div>\
    <hr>\
    <div id="detailContent">'+ content +'</div> \
    <hr>';

    for (var i = 0; i < tagList.length; i++) {
        var tag = tagList[i];
        html += '<div class="detailTag">' + tag + '</div>';
    }

    html += '<span class="arrow"></span>'; 
    var detail = document.getElementById("detail");
    detail.innerHTML = html;
}

function planHtml() {
    content = '<div id="planTitle" class="title">计划</div> \
    <div id="planTime" class="title">10月12日 截止</div> \
    <hr> \
    <div class="planContent"> \
            <div class="planContentLeft">1、对于 View 来说，你如果抽象得好，那么一个 App 的动画效果可以很方便地移植到别的 App 上，而 Github 上也有很多 UI 控件，这些控件都是在 View 层做了很好的封装设计，使得它能够方便地开源给大家复用。</div> \
            <div class="planContentRight">10月12日 截止</div> \
    </div> \
    <div class="planContent"> \
            <div class="planContentLeft">2、对于 View 来说，你如果抽象得好，那么一个 App 的动画效果可以很方便地移植到别的 App 上，而 Github 上也有很多 UI 控件，这些控件都是在 View 层做了很好的封装设计，使得它能够方便地开源给大家复用。</div> \
            <div class="planContentRight">10月12日 截止</div> \
    </div> \
    <div class="planContent"> \
            <div class="planContentLeft">3、对于 View 来说，你如果抽象得好，那么一个 App 的动画效果可以很方便地移植到别的 App 上，而 Github 上也有很多 UI 控件，这些控件都是在 View 层做了很好的封装设计，使得它能够方便地开源给大家复用。</div> \
            <div class="planContentRight">10月12日 截止</div> \
    </div>';
    var plan = document.getElementById("plan");
    plan.innerHTML = content;
}

function resultHtml() {
    content = '<div class="title">预期结果:</div> \
    <hr> \
    <div id="resultContent">对于 Model 来说，它其实是用来存储业务的数据的，如果做得好，它也可以方便地复用。比如我当时在做有道云笔记 iPad 版的时候，我们就直接和 iOS 版复用了所有的 Model 层的代码。在创业做猿题库客户端时，iOS 和 iPad 版的 Model 层代码再次被复用上了。当然，因为和业务本身的数据意义相关，Model 层的复用大多数是在一个产品内部，不太可能像 View 层那样开源给社区。</div> \
    <div id="resultImageContent"> \
            <img src="./images/logo.png" alt="" class="resultImage"> \
            <img src="./images/logo.png" alt="" class="resultImage"> \
            <img src="./images/logo.png" alt="" class="resultImage"> \
            <img src="./images/logo.png" alt="" class="resultImage"> \
            <img src="./images/logo.png" alt="" class="resultImage"> \
            <img src="./images/logo.png" alt="" class="resultImage"> \
    </div>';
    var result = document.getElementById("result");
    result.innerHTML = content;
}

function arrangeResultImage() {
    var w = tab.offsetWidth;
    var resultImage = document.getElementsByClassName("resultImage");
    for (var i = 0; i < resultImage.length; i++) {
        var imageHW =  w/3 - 10;
        var image = resultImage[i];
        image.style.width = imageHW + "px";
        image.style.height = imageHW + "px";
    }
}

/*------------------------------日志------------------------------------*/ 

function journalHtmlTemplate(journalAvatar, userName, likeNum, time, content, imageArray) {
    content = ' \
    <div class="journalContent"  onclick="onClick()"> \
    <div class="journalHeader" > \
            <img src="'+journalAvatar+'" alt="" class="avatar journalAvatar"> \
            <div> \
                    <span class="username">'+userName+'</span><span class="tip">更新了日志 </span>  \
                    <div class="likeNum">'+likeNum+'</div> \
                    <img src="images/like.png" alt="" class="like"> \
            </div> \
            <div><span class="journalTime">'+time+'</span></div> \
    </div> \
    <div class="journalText" >'+content+'</div>';

    for (var i = 0; i < imageArray.length; i++) {
        var image = imageArray[i];
        content += '<img src="'+image+'" alt="" class="journalImage">';
    }
    
    content += '</div>';
    return content;
}

function journalHtml() {
    content = '';
    for (var i = 0; i < 10; i++) {
        content +=  journalHtmlTemplate("images/logo.png", "userName", 
        "123", "12/12 02:17", "Helvetica: 被评为设计师最爱的字体，Realist风格，简洁现代的线条，非常受到追捧。在Mac下面被认为是最佳的网页字体，在Windows下由于Hinting的原因显示很糟糕", ["images/logo.png", "images/logo.png"]);    
    }
    
    var journal = document.getElementById("journal");
    journal.innerHTML = content;
}

function arrangeJournalImage() {
    var w = tab.offsetWidth;
    var journalImage = document.getElementsByClassName("journalImage");
    for (var i = 0; i < journalImage.length; i++) {
        var imageHW =  w/3 - 10;
        var image = journalImage[i];
        image.style.width = imageHW + "px";
        image.style.height = imageHW + "px";
    }
}

/*-----------------------------结果-------------------------------------*/ 


// showJournal()


function showProjectFromJsonObj(obj){
    showProject()
    memberHtml();
    // detailHtml(obj.data.detail, obj.data.tagList);
    planHtml();
    resultHtml();
    arrangeResultImage();

    journalHtml();
    arrangeJournalImage();
}




/*-----------------------------请求-------------------------------------*/ 

function requestText () {
  var path = "http://192.168.0.116/service/project/project?project_uuid="+"000000-7d83-11e7-889b-bbbbbb";
//   var path = "http://zruibin.cc/api/index.json";
// var path = "http://192.168.0.116/service/api/";
  var xmlhttp;

  if (window.XMLHttpRequest) {
      xmlhttp = new XMLHttpRequest();
      if (xmlhttp.overrideMimeType) {
          xmlhttp.overrideMimeType("text/json");
      }
    } else if (window.ActiveXObject) {
      var activexName = ["MSXML2.XMLHTTP","Microsoft.XMLHTTP"];
      for (var i = 0; i < activexName.length; i++) {
          try{
              xmlhttp = new ActiveXObject(activexName[i]);
              break;
          } catch(e){
          }
      }
    }

    function callback() {
      if (xmlhttp.readyState == 4) {
          if (xmlhttp.status == 200) {
              var responseText = xmlhttp.responseText;
              
            //   var obj = JSON.parse(responseText); 
              alert(responseText);
              
            //   showProjectFromJsonObj(obj);

          } else {
            alert(xmlhttp.status);
          }
      }
    }
    xmlhttp.onreadystatechange = callback;
    // xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest"); //请求头部，需要服务端同时设置
    // xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.open("GET", path, true);
    xmlhttp.send();
    // alert(path);
}

// requestText ();


$(document).ready(function() {

    // var path = "http://192.168.0.116/service/project/project?project_uuid="+"000000-7d83-11e7-889b-bbbbbb";
    // path = "http://zruibin.cc/api/index.json"
    // alert("1111111");
    // console.log(path);
    // $.get(path, function(obj){
    //     console.log(obj);
    //     // alert(obj);
    //     // showProjectFromJsonObj(obj);
    // });

    function showLocation(json)
    {
        console.log("json: " + json);    
    }

    var path = "http://39.108.174.16/service/project/project?project_uuid="+"000000-7d83-11e7-889b-bbbbbb";
   $.ajax({
        url:path,
        dataType:'jsonp',
        processData: false,
        // jsonp: "callback",
        type:'GET',
        timeout: 3000,
        crossDomain: true,
        async:false,
        dataType: 'jsonp',
        jsonp: 'callback',
        jsonpCallback:"showLocation",
        contentType: "application/json;utf-8",
        success:function(data, textStatus){
            data =  $.parseJSON(data);
            console.log(data);
        },
        error:function(XMLHttpRequest, textStatus, errorThrown) {
            console.log("XMLHttpRequest.status: " + XMLHttpRequest.status);
            console.log("XMLHttpRequest.readyState: " + XMLHttpRequest.readyState);
            console.log("textStatus: "+ textStatus);
            console.log("errorThrown: " + errorThrown);     
        }
    });
    

});



// setTimeout("showProjectFromJsonObj('')", 3000);


