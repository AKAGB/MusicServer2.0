<%@ page language="java" import="java.util.*,java.sql.*"
		 contentType="text/html; charset=utf-8"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<% 
String msg = "";
Cookie[] cookies = request.getCookies();
String adminname = Util.authenticateAdmin(session, cookies);

if (adminname.equals("")) {
// 验证失败，需要退回登录页面
response.sendRedirect("admin.jsp");
}
else {
// 以上为检测代码


	request.setCharacterEncoding("utf-8");
	
	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
							+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String user="user"; 
	String pwd="123";
	
	Integer t_num =  0;
	String temp = request.getParameter("t_num");
	if(temp!=null && !temp.isEmpty())
		 t_num =  Integer.parseInt(temp);
	
	
	String param = request.getParameter("pid");
	String pid = "";
	if(param != null && !param.isEmpty()){
		pid += param;
	}
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		Statement stmt = con.createStatement();
		String fmt="";
		switch(t_num){
		case 1:
			fmt="delete from playlist where id=%s";
			break;
		case 2:
			fmt="delete from play_collectuser where id=%s";
			break;
		case 3:
			fmt="delete from playlist_songs where id=%s";
			break;
		case 4:
			fmt="delete from song where id=%s";
			break;
		case 5:
			fmt="delete from user where id=%s";
			break;
		}
		String sql = String.format(fmt,pid);
		int cnt = stmt.executeUpdate(sql);
		if(cnt>0) msg = "删除成功!";
		stmt.close();
		con.close();
 	    }
	catch (Exception e){
		msg = e.getMessage();
	}
}
%>

<!DOCTYPE HTML><html><head><title>新增学生记录</title>
	<style> a:link,a:visited {color:blue;} 
		.container{  
			margin:0 auto;   
			width:500px;  
			text-align:center;  
		} 
	</style>
	</head>
	<body>
		<div class="container">
			<h1>删除记录</h1>
			<p><%=msg%></p><br>
			<a href='admin_op.jsp'>返回</a>
		</div>
	</body>
</html>

