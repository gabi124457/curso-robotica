import processing.serial.*;
import processing.sound.*;

SoundFile menuSong;
SoundFile gameSong;

Serial myPort;
ArrayList<Integer> x = new ArrayList<Integer>(), y = new ArrayList<Integer>();
int[] dx = {0, 0, 1, -1}, dy = {1, -1, 0, 0};

int w = 30, h = 30, bs = 20, dir = 2;
int applex = 12, appley = 10;
int newdir = 0;

int score = 0;
int state = 0;
float s = 0;

PImage img1;
PImage img2;

boolean gameover = false;
String inString;

void setup() {
  size(600, 600);
  smooth(2);
  
  x.add(5);
  y.add(5);
  
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil(10);
  
  menuSong = new SoundFile(this, "menu_song_2.mp3");
  gameSong = new SoundFile(this, "apple_eat_2.wav");
  
  menuSong.play();
  menuSong.amp(0.5);
  gameSong.amp(0.5);
  
  img1 = loadImage("menu.png");
  img2 = loadImage("menu_02.png");
}

void draw() {
  background(0);
  frameRate(60);
  
  if(state == 0) {
    s += 0.25;
    if(s > 10) {
      s = 0;
    }
    
    image(img1, 100, 80, 400, 400);
    
    fill(50, 190, 70);
    rect(width/2, height/2 + 40, 260 + s, 60 + s, 10);
    
    textSize(40);
    fill(0);
    textAlign(CENTER);
    text("PLAY GAME", width/2, (height/2) + 53);
    
    if (mousePressed && mouseX > 180 && mouseX < 410 && mouseY > 300 && mouseY < 350) {
      state ++;
      //gameSond.play();
    }
  }
  
  else if(state > 0) {
    snake();
  }
}

void snake() {
  background(0);
  
  menuSong.stop();
  
  for(int i = 0; i < w; i++) line(i*bs, 0, i*bs, height);
  for(int i = 0; i < h; i++) line(0, i*bs, width, i*bs);
  for(int i = 0; i < x.size(); i++) {
    fill(0, 255, 0);
    rect(x.get(i)*bs, y.get(i)*bs, bs, bs);
  }
  
  fill(50, 190, 70);
  textSize(20);
  text("SCORE:", 50, 42);
  text(score, 105, 42);
  
  if(!gameover) {
    
    fill(255, 0, 0);
    rect(applex*bs, appley*bs, bs, bs);
    
    if(frameCount%5==0) {
      x.add(0, x.get(0) + dx[dir]);
      y.add(0, y.get(0) + dy[dir]);
      
   if(x.get(0) < 0 || y.get(0) < 0 || x.get(0) >= w || y.get(0) >= h)
   gameover = true;
   
   for(int i = 1; i < x.size(); i++)
   if(x.get(0) == x.get(i) && y.get(0) == y.get(i)) gameover = true;
   
   if(x.get(0) == applex && y.get(0) == appley) {
     applex = (int)random(0, w);
     appley = (int)random(0, h);
     
     score++;
     gameSong.play();
   }
   
   else {
     x.remove(x.size() - 1);
     y.remove(y.size() - 1);
    }
   }
  }
  
  else {
    fill(50, 190, 70);
    textSize(50);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2 - 80);
    
    textSize(20);
    textAlign(CENTER);
    text("Score:", width/2 - 15, (height/2) - 50);
    text(score, width/ + 25, (height/2) - 50);
    
    gameSong.stop();
    
    textAlign(CENTER);
    text("SPACE: Jogar Novamente", width/2, (height/2) + 10);
    
    textAlign(CENTER);
    text("ESC: Sair", width/2, (height/2) + 60);
    
    if(keyPressed && key==' '){
       x.clear();
       y.clear();
       
       x.add(5);
       y.add(5);
       
       //file.play();
       gameover = false;
       score = 0;
       
       state -= 1;
       
       gameSong.stop();
       menuSong.play();
    }
  }
}

void serialEvent(Serial p) {
  inString = p.readString();
  
  float inInt = float(inString);
  
  int newdir = inInt==0.0 ? 0 : (inInt==1.0 ? 1 : (inInt==2.0 ? 2 : (inInt==3.0 ? 3 : -1)));
  if (newdir != -1 && (x.size() <= 1 || !(x.get(1) == x.get(0) +
  dx[newdir] && y.get(1) == y.get(0) + dy[newdir]))) dir = newdir;
}

void keyPressed() {
  int newdir = key=='s' ? 0 : (key=='w' ? 1 : (key=='d' ? 2 : (key=='a' ? 3 : -1)));
  if (newdir != -1 && (x.size() <= 1 || !(x.get(1) == x.get(0) +
  dx[newdir] && y.get(1) == y.get(0) + dy[newdir]))) dir = newdir;
}
