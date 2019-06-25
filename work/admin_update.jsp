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
	String param = request.getParameter("pid");
	String pid = "";
	
	// table content
	String playlistname = "";
	String build_user = "";
	String build_date = "";
	String picture_url = "";
	
	String playlist_id = "";
	String user_id = "";
	
	String playlist_id2 = "";
	String song_id = "";
	
	String songname = "";
	String song_time = "";
	String singer = "";
	String song_url = "";
	String picture_url2 = "";
	String userid = "";
	String album_name = "";
	String words = "";
	String isvalid = "";
	
	String username1 = "";
	String password = "";
	
	
	
	if(param != null && !param.isEmpty()){
		pid += param;
	}
	Integer t_num =  0;
	String temp = request.getParameter("t_num");
	if(temp!=null && !temp.isEmpty())
		 t_num =  Integer.parseInt(temp);
	if (adminname.equals("")) {
		// 验证失败，需要退回登录页面
		response.sendRedirect("admin.jsp");
	}
	else {
// 以上为检测代码
	
	String updateButton = request.getParameter("update"); 
	String clearButton = request.getParameter("clear"); 

	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
			+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8"; 
	String user="user";
	String pwd="123";
	
	try {

	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection(connectString, user, pwd);
	Statement stmt=con.createStatement();
	
	if(request.getMethod().equalsIgnoreCase("post")){
		String sql="";
			switch(t_num){
			case 1:
				playlistname = request.getParameter("playlistname");
				build_user = request.getParameter("build_user");
				build_date = request.getParameter("build_date");
				picture_url = request.getParameter("picture_url");
				
				if(updateButton != null){
					String fmt1="update playlist set playlistname='%s',build_user='%s',build_date='%s',picture_url='%s' where id='%s'";
					sql = String.format(fmt1,playlistname,build_user,build_date,picture_url,pid);
					int cnt1 = stmt.executeUpdate(sql);
					if(cnt1>0) msg = "修改成功!";
				}
				else{
			 		String fmt11="select * from playlist where id='%s'";
			 		String sql11 = String.format(fmt11,pid);
			 		ResultSet rs = stmt.executeQuery(sql11);
			 		if(rs.next()){
			 			playlistname = rs.getString("playlistname");
						build_user = rs.getString("build_user");
						build_date = rs.getString("build_date");
						picture_url = rs.getString("picture_url");
			 	    }
				}
				break;
			case 2:
				playlist_id = request.getParameter("playlist_id");
				user_id = request.getParameter("user_id");
				
				if(updateButton != null){
					String fmt2="update playlist_collectuser set playlist_id='%s',user_id='%s'  where id='%s'";
					String sql2 = String.format(fmt2,playlist_id,user_id,pid);
					int cnt2= stmt.executeUpdate(sql2);
					if(cnt2>0) msg = "修改成功!";
				}
				else{
			 		String fmt22="select * from playlist_collectuser where id='%s'";
			 		String sql22 = String.format(fmt22,pid);
			 		ResultSet rs = stmt.executeQuery(sql22);
			 		if(rs.next()){
			 			 playlist_id = rs.getString("playlist_id");
						 user_id = rs.getString("user_id");
			 	    }
				}
				break;
			case 3:
				playlist_id2 = request.getParameter("playlist_id");
				song_id = request.getParameter("song_id");
				
				if(updateButton != null){
					String fmt3="update  playlist_songs set  playlist_id='%s',song_id='%s' where id='%s'";
					String sql3 = String.format(fmt3,playlist_id2,song_id,pid);
					int cnt3= stmt.executeUpdate(sql3);
					if(cnt3>0) msg = "修改成功!";
				}
				else{
			 		String fmt22="select * from playlist_songs where id='%s'";
			 		String sql22 = String.format(fmt22,pid);
			 		ResultSet rs = stmt.executeQuery(sql22);
			 		if(rs.next()){
			 			 playlist_id2 = rs.getString("playlist_id");
						 song_id = rs.getString("song_id");
			 	    }
				}
				break;
			case 4:
				songname = request.getParameter("songname");
				song_time = request.getParameter("song_time");
				singer = request.getParameter("singer");
				song_url = request.getParameter("song_url");
				picture_url2 = request.getParameter("picture_url2");
				userid = request.getParameter("userid");
				album_name = request.getParameter("album_name");
				words = request.getParameter("words");
				isvalid = request.getParameter("isvalid");
				
				
				if(updateButton != null){
					String fmt4="update song set songname='%s',song_time='%s',singer='%s',song_url='%s',picture_url='%s',userid='%s',album_name='%s',words='%s',isvalid='%s' where id='%s'";
					String sql4 = String.format(fmt4,songname,song_time,singer,song_url,picture_url2,userid,album_name,words,isvalid,pid);
					int cnt4= stmt.executeUpdate(sql4);
					if(cnt4>0) msg = "保存成功!";
				}
				else{
			 		String fmt22="select * from song where id='%s'";
			 		String sql22 = String.format(fmt22,pid);
			 		ResultSet rs = stmt.executeQuery(sql22);
			 		if(rs.next()){
			 			 songname = rs.getString("songname");
						 song_time = rs.getString("song_time");
						 singer = rs.getString("singer");
						 song_url =rs.getString("song_url");
						 picture_url2 = rs.getString("picture_url2");
						 userid = rs.getString("userid");
						 album_name =rs.getString("album_name");
						 words = rs.getString("words");
						 isvalid = rs.getString("isvalid");
			 	    }
				}
				break;
			case 5:
				username1 = request.getParameter("username");
				password = request.getParameter("password");
			
				if(updateButton != null){
					String fmt3="update user set  username='%s', password='%s' where id='%s'";
					String sql3 = String.format(fmt3,username1,password, pid);
					System.out.println(sql3);
					int cnt3= stmt.executeUpdate(sql3);
					if(cnt3>0) msg = "修改成功!";
				}
				else{
			 		String fmt22="select * from user where id='%s'";
			 		String sql22 = String.format(fmt22,pid);
			 		ResultSet rs = stmt.executeQuery(sql22);
			 		if(rs.next()){
			 			 username1 = rs.getString("username");
				 	       password = rs.getString("password");
			 	    }
				}
				break;
			
			}
		
	}
	else {
		String select_sql = "";
		ResultSet rs = null;
		switch (t_num) {
		case 1:
			select_sql = "select * from playlist where id = '%s'";
			rs = stmt.executeQuery(String.format(select_sql, pid));
			if (rs.next()) {
				playlistname = rs.getString("playlistname");
				build_user = rs.getString("build_user");
				build_date = rs.getString("build_date");
				picture_url = rs.getString("picture_url");
			}
			break;
			
		case 2:
			select_sql = "select * from playlist_collectuser where id = '%s'";
			rs = stmt.executeQuery(String.format(select_sql, pid));
			if (rs.next()) {
				playlist_id = rs.getString("playlist_id");
				user_id = rs.getString("user_id");
			}
			break;
			
		case 3:
			select_sql = "select * from playlist_songs where id = '%s'";
			rs = stmt.executeQuery(String.format(select_sql, pid));
			if (rs.next()) {
				playlist_id2 = rs.getString("playlist_id");
				user_id = rs.getString("song_id");
			}
			break;
			
		case 4:
			select_sql = "select * from song where id = '%s'";
			rs = stmt.executeQuery(String.format(select_sql, pid));
			if (rs.next()) {
				songname = rs.getString("songname");
				song_time = rs.getString("song_time");
				singer = rs.getString("singer");
				song_url = rs.getString("song_url");
				picture_url2 = rs.getString("picture_url");
				userid = rs.getString("userid");
				album_name = rs.getString("album_name");
				words = rs.getString("words");
				isvalid = rs.getString("isvalid");
			}
			break;
		case 5:
			select_sql = "select * from user where id = '%s'";
			rs = stmt.executeQuery(String.format(select_sql, pid));
			if (rs.next()) {
				username1 = rs.getString("username");
				password = rs.getString("password");
			}
			break;
		}
		}
	stmt.close();
	con.close();
	}
	catch (Exception e) {
		System.out.println(e.getMessage());
	}
	}
%>
 
 
<!DOCTYPE HTML>
<html>
	<head>
	<link rel="stylesheet" href="assets/css/font-awesome.css">
		<title>管理员端-修改</title>
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
			<h1>修改playlist记录</h1>
			<form action="admin_update.jsp?pid=<%=pid%>" method="post" name="f">
				playlistname:<input id="playlistname" type="text" name="playlistname" value="<%= playlistname %>"><br>
				build_user:<input id="build_user" value="<%= build_user %>" type="text" name="build_user" ><br>
				build_date:<input id="build_date" value="<%= build_date %>" type="text" name="build_date" ><br>
				picture_url:<input id="picture_url" value="<%= picture_url %>" type="text" name="picture_url" ><br>
				<input id="t_num" value=<%=t_num %>   type="hidden" name="t_num" ><br>
				<input type="submit" name="update" value="修改">
				<input type="submit" name="clear" value="清空">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		
		<div  class="t">
			<h1>修改playlist_collectuser记录</h1>
			<form action="admin_update.jsp?pid=<%=pid%>" method="post" name="f">
				playlist_id:<input id="playlist_id" value="<%= playlist_id %>" type="text" name="playlist_id" ><br>
				user_id:<input id="user_id" value="<%= user_id %>" type="text" name="user_id" ><br>
				<input id="t_num" value=<%=t_num %>  type="hidden" name="t_num" ><br>
				<input type="submit" name="update" value="修改">
				<input type="submit" name="clear" value="清空">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		<div  class="t">
			<h1>修改playlist_songs记录</h1>
			<form action="admin_update.jsp?pid=<%=pid%>" method="post" name="f">
				playlist_id:<input id="playlist_id" value="<%= playlist_id2 %>" type="text" name="playlist_id" ><br>
				song_id:<input id="song_id" value="<%= user_id %>" type="text" name="song_id" ><br>
				<input id="t_num" value=<%=t_num %>   type="hidden" name="t_num" ><br>
				<input type="submit" name="update" value="修改">
				<input type="submit" name="clear" value="清空">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		<div  class="t">
			<h1>修改song记录</h1>
			<form action="admin_update.jsp?pid=<%=pid%>" method="post" name="f">
				song_name:<input id="song_name" value="<%= songname %>" type="text" name="song_name" ><br>
				song_time:<input id="song_time" value="<%= song_time %>" type="text" name="song_time" ><br>
				singer:<input id="singer" type="text" value="<%= singer %>" name="singer" ><br>
				song_url:<input id="song_url" type="text" value="<%= song_url %>" name="song_url" ><br>
				picture_url:<input id="picture_url" value="<%= picture_url2 %>" type="text" name="picture_url" ><br>
				userid:<input id="userid" value="<%= userid %>" type="text" name="userid" ><br>
				album_name:<input id="album_name" value="<%= album_name %>" type="text" name="album_name" ><br>
				words:<input id="words" value="<%= words %>" type="text" name="words" ><br>
				isvalid:<input id="isvalid" value="<%= isvalid %>" type="text" name="isvalid" ><br>
				
				<input id="t_num" value=<%=t_num %>   type="hidden" name="t_num" ><br>
				<input type="submit" name="update" value="修改">
				<input type="submit" name="clear" value="清空">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		<div  class="t">
			<h1>修改user记录</h1>
			<form action="admin_update.jsp?pid=<%=pid%>" method="post" name="f">
				姓名:<input id="username" value="<%= username1 %>" name="username" type="text" ><br>
				密码:<input id="password" value="<%= password %>" type="text" name="password" >
					<input id="t_num" value=<%=t_num %>  type="hidden" name="t_num" ><br>
				<input type="submit" name="update" value="修改">
				<input type="submit" name="clear" value="清空">
			</form>
			<%=msg%><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
		
		
		</div>
	
		
	</div>
</body>

<script>
		window.onload = function () {
			 var num = document.getElementById("t_num").value;
			 var table_list = document.getElementsByClassName("t");
			 table_list[num-1].style.display = "inline";
		function show_table(i)
		{
		   return function(){
			   var num = document.getElementById("t_num").value;
			   if(i!=num-1)
				   alert("not to update this table! please choose another.")
				else{
					 var table_list = document.getElementsByClassName("t");
					   for(var j=0;j<table_list.length;j++)
					   {
						   table_list[j].style.display = "none";
					   }
					   table_list[i].style.display = "inline";
					
				}
			  
		   }
		}
		
		var is = document.querySelectorAll('.left_body > div'); //添加到我的歌单时，右上角的x号
				for (var i = 0; i < is.length; i++) {
				   is[i].onclick = show_table(i);
			   }
		
		}
	   
	   </script>
	   

</html>
	
