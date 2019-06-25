<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*,java.sql.*"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	int flag = 0;
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	
	else{
		int playlist_id = Integer.parseInt(request.getParameter("id"));
		String choice = request.getParameter("choice");
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
				+ "?autoReconnect=true&useUnicode=true"
                + "&characterEncoding=UTF-8"; 
		String user="user";
		String pwd="123";
		String user_id = "";
		try{
			Class.forName("com.mysql.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString, user, pwd);
			Statement stmt=con.createStatement();
			String fmt = "select id from user where username='%s'";
			String sql = String.format(fmt,username);
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.next()){
				user_id = rs.getString("id");
			}
			
			
			if(choice.equals("1")){//删除自建
				fmt = "select playlistname from playlist where id='%d' ";
				sql = String.format(fmt,playlist_id);
				rs = stmt.executeQuery(sql);
				String playlistname = "";
				
				if(rs.next()){
					playlistname = rs.getString("playlistname");
				}
				
				if(playlistname.contains("喜欢的音乐")||playlistname.contains("发布的音乐")){
					flag = 1;
				}
				
				if(flag==0){
					fmt = "delete from playlist where id='%d'";
					sql = String.format(fmt,playlist_id);
					out.print(playlist_id);
					stmt.executeUpdate(sql);
				}
			}
			else{//取消收藏
				
				fmt = "delete from playlist_collectuser where playlist_id='%d' and user_id='%s'";
				sql = String.format(fmt,playlist_id,user_id);
				stmt.executeUpdate(sql);
				flag = 2;
			}
		}
		catch(Exception e){
			out.print(e);
		}
	}
%>

<%	
response.sendRedirect("mymusic.jsp");
%>


