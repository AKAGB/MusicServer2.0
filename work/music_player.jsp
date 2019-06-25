<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="com.sysugqk.Util"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	int styleClass = 3;
	Cookie[] cookies = request.getCookies();
	String username = Util.authenticate(session, cookies);
	if(username.equals("")){
		response.sendRedirect("SignIn.jsp");
	}
	// 以上为检测代码
%>
<!DOCTYPE html>
<html lang="en">

<head>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>单曲播放</title>
    <link rel="stylesheet" href="assets/css/controller.css">
    <link rel="stylesheet" href="assets/css/songlist.css" />
    <link rel="stylesheet" href="assets/css/song.css">
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <script type="text/javascript">
        musicList = <%= songs_result %>;
        songid = '<%= songid %>';
        // console.log(selfcreated_playlist);
        // var data = '{{ songs_result }}';
    </script>
    <script src="assets/js/music_player.js"></script>
</head>

<body>

    <audio id="mp3-player" src=""></audio>
	<%@ include file="nav.jsp" %>
    <div id="main">

        
        <div class="songlist">
            <table border="0">
                <thead class="songList_header">
                    <tr>
                        <th></th>
                        <th></th>
                        <th class="songList_header_name">歌曲 </th>
                        <th class="songList_header_author">歌手 </th>
                        <th class="songList_header_album">专辑 </th>
                        <th class="songList_header_time">时长</th>
                    </tr>
                </thead>
                <tbody class="songList_main">

                </tbody>
            </table>
        </div>


        <div id="right">
            <div id="Song_info">
                <div id="singer_img" class=""></div>
                <div id="song_info_name"></div>
                <div id="song_info_singer"></div>
                <div id="song_info_album"></div>
            </div>
            <div id="Song_Word_box">
                <div id="Song_Word_inner">
                </div>
            </div>
        </div>
    </div>

    <div id="controller">
        <div id="step-backward" class="player-controller">
            <i class="fa fa-step-backward fa-2x"></i>
        </div>
        <div id="play" class="player-controller">
            <i class="fa fa-play fa-2x"></i>
        </div>
        <div id="step-forward" class="player-controller">
            <i class="fa fa-step-forward fa-2x"></i>
        </div>
        <div id="music-player-controller" class="player-controller">
            <div id="music-info"></div>
            <div id="music-progress" class="progress">
                <div class="progress-bar"></div>
                <div class="progress-his"></div>
                <div class="progress-point"></div>
            </div>
            <div id="music-full-time"><span id="cur-time">00:00</span> / <span id="total-time">03:53</span></div>
        </div>

        <div id="play-mode" class="player-controller img-controller">
            <!-- <i class="fa fa-random fa-2x"></i> -->
            <div class="play-mode-icon" title="列表循环"></div>
        </div>

        <!-- <div id="add-music" class="player-controller img-controller">
            <div class="add-music-icon"></div>
        </div> -->

        <div id="download-music" class="player-controller img-controller">
            <div class="download-music-icon" title="下载音乐">
            </div>

            <a id="download-link" href="" download="" hidden></a>
        </div>

        <div id="volume" class="player-controller img-controller">
            <div class="volumn-icon" title=""></div>
        </div>

        <div id="volume-progress" class="progress">
            <div class="progress-bar"></div>
            <div class="progress-his"></div>
            <div class="progress-point"></div>
        </div>
    </div>
</body>

</html>