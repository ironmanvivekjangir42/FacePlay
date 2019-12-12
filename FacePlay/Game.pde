import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
PImage bg;

int numFrames=6;
int currentFrame=0;
PImage[] run =new PImage[numFrames];
PImage background;
PImage slide;
PImage ground1;
PImage stand;
PImage jump;
PImage shur;
PImage rock;
PImage enemy;
PVector Track;
PVector EnemyLoc;
int jumpStat=0;
int[] jumpLoc = {480/2,480/3,480/4,480/5,480/6,480/6,480/6,480/6,480/5,480/4,480/3,480/2};
int groundLocation=0;
int Yloc;
int GameState=0;
int Score=0;
int ObjectState=0;
int hitcount=10;
Boolean mov=true;
int player=0;
int slideDur=0;
JSONObject scr1,scr2;
int s1,s2;


void setup()
{
  size(640,480);
  frameRate(10);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  
  scr1 = loadJSONObject("data1.json");
  scr2 = loadJSONObject("data2.json");
  s1 =scr1.getInt("scr");
  s2 =scr2.getInt("scr");
  
  //images
  run[0] = loadImage("game_images/run/sasuke_run_0001.png");
  run[1] = loadImage("game_images/run/sasuke_run_0002.png");
  run[2] = loadImage("game_images/run/sasuke_run_0003.png");
  run[3] = loadImage("game_images/run/sasuke_run_0004.png");
  run[4] = loadImage("game_images/run/sasuke_run_0005.png");
  run[5] = loadImage("game_images/run/sasuke_run_0006.png");
  background = loadImage("game_images/sky.jpg");
  ground1 = loadImage("game_images/ground.png");
  stand = loadImage("game_images/sasuke_stand.png");
  jump = loadImage("game_images/sasuke_jump.png");
  rock = loadImage("game_images/rock.png");
  shur = loadImage("game_images/shuriken.png");
  enemy = loadImage("game_images/enemy.png");
  slide = loadImage("game_images/sliding.png");
  Track =new PVector(0,0);
  EnemyLoc = new PVector(0,0);

}

void draw()
{
  background(background);
  opencv.loadImage(video);
  fill(0,50);
  noStroke();
  //strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println("faces ="+faces.length);
  //image(video, 0, 0 );
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    if(i<=0){
    rect(((width/2)-faces[i].x+(faces[i].x)/10)*2,( faces[i].y+(faces[i].y)/3)*2, 50, 50);
    fill(0,20,200);
    noStroke();
    
    //rect(((width/2)-faces[i].x),( faces[i].y), 50+5, 50+5);
    Track.set(((width/2)-faces[i].x+(faces[i].x)/10)*2,( faces[i].y+(faces[i].y)/3)*2);
    }
    
  } 
  
  

  image(ground1,groundLocation,0);
  image(ground1,groundLocation+639,3);
  
  
  if(GameState==0)
  {
    color(255);
    fill(255);
    stroke(2);
    rect(50,50,width-100,height-100);
    textSize(50);
    fill(0,0,255);
    stroke(2);
    text("press 1 for player 1",100,100);
    text("press 2 for player 2",100,200);
    
    //GameState=1;
  }
  //__________________________________________________________________________________________________________________________________________________________________________________
  //__________________________________________________________________________________________________________________________________________________________________________________
  
  if(GameState==1){
    //rock
    
    if(groundLocation+width-60<=0){//-60
     //decide enemy or rock,,, update enemystate 
     if(mov==true){
       ObjectState=int(random(3));
       int temp =int(random(2));
       if(temp==1 && ObjectState==2)
       {
         ObjectState=0;
       }
     }
     println(ObjectState);
    }
    if(ObjectState==0){
      image(rock,groundLocation+width-60,2*height/3-20);
      EnemyLoc.set(groundLocation+width-60,2*height/3);
    }
    if(ObjectState==1){
      //shurikanes
      //circle(groundLocation+width-60,2*height/3,50);
      image(shur,groundLocation+width-60,2*height/3);
      EnemyLoc.set(groundLocation+width-60,2*height/3);
    }
    if(ObjectState==2){
      //enemy
      fill(255,0,0);
      //circle(groundLocation+width-60,2*height/3,100);
      image(enemy,groundLocation+width-60,height/2);
      EnemyLoc.set(groundLocation+width-60,2*height/3);
    }
    fill(0,102,153);
    textSize(18);
    text("Score =",10,20);
    text(str(Score),80,20);
    fill(255,50,150);
    textSize(25);
    text("Life = ",10,50);
    text(hitcount,80,50);
    
    
    //charecter movements
    if(Track.x>width/2){
      Score=Score+1;
      groundLocation=groundLocation-60;
      if(groundLocation<=-640)groundLocation=0;
      currentFrame = (currentFrame+1)%numFrames;
      if(Track.y<height/3){
        jumpStat=(jumpStat+1)%12;
      }
      if(jumpStat!=0 && jumpStat<11 && Track.y<height/3){
        jumpStat=(jumpStat+1)%12;
        image(jump,width/7,jumpLoc[jumpStat]);
        Yloc=jumpLoc[jumpStat];
        mov=true;
        slideDur=0;
      }
      if(Track.y>300){
        if(slideDur==25){
          slideDur=0;
        }
        else if(slideDur<15){
          image(slide,width/7,300);
          Yloc=height/5;
          slideDur++;
        }
        else{
          image(run[currentFrame],width/7,height/2);
          Yloc=height/2;
        }
        mov=true;
      }
      if((Track.y<300 && Track.y>height/3)){
        image(run[currentFrame],width/7,height/2);
        Yloc=height/2;
        slideDur=0;
        mov=true;
      }
    }
    else{
      image(stand,width/7,height/2);
      mov=false;
    }
    if(ObjectState==1)
    {
      if(EnemyLoc.x>=width/7 && EnemyLoc.x<=(width/7)+50){
        if(EnemyLoc.y>=Yloc && EnemyLoc.y<=Yloc+100)
        {
          if(Score>=10){
            hitcount=hitcount-1;
            Score=Score-10;
            if(hitcount==0)
            {
              GameState=2;
            }
          }
        }
      }
    }
    if(ObjectState==2){
      if(EnemyLoc.x>=width/7 && EnemyLoc.x<=(width/7)+10){
        if(EnemyLoc.y>=Yloc && EnemyLoc.y<=Yloc+150)
        {
          GameState=2;
          hitcount=hitcount-5;
          Score=Score-10;
          if(hitcount<=0)
          {
            GameState=2;
          }
        }
      }
    }
  }
  
  //__________________________________________________________________________________________________________________________________________________________________________________
  //__________________________________________________________________________________________________________________________________________________________________________________
  
  if(GameState==2)
  {
    textSize(72);
    text("Game Over",100,100);
    fill(255,44,44);
    textSize(48);
    text("your score=",100,200);
    text(Score,400,200);
    s1 =scr1.getInt("scr");
    s2 =scr2.getInt("scr");
    fill(0,0,255);
    if(player==0){
      text("High Score =",100,300);
      text(s1,400,300);
    }
    if(player==1){
      text("High Score =",100,300);
      text(s2,400,300);
    }
    //_________________________________________________________________
    //_________________________________________________________________
    
    if(player==0){
      if(Score>s1){
        scr1.setInt("scr",Score);
        saveJSONObject(scr1,"data1.json");
      }
    }
    if(player==1){
      if(Score>s2){
        scr2.setInt("scr",Score);
        saveJSONObject(scr2,"data2.json");

      }
    }    
  }
}

void keyPressed()
{
  GameState=0;
  Score=0;
  hitcount=10;
  
  if(key=='1')
  {
    player=0;
    GameState=1;
  }
  if(key=='2')
  {
    player=1;
    GameState=1;
  }
  if(key=='3')
  {
    player=2;
    GameState=1;
  }
}

void captureEvent(Capture c) {
  c.read();
}
