<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
    int alertBool = 0;
    String username = "";
    String password = "";
    if (request.getMethod().equalsIgnoreCase("post")) {
        username = request.getParameter("username");
        password = request.getParameter("password");
        if (username == null || username.equals("")) 
            alertBool = 1;
        else if (password == null || password.equals(""))
            alertBool = 2;
        else {
        	// 查询数据库，获取当前user验证
            String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
                    + "&characterEncoding=UTF-8";
            try {
            	Class.forName("com.mysql.jdbc.Driver");
            	Connection con=DriverManager.getConnection(connectString, 
                        "user", "123");
				 Statement stmt=con.createStatement();
				 String sql = "select * from user where username = '%s'";
				 ResultSet rs=stmt.executeQuery(String.format(sql, username));
				 if (rs.next() && rs.getString("password").equals(password)) {
				     // session.setAttribute(username, username + "ONLINE");
				     // request.getRequestDispatcher("index.jsp").forward(request, response);
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
				     alertBool = 3;
				 }
				 rs.close(); stmt.close(); con.close();
            }
            catch (Exception e) {
            	out.println(e.getMessage());
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
    <title>登录</title>
    <link rel="stylesheet" type="text/css" href="assets/css/font-awesome.css" />
    <link rel="stylesheet" href="assets/css/SignIn.css"/>
    <script type="text/javascript">
        var alertBool = <%= alertBool%>;
        console.log(alertBool);
        if(alertBool == '1') {
            alert('用户名不能为空！');
        }
        else if(alertBool == '2') {
            alert('密码不能空！');
        }
        else if(alertBool == '3') {
            alert('用户不存在或密码不正确！');
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
            <form method="POST" action="SignIn.jsp">
            <div >
                <i class="fa fa-user" ></i>
                <input type="text" id="username" name = "username" placeholder="用户名">
            </div>
            <div >
                <i class="fa fa-key"></i>
                <input type="password" id="password" name = "password" placeholder="密码">
            </div>
            <div><input type="submit" id="button" value="登录" onclick=""></div>
            
            </form>
            <a href="Register.jsp">
            <div><input type="submit" id="button" value="去注册" onclick=""></div></a>
        </div>
    </div>
</body>
</html>