window.onload = function () {
    var playlists_info = document.getElementsByClassName("header")[0];   //加载歌单的详情信息
   
        var div1 = document.createElement("div");
        div1.setAttribute("class","header_left");
        var img = document.createElement("img");
        img.setAttribute("src",playlists_result['picture_url'])  //图片路径
        img.width=130;
        img.height=130;
        div1.appendChild(img);
        playlists_info.appendChild(div1);

        var div2 = document.createElement("div");
        div2.setAttribute("class","header_right")
        var div2_1 = document.createElement("div");
        div2_1.setAttribute("class","row1");
        div2.appendChild(div2_1);
        var sp1 = document.createElement("span");
        sp1.innerHTML="歌单";
        sp1.setAttribute("class","playlist_box");
        var sp2 = document.createElement("span");
        sp2.innerHTML= playlists_result["playList_name"];
        sp2.setAttribute("class","playlist_name");
        div2_1.appendChild(sp1);
        div2_1.appendChild(sp2);

        var div2_2 = document.createElement("div");
        div2_2.setAttribute("class","row2");
        var sp3 = document.createElement("span");
        sp3.innerHTML=playlists_result["playList_build_user"];
        sp3.setAttribute("class","creator_name");
        var sp4 = document.createElement("span");
        sp4.innerHTML= playlists_result["playList_date"];
        sp4.setAttribute("class","created_time");
        div2_2.appendChild(sp3);
        div2_2.appendChild(sp4);

        div2.appendChild(div2_1);
        div2.appendChild(div2_2);
        playlists_info.appendChild(div2);



        //加载歌单里的歌曲
        var tbody = document.getElementsByClassName("songList_body")[0];
        for(var i=0;i<songs_result.length;i++)
        {
            var tr = document.createElement("tr");
            tr.setAttribute("class","listbody_tr");

            var th1 = document.createElement("th");
            th1.innerHTML=i+1;
            tr.appendChild(th1);

            var th1_a = document.createElement("a")
            var url = "music_player_playlist.jsp"+"?playlistid="+playlists_result["playlist_id"]+"&songid="+songs_result[i]["song_id"];  //链接未确定？？？？
            th1_a.classList.add("play_a");
            th1_a.setAttribute("target", "_blank");
            th1_a.setAttribute("href",url);

            var th2 = document.createElement("th");
            var i1 = document.createElement("i");
            i1.setAttribute("class", "fa fa-play");
            i1.setAttribute("aria-hidden", "true");
            th1_a.appendChild(i1);
            th2.appendChild(th1_a)
            tr.appendChild(th2);

            var th3 = document.createElement("th");
            th3.innerHTML = songs_result[i].songList_songname;
            th3.setAttribute("class","songList_songname")
            tr.appendChild(th3);
            
            var th4 =document.createElement("th");
            th4.innerHTML = songs_result[i].songList_songauthor;
            th4.setAttribute("class","songList_songauthor");
            tr.appendChild(th4);
            
            var th5 = document.createElement("th");
            th5.innerHTML = songs_result[i].songList_songtime;
            th5.setAttribute("class","songList_songtime");
            tr.appendChild(th5);
           

            var th6 = document.createElement("th");
            var i2 = document.createElement("i");
            i2.setAttribute("class", "fa fa-plus");
            i2.id=songs_result[i]["song_id"];
            i2.setAttribute("aria-hidden", "true");
            th6.appendChild(i2);
            tr.appendChild(th6);

            var th7 = document.createElement("th");
            var i3 = document.createElement("i");
            i3.setAttribute("class", "fa fa-trash");
            i3.setAttribute("aria-hidden", "true");
            th7.appendChild(i3);
            tr.appendChild(th7);

            tbody.appendChild(tr);
        }

        flag=0;
        function change(){
            var name = this.className;
            if (name=="fa fa-pause")
            {
                this.setAttribute("class","fa fa-play");

                flag=0;
            } 
            else if(flag==0 && name=="fa fa-play" )
            {
                this.setAttribute("class","fa fa-pause");
                flag=1;
            }
            else if(flag==1 && name=="fa fa-play")
            {
                var sub_arr = document.getElementsByClassName("fa fa-pause")[0];
                sub_arr.setAttribute("class", "fa fa-play");
                this.setAttribute("class","fa fa-pause");
                flag=1;
            }
        }

        function delete_it(i)
        {
            return function()
            {
                var xmlhttp = new XMLHttpRequest(); // 创建http请求
                xmlhttp.onreadystatechange = function () { // 当http请求的状态变化时执行
                if (xmlhttp.readyState == 4) 
                    { // 4-已收到http响应数据
                    if (xmlhttp.status >= 200 && xmlhttp.status < 300 || xmlhttp.status == 304 ||xmlhttp.status == 0)
                    { 
                        location.reload([true]);  
                    } else {
                        alert("error");
                    }
                    }
                }
                // 打开http请求（open）的参数： get|post， url，是否异步发送
                var url =   "ajax_removesong.jsp?songlistid=" +   playlists_result["playlist_id"]+"&songid=" + songs_result[i]['song_id'];//删除歌单里的歌曲
                xmlhttp.open("get",url, true);
                xmlhttp.send(null); //发送http请求。 get只能用null作为参数
            }
            
        
        }




        function show_box()
        {
           
                var list_div = document.getElementsByClassName("add_toMylist")[0];
                showShadow();
                
                list_div.style.display = "inline-block";
                list_div.style.top=""+4*document.documentElement.clientHeight/12+"px";  
                list_div.style.left=""+4*document.documentElement.scrollWidth/12-30+"px";  
                show_songlist(this.id);
        }
       
        function show_songlist(this_songid)
        {
            get_list(this_songid);//
            //根据得到的歌单数据， 动态地显示我的歌单
           add_songid=this_songid;
    
        }
        // my_songlist = [];
        function get_list(this_songid)  //向后台发送get请求，得到歌单数据
        {
            //发送加入歌单的请求post
             var xmlhttp = new XMLHttpRequest(); // 创建http请求
            xmlhttp.onreadystatechange = function () { // 当http请求的状态变化时执行
            if (xmlhttp.readyState == 4) 
                { // 4-已收到http响应数据
                if (xmlhttp.status >= 200 && xmlhttp.status < 300 || xmlhttp.status == 304 ||xmlhttp.status == 0)
                { 
                    var data = xmlhttp.responseText;
                    my_songlist = JSON.parse(data);
                     var lt = document.getElementsByClassName("list_info");
            var par = document.getElementsByClassName("add_toMylist")[0];
            
            if(lt != "")
            {
                for(var i=0;;)
                {
                    if(lt.length == 0)
                        break;
                    par.removeChild(lt[i]);
                }    
            }

            for(var i=0;i<my_songlist.length;i++){
            
                var div = document.createElement("div");
                div.setAttribute("class","list_info");
                div.id=my_songlist[i]["play_listid"];
                div.songid= this_songid;

                var list_img = document.createElement("img");
                list_img.setAttribute("class","list_img");
                list_img.setAttribute("src",my_songlist[i]["list_img"]);
               
                div.appendChild(list_img);
    
                var div1 =  document.createElement("span");
                div1.setAttribute("class","list_name");
                div1.innerHTML=my_songlist[i]["list_name"];
                div.appendChild(div1);
                
                var div2 =  document.createElement("span");
                div2.setAttribute("class","list_num");
                div2.innerHTML=my_songlist[i]["list_num"];
                div.appendChild(div2);
            
                document.getElementsByClassName("add_toMylist")[0].appendChild(div);
            }
            var is = document.querySelectorAll('.list_info'); // 添加到我的歌单时，选择相应的歌单
            for (var i = 0; i < is.length; i++) {
               is[i].onclick = add_list;
           }
                   
                } else {
                    alert("error");
                }
                }
            }
            // 打开http请求（open）的参数： get|post， url，是否异步发送
            xmlhttp.open("get", "ajax_songlist.jsp" , true);
            
            xmlhttp.send(null); //发送http请求。 get只能用null作为参数
        }

        function showShadow(){ //变灰色  
            var shadow=document.getElementById("shadow");  
            shadow.style.width=""+document.documentElement.scrollWidth+"px";  
            if(document.documentElement.clientHeight>document.documentElement.scrollHeight)  
               shadow.style.height=""+document.documentElement.clientHeight+"px";  
            else  
               shadow.style.height=""+document.documentElement.scrollHeight+"px";  
            shadow.style.display="block";  
        }  

        function hidebox()
        {
            var list_div = document.getElementsByClassName("add_toMylist")[0];
            var shadow=document.getElementById("shadow");
            list_div.style.display="none";
            shadow.style.display = "none";
        }

        function add_list()
        {
                var collected ;
                var xmlhttp = new XMLHttpRequest(); // 创建http请求
                xmlhttp.onreadystatechange = function () { // 当http请求的状态变化时执行
                if (xmlhttp.readyState == 4) 
                    { // 4-已收到http响应数据
                    if (xmlhttp.status >= 200 && xmlhttp.status < 300 || xmlhttp.status == 304 ||xmlhttp.status == 0)
                    { 
                        collected=xmlhttp.responseText;
                        collected = JSON.parse(collected)[0];
                        alert(collected["message"]);
                       
                    } else {
                        alert("error");
                    }
                    }
                }
            
                // 打开http请求（open）的参数： get|post， url，是否异步发送
                var url =  "ajax_addsong.jsp?songlistid=" + this.id + "&songid="+add_songid;
                xmlhttp.open("get",url, true);
                xmlhttp.send(null); //发送http请求。 get只能用null作为参数
                hidebox();
                   
        }

        var is = document.querySelectorAll('.fa-plus'); //点击加号，添加到我的歌单
        for (var i = 0; i < is.length; i++) {
            is[i].onclick = show_box;
        }

        
        var is = document.querySelectorAll('.fa-trash'); //点击播放歌曲
        for (var i = 0; i < is.length; i++) {
            is[i].onclick = delete_it(i);
        }

        var is = document.querySelectorAll('.fa-play'); //点击播放歌曲
        for (var i = 0; i < is.length; i++) {
            is[i].onclick = change;
        }


        var is = document.querySelectorAll('.fa-trash'); //点击播放歌曲
        for (var i = 0; i < is.length; i++) {
            is[i].onclick = delete_it(i);
        }
        
        var is = document.querySelectorAll('.close > i'); //添加到我的歌单时，右上角的x号
        for (var i = 0; i < is.length; i++) {
           is[i].onclick = hidebox;
       }
}