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
    window.location.href="/"; 
}

function avatar() {
    return "/images/logo.png"
}


/*------------------------------项目------------------------------------*/ 

function memberHtml(memberList) {
    var w = tab.offsetWidth;
    var num = parseInt(w / (45 + 12));
    // console.log(num)
    var html = '<div id="memberListTitle">成员</div>';

    if (memberList.length < num) {
        num = memberList.length;
    }
    for (var i=0; i<num; i++) {
        var member = memberList[i];
        var avatar = member.avatar;
        if (avatar.length == 0) avatar = avatar();
        content = '<div class="member" onclick="showProject()"> \
        <img src="' + avatar + '" alt="" class="avatar" onerror="this.src=\'/images/logo.png\'"> \
        <div class="nickname">' + member.nickname + '</div>  \
                </div>'
        html += content
    }
    var memberList = document.getElementById("memberList");
    memberList.innerHTML = html;
}

function detailHtml(content, tagList) {
    var html = '<div id="detailTitle" class="title">简单介绍</div>\
    <hr><div id="detailContent">'+ content +'</div><hr>';

    for (var i = 0; i < tagList.length; i++) {
        var tag = tagList[i];
        html += '<div class="detailTag">' + tag + '</div>';
    }

    html += '<span class="arrow"></span>'; 
    var detail = document.getElementById("detail");
    detail.innerHTML = html;
}

function planHtml(planList) {
    var content = '<div id="planTitle" class="title">计划</div> \
    <div id="planTime" class="title"></div><hr>';

    if (planList.length == 0) {
        content += '<div class="blankContent">暂无内容</div>'
    } else {
        for (var i = 0; i < planList.length; i++) {
            var plan = planList[i];
            content += '<div class="planContent"> \
                    <div class="planContentLeft">'+ (i+1) + '.' + plan.content +'</div> \
                        <div class="planContentRight">'+ plan.finishTime +' 截止</div> \
                </div>';
        }
    }
    var plan = document.getElementById("plan");
    plan.innerHTML = content;
}

function resultHtml(result, resultMedias) {
    // result = '';
    // resultList = []
    var  content = '<div class="title">预期结果:</div><hr>';

    if (result.length==0 && resultMedias.length==0) {
        content += '<div class="blankContent">暂无内容</div>';
    } else {
        if (result.length != 0) {
            content += '<div id="resultContent">' + result + '</div>';
        }
        for (var i = 0; i < resultMedias.length; i++) {
            var image = resultMedias[i];
            content += '<img src="'+ image + '" alt="" class="resultImage" onerror="this.src=\'/images/logo.png\'">';
            
        }
    }
    content += '</div>';
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

function journalHtmlTemplate(journalAvatar, userName, likeNum, time, text, imageArray) {
    var content = ' \
    <div class="journalContent"  onclick="onClick()"> \
    <div class="journalHeader" > \
            <img src="'+journalAvatar+'" alt="" class="avatar journalAvatar" onerror="this.src=\'/images/logo.png\'"> \
            <div> \
                    <span class="username">'+userName+'</span><span class="tip">更新了日志 </span>  \
                    <div class="likeNum">'+likeNum+'</div> \
                    <img src="/images/like.png" alt="" class="like"> \
            </div> \
            <div><span class="journalTime">'+time+'</span></div> \
    </div>';

    if (text.length > 0) {
        content += '<div class="journalText" >'+text+'</div>';
    }

    for (var i = 0; i < imageArray.length; i++) {
        var image = imageArray[i];
        if (image) {
            content += '<img src="'+image+'" alt="" class="journalImage" onerror="this.src=\'/images/logo.png\'">';
        }
    }
    
    content += '</div>';
    return content;
}

function journalHtml(data) {
    var content = '';
    if (!data) {
        content += '<div class="blankContent" style="width:100%; height:100px;">暂无内容</div>';
    } else {
        for (var i = 0; i < data.length; i++) {
            var obj = data[i]
            var avatar = obj.avatar;
            var nickname = obj.nickname;
            var time = obj.time;
            var text = obj.content;
            var like = obj.like;
            var medias = obj.medias;

            if (avatar.length == 0) avatar = avatar();

            content +=  journalHtmlTemplate(avatar, nickname, like, time, text, medias);    
        }
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
    document.title = obj.data.title;
    showProject()
    memberHtml(obj.data.memberList);
    detailHtml(obj.data.detail, obj.data.tagList);
    planHtml(obj.data.planList);
    resultHtml(obj.data.result, obj.data.resultMedias);
    arrangeResultImage();
}

function showJournalFromJsonObj(obj) {
    var data = obj.data;
    journalHtml(data);
    arrangeJournalImage();
}


/*-----------------------------请求-------------------------------------*/ 


function loadingProjectData(uuid) {

    var projectPath = "/service/project/project?project_uuid=" + uuid;
    var journalPath = "/service/project/journal?project_uuid=" + uuid;

    reqwest({
        url: projectPath, 
        type: 'json', 
        method: 'get'
    }).then(function (projectData) {
        // console.log(resp);     
        if (projectData.data) {
            loadingJournalData(projectData, journalPath);
        } else {
            alert("请求不存在！");
        }
    }).fail(function (err, msg) {
        // console.log(err);     
        alert("请求失败，请重新刷新！");
    });
}

function loadingJournalData(projectData, journalPath) {
    reqwest({
        url: journalPath, 
        type: 'json', 
        method: 'get'
    }).then(function (journalData) {
        // console.log(resp);
        var mask = document.getElementById('overlayMask');
        mask.parentNode.removeChild(mask); 
        showProjectFromJsonObj(projectData);
        showJournalFromJsonObj(journalData);
    }).fail(function (err, msg) {
        // console.log(err);     
        alert("请求失败，请重新刷新！");
    });
}


function loadingData() 
{ 
    var url = location.search.toString(); //获取url中"?"符后的字串含?
    var uuid = url.substring(1, url.length);
    // console.log('url: ' + uuid);
    loadingProjectData(uuid);
} 



loadingData();