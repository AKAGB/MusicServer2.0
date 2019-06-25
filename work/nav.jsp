<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="assets/css/navigation.css"/>
<div id="header_outer" width="20%">
    <ul class="wrapper" id="nav">
        <li><img src="assets/images/bk1.jpg"  id="logo"> </li>
        <!-- <li class="nav_hover"><a href="">首页</a></li> -->
        <li class="nav_li"><a href="index.jsp">首页</a></li>
        <li class="nav_li"><a href="mymusic.jsp">我的音乐</a></li>
        <li class="nav_li"><a href="upload.jsp">音乐人</a></li>
    </ul>

    <div class="user-info">
        <img class="user-icon" src="assets/images/user_icon.jpg" alt="">
        <span class="user-name"><%= username %></span>
        <a href="LogOut.jsp?username=<%= username %>">
        <span class="out">
            <i class="fa fa-sign-out" aria-hidden="true"></i>
        </span>退出
    </a>
    </div>
    <script>
    	var lis = document.getElementsByClassName('nav_li');
    	var li_index = parseInt(<%= styleClass %>);
    	lis[li_index].classList.add('nav_hover');
    </script>
</div>