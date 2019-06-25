<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	String JsonResponse = "";
	JSONArray resArray1 = new JSONArray();
	JSONArray resArray2 = new JSONArray();
	JSONArray resArray3 = new JSONArray();
	JSONArray resArray4 = new JSONArray();
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
	
	else{
		String songid = "";			
		String songlistid = "";		
		songid = request.getParameter("songid");			//	获得歌曲的id
		songlistid = request.getParameter("songlistid");	//	获得歌单的id
		
		String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true"
	                + "&characterEncoding=UTF-8"; 
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString,"user", "123");
		Statement stmt2=con.createStatement();
		
		// (参数错误, status:0)
		if (songid == null || songlistid == null){
			JSONObject obj1 = new JSONObject();
			obj1.put("message", "参数错误");
	        obj1.put("status", 0);
			resArray1.put(obj1);
			JsonResponse = resArray1.toString();
			out.print(JsonResponse);
		}
		
		else{
			// 判断用户是否为歌单创建者
			String sql = "select * from playlist,user where playlist.id = '%s'"
						+" and user.id = playlist.build_user"
						+" and user.username = '%s'";
			ResultSet rs2=stmt2.executeQuery(String.format(sql,songlistid,username));
			
				//	用户不是歌单创建者
			if(!rs2.next()){
				JSONObject obj2 = new JSONObject();
				obj2.put("message", "这不是您创建的歌单，您没有权限！");
				obj2.put("status", 0);
				resArray2.put(obj2);
				JsonResponse = resArray2.toString();
				out.print(JsonResponse);
			}
	
				//	用户为歌单创建者
			else{
				sql = "select * from playlist_songs where playlist_id = '%s' "
						+ " and song_id = '%s'";
				Statement stmt3=con.createStatement();
				ResultSet rs3=stmt3.executeQuery(String.format(sql,songlistid,songid));
				
				// 判断歌曲在不在歌单中
				if(!rs3.next()){
					//	添加歌曲
					
					sql = "insert into playlist_songs(playlist_id,song_id)"+
						" values('%s','%s')";
					stmt3.executeUpdate(String.format(sql,songlistid,songid));
					
					JSONObject obj3 = new JSONObject();
					obj3.put("message", String.format("您成功将歌曲添加入歌单: '%s'!", rs2.getString("playlistname")));
					obj3.put("status", 1);
					resArray3.put(obj3);
					JsonResponse = resArray3.toString();
					out.print(JsonResponse);
				}
				else{
					//	不添加歌曲
					JSONObject obj4 = new JSONObject();
					obj4.put("message", String.format("歌单: '%s' 已存在该收藏歌曲!", rs2.getString("playlistname")));
					obj4.put("status", 1);
					resArray4.put(obj4);
					JsonResponse = resArray4.toString();
					out.print(JsonResponse);
				}
			}
		}	
	}
%>