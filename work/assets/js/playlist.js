window.onload = function(){

    var tbody=document.querySelector(".selfcreated_playlist .playList_main");
    for(var i=0;i<selfcreated_playlist.length;i++){
        var tr = document.createElement("tr");
        var td0 = document.createElement("td");
        td0.attributes["class"] = "num";
        td0.innerHTML = i+1;
        tr.appendChild(td0);
        var id = selfcreated_playlist[i]["id"];

        var td1 = document.createElement("td");
        td1.attributes["class"] = "playList_name";
        var a = document.createElement("a");
        a.setAttribute("href","single_playlist_info.jsp?id=" + id);
        a.innerHTML = selfcreated_playlist[i].playList_name;
        a.style.color = "white";
        a.style.textDecoration = 'none';
        td1.appendChild(a);
        tr.appendChild(td1);
        
        var td2 = document.createElement("td");
        td2.attributes["class"] = "playList_cnt";
        td2.innerHTML = selfcreated_playlist[i].playlist_cnt;
        tr.appendChild(td2);
        
        var td3 = document.createElement("td");
        td3.attributes["class"] = "playList_cnt";
        td3.innerHTML = selfcreated_playlist[i].playlist_createdTime;
        tr.appendChild(td3);
        
        var last_td = document.createElement('td');
        last_td.setAttribute("class","remove");
        var a = document.createElement("a");
        var _i = document.createElement("i");
        _i.setAttribute('class','fa fa-trash');
        a.appendChild(_i);
        a.setAttribute("href",'remove_playlist.jsp?id='+id+"&choice="+1);
        last_td.appendChild(a);
        tr.appendChild(last_td);
        tbody.appendChild(tr);
    }

    var tbody=document.querySelector(".collection_playlist .playList_main");
    for(var i=0;i<collection_playlist.length;i++){
        var tr = document.createElement("tr");
        var td0 = document.createElement("td");
        td0.attributes["class"] = "num";
        td0.innerHTML = i+1;
        tr.appendChild(td0);
        var id = collection_playlist[i]["id"];

        var td1 = document.createElement("td");
        td1.attributes["class"] = "playList_name";
        var a = document.createElement("a");
        a.setAttribute("href","single_playlist_info.jsp?id=" + id);
        a.innerHTML = collection_playlist[i].playList_name;
        a.style.color = "white";
        a.style.textDecoration = 'none';
        td1.appendChild(a);
        tr.appendChild(td1);
        
        var td2 = document.createElement("td");
        td2.attributes["class"] = "playList_cnt";
        td2.innerHTML = collection_playlist[i].playlist_cnt;
        tr.appendChild(td2);
        
        var td3 = document.createElement("td");
        td3.attributes["class"] = "playList_cnt";
        td3.innerHTML = collection_playlist[i].playlist_createdTime;
        tr.appendChild(td3);
        
        var last_td = document.createElement('td');
        last_td.setAttribute("class","remove");
        var a = document.createElement("a");
        var _i = document.createElement("i");
        _i.setAttribute('class','fa fa-trash');
        a.appendChild(_i);
        a.setAttribute("href",'remove_playlist.jsp?id='+id+"&choice="+2);
        last_td.appendChild(a);
        tr.appendChild(last_td);
        tbody.appendChild(tr);
    }
}