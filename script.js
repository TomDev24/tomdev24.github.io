let about = document.getElementById("about")

$(document).ready(()=>{
  if(screen.width < 720){
    return;
  }else {
    $(".card").on("mouseenter",e=>{

      if ($(e.currentTarget).data().name ==="notes" ){
        about.innerHTML=`<p id="about"><span style="font-weight:bold;">NotesFromTheRoad</span> -
          адаптивная верстка с использованием FlexBox и jQuery</p>`
      } else if ($(e.currentTarget).data().name ==="sky" ){
        about.innerHTML=`<p id="about"><span style="font-weight:bold;">SkyPype</span> -
          использование технологии React и Redux для иммитации мессенджера</p>`
      } else if ($(e.currentTarget).data().name ==="blog" ){
          about.innerHTML=`<p id="about"><span style="font-weight:bold;">SimpleBlog</span> -
           пример использования фреймворка React</p>`
      } else {
        about.innerHTML=`<p id="about"><span style="font-weight:bold;">Ravenous</span> -
         SPA на React и Yelp API</p>`
      }

          $(".info").show();

          $(".info").find("p").animate({
            marginLeft:'5%'
          },400)
      })
  }

});
