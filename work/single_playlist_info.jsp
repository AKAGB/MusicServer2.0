<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	String playlists_result = "";
	String songs_result = "";
	JSONArray resArray = new JSONArray();
	JSONArray resArray_ = new JSONArray();
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	
	else{
		// 获取用户歌单和其中歌的详细信息
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
	                + "&characterEncoding=UTF-8"; 
	
			Class.forName("com.mysql.jdbc.Driver");
	        Connection con=DriverManager.getConnection(connectString,"user", "123");
	        Statement stmt=con.createStatement();
			
			//  获得歌单的详细信息
			String id = "";
			id = request.getParameter("id");
	        String sql = "select * from playlist, user where playlist.id = '%s'"  +
		              " and playlist.build_user = user.id";
	        ResultSet rs=stmt.executeQuery(String.format(sql,id));
	        Statement stmt2=con.createStatement();
	        while (rs.next()) {
	            JSONObject obj = new JSONObject();
	            obj.put("playlist_id", rs.getString("id"));
	            obj.put("playList_name", rs.getString("playlistname"));
	            obj.put("playList_date", rs.getString("build_date").substring(0, 10));
				obj.put("picture_url", rs.getString("picture_url"));
				
				sql = "select * from playlist_songs,playlist where playlist.id = '%s'"
						+" and playlist_songs.playlist_id = playlist.id";
				ResultSet rs_=stmt2.executeQuery(String.format(sql,id));
				rs_.last();
				int song_num = rs_.getRow();
				String num = Integer.toString(song_num);
				obj.put("playlist_cnt", num);
				obj.put("playList_build_user", rs.getString("username"));
				// System.out.println("points");
	            resArray.put(obj);
	        }
	        playlists_result = resArray.toString();
	        
			
			//  获得歌单中歌的详细信息
			sql = "select * from playlist_songs,playlist,song" +
			      " where playlist.id = '%s' " +
	              " and playlist_songs.playlist_id = playlist.id" +
				  " and playlist_songs.song_id = song.id";
			
			rs=stmt.executeQuery(String.format(sql,id));
			Statement stmt3 = con.createStatement();
			while (rs.next()) {
	            JSONObject obj_ = new JSONObject();
				obj_.put("song_id", rs.getString("song_id"));
	            obj_.put("songList_songname", rs.getString("songname"));
				obj_.put("songList_songauthor", rs.getString("singer"));
				obj_.put("songList_album", rs.getString("album_name"));
				String temp =  rs.getString("song_time");
				System.out.println(temp);
				int time = Math.round(Float.valueOf(temp));
				temp = "" + (time / 60) + ":" + (time % 60);
				obj_.put("songList_songtime", temp);
				
	            resArray_.put(obj_);
	        }
	        songs_result = resArray_.toString();
					
		
	}
  
%>

<!DOCTYPE html>
<html lang="en">
<head>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>single_playlist_info</title>
    <link rel="stylesheet" type="text/css" href="assets/css/single_playlist_info.css" />
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <script type="text/javascript">
        songs_result = <%= songs_result %>;
        playlists_result = <%= playlists_result %>[0];
        // console.log(playlists_result);
    </script>
</head>
<body>

    <div id="shadow">  
    </div>  
    <div class="add_toMylist">
        <div class="words">
        <span>添加到我的歌单</span>
            <span class="close"> <i class="fa fa-times" aria-hidden="true"></i></span>
        </div>
    </div> 
    <div class="container">
        <div class="header">
            <!-- <div class="header_left">
                <img src="../images/guangnian.jpg">
            </div>
            <div class="header_right">
                <div class="row1">
                    <span class="playlist_box">
                        歌单
                    </span>
                    <span class="playlist_name">我喜欢的音乐</span>
                </div>
                <div class="row2">
                    <span class="creater_name">creater_name</span>
                    <span class="created_time">created_time创建</span>
                </div>
            </div> -->
        </div>

        <div class="songList">
            <table>
                <caption>歌曲列表</caption>
                <thead>
                    <tr>
                        <th></th>
                        <th>操作</th>
                        <th class="songList_header_name">歌曲</th>
                        <th class="songList_header_author">歌手</th>
                        <th class="songList_header_time">时长</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody class="songList_body">
                    <!-- <tr>
                        <th>1</th>
                        <th>播放</th>
                        <th>光年之外</th>
                        <th>邓紫棋</th>
                        <th>04:02</th>
                        <th>收藏</th>
                        <th>移除</th>
                    </tr>
                    <tr>
                        <th>2</th>
                        <th>播放</th>
                        <th>光年之外</th>
                        <th>邓紫棋</th>
                        <th>04:02</th>
                        <th>收藏</th>
                        <th>移除</th>
                    </tr> -->
                </tbody>
            </table>
        </div>
    </div>
</body>
<script type="text/javascript" src="assets/js/single_playlist_info.js"></script>
</html>