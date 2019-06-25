<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	//检查是否处于登录状态，是则加载本页面，否则就跳转回登录页面
	
	Cookie[] cookies = request.getCookies();
String adminname = Util.authenticateAdmin(session, cookies);
String msg = "";
Integer t_num =  0;
try {
	
if (adminname.equals("")) {
	// 验证失败，需要退回登录页面
	response.sendRedirect("admin.jsp");
}
else {
	
	request.setCharacterEncoding("utf-8");
	
	
	
	String temp = request.getParameter("t_num");
	if(temp!=null && !temp.isEmpty())
		 t_num =  Integer.parseInt(temp);
	
	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
			+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8"; 
	String user="user";
	String pwd="123";
	

	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection(connectString, user, pwd);
	Statement stmt=con.createStatement();
	
	if(request.getMethod().equalsIgnoreCase("post")){
			switch(t_num){
			case 1:
				String playlistname = request.getParameter("playlistname");
				String build_user = request.getParameter("build_user");
				String build_date = request.getParameter("build_date");
				String picture_url = request.getParameter("picture_url");
				
				String fmt1="insert into playlist(playlistname,build_user,build_date,picture_url) values('%s','%s','%s','%s')";
				String sql1 = String.format(fmt1,playlistname,build_user,build_date,picture_url);
				int cnt1 = stmt.executeUpdate(sql1);
				if(cnt1>0) msg = "保存成功!";
				break;
			case 2:
				String playlist_id = request.getParameter("playlist_id");
				String user_id = request.getParameter("user_id");
				String fmt2="insert into playlist_collectuser(playlist_id,user_id) values('%s','%s')";
				String sql2 = String.format(fmt2,playlist_id,user_id);
				int cnt2= stmt.executeUpdate(sql2);
				if(cnt2>0) msg = "保存成功!";
				break;
			case 3:
				String playlist_id2 = request.getParameter("playlist_id");
				String song_id = request.getParameter("song_id");
				String fmt3="insert into playlist_songs(playlist_id,song_id) values('%s','%s')";
				String sql3 = String.format(fmt3,playlist_id2,song_id);
				int cnt3= stmt.executeUpdate(sql3);
				if(cnt3>0) msg = "保存成功!";
				break;
			case 4:
				String songname = request.getParameter("songname");
				String song_time = request.getParameter("song_time");
				String singer = request.getParameter("singer");
				String song_url = request.getParameter("song_url");
				String picture_url2 = request.getParameter("picture_url2");
				String userid = request.getParameter("userid");
				String album_name = request.getParameter("album_name");
				String words = request.getParameter("words");
				String isvalid = request.getParameter("isvalid");
				
				String fmt4="insert into song(songname,song_time,singer,song_url,picture_url,userid,album_name,words,isvalid) values('%s','%s','%s','%s','%s','%s','%s','%s','%s')";
				String sql4 = String.format(fmt4,songname,song_time,singer,song_url,picture_url2,userid,album_name,words,isvalid);
				int cnt4= stmt.executeUpdate(sql4);
				if(cnt4>0) msg = "保存成功!";
				break;
			case 5:
				String num = request.getParameter("num");
				String name = request.getParameter("name");
				String fmt="insert into user(username,password) values('%s','%s')";
				String sql = String.format(fmt,num,name);
				int cnt = stmt.executeUpdate(sql);
				if(cnt>0) msg = "保存成功!";
				break;
			
			}
		
	}
	stmt.close();
	con.close();
}
}
catch (Exception e) {
	System.out.println(e.getMessage());
}
%>
 
 
<!DOCTYPE HTML>
<html>
	<head>
	<link rel="stylesheet" href="assets/css/font-awesome.css">
		<title>管理员端-增加</title>
		<style>
			body{
				font-family:微软雅黑,宋体;
			}
			.title{
				height:100px;
				text-align:center;
				font-size:2em;
				font-family:kaiti;
				background-color:skyblue;
			}
			.left_body{
				float:left;
				width:200px;
				height:100%;
				background-color:gray;
			}
			.right_body{
				float:left;
				width:500px;
				height:100%;
				margin-left:50px;
		        margin-top:0px;
			}
			.left_body div{
				height:50px;
			}	
			a:link,a:visited { color:blue; }
			.container{
				margin:0 auto;
				width:500px;
				text-align:center;
			}
			form { line-height:50px; }
			a{
				margin-top : 300px;
			}
			.t{
				display:none;
			}
			
		</style>
	</head>
	
<body>
	<div class="title">
		欢迎登录悠闲音乐系统-管理员端 ！
	</div>
	<div  class="left_body">
		
		<div  class="t1"> 
		<i class="fa fa-table" aria-hidden="true"></i>playlist
		</div>
		
		<div  class="t2"> 
		<i class="fa fa-table" aria-hidden="true"></i>playlist_collectuser
		</div>
		
		<div  class="t3">
		<i class="fa fa-table" aria-hidden="true"></i>playlist_songs
		</div>
		
		<div  class="t4">
			<i class="fa fa-table" aria-hidden="true"></i>song
		</div>

		<div  class="t5"> 
			<i class="fa fa-table" aria-hidden="true"></i>user
		</div>
	</div>
	<div class="right_body">
		<div class="container">
		<div  class="t">
			<h1>新增playlist记录</h1>
			<form action="admin_add.jsp" method="post" name="f">
				playlistname:<input id="playlistname" type="text" name="playlistname" ><br>
				build_user:<input id="build_user" type="text" name="build_user" ><br>
				build_date:<input id="build_date" type="text" name="build_date" ><br>
				picture_url:<input id="picture_url" type="text" name="picture_url" ><br>
				<input id="t_num" value=1  type="hidden" name="t_num" ><br>
				<input type="submit" name="sub" value="保存">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		
		<div  class="t">
			<h1>新增playlist_collectuser记录</h1>
			<form action="admin_add.jsp" method="post" name="f">
				playlist_id:<input id="playlist_id" type="text" name="playlist_id" ><br>
				user_id:<input id="user_id" type="text" name="user_id" ><br>
				<input id="t_num" value=2  type="hidden" name="t_num" ><br>
				<input type="submit" name="sub" value="保存">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		<div  class="t">
			<h1>新增playlist_songs记录</h1>
			<form action="admin_add.jsp" method="post" name="f">
				playlist_id:<input id="playlist_id" type="text" name="playlist_id" ><br>
				song_id:<input id="song_id" type="text" name="song_id" ><br>
				<input id="t_num" value=3  type="hidden" name="t_num" ><br>
				<input type="submit" name="sub" value="保存">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		<div  class="t">
			<h1>新增song记录</h1>
			<form action="admin_add.jsp" method="post" name="f">
				song_name:<input id="song_name" type="text" name="song_name" ><br>
				song_time:<input id="song_time" type="text" name="song_time" ><br>
				singer:<input id="singer" type="text" name="singer" ><br>
				song_url:<input id="song_url" type="text" name="song_url" ><br>
				picture_url:<input id="picture_url" type="text" name="picture_url" ><br>
				userid:<input id="userid" type="text" name="userid" ><br>
				album_name:<input id="album_name" type="text" name="album_name" ><br>
				words:<input id="words" type="text" name="words" ><br>
				isvalid:<input id="isvalid" type="text" name="isvalid" ><br>
				
				<input id="t_num" value=4  type="hidden" name="t_num" ><br>
				<input type="submit" name="sub" value="保存">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		<div  class="t">
			<h1>新增user记录</h1>
			<form action="admin_add.jsp" method="post" name="f">
				姓名:<input id="num" name="num" type="text" ><br>
				密码:<input id="name" type="text" name="name" >
					<input id="t_num" value=5  type="hidden" name="t_num" ><br>
				<input type="submit" name="sub" value="保存">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		
		
		</div>
	
		
	</div>
</body>

<script>
		window.onload = function () {
		   
		function show_table(i)
		{
		   return function(){
			   var table_list = document.getElementsByClassName("t");
			   for(var j=0;j<table_list.length;j++)
			   {
				   table_list[j].style.display = "none";
			   }
			   table_list[i].style.display = "inline";
		   }
		}
		
		var is = document.querySelectorAll('.left_body > div'); //添加到我的歌单时，右上角的x号
				for (var i = 0; i < is.length; i++) {
				   is[i].onclick = show_table(i);
			   }
			show_table(<%= t_num %> - 1)();
		}
		
		
	   
	   </script>
	   

</html>
	
