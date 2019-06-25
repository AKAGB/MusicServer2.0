<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*,java.sql.*"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	try{
		
		Cookie[] cookies = request.getCookies();
		String username = Util.authenticate(session, cookies);
		System.out.print(username+"<br>");
		if(username.equals("")){
			response.sendRedirect("SignIn.jsp");
		}// 以上为检测代码
		else{
			String playlist_id = request.getParameter("songlistid");
			String song_id = request.getParameter("songid");
			System.out.print(playlist_id+"<br>");
			System.out.print(song_id+"<br>");
			String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
	                + "&characterEncoding=UTF-8"; 
			String user="user";
			String pwd="123";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString, user, pwd);
			Statement stmt=con.createStatement();
			
			String fmt = "delete from  playlist_songs where playlist_id='%s' and song_id='%s'";
			String sql = String.format(fmt,playlist_id,song_id);
			int cnt = stmt.executeUpdate(sql);
			System.out.print(cnt);
			
		}
	}
	catch(Exception e){
		System.out.print(e);
	}

%>
