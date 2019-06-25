<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*, java.text.SimpleDateFormat"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
    int alertBool = 0;
    String username = "";
    String password = "";
	String password2 = "";
	if (request.getMethod().equalsIgnoreCase("post")) {
        username = request.getParameter("username");
        password = request.getParameter("password1");
		password2 = request.getParameter("password2");
		if (username == null || username.equals("")) 
            alertBool = 1;
        else if (password == null || password.equals(""))
            alertBool = 2;
        else if (password2 == null || password2.equals(""))
            alertBool = 3;
        else if (!password.equals(password2))
        	alertBool = 5;
        else {
        	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
                    + "&characterEncoding=UTF-8"; 
            try {
            	Class.forName("com.mysql.jdbc.Driver");
            	 Connection con=DriverManager.getConnection(connectString, 
                        "user", "123");
				 Statement stmt=con.createStatement();
				 String sql = "insert into user(username, password) values('%s', '%s')";
				 int cnt = stmt.executeUpdate(String.format(sql, username, password));
				 if (cnt > 0) {
					 // 创建用户成功后，再给用户创建两个系统歌单
					 ResultSet rs = stmt.executeQuery(String.format("select * from user where username = '%s'", 
					 							username));
					 String user_id = "";
					 if (rs.next()) {
						 user_id = rs.getString("id");
					 }
					  
					 String insert_playlist = "insert into playlist(playlistname, build_user, build_date, picture_url) values('%s', '%s', '%s', '%s')";
					 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					 java.util.Date date = new java.util.Date();
					 String currentTime = df.format(date);
					 sql = String.format(insert_playlist, username + "_发布的音乐", user_id, currentTime, "assets/images/发布的音乐.jpg");
					 stmt.executeUpdate(sql);
					 sql = String.format(insert_playlist, username + "_喜欢的音乐", user_id, currentTime, "assets/images/喜欢的音乐.jpg");
					 stmt.executeUpdate(sql);
					 stmt.close(); con.close();
					 // 设置Cookie
					 session.setAttribute(username, "online");
					 String id = session.getId();
				     Cookie cookie = new Cookie("MUSICSESSIONID", id);
				     cookie.setMaxAge(3600);
				     cookie.setPath("/");
				     response.addCookie(cookie);
				     cookie = new Cookie("username", username);
				     cookie.setMaxAge(3600);
				     cookie.setPath("/");
				     response.addCookie(cookie);
				     response.sendRedirect("index.jsp");
				 }
				 else {
					 stmt.close(); con.close();
				 }
            }
            catch (Exception e) {
            	alertBool = 4;
            }
        }
	}
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" type="text/css" href="assets/css/font-awesome.css" />
    <link rel="stylesheet" href="assets/css/Register.css">
    <title>注册</title>
    <script type="text/javascript">
        var alertBool = <%= alertBool%>;
        if(alertBool == '1') {
            alert('用户名不能为空！');
        }
        else if(alertBool == '2') {
            alert('密码不能空！');
        }
        else if(alertBool == '3') {
            alert('重新输入密码不能为空！');
        }
        else if (alertBool == '4') {
        	alert('用户名已存在，请勿重复注册！');
        }
        else if (alertBool == '5') {
        	alert("两次输入的密码不一致");
        }
    </script>
</head>
<body>
    <div id="main">
        <div class="site_name"> 
            <h1>悠闲听音乐系统</h1>
            </div>
        <div id="container">

        <div id="img">
                <img src="assets/images/logo.jpg"/>
            </div>
        <form method="POST" action="Register.jsp">
            <div >
                <i class="fa fa-user" ></i>
                <input type="text" id="username" name = "username" placeholder="用户名">
            </div>
            <div >
                <i class="fa fa-key"></i>
                <input type="password" id="password1" name="password1" placeholder="密码">
            </div>
            <div >
                <i class="fa fa-key"></i>
                <input type="password" id="password2" name = "password2" placeholder="再次输入密码">
            </div>
            <div><input type="submit" id="button" value="注册" onclick="return submit()"></div>
        </form>
            <a href="SignIn.jsp"><div><input type="submit" id="button" value="去登录" ></div></a>
        </div>
    </div>
</body>
</html>