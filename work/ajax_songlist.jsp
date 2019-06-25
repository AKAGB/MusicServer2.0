<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
    String JsonResponse = "";
	JSONArray resArray = new JSONArray();
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	
	else{
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
	                + "&characterEncoding=UTF-8"; 
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString,"user", "123");
		Statement stmt=con.createStatement();
		String sql = "select distinct * from playlist,user"
						+" where user.id=playlist.build_user"
						+" and user.username='%s'"
						+" and playlist.id not in(" 
						+"  select id from playlist"
						+"  where playlist.playlistname='%s_发布的音乐')";
		ResultSet rs=stmt.executeQuery(String.format(sql,username,username));
		while (rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("play_listid", rs.getString("id"));
			String id = rs.getString("id");
			obj.put("list_img", rs.getString("picture_url"));
			
			Statement stmt2=con.createStatement();
			
			sql = "select * from playlist_songs,playlist where playlist.id = '%s'"
					+" and playlist_songs.playlist_id = playlist.id";
			ResultSet rs_=stmt2.executeQuery(String.format(sql,id));
			rs_.last();
			int song_num = rs_.getRow();
			String num = Integer.toString(song_num);
			obj.put("list_num", num);
			obj.put("list_name", rs.getString("playlistname"));
			resArray.put(obj);
			JsonResponse = resArray.toString();
			
		}
		out.print(JsonResponse);
	}
%>