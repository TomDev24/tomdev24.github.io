var el = document.getElementById("main")


function httpGetAsync(theUrl, callback)
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", theUrl, true); // true for asynchronous
    xmlHttp.send(null);
}

function changeData(newData){
  el.textContent = newData;
}

httpGetAsync("http://ovz1.j2953835.no45p.vps.myjino.ru:49265", changeData)
