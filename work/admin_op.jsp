<%@ page language="java" import="java.util.*,java.sql.*"
		 contentType="text/html; charset=utf-8"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<% 

//检查是否处于登录状态，是则加载本页面，否则就跳转回登录页面
Cookie[] cookies = request.getCookies();
String adminname = Util.authenticateAdmin(session, cookies);
String msg ="";
StringBuilder table = new StringBuilder();
StringBuilder table2 = new StringBuilder();
StringBuilder table3 = new StringBuilder();
StringBuilder table4 = new StringBuilder();
StringBuilder table5 = new StringBuilder();
if (adminname.equals("")) {
	// 验证失败，需要退回登录页面
	response.sendRedirect("admin.jsp");
}
else {
	

	Integer t_num =  0;
	String temp = request.getParameter("t_num");
	if(temp!=null && !temp.isEmpty())
		 t_num =  Integer.parseInt(temp);

	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8"; 
	String user="user";
	String pwd="123";
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, user, pwd);
		Statement stmt=con.createStatement();
		
		switch(t_num){
		case 1:
		{
		Integer pgno = 0; //当前页号
		Integer pgcnt = 4; //每页行数
		if(t_num==1)
		{
			String param = request.getParameter("pgno");
			if(param != null && !param.isEmpty()){
				pgno = Integer.parseInt(param);
			}
			param = request.getParameter("pgcnt");
			if(param != null && !param.isEmpty()){
				pgcnt = Integer.parseInt(param);
			}
		}
		
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;

		String sql=String.format("select * from playlist limit %d,%d", pgno*pgcnt,pgcnt);
		ResultSet rs=stmt.executeQuery(sql);
		table.append("<div  class='t' ><h1>浏览playlist表</h1><table><tr><th>id</th><th>playlistname</th><th>build_user</th><th>build_date</th><th>picture_url</th>"+
		"<th>-</th></tr>");
		int pgcount = 0;
		while(rs.next()) {
			pgcount++;
			table.append(String.format(
			"<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
			rs.getString("id"),rs.getString("playlistname"),rs.getString("build_user"),rs.getString("build_date"),rs.getString("picture_url"),
			"<a href='admin_update.jsp?pid="+rs.getString("id")+"&t_num=1'>修改</a>",
			"<a href='admin_delete.jsp?pid="+rs.getString("id")+"&t_num=1'>删除</a>"	));
		}
		if(pgcount < 4) {
			pgprev = (pgno>0)?pgno-1:0;
			pgnext = pgno;
		}
		table.append("</table> ");
		table.append("<div style='float:left'><a href='admin_add.jsp?t_num=1'>新增</a></div>");
		table.append("<div style='float:right'>");
		String url1 = "'admin_op.jsp?pgno="  + pgprev +  "&pgcnt=" + pgcnt + "&t_num=1'";
		String url2 = "'admin_op.jsp?pgno="  + pgnext +"&pgcnt="  +  pgcnt  +"&t_num=1''";
		table.append(String.format("<a href=%s>上一页</a>",url1));
		table.append(String.format("<a href=%s>下一页</a>",url2));
		table.append("</div></div> ");
		rs.close(); 
		}
		break;

		// 表二
		case 2:
		{
		Integer pgno = 0; //当前页号
		Integer pgcnt = 4; //每页行数
		if(t_num==2)
		{
			String param = request.getParameter("pgno");
			if(param != null && !param.isEmpty()){
				pgno = Integer.parseInt(param);
			}
			param = request.getParameter("pgcnt");
			if(param != null && !param.isEmpty()){
				pgcnt = Integer.parseInt(param);
			}
		}
			
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;
	
		String sql=String.format("select * from playlist_collectuser limit %d,%d", pgno*pgcnt,pgcnt);
		ResultSet rs=stmt.executeQuery(sql);
		table2.append("<div  class='t' ><h1>浏览playlist_collectuser表</h1>"+
		"<table><tr><th>id</th><th>playlist_id</th><th>user_id</th>"+
		"<th>-</th></tr>");
		int pgcount = 0;
		while(rs.next()) {
			pgcount++;
			table2.append(String.format(
			"<tr><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
			rs.getString("id"),rs.getString("playlist_id"),rs.getString("user_id"),
			"<a href='admin_update.jsp?pid="+rs.getString("id")+"&t_num=2'>修改</a>",
			"<a href='admin_delete.jsp?pid="+rs.getString("id")+"&t_num=2'>删除</a>"	));
		}
		if(pgcount < 4) {
			pgprev = (pgno>0)?pgno-1:0;
			pgnext = pgno;
		}
		table2.append("</table> ");
		table2.append("<div style='float:left'><a href='admin_add.jsp?t_num=2'>新增</a></div>");
		table2.append("<div style='float:right'>");
		String url1 = "'admin_op.jsp?pgno="  + pgprev +  "&pgcnt=" + pgcnt + "&t_num=2'";
		String url2 = "'admin_op.jsp?pgno="  + pgnext +"&pgcnt="  +  pgcnt  +"&t_num=2''";
		table2.append(String.format("<a href=%s>上一页</a>",url1));
		table2.append(String.format("<a href=%s>下一页</a>",url2));
		table2.append("</div></div> ");
		rs.close(); 
		}
	break;

			
		// 表三
		case 3:
		{
		Integer pgno = 0; //当前页号
		Integer pgcnt = 4; //每页行数
		if(t_num==3)
		{
			String param = request.getParameter("pgno");
			if(param != null && !param.isEmpty()){
				pgno = Integer.parseInt(param);
			}
			param = request.getParameter("pgcnt");
			if(param != null && !param.isEmpty()){
				pgcnt = Integer.parseInt(param);
			}
		}
		
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;

		String sql=String.format("select * from playlist_songs limit %d,%d", pgno*pgcnt,pgcnt);
		ResultSet rs=stmt.executeQuery(sql);
		table3.append("<div  class='t' ><h1>浏览playlist_songs表</h1><table><tr><th>id</th><th>playlist_id</th><th>song_id</th>"+
		"<th>-</th></tr>");
		int pgcount = 0;
		while(rs.next()) {
			pgcount++;
			table3.append(String.format(
			"<tr><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
			rs.getString("id"),rs.getString("playlist_id"),rs.getString("song_id"),
			"<a href='admin_update.jsp?pid="+rs.getString("id")+"&t_num=3'>修改</a>",
			"<a href='admin_delete.jsp?pid="+rs.getString("id")+"&t_num=3'>删除</a>"	));
		}
		if(pgcount < 4) {
			pgprev = (pgno>0)?pgno-1:0;
			pgnext = pgno;
		}
		table3.append("</table> ");
		table3.append("<div style='float:left'><a href='admin_add.jsp?t_num=3'>新增</a></div>");
		table3.append("<div style='float:right'>");
		String url1 = "'admin_op.jsp?pgno="  + pgprev +  "&pgcnt=" + pgcnt + "&t_num=3'";
		String url2 = "'admin_op.jsp?pgno="  + pgnext +"&pgcnt="  +  pgcnt  +"&t_num=3''";
		table3.append(String.format("<a href=%s>上一页</a>",url1));
		table3.append(String.format("<a href=%s>下一页</a>",url2));
		table3.append("</div></div> ");
		rs.close(); 
		}
	break;

		// 表四
		case 4:
		{
		Integer pgno = 0; //当前页号
		Integer pgcnt = 4; //每页行数
		if(t_num==4)
		{
			String param = request.getParameter("pgno");
			if(param != null && !param.isEmpty()){
				pgno = Integer.parseInt(param);
			}
			param = request.getParameter("pgcnt");
			if(param != null && !param.isEmpty()){
				pgcnt = Integer.parseInt(param);
			}
		}
		
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;

		String sql=String.format("select * from song limit %d,%d", pgno*pgcnt,pgcnt);
		ResultSet rs=stmt.executeQuery(sql);
		table4.append("<div  class='t' ><h1>浏览song表</h1>"+
		"<table style='width: 1800px'><tr><th>id</th><th>songname</th><th>song_time</th><th>singer</th><th>song_url</th>"+
			"<th>picture_url</th><th>userid</th><th>album_name</th><th>words</th><th>isvalid</th>"+
		"<th>-</th></tr>");
		int pgcount = 0;
		while(rs.next()) {
			pgcount++;
			table4.append(String.format(
			"<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
			rs.getString("id"),rs.getString("songname"),rs.getString("song_time"),rs.getString("singer"),rs.getString("song_url"),
			rs.getString("picture_url"),rs.getString("userid"),rs.getString("album_name"),rs.getString("words"),rs.getString("isvalid"),
			"<a href='admin_update.jsp?pid="+rs.getString("id")+"&t_num=4'>修改</a>",
			"<a href='admin_delete.jsp?pid="+rs.getString("id")+"&t_num=4'>删除</a>"	));
		}
		if(pgcount < 4) {
			pgprev = (pgno>0)?pgno-1:0;
			pgnext = pgno;
		}
		table4.append("</table> ");
		table4.append("<div style='float:left'><a href='admin_add.jsp?t_num=4'>新增</a></div>");
		table4.append("<div style='float:right'>");
		String url1 = "'admin_op.jsp?pgno="  + pgprev +  "&pgcnt=" + pgcnt + "&t_num=4'";
		String url2 = "'admin_op.jsp?pgno="  + pgnext +"&pgcnt="  +  pgcnt  +"&t_num=4''";
		table4.append(String.format("<a href=%s>上一页</a>",url1));
		table4.append(String.format("<a href=%s>下一页</a>",url2));
		table4.append("</div></div> ");
		rs.close(); 
		}
	break;
		// 表五
		case 5:
		{
		Integer pgno = 0; //当前页号
		Integer pgcnt = 4; //每页行数
		if(t_num==5)
		{
			String param = request.getParameter("pgno");
			if(param != null && !param.isEmpty()){
				pgno = Integer.parseInt(param);
			}
			param = request.getParameter("pgcnt");
			if(param != null && !param.isEmpty()){
				pgcnt = Integer.parseInt(param);
			}
		}
		
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;

		String sql=String.format("select * from user limit %d,%d", pgno*pgcnt,pgcnt);
		ResultSet rs=stmt.executeQuery(sql);
		table5.append("<div  class='t' ><h1>浏览user表</h1><table><tr><th>id</th><th>username</th><th>password</th>"+
		"<th>-</th></tr>");
		int pgcount = 0;
		while(rs.next()) {
			pgcount++;
			table5.append(String.format(
			"<tr><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
			rs.getString("id"),rs.getString("username"),rs.getString("password"),
			"<a href='admin_update.jsp?pid="+rs.getString("id")+"&t_num=5'>修改</a>",
			"<a href='admin_delete.jsp?pid="+rs.getString("id")+"&t_num=5'>删除</a>"	));
		}
		if(pgcount < 4) {
			pgprev = (pgno>0)?pgno-1:0;
			pgnext = pgno;
		}
		table5.append("</table> ");
		table5.append("<div style='float:left'><a href='admin_add.jsp?t_num=5'>新增</a></div>");
		table5.append("<div style='float:right'>");
		String url1 = "'admin_op.jsp?pgno="  + pgprev +  "&pgcnt=" + pgcnt + "&t_num=5'";
		String url2 = "'admin_op.jsp?pgno="  + pgnext +"&pgcnt="  +  pgcnt  +"&t_num=5''";
		table5.append(String.format("<a href=%s>上一页</a>",url1));
		table5.append(String.format("<a href=%s>下一页</a>",url2));
		table5.append("</div></div> ");
		rs.close(); 
		}
		break;
		}
		
		stmt.close(); con.close();
	}
	catch (Exception e) {
		System.out.println(e.getMessage());
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="assets/css/font-awesome.css">
<title>悠闲听-管理员端</title>
<style type="text/css">
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
		position: absolute;
		left: 200px;
		width:1200px;
		height:100%;
		margin-left:50px;
        margin-top:0px;
	}
	.left_body div{
		height:50px;
	}	

	table{
		border-collapse: collapse;
		width: 100%;
	}
	td,th{
		border: solid grey 1px;
		width : 150px;
		height : 50px;
		overflow: hidden;
		display: inline-block;
	}
	a:link,a:visited{
		color:blue
	}
	.container{
		margin:0 auto;
		width:100%;
		text-align:center;
	}
	div {
		margin-top : 20px;
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
			
			<%=table%>
			<%=table2%>
			<%=table3%>
			<%=table4%>
			<%=table5%>
			
			
			<br><br>
			<%=msg%><br><br>
		</div>
	
		
	</div>
</body>

<script>
		window.onload = function () {
		   
		function show_table(i)
		{
		   return function(){
			   i=i+1;
			   var url="admin_op.jsp?t_num="+i.toString();
			   var table_list = document.getElementsByClassName("t");
			   
			  
			   window.location.href=url;
			   
			   
		   }
		}
		
		var is = document.querySelectorAll('.left_body > div'); //添加到我的歌单时，右上角的x号
				for (var i = 0; i < is.length; i++) {
				   is[i].onclick = show_table(i);
			   }
		
		}
	   
	   </script>
	   

</html>