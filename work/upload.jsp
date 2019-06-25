<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*,javax.servlet.* ,java.text.*,org.apache.commons.io.*"%>
<%@ page import=" javax.sound.sampled.*" %>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="org.jaudiotagger.audio.mp3.MP3File" %>
<%@ page import="org.jaudiotagger.audio.mp3.MP3AudioHeader" %>
<%@ page import="org.jaudiotagger.audio.AudioFileIO" %>

<%  request.setCharacterEncoding("utf-8"); %>
<%
String username = "";
String user_id = "";
int styleClass = 2;
int alertBool = 2;
String sessionId = "";
Boolean flag = true;
Cookie[] cookies = request.getCookies();

for (Cookie cookie : cookies) {
	String name = cookie.getName();
	String value = cookie.getValue();
	if (name.equals("MUSICSESSIONID")) {
		sessionId = value;
	}
	else if (name.equals("username")) {
		username = value;
	}
}
if (sessionId.equals(session.getId())) {
	if (session.getAttribute(username) != null) {
		flag = false;
	}
}
if (flag) {
	// flag为true则表示验证失败，需要退回登录页面
	response.sendRedirect("SignIn.jsp");
}
// 以上为检测代码
else{
	String connectString = "jdbc:mysql://localhost:3306/boke16337012"
			+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String user="user";
	String pwd="123";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, user, pwd);
		Statement stmt=con.createStatement();
		
		ResultSet rs = stmt.executeQuery(String.format("select * from user where username = '%s'", 
					username));
		user_id = "";
		
		if (rs.next()) {
		 user_id = rs.getString("id");
		}
		stmt.close(); con.close();
	}
	catch(Exception e){
		out.print(e);
	}
	if(request.getMethod().equalsIgnoreCase("post")){
		String album_name = "";
		String songname = "";
		String singer = "";
		
		String song_words = "";
		String song_url = "";
		String song_img_url = "";
		String mp_time = "";
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List items = upload.parseRequest(request);
		
		for (int i = 0; i < items.size(); i++) {
			FileItem fi = (FileItem) items.get(i);
			if (fi.isFormField()) {
				if(fi.getFieldName().equals("album_name")){
					album_name = fi.getString("utf-8");
				}
				else if(fi.getFieldName().equals("songname")){
					songname = fi.getString("utf-8");
				}
				else{
					singer = fi.getString("utf-8");
				}
			}
			else {
			
			DiskFileItem dfi = (DiskFileItem) fi;
			if (!dfi.getName().trim().equals("")) {
			//out.print("文件被上传到服务上的实际位置：");
				if(fi.getFieldName().equals("picture_file")){
				String fileName=application.getRealPath("/assets/picture_file")
						+ System.getProperty("file.separator")
						+ FilenameUtils.getName(dfi.getName());
				dfi.write(new File(fileName));
				song_img_url = "assets/picture_file/"+FilenameUtils.getName(dfi.getName());
				}
				else if(fi.getFieldName().equals("song_words_file")){
					song_words = fi.getString("utf-8");
				}
				else{
					String fileName=application.getRealPath("/assets/mp3")
							+ System.getProperty("file.separator")
							+ user_id+"_"+songname+".mp3";
					//out.print(fileName);
					dfi.write(new File(fileName));
					song_url = "assets/mp3/"+user_id+"_"+songname+".mp3";
					
					File file = new File(fileName);
					MP3File f = (MP3File)AudioFileIO.read(file); 
					MP3AudioHeader audioHeader = (MP3AudioHeader)f.getAudioHeader();
					
					int int_len = audioHeader.getTrackLength();
					
					mp_time = Integer.toString(int_len);
				}
			} 
			else{
				alertBool = 0;
				break;
			}
			} 
		} 
		if(alertBool!=0){
				try{
				Class.forName("com.mysql.jdbc.Driver");
				Connection con=DriverManager.getConnection(connectString, user, pwd);
				Statement stmt=con.createStatement();
				
				String fmt="insert into song(songname,song_time,singer,song_url,picture_url,userid,album_name,words,isvalid)"+
						"values('%s', '%s','%s','%s','%s','%s','%s','%s','%s')";
				String sql = String.format(fmt,songname,mp_time,singer,song_url,song_img_url,user_id,album_name,song_words,"1");
				int cnt = stmt.executeUpdate(sql);
				if(cnt>0)alertBool=1;
				String playlistname = username + "_发布的音乐";
				fmt = "select id from playlist where playlistname = '%s'";
				sql = String.format(fmt,playlistname);
				ResultSet rs = stmt.executeQuery(sql);
				String playlist_id = "";
				if(rs.next()){
					playlist_id = rs.getString("id");
				}
				
				sql = "select max(id) as max_id from song";
				rs = stmt.executeQuery(sql);
				String song_id = "";
				if(rs.next()){
					song_id = rs.getString("max_id");
				}
				fmt = "insert into playlist_songs(playlist_id,song_id) values('%s','%s')";
				sql = String.format(fmt,playlist_id,song_id);
				cnt = stmt.executeUpdate(sql);
				stmt.close(); con.close();
			}
			catch(Exception e){
				out.print(e);
			}
		}
	}
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" type="text/css" href="assets/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/upload.css" />
    <title>音乐文件上传</title>
    <script type="text/javascript" src="assets/js/upload.js"></script>
    <script src="assets/js/check.js"></script>
    <script type="text/javascript">
        var alertBool = <%=alertBool%>;
        if (alertBool == 1) {
            alert('上传成功！');
        }
        else if(alertBool == 0){
            alert('上传失败，请检查是否空输入或文件格式不对应，请重新上传！')
        }
    </script>
</head>
<body>
    <%@ include file="nav.jsp" %>
    <div class="apply">
        <div class="apply_header"><span>音乐文件上传</span></div>
        <div class="left">
                <div class="left_con">
                    <i class="fa fa-tasks" aria-hidden="true"></i>
                    专辑名:
                </div>
                <div class="left_con">
                    <i class="fa fa-music" aria-hidden="true"></i>
                    歌曲名:
                </div>
                <div class="left_con">
                    <i class="fa fa-male" aria-hidden="true"></i>
                    歌手名:
                </div>
                
                <div class="left_con">
                    <i class="fa fa-music" aria-hidden="true"></i>
                    音乐文件:
                </div>
                <div class="left_con">
                <i class="fa fa-file" aria-hidden="true"></i>
                歌词文件:
                </div>
                <div class="left_con">
                    <i class="fa fa-file-image-o" aria-hidden="true"></i>
                    歌曲配图:
                </div>
                
        </div>
        <div class="right">
        <form method="post" action="upload.jsp" enctype="multipart/form-data">
            
            <div class="right_con">
                <input type="text" class="album" name="album_name" >
            </div>
            <div class="right_con">
                <input type="text" class="song_name" name="songname">
            </div>
            <div class="right_con">
                <input type="text" class="singer" name="singer" >
            </div>

                <div class="file right_con">
                <input type="file"  class="file_btn"  name="song_file"  value = "">
                </div>

                <div class="file right_con">
                <input type="file"  class="file_btn"  name="song_words_file" >
                </div>

                <div class="file right_con">
                <input type="file"  class="file_btn"  name="picture_file"  value = "">
                </div>

            
            <div class="right_con submit_btn">
                <input type="submit" value="提交" class="submit" action="submit()" >
            </div>
        </form>
        </div>
    </div>

</body>
</html>