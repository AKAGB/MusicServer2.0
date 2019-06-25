<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	String JsonResponse = "";
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	
	else{
		
		String songlistid = "";	
		songlistid = request.getParameter("songlistid");	//	获得歌单的id
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
	                + "&characterEncoding=UTF-8"; 
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString,"user", "123");
		Statement stmt=con.createStatement();
		
		if (songlistid == null){
			JSONObject obj1 = new JSONObject();
			obj1.put("message", "parameters errors");
			JsonResponse = obj1.toString();
			out.print(JsonResponse);
		}
		else{
			String sql = "select * from playlist_collectuser,user"
						+" where playlist_collectuser.playlist_id = '%s'"
						+" and playlist_collectuser.user_id = user.id"
						+" and user.username = '%s'";
			ResultSet rs=stmt.executeQuery(String.format(sql,songlistid,username));
			String user_id = "";
			if(rs.next()){
				//取消收藏歌单
				
				sql = "SELECT playlist_collectuser.id from playlist_collectuser,user"
					+ " where playlist_collectuser.playlist_id = '%s'"
					+ " and user.id = playlist_collectuser.user_id"
					+ " and user.username = '%s'" ;
				ResultSet rs2 = stmt.executeQuery(String.format(sql,songlistid,username));
				String playlist_collectuser_id = "";
				if (rs2.next())
					playlist_collectuser_id = rs2.getString("id");
				sql = "delete from  playlist_collectuser where id = '%s'";
				stmt.executeUpdate(String.format(sql,playlist_collectuser_id)) ;
				JSONObject obj2 = new JSONObject();
				obj2.put("message", "你已取消收藏该歌单");
				JsonResponse = obj2.toString();
				out.print(JsonResponse);
			}
			else{
				// 收藏歌单
				sql = "select * from user where user.username = '%s'";
				ResultSet rs2 = stmt.executeQuery(String.format(sql,username));
				String user_id_ = "";
				if (rs2.next())
					user_id_ = rs2.getString("id");
				sql = "insert into playlist_collectuser(playlist_id,user_id) values('%s','%s')";
				stmt.executeUpdate(String.format(sql,songlistid,user_id_));
				JSONObject obj2 = new JSONObject();
				obj2.put("message", "你成功收藏改该歌单");
				JsonResponse = obj2.toString();
				out.print(JsonResponse);
			}
		}
	}

	
%>
