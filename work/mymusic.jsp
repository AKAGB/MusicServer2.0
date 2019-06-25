<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	String collect_result = "";
	String build_result = "";
	JSONArray resArray = new JSONArray();
	JSONArray resArray2 = new JSONArray();
	Cookie[] cookies = request.getCookies();
	int styleClass = 1;
	String username = Util.authenticate(session, cookies);
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	
	else{
		// 获取用户创建或收藏的歌单
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
	                + "&characterEncoding=UTF-8"; 
	    try {
			Class.forName("com.mysql.jdbc.Driver");
	        Connection con=DriverManager.getConnection(connectString,"user", "123");
	        Statement stmt=con.createStatement();
			
			//  获得收藏的歌单
	        String sql = "select * from user,playlist,playlist_collectuser "
			             +  "where username = '%s' "+ " and playlist_collectuser.user_id = user.id "
						 +  "and playlist.id = playlist_collectuser.playlist_id";
	        ResultSet rs=stmt.executeQuery(String.format(sql,username));
	        Statement stmt2=con.createStatement();
	        while (rs.next()) {
	            JSONObject obj = new JSONObject();
	            obj.put("id", rs.getString("playlist_id"));
	            obj.put("playList_name", rs.getString("playlistname"));
	            obj.put("playlist_createdTime", rs.getString("build_date").substring(0, 10));
				
				String id = rs.getString("playlist_id");
				sql = "select * from playlist_songs,playlist where playlist.id = '%s' and "
						+"playlist_songs.playlist_id = playlist.id";
				ResultSet rs_=stmt2.executeQuery(String.format(sql,id));
				int song_num = 0; 
				while(rs_.next()) {   
					song_num++;
				}
				String num = Integer.toString(song_num);
				obj.put("playlist_cnt", num);
	            resArray.put(obj);
	        }
	        collect_result = resArray.toString();
			
			//  获得创建的歌单
			sql = "select * from playlist, user" +
			      " where user.username = '%s'" +
	              " and playlist.build_user = user.id";
			
			rs=stmt.executeQuery(String.format(sql,username));
			Statement stmt3 = con.createStatement();
			while (rs.next()) {
	            JSONObject obj_ = new JSONObject();
	            obj_.put("id", rs.getString("id"));
				obj_.put("playList_name", rs.getString("playlistname"));
	            obj_.put("playlist_createdTime", rs.getString("build_date").substring(0, 10));
				String id = rs.getString("id");
				String sql_ = "select * from playlist_songs,playlist where playlist.id = '%s' and "
						+"playlist_songs.playlist_id = playlist.id";
				
				ResultSet rs_=stmt3.executeQuery(String.format(sql_,id));
				int song_num_ = 0;
				while(rs_.next()) {   
					song_num_++;
				}
				String num = Integer.toString(song_num_);
				obj_.put("playlist_cnt", num);
				
	            resArray2.put(obj_);
	            
	        }
	        build_result = resArray2.toString();
        	
		}
		catch (Exception e) {
    		System.out.println(e.getMessage());
        }
	}
		
	
    
%>

<!DOCTYPE HTML>
<html>
<head>
    
    <meta content="text/html;charset=utf-8">
    <title>歌单</title>
    <link rel="stylesheet" href="assets/css/playlist.css" type="text/css" />
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <script type="text/javascript">
        selfcreated_playlist = <%= build_result %>;
        collection_playlist = <%= collect_result %>;
        console.log(selfcreated_playlist);
    </script>
    <script src="assets/js/playlist.js"></script> 
    <script type="text/javascript">
        var success = '<>';
        if (success == '0') {
            alert('无法删除系统默认歌单！');
        }
        else if (success == '1') {
            alert('删除自建歌单成功！');
        }
        else if (success == '2') {
            alert('取消收藏歌单成功！');
        }
        else if (success == '3') {
            alert('创建歌单成功！');
        }

    </script>
</head>
<body>
   		<%@ include file="nav.jsp" %>
        <div class="container">
        <a href="createlist.jsp" target="_blank">
        <div class="create"><input type="button" value="创建列表" class="btn1"></div>
        </a>


        <div class="selfcreated_playlist">
                <table>
                        <caption>自创歌单</caption>
                            <thead class="playList_header">
                                <tr>
                                    <td ></td>
                                    <td class="playList_name">歌单名称</td>
                                    <td class="playlist_cnt">歌曲数</td> 
                                    <td class="playlist_createdTime">创建时间</td>
                                    <td class="remove">移除</td>
                                </tr> 
                            </thead>
                            <tbody class="playList_main">
                                
                                
                            </tbody>
                    </table>
        </div>
        <div class="hr"></div>
        <div class="collection_playlist">
            <table>
                    <caption>收藏歌单</caption>
                        <thead class="playList_header">
                            <tr>
                                <td ></td>
                                <td class="playList_name">歌单名称</td>
                                <td class="playlist_cnt">歌曲数</td>
								<td class="playlist_createdTime">创建时间</td>
                                <td class="remove">移除</td>
                            </tr> 
                        </thead>
                        <tbody class="playList_main">
                            
                            
                        </tbody>
                </table>
    </div>
    </div>
   
</body>
</html>
