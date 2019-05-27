window.onload = function () {
    // 点击播放列表的播放按键
    function change(){
        var name = this.className;
        if (name=="fa fa-play") {
            var bro = document.getElementsByClassName('songList_main')[0].querySelectorAll('i');
            for (var i = 0; i < bro.length; i++) {
                bro[i].setAttribute("class","fa fa-play");
            }
            
                this.setAttribute("class","fa fa-pause");
                var index = parseInt(this.parentNode.parentNode.children[0].innerHTML) - 1;
                setBar(index);
                setLyrics(index);
                playAudio(index);
                // musicList[index]
            }
     }

    function scroll (event) {
        height = document.getElementsByTagName('p')[2].offsetHeight;
        origin = document.getElementById("Song_Word_inner").offsetTop;
        bottom = -document.getElementById("Song_Word_inner").offsetHeight;
        if (event.wheelDelta < 0) {
            if (origin > bottom + 5 * height) {
                document.getElementById("Song_Word_inner").style.top = origin - height + 'px';
            }
        } else {
            if (origin != 0) {
                document.getElementById("Song_Word_inner").style.top = origin + height + 'px';
            }
        }
    }
    document.getElementById("Song_Word_box").addEventListener("wheel", scroll);

    

    // 控制组件的js
    // 将xx:xx格式的时间转换为秒数
    function time2second(timetext) {
        var ts = timetext.split(':');
        return parseInt(ts[0]) * 60 + parseInt(ts[1]);
    }

    function second2time(second) {
        var minute =  '' + Math.floor(second / 60), 
            second = '' + second % 60;
        if (minute.length == 1)
            minute = '0' + minute;
        if (second.length == 1)
            second = '0' + second;
        return minute + ':' + second;
    }

    

    // 改变音乐当前时间，参数为百分比
    function changeCurTime(percent) {
        var cur_time = document.getElementById('cur-time'),
            total_time = document.getElementById('total-time');
        var new_time = parseInt(percent * time2second(total_time.innerHTML));
        new_time = second2time(new_time);
        cur_time.innerHTML = new_time;
    }

    // 拖拽进度点事件
    function pointMouseDown(event) {
        var rex = event.clientX - this.offsetLeft;
        var point = this,
            his = this.parentNode.children[1];
        document.body.onmousemove = function (e) {
            var xX = e.clientX - rex;
            if (xX < 0) 
                xX = 0;
            else if(xX > point.MAXVALUE) {
                xX = point.MAXVALUE;
            }
            point.style.left = '' + xX + 'px';
            his.style.width = '' + xX + 'px';
            var per = xX / point.MAXVALUE;
            changeCurTime(per);
        };
    }

    function pointMouseUp() {
        document.body.onmousemove = null;
    }

    // 点击进度条
    function barClick(event) {
        var rex = event.offsetX,
            point = this.parentNode.children[2],
            his = this.parentNode.children[1];
        point.style.left = '' + rex + 'px';
        his.style.width = '' + rex + 'px';
        var per = rex / point.MAXVALUE;
        changeCurTime(per);
    }

    // 播放或暂停的click回调
    function playOrPause() {
        var i = this.children[0];
        i.classList.remove(playClass[playState]);
        playState = 1 - playState;
        i.classList.add(playClass[playState]);
    }

    // 设置时间，同时改变进度条和时间字符串
    function setTime(per) {
        changeCurTime(per);
        var 
            progress = document.querySelector('#music-progress .progress'),
            xX = parseInt(per * progress.children[2].MAXVALUE);
        progress.children[1].style.width = '' + xX + 'px';
        progress.children[2].style.left = '' + xX + 'px';
    }

    // 设置进度条模块
    function setBar(index) {
        var 
            music_info = document.getElementById('music-info'),
            total_time = document.getElementById('total-time');
        music_info.innerHTML = musicList[index]['music_name'] + ' - ' + musicList[index]['singer_name'];
        total_time.innerHTML = musicList[index]['time'];
        setTime(0);
    }

    // 设置歌词模块
    function setLyrics(index) {
        var 
            song_img = document.getElementById('singer_img'),
            song_name = document.getElementById('song_info_name'),
            singer_name = document.getElementById('song_info_singer'),
            album_name = document.getElementById('song_info_album'),
            song_word = document.getElementById('Song_Word_inner'),
            text = musicList[index]['lyrics'].split('\n');

        song_img.style.backgroundImage = 'url(' + musicList[index]['img_url'] + ')';
        song_name.innerHTML = '歌曲名：' + musicList[index]['music_name'];
        singer_name.innerHTML = '歌手名：' + musicList[index]['singer_name'];
        album_name.innerHTML = '专辑名：' + musicList[index]['album_name'];

        song_word.innerHTML = '';
        for (var i = 0; i < text.length; i++) {
            var p = document.createElement('p');
            p.innerHTML = text[i];
            p.setAttribute('data-id', 'line_' + i);
            song_word.appendChild(p);
        }
    }

    // 播放音乐
    function playAudio(index) {
        var audio = document.getElementById('mp3-player');
        audio.setAttribute('src', musicList[index]['music_url']);
        audio.play();
    }

    playState = 1;          // 播放状态，0表示播放，1表示暂停
    playClass = ['fa-pause', 'fa-play'];
    musicList = [
        {
            music_name: '光年之外',
            time: '03:55',
            lyrics: '光年之外 (《太空旅客（Passengers）》电影中国区主题曲) - G.E.M. 邓紫棋 (Gem Tang)\n词：G.E.M. 邓紫棋\n曲：G.E.M. 邓紫棋\n编曲：Lupo Groinig\n监制：Lupo Groinig\n感受停在我发端的指尖\n如何瞬间冻结时间\n记住望着我坚定的双眼\n也许已经没有明天\n面对浩瀚的星海\n我们微小得像尘埃\n漂浮在一片无奈\n缘分让我们相遇乱世以外\n命运却要我们危难中相爱\n也许未来遥远在光年之外\n我愿守候未知里为你等待\n我没想到为了你我能疯狂到\n山崩海啸没有你根本不想逃\n我的大脑为了你已经疯狂到\n脉搏心跳没有你根本不重要\n一双围在我胸口的臂弯\n足够抵挡天旋地转\n一种执迷不放手的倔强\n足以点燃所有希望\n宇宙磅礡而冷漠\n我们的爱微小却闪烁\n颠簸却如此忘我\n缘分让我们相遇乱世以外\n命运却要我们危难中相爱\n也许未来遥远在光年之外\n我愿守候未知里为你等待\n我没想到为了你我能疯狂到\n山崩海啸没有你根本不想逃\n我的大脑为了你已经疯狂到\n脉搏心跳没有你根本不重要\n也许航道以外是醒不来的梦\n乱世以外是纯粹的相拥\n我没想到为了你我能疯狂到\n山崩海啸没有你根本不想逃\n我的大脑为了你已经疯狂到\n脉搏心跳没有你根本不重要\n相遇乱世以外危难中相爱\n相遇乱世以外危难中相爱\n我没想到',
            singer_name: '邓紫棋',
            album_name: '光年之外',
            music_url: 'http://m701.music.126.net/20190526214539/9a4dac4ced1fef5a529774da63bd1e4e/jdyyaac/0753/0e5a/075c/0986657142908367e44306e7570338ff.m4a',
            img_url: 'https://p1.music.126.net/fkqFqMaEt0CzxYS-0NpCog==/18587244069235039.jpg?param=130y130',
        },
        {
            music_name: '牵丝戏',
            time: '03:59',
            lyrics: '作曲 : 银临\n作词 : VAGARY\n银临：嘲笑谁恃美扬威 没了心如何相配\n盘铃声清脆 帷幕间灯火幽微\n我和你 最天生一对\n没了你才算原罪 没了心才好相配\n你褴褛我彩绘 并肩行过山与水\n你憔悴 我替你明媚\n是你吻开笔墨 染我眼角珠泪\n演离合相遇悲喜为谁\n他们迂回误会 我却只由你支配\n问世间哪有更完美\nAki：兰花指捻红尘似水\n三尺红台 万事入歌吹\n唱别久悲不成悲 十分红处竟成灰\n愿谁记得谁 最好的年岁\n银临：你一牵我舞如飞 你一引我懂进退\n苦乐都跟随 举手投足不违背\n将谦卑 温柔成绝对\n你错我不肯对 你懵懂我蒙昧\n心火怎甘心扬汤止沸\n你枯我不曾萎 你倦我也不敢累\n用什么暖你一千岁\nAki：风雪依稀秋白发尾\n灯火葳蕤 揉皱你眼眉\n假如你舍一滴泪 假如老去我能陪\n烟波里成灰 也去得完美\n风雪依稀秋白发尾\n灯火葳蕤 揉皱你眼眉\n假如你舍一滴泪 假如老去我能陪\n烟波里成灰 也去得完美',
            singer_name: '银临/Aki阿杰',
            album_name: '牵丝戏',
            music_url: 'http://m701.music.126.net/20190527213548/4197da60891c2f4a443db30a2b484888/jdyyaac/5108/520b/565d/fbf670192fea110ebfa7a757e17941e2.m4a',
            img_url: 'https://p2.music.126.net/Nd86SOcyCxU5Qu7jdZn_MQ==/7725168696876736.jpg?param=130y130',
        }
    ];
    
    var 
        playButton = document.getElementById('play'),
        progress = document.getElementsByClassName('progress');

    document.body.onmouseup = pointMouseUp;
    playButton.onclick = playOrPause;
    for (var i = 0; i < progress.length; i++) {
        var bar = progress[i].children[0],
            his = progress[i].children[1],
            point = progress[i].children[2];
        point.MAXVALUE = point.parentNode.offsetWidth;
        point.onmousedown = pointMouseDown;
        bar.onclick = barClick;
        his.onclick = barClick;
    }
    
    // 生成歌曲列表
    var songList = document.getElementsByClassName('songList_main')[0];
    var songListClass = ['num', 'play_img', 'songList_songname',
                            'songList_songauthor', 'songList_album', 'songList_songtime']
    for (var i = 0; i < musicList.length; i++) {
        var 
            tr = document.createElement('tr'),
            th_HTML = [i + 1, '<i class="fa fa-play" aria-hidden="true"></i>',
                        musicList[i]['music_name'], musicList[i]['singer_name'],
                        musicList[i]['album_name'], musicList[i]['time']];
        for (j = 0; j < songListClass.length; j++) {
            var th = document.createElement('th');
            th.classList.add(songListClass[j]);
            th.innerHTML = th_HTML[j];
            tr.appendChild(th);
        }
        tr.url = musicList[i]['url'];
        songList.appendChild(tr);
    }

    var is = document.querySelectorAll('.play_img > i');
    for (var i = 0; i < is.length; i++) {
        is[i].onclick = change;
    }

}

