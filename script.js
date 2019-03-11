const cards=document.getElementsByClassName("card");
console.log(cards)

for (let i=0; i<cards.length; i++){
  cards[i].classList.add("hide");
}

for (let i=0; i<cards.length; i++){
  setTimeout(addAnimation.bind(null,i),i*400);
}


function addAnimation(i) {
  console.log(i)
  cards[i].classList.remove("hide");
}
