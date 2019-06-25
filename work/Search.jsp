<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	int styleClass = 0;
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	String songs_result = "";
	String playlists_result = "";
	String value = request.getParameter("value");
	if (username.equals("")) {
		// 验证失败，需要退回登录页面
		response.sendRedirect("SignIn.jsp");
	}
	else {
		if (value != null) {
			songs_result = Util.search_music(value);
			playlists_result = Util.search_playlist(username, value);
		}
		else {
			songs_result = Util.search_music("");
			playlists_result = Util.search_playlist(username, "");
		}
	}
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta content="text/html;charset=utf-8">
    <title>歌曲列表</title>
    <link rel="stylesheet" href="assets/css/Search.css" type="text/css" />
    <link rel="stylesheet" href="assets/css/font-awesome.css">
   
    <script type="text/javascript">
        songList_elemt = <%= songs_result%>;
        songListS_elemt = <%= playlists_result %>;
        value = '<%= value%>';
        // var data = '{{ songs_result }}';
    </script>

</head>
<body>
	<%@ include file="nav.jsp" %>

      <div id="shadow">  
      </div>  
      <div class="add_toMylist">
          <div class="words">
              <span>添加到我的歌单</span>
              <span class="close"> <i class="fa fa-times" aria-hidden="true"></i></span>
          </div>
      </div> 
      <div class="songlist">
              <div class="search">
                      <input class="search_text" id="search_word" cols="65" rows="1">
                      <i class="fa fa-search"  id="search_icon" aria-hidden="true"></i>
                      <a id="search_a" href="" hidden></a>
                  </div>
                  <div class="choose_mode"> 
                      <span class="single_song"  > 单曲</span>
                      <span class="songs"   > 歌单 </span>
                  </div>
                  
              <table class="songT" id="t1">
                      <caption>歌曲列表</caption>
                          <thead class="songList_header">
                              <tr>
                                  <th ></th>
                                  <th ></th>
                                  <th class="songList_header_name">歌曲 </th>
                                  <th class="songList_header_author">歌手 </th>
                                  <th class="songList_header_album">专辑 </th>
                                  <th class="songList_header_time">时长</th> 
                                  <th ></th>
                              </tr> 
                          </thead>
                          <tbody class="songList_main">
                          </tbody>
                  </table>

                  <table class="songs_listT" id="t2">
                      <caption>歌单列表</caption>
                          <tr>
                              <th ></th>
                              <th class="songList_header_name">名称 </th>
                              <th class="songList_header_author">歌曲数 </th>
                              <th class="songList_header_album">创建者 </th>
                              <th ></th>
                          </tr> 
                    
                  </table>
      </div>

   
</body>
<script type="text/javascript" src="assets/js/Search.js"></script>
</html>