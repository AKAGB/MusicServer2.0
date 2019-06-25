<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*, java.text.SimpleDateFormat,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
String username = "";
int styleClass = 0;
int alertBool = 2;
String sessionId = "";
Boolean flag = true;
Cookie[] cookies = request.getCookies();
try{
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
}
catch(Exception e){
	response.sendRedirect("SignIn.jsp");
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
else{
	if(request.getMethod().equalsIgnoreCase("post")){
		String playlistname = "";
		String img_url="";
		
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List items = upload.parseRequest(request);
		for(int i=0;i<items.size();i++){
			FileItem fi = (FileItem) items.get(i);
			if(fi.isFormField()){
				playlistname = fi.getString("utf-8");
			}
			else{
				DiskFileItem dfi = (DiskFileItem) fi;
				if (!dfi.getName().trim().equals("")) {
					String fileName=application.getRealPath("/assets/picture_file")
							+ System.getProperty("file.separator")
							+ FilenameUtils.getName(dfi.getName());
					dfi.write(new File(fileName));
					img_url = "assets/picture_file/"+FilenameUtils.getName(dfi.getName());
				}
				else{
					alertBool=0;
					break;
				}
			}
		}
		if(alertBool!=0){
			String connectString = "jdbc:mysql://localhost:3306/boke16337012"
					+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
			String user="user";
			String pwd="123";
			try{
				Class.forName("com.mysql.jdbc.Driver");
				Connection con=DriverManager.getConnection(connectString, user, pwd);
				Statement stmt=con.createStatement();
				String datetime=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); //获取系统时间
				ResultSet rs = stmt.executeQuery(String.format("select * from user where username = '%s'", 
							username));
				String user_id = "";
				if (rs.next()) {
				 user_id = rs.getString("id");
				}
				String fmt="insert into playlist(playlistname,build_user,build_date,picture_url) values('%s','%s','%s','%s')";
				String sql = String.format(fmt,playlistname,user_id,datetime,img_url);
				int cnt = stmt.executeUpdate(sql);
				if(cnt>0)alertBool=1;
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
    <link rel="stylesheet" type="text/css" href="asssets/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/createlist.css" />
    <title>音乐歌单创建</title>
    <script type="text/javascript" src="assets/js/createlist.js"></script>
    <script type="text/javascript" src="assets/js/check.js"></script>
    <script type="text/javascript">
        var alertBool = <%= alertBool%>;
        if (alertBool == 1) {
            alert('创建成功！');
        }
        else if(alertBool == 0) {
            alert('创建失败，请重新创建！');
        }
    </script>
</head>

<body>
	
    <div class="apply">
        <div class="apply_header">
            <span>歌单创建</span>
        </div>
        <div class="left">
            <div class="left_con">
                <i class="fa fa-tasks" aria-hidden="true"></i>
                歌单名:
            </div>
            <div class="left_con">
                <i class="fa fa-file-image-o" aria-hidden="true"></i>
                歌单配图:
            </div>

        </div>
        <div class="right">
            <form method="post" action="createlist.jsp" enctype="multipart/form-data">
                
                <div class="right_con">
                    <input type="text" class="album" name="playlistname" value="">
                </div>

                <div class="file right_con">
                    <input type="file" class="file_btn" name="picture_file" value="{{error.5}}">
                </div>


                <div class="right_con submit_btn">
                    <input type="submit" value="提交" class="submit">
                </div>
            </form>
        </div>
    </div>

</body>

</html>