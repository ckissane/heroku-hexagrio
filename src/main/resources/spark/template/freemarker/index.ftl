<!DOCTYPE html>

  <html>
      <head>
        <#include "header.ftl">
          <script src="https://cdn.firebase.com/js/client/2.2.1/firebase.js"></script>
          <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
          <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
          <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
          <style>
              #c {
                  width:100%;
                  height:100%;
                  background:white;
              }
              body {
                  margin:0;
              }
              div.popup {
                  display:absolute;
                  position: absolute;
                  top: calc(50% - 150px);
                  left: calc(50% - 150px);
                  width:300px;
                  border:none;
                  background:rgba(244, 244, 244, 1);
                  height:400px;
                  font-size:15px;
                  box-shadow: 10px 5px 5px black;
                  border-radius:20px;
                  color:black;
              }
              div.black {
                  display:absolute;
                  position: absolute;
                  width:100%;
                  border:none;
                  background:url("BK2.png");
                  height:100%;
                  font-size:15px;
                  color:black;
              }
              .name-input {
                  display:absolute;
                  position: absolute;
                  top: calc(50% - 15px);
                  left: calc(50% - 95px);
                  width:190px;
                  border:none;
                  height:30;
                  background:rgba(192, 192, 192, 0.5);
                  font-size:15px;
                  color:black;
              }
              .players-on-title {
                  font-size:30px;
                  color:black;
                  text-align:center;
              }
              .enter-username {
                  font-size:30px;
                  color:black;
                  text-align:center;
              }
              div.chat {
                  display:absolute;
                  position: absolute;
                  bottom:50;
                  left:10px;
                  width:210px;
                  border:none;
                  background:rgba(192, 192, 192, 0.5);
                  height:400px;
                  font-size:15px;
                  color:black;
                  overflow:hidden;
              }
              div.leaderboard {
                  display:absolute;
                  position: absolute;
                  top:10;
                  right:10px;
                  width:210px;
                  border:none;
                  background:rgba(192, 192, 192, 0.5);
                  height:400px;
                  font-size:15px;
                  color:black;
                  overflow:hidden;
              }
              .chat-input {
                  display:absolute;
                  position: absolute;
                  bottom:0;
                  left:10;
                  width:190px;
                  border:none;
                  border-top:1px solid black;
                  background:none;
                  outline:none;
                  height:30;
                  font-size:15px;
                  color:black;
              }
              .chat-list {
                  width:190px;
                  display:absolute;
                  position: absolute;
                  border:none;
                  list-style:none;
                  background:none;
                  outline:none;
                  font-size:15px;
                  color:black;
                  margin-top:10px;
              }
              .score-list {
                  margin-left:10px;
                  width:190px;
                  display:absolute;
                  position: absolute;
                  border:none;
                  list-style:none;
                  background:none;
                  outline:none;
                  font-size:15px;
                  color:black;
                  margin-top:10px;
              }
              .score-list chat {
                  width:190px;
                  padding:10px;
                  display:block;
                  font-size:20px;
              }
              .chat-list chat {
                  width:190px;
                  padding:10px;
                  display:block;
              }
              .coords {
                  display:absolute;
                  position: absolute;
                  top:10px;
                  left:10px;
                  border:none;
                  background:none;
                  text-align:center;
                  padding-top:7.5px;
                  padding-bottom:7.5px;
                  font-size:15px;
                  color:black;
                  background:rgba(192, 192, 192, 0.5);
                  width:210px;
              }
              .score {
                  padding-top:7.5px;
                  padding-bottom:7.5px;
                  display:absolute;
                  position: absolute;
                  bottom:10px;
                  left:10px;
                  border:none;
                  background:none;
                  font-size:15px;
                  width:210px;
                  text-align:center;
                  color:black;
                  background:rgba(192, 192, 192, 0.5);
              }
              #overlay {
                  display:absolute;
                  position: absolute;
                  left: 0px;
                  right: 0px;
                  top: 0px;
                  bottom: 0px;
                  z-index: 100;
                  display: block;
              }
          </style>

          <title>Hexagario
          </title>

      </head>

      <body>
        <!--<#include "nav.ftl">-->
          <div id="overlay">
              <st class="coords">Position: (3431, 4615)</st>
              <st class="score">Score: (25, Mass:25)</st>
              <div class="chat">
                  <chatlist class="chat-list">
                      <chat>hi</chat>
                      <chat>hello</chat>
                  </chatlist>
                  <input class="chat-input" value="" placeHolder="Type Here">
              </div>
              <div class="leaderboard">
                   <h1 class="players-on-title">Players Online</h1>
                  <scorelist class="score-list">
                      <chat>hi</chat>
                      <chat>hello</chat>
                  </scorelist>
              </div>
              <div class="black">

              </div>
              <div class="popup">
                   <h1 class="enter-username">Enter Username To Play</h1>
                  <input class="name-input" maxlength="17" value="" placeHolder="Username">
              </div>
          </div>

          <canvas id="c" width="1059" height="662"></canvas>
          <script defer="">
              // JavaScript
              console.log(Firebase.ServerValue.TIMESTAMP);
              var gameDown = false;
              if (gameDown == false) {
                  var serverTime = 0;
                  var w = $("body").width();
                  var h = $("body").height();
                  $("#c").attr("width", $("body").width());

                  $("#c").attr("height", $("body").height());
                  var c = document.getElementById("c");
                  var ctx = c.getContext("2d");
                  var mouseX = 0;
                  var mouseY = 0;
                  var mapsize = 10000;

                  function getCoords(event) {
                      mouseX = event.clientX;
                      mouseY = event.clientY;
                      //document.getElementById("demo").innerHTML = coords;
                  }

                  $("body").attr("onmousemove", "getCoords(event)");
                  //$("#c").attr("onmousedown", "alert(allPlayers.val())");
                  var username = 1;
                  var myOrganism = {

                      x: 5000,
                      y: 5000 + Math.random() * 100,
                      textName: readableName,
                      lastTick: Firebase.ServerValue.TIMESTAMP,
                      mass: 25,
                      size: 50,
                      color: color,
                      eaten: false,
                      dir: 0
                  };
                  var myOrgRef;
                  var readableName = "bob";
                  $(".name-input").keypress(function(e) {

                      if (e.which == '13') {
                          e.preventDefault();
                          readableName = $(".name-input").val();
                          $(".popup").hide();
                          $(".black").hide();
                          start();
                      }

                  });

                  var lastData;
                  var eatenPeople;
                  var lastChatData;
                  var color = Math.random() * 360;

                  var myDataRef = new Firebase('https://blobber.firebaseio.com/');
                  var eatenRef = myDataRef.child("eaten");
                  var timeRef = myDataRef.child("time");

                  var hexRatio = Math.sqrt(3) / 2
                  var myFoodRef = myDataRef.child("food");
                  var chatRef = myDataRef.child("chat");
                  chatRef.set(["server"])
                  //eatenRef.set(["server",{guyRef:"-K-QL1xGYbq7_rRA_c0y"}]);
                  //myFoodRef.set(["server"]);

                  $(".chat-input").keypress(function(e) {

                      if (e.which == '13') {
                          e.preventDefault();
                          var now = new Date();
                          var now_utc = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds());
                          chatRef.push({
                                  time: Firebase.ServerValue.TIMESTAMP,
                                  message: $(".chat-input").val(),
                                  user: readableName
                              });
                          $(".chat-input").val("");
                      }

                  });
                  var lastTick_utc;
                  var allPlayers;
                  var allFood;
                  //myDataRef.set({players: ["server"]});

                  function start() {

                      var nowTemp = new Date();
                      var now_utcTemp = Date.UTC(nowTemp.getUTCFullYear(), nowTemp.getUTCMonth(), nowTemp.getUTCDate(), nowTemp.getUTCHours(), nowTemp.getUTCMinutes(), nowTemp.getUTCSeconds(), nowTemp.getUTCMilliseconds());
                      username = 100;
                      lastTick_utc = now_utcTemp;






                      myOrganism = {

                          x: 00,
                          y: 5000 + Math.random() * 100,
                          textName: readableName,
                          lastTick: serverTime,
                          mass: 25,
                          size: 50,
                          color: color,
                          eaten: false,
                          dir: 0
                      };


                      while (allPlayers == null) {
                          console.log("lag");

                      }

                      myOrgRef = myDataRef.child("players").push(myOrganism);
                      myDataRef.child("players").orderByValue().once("value", function(snapshot) {
                          //console.log("value");
                          allPlayers = snapshot;
                          setInterval(tick, 1);
                          setInterval(clearIdiots, 1000);
                          setInterval(updateMyTick, 1);
                      });

                  }
                  //var list = $firebaseArray(ref);

                  function updateMyTick() {
                      myOrgRef.child("lastTick").set(Firebase.ServerValue.TIMESTAMP);
                  }

                  function tick() {
                      updateMyTick();
                      ctx.setTransform(1, 0, 0, 1, 0, 0);
                      w = $("body").width();
                      h = $("body").height();
                      $("#c").attr("width", $("body").width());

                      $("#c").attr("height", $("body").height());

                      var mouseDiffX = mouseX - w / 2;
                      var mouseDiffY = mouseY - h / 2;
                      var mouseDist = Math.sqrt(mouseDiffX * mouseDiffX + mouseDiffY * mouseDiffY);
                      if(readableName=="Cole"){
                          mouseDist*=2;
                      }
                      if (mouseDist < 20) {
                          mouseDist = 0;
                      }
                      var now = new Date();
                      var now_utc = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds());
                      var tickDelta = now_utc - lastTick_utc;
                      lastTick_utc = now_utc;
                      if (lastData) {
                          serverTime += tickDelta;
                          $("chatlist.chat-list").css("margin-top", (369 - $("chatlist.chat-list").height()));
                          $("chatlist.chat-list").html("");
                          $(".score-list").html("");
                          //if (lastData.child("players").child(myOrgRef.key()).val() != null) {
                          eatenPeople.forEach(function(data) {
                              if (data.val() == "server") {

                              } else {
                                  if (data.val().guyRef == myOrgRef.key()) {
                                      console.log("eaten");
                                      myOrganism = {

                                          x: 00,
                                          y: 5000 + Math.random() * 100,
                                          textName: readableName,
                                          lastTick: Firebase.ServerValue.TIMESTAMP,
                                          mass: 25,
                                          size: 50,
                                          color: color,
                                          eaten: false,
                                          dir: 0
                                      };


                                      eatenRef.child(data.key()).set(null);
                                      myOrgRef.set(myOrganism);
                                      return;
                                  }
                              }
                          });


                          // myDataRef.set({users: myDataRef.val().users.concat(["hi"])});
                          var hasMe = false;





                          if (lastData.child("players").child(myOrgRef.key()).val() != null) {
                              myOrganism = lastData.child("players").child(myOrgRef.key()).val();
                          }
                          var speed = 20 / Math.pow(myOrganism.size, 0.7) * tickDelta / 20;
                          myOrganism.x += mouseDiffX / 200 * Math.min(mouseDist, 200) / 100 * speed;
                          myOrganism.y += mouseDiffY / 200 * Math.min(mouseDist, 200) / 100 * speed;
                          myOrganism.x = Math.max(Math.min(myOrganism.x, 10000), 0);
                          myOrganism.y = Math.max(Math.min(myOrganism.y, 10000), 0);
                          //myOrganism.textName = readableName;
                          //myOrganism.size = Math.sqrt(myOrganism.mass) * 10;
                          //myOrganism.lastTick = Firebase.ServerValue.TIMESTAMP;
                          //myOrgansim.dir= myOrgansim.dir+1/(myOrganism.size);

                          myOrgRef.child("x").set(myOrganism.x);
                          myOrgRef.child("y").set(myOrganism.y);
                          //myOrgRef.child("y").set(myOrganism.size);

                          $(".coords").html("Position: (" + Math.floor(myOrganism.x) + ", " + Math.floor(myOrganism.y) + ")");
                          $(".score").html("Score: (" + Math.floor(myOrganism.size) + ", Mass:" + Math.floor(myOrganism.mass) + ")");







                          /*allPlayers.forEach(function(data) {
                                  if (data.val().lastTick) {
                                      if (Math.abs(now_utc - data.val().lastTick) > 1000) {
                                          myDataRef.child("players").child(data.key()).set(null);
                                      }
                                  }
                              });*/



                          ctx.clearRect(0, 0, w, h);

                          ctx.save();
                          ctx.translate(w / 2, h / 2);
                          var scaleToDo = Math.pow(myOrganism.size, 0.5);
                          ctx.scale(5 / scaleToDo, 5 / scaleToDo);
                          ctx.translate(-myOrganism.x, -myOrganism.y);

                          for (var i = -1000; i < 11001; i += 50) {
                              ctx.lineWidth = 1;
                              ctx.strokeStyle = "grey";
                              ctx.moveTo(i, -1000);
                              ctx.lineTo(i, 11000);
                              ctx.stroke();
                              ctx.lineWidth = 1;

                          }
                          for (var i = -1000; i < 11001; i += 50) {
                              ctx.lineWidth = 1;
                              ctx.strokeStyle = "grey";
                              ctx.moveTo(-1000, i);
                              ctx.lineTo(11000, i);
                              ctx.stroke();
                              ctx.lineWidth = 1;

                          }


                          ctx.moveTo(0, 0);
                          ctx.lineTo(10000, 0);
                          ctx.moveTo(0, 0);
                          ctx.lineTo(0, 10000);
                          ctx.moveTo(0, 10000);
                          ctx.lineTo(10000, 10000);
                          ctx.moveTo(10000, 0);
                          ctx.lineTo(10000, 10000);


                          ctx.stroke();
                          ctx.lineWidth = 10;
                          ctx.strokeStyle = "rgba(0,0,0,1)";
                          var foodCount = -1;
                          allFood.forEach(function(data) {
                              foodCount++;
                              if (foodCount > 0) {

                                  var o = data.val();
                                  var dirOffset = (serverTime / 10) % 60;
                                  if (Math.round(o.color) % 2 == 1) {
                                      dirOffset = -dirOffset;
                                  }
                                  ctx.lineWidth = 10;
                                  ctx.strokeStyle = "hsl(" + o.color + ",100%,40%)";

                                  ctx.fillStyle = "hsl(" + o.color + ",100%,50%)";
                                  ctx.lineCap = "round";
                                  ctx.lineJoin = "round";
                                  ctx.beginPath();
                                  //ctx.arc(o.x, o.y, Math.sqrt(1) * 10, 0, 2 * Math.PI);

                                  ctx.moveTo(o.x + 10 / hexRatio * dir(dirOffset).x, o.y + 10 / hexRatio * dir(dirOffset).y);
                                  for (var i = 1; i < 7; i++) {
                                      ctx.lineTo(o.x + 10 / hexRatio * dir(dirOffset + 60 * i).x, o.y + 10 / hexRatio * dir(dirOffset + 60 * i).y);
                                  }

                                  ctx.stroke();
                                  ctx.strokeStyle = "hsl(" + o.color + ",100%,10%)";
                                  ctx.fill();

                                  if (Math.sqrt(Math.pow(o.x - myOrganism.x, 2) + Math.pow(o.y - myOrganism.y, 2)) < myOrganism.size) {
                                      myFoodRef.child(data.key()).set(null);

                                      myOrgRef.child("mass").set(myOrganism.mass + 2);
                                      myOrgRef.child("size").set(Math.sqrt(myOrganism.mass + 2) * 10);
                                      //myOrganism.mass=myOrganism.mass + 2;
                                  }
                              }


                          });
                          var chatCount = -1;
                          lastChatData.forEach(function(data) {
                              chatCount++;
                              if (chatCount > 0) {
                                  if (Math.abs(serverTime - data.val().time) < 10000) {
                                      $("chatlist.chat-list").html($("chatlist.chat-list").html() + "<chat>" + data.val().user + ": " + data.val().message + "</chat>");
                                  } else {
                                      chatRef.child(data.key()).set(null);
                                  }
                              }
                          });
                          allPlayers.forEach(function(data) {
                              if (data.val() == "server") {

                              } else {

                                  $(".score-list").html($(".score-list").html() + "<chat>" + data.val().textName + ": " + Math.floor(data.val().size) + "</chat>");
                              }
                          });

                          var eatenGuys = [];
                          var eatenI = 0;
                          eatenPeople.forEach(function(data) {
                              if (data.val() == "server") {

                              } else {

                                  eatenGuys[eatenI] = data.val().guyRef;
                                  eatenI++;
                              }
                          });
                          allPlayers.forEach(function(data) {
                              if (data.val() == "server") {

                              } else {
                              var o = data.val();
                              var dirOffset = (serverTime / o.size) % 60;
                              if (Math.round(o.color) % 2 == 1) {
                                  dirOffset = -dirOffset;
                              }
                              ctx.lineWidth = 10;
                              ctx.strokeStyle = "hsl(" + o.color + ",100%,40%)";

                              ctx.fillStyle = "hsl(" + o.color + ",100%,50%)";
                              ctx.beginPath();
                              //ctx.arc(o.x, o.y, o.size, 0, 2 * Math.PI);
                              ctx.moveTo(o.x + o.size / hexRatio * dir(dirOffset).x, o.y + o.size / hexRatio * dir(dirOffset).y);
                              for (var i = 1; i < 7; i++) {
                                  ctx.lineTo(o.x + o.size / hexRatio * dir(dirOffset + 60 * i).x, o.y + o.size / hexRatio * dir(dirOffset + 60 * i).y);
                              }
                              ctx.stroke();
                              ctx.strokeStyle = "hsl(" + o.color + ",100%,10%)";
                              ctx.fill();
                              ctx.fillStyle = "white";
                              ctx.font = "30px Arial";
                              if (o.textName == "") {
                                  o.textName = "???";
                              }
                              var fontSize = Math.min(30 * (o.size * 2 - 5) / ctx.measureText(o.textName).width, o.size / 1.5);
                              ctx.font = "" + fontSize + "px Arial";
                              ctx.fillText(o.textName, o.x - ctx.measureText(o.textName).width / 2, o.y + fontSize / 140 * 50);

                              if (myOrgRef.key() != data.key()) {


                                  if (myOrganism.size * 0.8 > o.size) {
                                      if (Math.sqrt(Math.pow(o.x - myOrganism.x, 2) + Math.pow(o.y - myOrganism.y, 2)) < myOrganism.size - o.size / 2) {
                                          var targetEaten = false;
                                          for (var i = 0; i < eatenGuys.length; i++) {
                                              if (eatenGuys[i] == data.key()) {
                                                  targetEaten = true;

                                                  break;
                                              }
                                          }
                                          if (targetEaten == false) {
                                              eatenGuys[eatenGuys.length]=data.key();
                                              myDataRef.child("players").child(data.key()).child("eaten").set(true);

                                              eatenRef.push({
                                                      guyRef: data.key()
                                                  });

                                              myOrgRef.child("mass").set(myOrganism.mass + o.mass);
                                              myOrgRef.child("size").set(Math.sqrt(myOrganism.mass + o.mass) * 10);
                                              //myOrganism.mass=myOrganism.mass + o.mass;
                                          }

                                      }

                                  }
                              }
                              }
                          });





                          for (var i = 0; i < 2000 - foodCount; i++) {
                              var newFood = {
                                  x: Math.random() * 10000,
                                  y: Math.random() * 10000,
                                  color: "" + Math.random() * 360
                              };
                              myFoodRef.push(newFood);
                          }

                          ctx.restore();





                      }

                  }

              }

              function clearIdiots() {

                  if (lastData) {
                      allPlayers.forEach(function(data) {
                          if (data.val() == "server") {

                              } else {
                          if (myOrgRef.key() != data.key()) {
                              if (data.val().lastTick) {
                                  if (Math.abs(serverTime - data.val().lastTick) > 10000) {
                                      console.log("bye bye " + data.val().textName);
                                      console.log(serverTime + "," + data.val().lastTick);
                                      myDataRef.child("players").child(data.key()).set(null);

                                  }
                              }

                          }
                              }
                      });
                  }
              }

              function deg(x) {
                  return Math.PI * x / 180
              }

              function dir(i) {
                  return {
                      x: Math.cos(deg(i)),
                      y: Math.sin(deg(i))
                  };
              }
              myDataRef.on('value', function(snapshot) {
                  lastData = snapshot;
              });
              eatenRef.on('value', function(snapshot) {
                  eatenPeople = snapshot;
              });
              myDataRef.once('value', function(snapshot) {
                  lastData = snapshot;

              });
              myDataRef.child("players").orderByValue().on("value", function(snapshot) {
                  //console.log("value");
                  allPlayers = snapshot;
                  /*snapshot.forEach(function(data) {
          allPlayers[
      i++;

      });*/

              });
              myFoodRef.orderByValue().on("value", function(snapshot) {
                  //console.log("value");
                  allFood = snapshot;
                  /*snapshot.forEach(function(data) {
          allPlayers[
      i++;


      });*/

              });
              timeRef.on('value', function(snapshot) {
                  serverTime = snapshot.val();
                  timeRef.set(Firebase.ServerValue.TIMESTAMP);
              });
              chatRef.on("value", function(snapshot) {
                  //console.log("value");
                  lastChatData = snapshot;
                  /*snapshot.forEach(function(data) {
          allPlayers[
      i++;

      });*/

              });
          </script>

      </body>

  </html>
