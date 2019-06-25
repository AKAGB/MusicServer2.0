<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%
	String songid = request.getParameter("id");
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	JSONObject result = new JSONObject();
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	else {
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
				+ "?autoReconnect=true&useUnicode=true"
                + "&characterEncoding=UTF-8"; 
        try {
        	Class.forName("com.mysql.jdbc.Driver");
        	Connection con=DriverManager.getConnection(connectString, 
                    "user", "123");
			Statement stmt=con.createStatement();
        	String sql = "select * from song where id = '%s'";
			ResultSet rs=stmt.executeQuery(String.format(sql, songid));   
			if (rs.next()) {
				result.put("songname", rs.getString("songname"));
				result.put("album_name", rs.getString("album_name"));
				result.put("song_url", rs.getString("song_url"));
				result.put("words", rs.getString("words"));
				result.put("picture_url", rs.getString("picture_url"));
			}
			rs.close();
			stmt.close();
			con.close();
        }
        catch (Exception e) {
			System.out.println(e.getMessage());
        }
	}
	out.print(result.toString());
%>