<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	// 检查是否处于登录状态，是则加载本页面，否则就跳转回登录页面
	
	String recommendData = "";
	JSONArray resArray = new JSONArray();
	int styleClass = 0;

	String test = Util.search_music("修");
	
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	
	if (username.equals("")) {
		// 验证失败，需要退回登录页面
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	else {
		// 获取推荐歌单（直接从歌单表中获取前3个）
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
				+ "?autoReconnect=true&useUnicode=true"
                + "&characterEncoding=UTF-8"; 
        try {
        	Class.forName("com.mysql.jdbc.Driver");
        	Connection con=DriverManager.getConnection(connectString, 
                    "user", "123");
			Statement stmt=con.createStatement();
        	String sql = "select * from playlist limit 0, 3";
			ResultSet rs=stmt.executeQuery(String.format(sql, username));   
			while (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("list_id", rs.getString("id"));
				obj.put("list_name", rs.getString("playlistname"));
				obj.put("list_picture", rs.getString("picture_url"));
				resArray.put(obj);
			}
			recommendData = resArray.toString();
			rs.close();
			stmt.close();
			con.close();
        }
        catch (Exception e) {
			System.out.println(e.getMessage());
        }
	}
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>悠闲听音乐</title>
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <link rel="stylesheet" href="assets/css/navigation.css"/>
    <link rel="stylesheet" href="assets/css/index_main.css">
    <link rel="stylesheet" href="assets/css/footer.css"/>
    <link rel="stylesheet" href="assets/css/searchBar.css">
    <script type="text/javascript">
        
        recommandMusic = <%= recommendData %>;
        test = <%=test%>;
        console.log(test);
    </script>
</head>

<body>
	
	<%@ include file="nav.jsp" %>
	
    <div id="main">

        <form action="Search.jsp" method="GET" class="icon-search">
            <div class="bar"></div>
            <input type="text" name="value" id="search-text" class="form-search" autocomplete="off" spellcheck="false">
            <!-- <input type="text" name="" hidden> -->
           
            <button type="button" class="rs-btn"><i class="fa fa-times" aria-hidden="true"></i></button>
        </form>

        <div>
            <h1>推荐歌单</h1>
            <div id="container">
                <div id="img-box">
                    <div class="slider-block middle" >
                    </div>
                    <div class="slider-block right" >
                    </div>
                    <div class="slider-block left" >
                    </div>
                </div>
                <div id="toLeft"></div>
                <div id="toRight"></div>
                <div id="pointsContainer">
                    <div id="point1" class="points active"></div>
                    <div id="point1" class="points"></div>
                    <div id="point1" class="points"></div>
                </div>
            </div>
        </div>
        
    </div>

    

    <div id="footer">
        <p>
            &copy; Copyright 2019-2020 小组XX制作<br>
            小组XX   版权所有
        </p>
    </div>
    <!--footer end-->    

    <script src="assets/js/index_main.js"></script>
</body>

</html>
