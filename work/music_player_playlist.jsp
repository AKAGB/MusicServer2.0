<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	JSONArray resArray = new JSONArray();
	String playlistid = request.getParameter("playlistid");
	String songid = request.getParameter("songid");
	String songs_result = "";
	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
			+ "?autoReconnect=true&useUnicode=true"
            + "&characterEncoding=UTF-8"; 
    try {
    	Class.forName("com.mysql.jdbc.Driver");
    	Connection con=DriverManager.getConnection(connectString, 
                "user", "123");
		Statement stmt=con.createStatement();
    	String sql = "select * from playlist, playlist_songs, song " + 
					"where playlist.id = playlist_songs.playlist_id " +
    				"and song.id = playlist_songs.song_id " + 
					"and playlist.id = '%s'";
		ResultSet rs=stmt.executeQuery(String.format(sql, playlistid));   
		while (rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("song_id", rs.getString("song_id"));
			obj.put("songList_songname", rs.getString("songname"));
			obj.put("songList_songauthor", rs.getString("singer"));
			obj.put("songList_album", rs.getString("album_name"));
			
			String tmp = rs.getString("song_time");
			int time = Math.round(Float.valueOf(tmp));
			tmp = "" + (time / 60) + ":" + (time % 60);
			
			obj.put("songList_songtime", tmp);
			resArray.put(obj);
		}
		rs.close();
		stmt.close();
		con.close();
		songs_result = resArray.toString();
    }
    catch (Exception e) {
		System.out.println(e.getMessage());
    }
%>
<%@ include file="music_player.jsp" %>