function submit(event){
    var inputs = document.getElementsByTagName("input");
    var msg = "";
    for(var i=0;i<inputs.length;i++){
        if(inputs[i].value==""){
            msg += inputs[i].name+" can not be empty!\n";
        }
    }
    if(msg!=""){
        alert(msg);
        event.preventDefault();
        return ;
    }
    return;
}
window.onload = function(){
    document.getElementsByClassName("submit")[0].onclick=submit;
}