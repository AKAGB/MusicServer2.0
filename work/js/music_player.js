window.onload = function () {
    // 改变播放列表播放图标
    function changePlayIcon(index) {
        var bro = document.getElementsByClassName('songList_main')[0].querySelectorAll('i');
        for (var i = 0; i < bro.length; i++) {
            bro[i].setAttribute("class","fa fa-play");
        }
        bro[index].setAttribute("class","fa fa-pause");
    }

    // 点击播放列表的播放按键
    function change(){
        var name = this.className;
        if (name=="fa fa-play") {
            var index = parseInt(this.parentNode.parentNode.children[0].innerHTML) - 1;
            playAudio(index);
            cur_music = index;
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
        pointMove = (this.parentNode.id == 'music-progress') ? 0 : 1;

        audio.ontimeupdate = null;
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
            if (pointMove == 0) {
                changeCurTime(per);
            }
            else {
                setVolume();
            }
        };
    }

    function pointMouseUp() {
        document.body.onmousemove = null;
        if (pointMove == 0) {
            var time = document.getElementById('cur-time').innerHTML;
            time = time2second(time);
            audio.currentTime = time;
            audio.ontimeupdate = synchronize;
        }
        pointMove = 3;
    }

    // 点击进度条
    function barClick(event) {
        var rex = event.offsetX,
            point = this.parentNode.children[2],
            his = this.parentNode.children[1];
        point.style.left = '' + rex + 'px';
        his.style.width = '' + rex + 'px';
        var per = rex / point.MAXVALUE;
        if (this.parentNode.id == 'music-progress') {
            audio.currentTime = per * audio.duration;
        }
        else {
            setVolume();
        }
    }

    // 播放或暂停的click回调
    function playOrPause() {
        var i = this.children[0];
        i.classList.remove(playClass[playState]);
        playState = 1 - playState;
        i.classList.add(playClass[playState]);
        if (playState == 0) 
            audio.play();
        else 
            audio.pause();
    }

    // 设置时间，同时改变进度条和时间字符串
    function setTime(per) {
        changeCurTime(per);
        var 
            progress = document.querySelector('#music-player-controller .progress'),
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
        
        lyric_time = [];

        song_img.style.backgroundImage = 'url(' + musicList[index]['img_url'] + ')';
        song_name.innerHTML = '歌曲名：' + musicList[index]['music_name'];
        singer_name.innerHTML = '歌手名：' + musicList[index]['singer_name'];
        album_name.innerHTML = '专辑名：' + musicList[index]['album_name'];

        song_word.innerHTML = '';
        //初始化歌词滚动时间列表lyrix_time
        for (var i = 0; i < text.length; i++) {
            var p = document.createElement('p');
            p.innerHTML = text[i].substr(text[i].indexOf(']')+1);
            var tmp = text[i].substr(text[i].indexOf('[')+1,text[i].indexOf(']')-1);
            if (tmp.length){
                var arr = tmp.split(":"),
                    cnt = 0;
                for(var j=0;j<arr.length;j++){
                    cnt = cnt*60 + parseFloat(arr[j]);
                }
                lyric_time.push(cnt);   
            }
            p.setAttribute('data-id', 'line_' + i);
            song_word.appendChild(p);
        }
    }

    // 播放音乐
    function playAudio(index) {
        setBar(index);
        setLyrics(index);
        changePlayIcon(index);
        audio.setAttribute('src', musicList[index]['music_url']);
        playState = 1;
        var clickEvent = document.createEvent('MouseEvent'),
            playButton = document.getElementById('play');
        clickEvent.initEvent('click', true, true);
        playButton.dispatchEvent(clickEvent);
    }

    // 同步时间和进度条
    function synchronize() {
        setTime(audio.currentTime / audio.duration);
        setLyricsTime();
    }

    // 设置音量
    function setVolume() {
        var point = document.querySelector('#volume-progress .progress-point');
        audio.volume = point.offsetLeft / point.MAXVALUE;
    }

    // 音量键回调
    function volumeClick() {
        var progress = document.querySelector('#volume-progress');
        if (volumeState == 1) {
            progress.children[1].style.width = '0px';
            progress.children[2].style.left = '0px';
            setVolume();
        }
        else {
            // -144
            var total = progress.offsetWidth;
            progress.children[1].style.width = '' + (0.5 * total) + 'px'; 
            progress.children[2].style.left = '' + (0.5 * total) + 'px';
            setVolume();
        }
    }

    // 音量改变
    function volumeChange() {
        var volumeIcon = document.querySelector('#volume .volumn-icon');
        if (audio.volume == 0 && volumeState == 1) {
            volumeIcon.style.backgroundPosition = '0px -181px';
            volumeState = 0;
        } 
        else if (volumeState == 0) {
            volumeIcon.style.backgroundPosition = '0px -143px';
            volumeState = 1;
        }
            
    }

    //同步歌词
    function setLyricsTime(){
        var index=0;
        var inner = document.getElementById("Song_Word_inner");
        for(;index<lyric_time.length-1;index++){
            if(audio.currentTime>=lyric_time[index]&&audio.currentTime<lyric_time[index+1]){
                break;
            }
        }
        if(index==lyric_time.length-1&&lyric_time[0]>audio.currentTime){
            index=0;
        }
        var height = height = document.getElementsByTagName('p')[2].offsetHeight;
        inner.style.top= -height*index+'px';
        inner.children[index].style.fontSize = '1.5em';
        inner.children[index].style.color = 'yellow';
        for(var i=index-1;i>=0;i--){
            inner.children[i].style.fontSize = '1.1em';
            inner.children[i].style.color = 'white';
        }
        for(var i=index+1;i<lyric_time.length;i++){
            inner.children[i].style.fontSize = '1.1em';
            inner.children[i].style.color = 'white';
        }
    }

    // 播放模式Click
    function playModeClick() {
        playMode = (playMode + 1) % 3;
        if (playMode == 0) 
            this.style.backgroundPosition = '0px -206px';
        else if (playMode == 1) 
            this.style.backgroundPosition = '0px -233px';
        else 
            this.style.backgroundPosition = '0px -72px';

    }

    // 切下一首歌Click
    function getNext() {
        if (playMode == 0) 
            cur_music = (cur_music + 1) % musicList.length;
        else if (playMode == 1)
            cur_music = cur_music;
        else if (playMode == 2)
            cur_music = Math.floor(Math.random() * musicList.length);

        playAudio(cur_music);
    }

    // 切上一首歌
    function getPrevious() {
        if (playMode == 0) 
            cur_music = (cur_music - 1 + musicList.length) % musicList.length;
        else if (playMode == 1)
            cur_music = cur_music;
        else if (playMode == 2)
            cur_music = Math.floor(Math.random() * musicList.length);

        playAudio(cur_music);
    }

    // 下载Click
    function downloadClick() {
        var music_link = document.querySelector('#download-link');
        music_link.href = musicList[cur_music]['music_url'];
        music_link.download = musicList[cur_music]['music_name'] + '.m4a';
        var clickEvent = document.createEvent('MouseEvent');
        clickEvent.initEvent('click', true, true);
        music_link.dispatchEvent(clickEvent);
    }

    playState = 1;          // 播放状态，0表示播放，1表示暂停
    playClass = ['fa-pause', 'fa-play'];
    playMode = 0;           // 0表示列表循环，1单曲循环，2随机播放
    cur_music = 0;          // 当前歌曲下标
    audio = document.getElementById('mp3-player');
    volumeState = 1;        // 音量状态，如果为0则静音
    pointMove = 3;          // 当前拖拽的是进度条还是音量条，0表示进度，1表示音量，3则无效
    lyric_time = [];        //歌词时间数组

    musicList = [
        {
            music_name: '光年之外',
            time: '03:55',
            lyrics: '[00:00.61]光年之外 - G.E.M.邓紫棋\n[00:00.90]词曲： G.E.M. 邓紫棋\n[00:01.20]编曲： Lupo Groinig\n[00:01.51]监制： Lupo Groinig\n[00:12.30]感受停在我发端的指尖\n[00:16.35]如何瞬间  冻结时间\n[00:23.02]记住望着我坚定的双眼\n[00:27.06]也许已经  没有明天\n[00:33.69]面对浩瀚的星海\n[00:36.26]我们微小得像尘埃\n[00:38.64]漂浮在  一片无奈\n[00:44.57]缘份让我们相遇乱世以外\n[00:50.04]命运却要我们危难中相爱\n[00:55.45]也许未来遥远在光年之外\n[01:00.91]我愿守候未知里为你等待\n[01:04.90]我没想到  为了你  我能疯狂到\n[01:10.54]山崩海啸  没有你  根本不想逃\n[01:15.80]我的大脑  为了你  已经疯狂到\n[01:21.43]脉搏心跳  没有你  根本不重要\n[01:28.57]一双围在我胸口的臂弯\n[01:32.83]足够抵挡  天旋地转\n[01:39.38]一种执迷不放手的倔强\n[01:43.51]足以点燃  所有希望\n[01:50.04]宇宙磅礡而冷漠\n[01:52.64]我们的爱微小却闪烁\n[01:55.13]颠簸  却如此忘我\n[02:00.89]缘份让我们相遇乱世以外\n[02:06.34]命运却要我们危难中相爱\n[02:11.74]也许未来遥远在光年之外\n[02:17.17]我愿守候未知里为你等待\n[02:21.17]我没想到  为了你  我能疯狂到\n[02:26.79]山崩海啸 没有你  根本不想逃\n[02:32.17]我的大脑  为了你  已经疯狂到 \n[02:37.64]脉搏心跳  没有你  根本不重要\n[02:43.79]也许航道以外  是醒不来的梦\n[02:56.24]乱世以外  是纯粹的相拥\n[03:05.00]我没想到  为了你  我能疯狂到\n[03:10.50]山崩海啸 没有你  根本不想逃\n[03:15.80]我的大脑  为了你  已经疯狂到\n[03:21.24]脉搏心跳  没有你  根本不重要 \n[03:27.24]相遇乱世以外 危难中相爱\n[03:38.32]相遇乱世以外 危难中相爱\n[03:48.55]我没想到\n[03:50.12]',
            singer_name: '邓紫棋',
            album_name: '光年之外',
            music_url: '../光年之外.m4a',
            img_url: 'https://p1.music.126.net/fkqFqMaEt0CzxYS-0NpCog==/18587244069235039.jpg?param=130y130',
        },
        {
            music_name: '牵丝戏',
            time: '03:59',
            lyrics: '[00:00.11]牵丝戏 - Aki阿杰/银临\n[00:01.88]词：Vagary\n[00:02.44]曲：银临\n[00:24.55]银：嘲笑谁恃美扬威\n[00:30.16]没了心如何相配\n[00:34.97]盘铃声清脆\n[00:37.80]帷幕间灯火幽微\n[00:40.63]我和你 最天生一对\n[00:46.94]没了你才算原罪\n[00:52.59]没了心才好相配\n[00:57.22]你褴褛我彩绘\n[00:59.93]并肩行过山与水\n[01:02.80]你憔悴 我替你明媚\n[01:08.42]是你吻开笔墨\n[01:11.35]染我眼角珠泪\n[01:14.07]演离合相遇悲喜为谁\n[01:19.68]他们迂回误会\n[01:22.47]我却只由你支配\n[01:25.11]问世间哪有更完美\n[01:30.26]Aki：兰花指捻红尘似水\n[01:35.96]三尺红台 万事入歌吹\n[01:41.62]唱别久悲不成悲\n[01:44.67]十分红处竟成灰\n[01:47.47]愿谁记得谁 最好的年岁\n[02:16.30]银：你一牵我舞如飞\n[02:21.82]你一引我懂进退\n[02:26.53]苦乐都跟随\n[02:29.31]举手投足不违背\n[02:32.01]将谦卑 温柔成绝对\n[02:37.83]你错我不肯对\n[02:40.47]你懵懂我蒙昧\n[02:43.23]心火怎甘心扬汤止沸\n[02:48.99]你枯我不曾萎\n[02:51.72]你倦我也不敢累\n[02:54.32]用什么暖你一千岁\n[02:59.93]Aki：风雪依稀秋白发尾\n[03:05.36]灯火葳蕤 揉皱你眼眉\n[03:10.84]假如你舍一滴泪\n[03:14.06]假如老去我能陪\n[03:16.63]烟波里成灰 也去得完美\n[03:22.07]风雪依稀秋白发尾\n[03:27.61]灯火葳蕤 揉皱你眼眉\n[03:33.13]假如你舍一滴泪\n[03:36.32]假如老去我能陪\n[03:39.14]烟波里成灰 也去得完美',
            singer_name: '银临/Aki阿杰',
            album_name: '牵丝戏',
            music_url: '../牵丝戏.m4a',
            img_url: 'https://p2.music.126.net/Nd86SOcyCxU5Qu7jdZn_MQ==/7725168696876736.jpg?param=130y130',
        },
        {
            music_name: '修炼爱情',
            time: '04:47',
            lyrics: '[00:00.50]修炼爱情\n[00:05.41]作词：易家扬 作曲：林俊杰\n[00:09.41]演唱：林俊杰\n[00:18.21]凭什么要失望\n[00:25.18]藏眼泪到心脏\n[00:30.19]往事不会说谎别跟他为难\n[00:37.06]我们两人之间不需要这样\n[00:44.40]我想\n[00:47.48]修炼爱情的心酸\n[00:50.92]学会放好以前的渴望\n[00:54.99]我们那些信仰 要忘记多难\n[01:01.61]远距离的欣赏 近距离的迷惘\n[01:04.99]谁说太阳会找到月亮\n[01:09.09]别人有的爱\n[01:10.83]我们不可能模仿\n[01:15.63]修炼爱情的悲欢\n[01:19.05]我们这些努力不简单\n[01:23.19]快乐炼成泪水 是一种勇敢\n[01:29.94]几年前的幻想 几年后的原谅\n[01:33.45]为一张脸去养一身伤\n[01:37.34]别讲想念我 我会受不了这样\n[01:47.20]记忆它真嚣张\n[01:53.46]路灯把痛点亮\n[01:59.12]情人一起看过多少次月亮\n[02:05.97]他在天空看过多少次遗忘\n[02:12.68]多少心慌\n[02:16.11]修炼爱情的心酸\n[02:19.61]学会放好以前的渴望\n[02:23.62]我们那些信仰 要忘记多难\n[02:30.38]远距离的欣赏 近距离的迷惘\n[02:33.89]谁说太阳会找到月亮\n[02:37.61]别人有的爱\n[02:39.72]我们不可能模仿\n[02:44.41]修炼爱情的悲欢\n[02:48.05]我们这些努力不简单\n[02:52.07]快乐炼成泪水 是一种勇敢\n[02:58.75]几年前的幻想 几年后的原谅\n[03:02.23]为一张脸去养一身伤\n[03:06.26]别讲想念我 我会受不了这样\n[03:24.52]笑着说爱让人疯狂\n[03:27.70]哭着说爱让人紧张\n[03:31.28]忘不了那个人就投降\n[03:39.36]修炼爱情的悲欢\n[03:42.84]我们这些努力不简单\n[03:46.91]快乐炼成泪水\n[03:49.24]是一种勇敢\n[03:53.58]几年前的幻想 几年后的原谅\n[03:57.04]为一张脸去养一身伤\n[04:01.13]别讲想念我 我会受不了这样\n[04:07.82]几年前的幻想 几年后的原谅\n[04:11.40]为一张脸去养一身伤\n[04:15.41]别讲想念我 我会受不了这样', 
            singer_name: '林俊杰',
            album_name: '因你而在',
            music_url: '../修炼爱情.m4a',
            img_url: 'https://p2.music.126.net/D_hiKMwrdQlqD36LoKLO2w==/109951163187408030.jpg?param=130y130',
        
        },
        {
            music_name: '匆匆那年',
            time: '04:01',
            lyrics: '[00:00.73]匆匆那年\n[00:01.53]演唱：王菲\n[00:02.43]作曲：梁翘柏\n[00:03.53]作词：林夕\n[00:04.48]电影（匆匆那年）主题曲\n[00:32.45]匆匆那年我们究竟说了几遍\n[00:34.55]再见之后再拖延\n[00:37.88]可惜谁有没有\n[00:38.98]爱过不是一场\n[00:40.43]七情上面的雄辩\n[00:43.63]匆匆那年我们一时匆忙落下\n[00:46.08]难以承受的诺言\n[00:49.22]只有等别人客观\n[00:54.74]不怪那吻痕还没积累成茧\n[01:00.39]拥抱着冬眠也没能羽化成仙\n[01:05.84]不怪这一段情 没空反复再排练\n[01:11.45]是岁月宽容恩赐 反悔的时间\n[01:22.53]如果再见不能红着眼 是否还能红着脸\n[01:28.38]就像那年匆促 刻下永远一起\n[01:31.08]那样美丽的谣言\n[01:33.48]如果过去还值得眷恋\n[01:36.18]别太快冰释前嫌\n[01:39.43]谁甘心就这样 彼此无挂也无牵\n[01:45.08]我们要互相亏欠 要不然凭何怀缅\n[02:02.52]匆匆那年我们见过太少世面\n[02:04.72]只爱看同一张脸\n[02:07.59]那么莫名其妙那么讨人欢喜\n[02:10.54]闹起来又太讨厌\n[02:13.19]相爱那年活该 匆匆因为我们\n[02:16.09]不懂顽固的诺言\n[02:19.04]只是分手的前言\n[02:24.24]不怪那天太冷 泪滴水成冰\n[02:30.34]春风也一样没吹进凝固的照片\n[02:35.79]不怪一个人 没能完整爱一遍\n[02:41.56]是岁月善意落下 残缺的悬念\n[02:52.33]如果再见不能红着眼 是否还能红着脸\n[02:58.39]就像那年匆促 刻下永远一起\n[03:00.79]那样美丽的谣言\n[03:03.19]如果过去还值得眷恋\n[03:06.34]别太快冰释前嫌\n[03:09.54]谁甘心就这样 彼此无挂也无牵\n[03:14.64]如果再见不能红着眼 是否还能红着脸\n[03:20.69]就像那年匆促 刻下永远一起\n[03:23.39]那样美丽的谣言\n[03:25.89]如果过去还值得眷恋\n[03:29.19]别太快冰释前嫌\n[03:31.89]谁甘心就这样 彼此无挂也无牵\n[03:37.54]我们要互相亏欠\n[03:43.39]我们要藕断丝连', 
            singer_name: '王菲',
            album_name: '匆匆那年',
            music_url: '../匆匆那年.m4a',
            img_url: 'https://p1.music.126.net/yXyeAl-7m0tqfx4AX7BDSQ==/2542070884980240.jpg?param=130y130',
        },
    ];
    
    var 
        playButton = document.getElementById('play'),
        progress = document.getElementsByClassName('progress'),
        volumeButton = document.querySelector('#volume .volumn-icon'),
        playModeButton = document.querySelector('.play-mode-icon'),
        nextButton = document.querySelector('#step-forward i'),
        previousButton = document.querySelector('#step-backward i'),
        downloadButton = document.querySelector('.download-music-icon');

    document.body.onmouseup = pointMouseUp;
    playButton.onclick = playOrPause;
    audio.ontimeupdate = synchronize;
    audio.onvolumechange = volumeChange;
    audio.onended = getNext;
    volumeButton.onclick = volumeClick;
    playModeButton.onclick = playModeClick;
    nextButton.onclick = getNext;
    previousButton.onclick = getPrevious;
    downloadButton.onclick = downloadClick;
    for (var i = 0; i < progress.length; i++) {
        var bar = progress[i].children[0],
            his = progress[i].children[1],
            point = progress[i].children[2];
        point.MAXVALUE = point.parentNode.offsetWidth;
        point.onmousedown = pointMouseDown;
        bar.onclick = barClick;
        his.onclick = barClick;
    }
    // setVolume();
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

