//added
import processing.serial.*;
Serial myPort;
String val;

//added
float parent_max_score = 0;
final static String ACTION_RIGHT = "RIGHT";
final static String ACTION_LEFT = "LEFT";
final static String ACTION_JUMP = "JUMP";

//declare global variables
final static float GRAVITY = 0.1;
final static float MOVE_SPEED = 3.15;
final static float ICE_SIZE = 100;
final static float RIGHT_MARGIN = 400;
final static float STAR_SIZE = 25;
//game over
float game_over_score = 20;
boolean start_game;
boolean show_setting;
boolean game_over;
boolean win_game;
int game_over_timer;
boolean game_over_timer_activate = false;
boolean show_jumping_face;

//added
boolean baby_pressure_text = false;
boolean parent_pressure_text = false;
//float baby_pressure = 0;
//float parent_pressure = 0;

Penguin baby_penguin;
Penguin parent_penguin;

final static float BABY_GROUND = 490;
final static float BABY_FALL_GROUND = 500;
final static float PARENT_GROUND = 790;
final static float COIN_X = 250;

final static float END_GAME_TEXT_X = 100;
final static float END_GAME_TEXT_Y = 300;
//final static float FEEDBACK_TEXT_X = 250;
//final static float FEEDBACK_TEXT_Y = 90;
//final static float FEEDBACK_TEXT_SIZE = 50;
final static float FEEDBACK_TEXT_BABY_X = 150;
final static float FEEDBACK_TEXT_BABY_Y = 340;
final static float FEEDBACK_TEXT_PARENT_X = 150;
final static float FEEDBACK_TEXT_PARENT_Y = 600;
final static float FEEDBACK_TEXT_SIZE = 50;
float score;
final static float SCORE_TEXT_Y = 50;
final static float SCORE_TEXT_SIZE = 25;
boolean try_harder_message = false;

//cordination of 
Iceberg goal;
PImage sea_img;
PImage parent_img;
PImage child_img;
PImage jump_face;
//PImage star_img;
ArrayList<Iceberg> platforms;
ArrayList<Star> bonus;

float view_x;
float score_text_x;

Button start_game_button;
Button difficulties_button;
Button easy_button;
Button medium_button;
Button hard_button;


//todo new score system


void setup(){
  //back ground
  size(800, 900);
  imageMode(CENTER);
  sea_img = loadImage("data/sea.png");
  sea_img.resize(800,900);
  //initialize image
  child_img = loadImage("data/baby_stand.png");
  parent_img = loadImage("data/parent_stand.png");
  jump_face = loadImage("data/faceHappy.png");
  //initialize baby penguin
  baby_penguin = new Penguin(child_img, 1.0, 60, BABY_GROUND -5);
  baby_penguin.change_x = 0;
  baby_penguin.change_y = 0;
  //initialize parent penguin
  parent_penguin = new Penguin(parent_img, 1.0, 60, PARENT_GROUND- 5);
  parent_penguin.change_x = 0;
  parent_penguin.change_y = 0;
  //default values
  score = 0;
  view_x = 0;
  score_text_x = 100;
  //initialize game status
  start_game = false;
  show_setting = false;
  game_over = false;
  win_game = false;
  game_over_timer_activate = false;
  
  platforms = new ArrayList<Iceberg>();
  bonus = new ArrayList<Star>();
  createPlatforms("ice_list.csv");
  
  start_game_button = new Button(150, 500, "start new game", 0, 100,200);
  difficulties_button = new Button(450, 500, "difficulty level", 0, 100,200);
  easy_button = new Button(300, 250, "easy", 0, 200,250);
  medium_button = new Button(300, 400, "medium", 0, 170,230);
  hard_button = new Button(300, 550, "hard", 0, 120,200);
  
  //added
  //String portName = Serial.list()[0];
  //if (myPort == null) {
  //  myPort = new Serial(this, portName, 9600);
  //}
}

void draw(){
  background(255);
  image(sea_img, 400, 450);
  //start game menu
  if(start_game == false && show_setting == false){
    play_start_menu();
  }
  //settings
  else if(start_game == false && show_setting == true){
    play_settings();
  } 
  // play game
  else{
    scroll();
    display();
    resolveGroundCollision(parent_penguin, PARENT_GROUND);
    if(game_over && game_over_timer < millis()){
      run_gameover();
    }
    else{
      run_game();
      }
  }
}

void run_game(){
  if(baby_penguin.getBottom() < BABY_GROUND && show_jumping_face == true){
    //jumping
      baby_penguin.talk(jump_face);
  }
  if(parent_penguin.get_score() - baby_penguin.get_score() >= game_over_score){
    //parent got much more score before reaching goal
    child_img = loadImage("data/baby_sit.png");
    baby_penguin.setBottom(BABY_FALL_GROUND);
    baby_penguin.change_x = 0;
    game_over=true;
    if(game_over_timer_activate == false){
      //start the counter after game over
      game_over_timer = millis() + 1000;
      game_over_timer_activate = true;
    }
  }
  else if(baby_penguin.getLeft() > goal.getLeft() && baby_penguin.getBottom() >= BABY_GROUND){
    //won the game
    child_img = loadImage("data/baby_end.png");
    baby_penguin.talk(loadImage("data/heart.png"));
    baby_penguin.setBottom(BABY_GROUND);
    baby_penguin.change_x = 0;
    game_over=true;
    win_game = true;
    if(game_over_timer_activate == false){
      game_over_timer = millis() + 1000;
      game_over_timer_activate = true;
    }
  }
  else{
    //continue game
    resolveGroundCollision(baby_penguin, BABY_GROUND);
    for(Star s: bonus){
      resolveBonusCollision(baby_penguin, s);
    }
    //added
    //processEvents();
  }
}

//added
void processEvents() {
if (myPort.available() > 0)
  {
    val = myPort.readStringUntil('\n');
    String[] eventString = val.split(" "); 
    String action = eventString[0];
    if (eventString.length > 1) {
      float score_input = float(val.split(" ")[1]);
      actionPerformed(action, score_input);   
    } else {
      actionPerformed(ACTION_JUMP, 0);
    }
  }
}


void run_gameover(){
    if(win_game){
      baby_penguin.talk(loadImage("data/heart.png"));
      baby_penguin.setBottom(BABY_GROUND);
      fill(0, 0, 0);
      textSize(70);
      text("Congradulations!", view_x + END_GAME_TEXT_X, END_GAME_TEXT_Y);
      textSize(50);
      text("press any key", view_x + END_GAME_TEXT_X, END_GAME_TEXT_Y + 90);
    }
    else{
      baby_penguin.setBottom(BABY_FALL_GROUND);
      fill(0, 0, 0);
      textSize(70);
      text("game over", view_x + END_GAME_TEXT_X, END_GAME_TEXT_Y);
      textSize(50);
      text("press any key", view_x + END_GAME_TEXT_X, END_GAME_TEXT_Y + 90);
    }
}

void display(){
  for(Iceberg i: platforms){
    i.display();
  }
  //display baby
  baby_penguin.display(child_img);
  baby_penguin.update();
  //display parent
  parent_penguin.display(parent_img);
  parent_penguin.update();
  //display bonus
  for(Star s: bonus){
    if(s.getTouched()==false){
      // do not display a bonus that is touched
      s.display();
    }
  }
  if(try_harder_message == true && baby_penguin.getLeft() > 80 && game_over==false){
      textSize(FEEDBACK_TEXT_SIZE);
      text("try a bit harder!", baby_penguin.getLeft() + FEEDBACK_TEXT_BABY_X, FEEDBACK_TEXT_BABY_Y - 70);
  }
  else if (baby_penguin.getLeft() > 80 && game_over==false){
      textSize(FEEDBACK_TEXT_SIZE);
      text("Good !",  baby_penguin.getLeft() + FEEDBACK_TEXT_BABY_X, FEEDBACK_TEXT_BABY_Y - 50);  
  }
  //added
  if (baby_pressure_text && game_over==false) {
      textSize(FEEDBACK_TEXT_SIZE);
      text((int)baby_penguin.get_pressure(), baby_penguin.getLeft() + FEEDBACK_TEXT_BABY_X, FEEDBACK_TEXT_BABY_Y);  
  }
  
  if (parent_pressure_text && game_over==false) {
      textSize(FEEDBACK_TEXT_SIZE);
      text((int)parent_penguin.get_pressure(), parent_penguin.getLeft() + FEEDBACK_TEXT_PARENT_X, FEEDBACK_TEXT_PARENT_Y);
  }
  print_score();
}

void print_score(){
  fill(0, 0, 0);
  textSize(SCORE_TEXT_SIZE);
  //text("parent: "+ parent_penguin.get_pressure(), score_text_x, SCORE_TEXT_Y);
  //text("child: "+ baby_penguin.get_pressure(), score_text_x, SCORE_TEXT_Y * 2);
  text("score: " + score, score_text_x, SCORE_TEXT_Y *3);
}

void keyPressed(){
  if(game_over == false){
    if(key == 'a' && baby_penguin.getBottom() >= BABY_GROUND && baby_penguin.getRight() < parent_penguin.getLeft()){
      baby_pressure_text  = true;
      baby_penguin.change_y = -MOVE_SPEED;
      baby_penguin.change_x = MOVE_SPEED;
      baby_penguin.add_score(10);
      baby_penguin.set_pressure(10);
      score += 10;
      try_harder_message = false;
      show_jumping_face = true;
      jump_face = loadImage("data/faceHappy.png");
      child_img = loadImage("data/baby_jump_good.png");
    }
    else if(key == 's' && baby_penguin.getBottom() >= BABY_GROUND && baby_penguin.getRight() < parent_penguin.getLeft()){
      baby_pressure_text  = true;
      baby_penguin.change_y = -MOVE_SPEED;
      baby_penguin.change_x = MOVE_SPEED;
      baby_penguin.add_score(5);
      baby_penguin.set_pressure(5);
      score += 5;
      try_harder_message = true;
      show_jumping_face = true;
      jump_face = loadImage("data/drops.png");
      child_img = loadImage("data/baby_jump_bad.png");
    }
    else if(key == 'z' && parent_penguin.getBottom() >= PARENT_GROUND && parent_penguin.getLeft() < baby_penguin.getRight()){
      baby_pressure_text = false;
      parent_pressure_text = true;
      parent_penguin.change_y = -MOVE_SPEED;
      parent_penguin.change_x = MOVE_SPEED;
      parent_penguin.add_score(10);
      parent_penguin.set_pressure(10);
      parent_img = loadImage("data/parent_jump.png");
    }
    if(key == 'j' && baby_penguin.getBottom() >= BABY_GROUND ){
      baby_penguin.change_y = -MOVE_SPEED*1.2;
      show_jumping_face = false;
    }
  }
  else{
  if(keyPressed){
    restart_game();
    }
  }
}

void restart_game(){
  translate(0,0);
  setup();
}


void resolveGroundCollision(Penguin p, float ground_h){
  // checks if the penguin is on the ground
  p.change_y += GRAVITY;
  p.center_y += p.change_y;
  if(p.getBottom() > ground_h){
    p.setBottom(ground_h + 3);
    p.change_x = 0;
    if(p == baby_penguin){
      child_img = loadImage("data/baby_stand.png");
    }
    if(p == parent_penguin){
      parent_img = loadImage("data/parent_stand.png");
    }
  }
}

void resolveBonusCollision(Penguin p, Star s){
  if(p.getTop() < s.getBottom() && p.getRight() >s.getRight() && p.getLeft() < s.getLeft() && s.getTouched() == false){
    score +=10;
    s.touched();
  }
}


void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col =0; col < values.length; col++){
      if(values[col].equals("1")){
        //print("entered");
        Iceberg ice = new Iceberg(loadImage("data/ice_1.png"), 1, 200, 100);
        ice.center_x = col * ICE_SIZE + 45;
        ice.center_y = row * (ICE_SIZE*0.75) + 120;
        platforms.add(ice);
        print(ice.getLeft()+ " " );
      }
      else if(values[col].equals("2")){
        Iceberg ice = new Iceberg(loadImage("data/ice_2.png"), 1, 200, 100);
        ice.center_x = col * ICE_SIZE+ 55;
        ice.center_y = row * (ICE_SIZE*0.75) + 120;
        platforms.add(ice);
        print(ice.getLeft()+ " " );
      }
      else if(values[col].equals("3")){
        Iceberg ice = new Iceberg(loadImage("data/ice_3.png"), 1, 200, 100);
        ice.center_x = col * ICE_SIZE + 45;
        ice.center_y = row * (ICE_SIZE*0.75) + 120;
        platforms.add(ice);
        print(ice.getLeft()+ " " );
      }
      else if(values[col].equals("4")){
        Iceberg ice = new Iceberg(loadImage("data/ice_4.png"), 1, 200, 100);
        ice.center_x = col * ICE_SIZE + 45;
        ice.center_y = row * (ICE_SIZE*0.75) + 120;
        platforms.add(ice);
        print(ice.getLeft()+ " " );
      }
      else if(values[col].equals("5")){
        Iceberg ice = new Iceberg(loadImage("data/ice_5.png"), 1, 200, 100);
        ice.center_x = col * ICE_SIZE+ 45;
        ice.center_y = row * (ICE_SIZE*0.75) + 120;
        platforms.add(ice);
        print(ice.getLeft()+ " " );
      }
      else if(values[col].equals("6")){
        goal = new Iceberg(loadImage("data/222.png"), 1, 320, 500);
        goal.center_x = col * ICE_SIZE+ 120;
        goal.center_y = row * (ICE_SIZE*0.75) + 230;
        //goal.resize_ice(350, 400);
        platforms.add(goal);
        print("goal:" + goal.getLeft()+ " " );
      }
      else if(values[col].equals("7")){
        Star star = new Star(1, col*100 + 50, COIN_X);
        bonus.add(star);
      }
    }
  }
}

void scroll(){
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if(baby_penguin.getRight() > right_boundary){
    view_x += baby_penguin.getRight() - right_boundary;
    score_text_x += baby_penguin.getRight() - right_boundary;
  }
  translate(-view_x, 0);
}

void play_start_menu(){
    fill(0, 0, 0);
    textSize(25);
    if(start_game_button.isClicked())
    {
      start_game = true;
    }
    if(difficulties_button.isClicked()){
      show_setting = true;
    }
    start_game_button.update();
    start_game_button.render();
    difficulties_button.update();
    difficulties_button.render();
}

void play_settings(){
    fill(0, 0, 0);
    textSize(25);
    if(easy_button.isClicked())
    {
      game_over_score = 40;
      show_setting = false;
    }
    else if(medium_button.isClicked())
    {
      game_over_score = 30;
      show_setting = false;
    }
    else if(hard_button.isClicked())
    {
      game_over_score = 20;
      show_setting = false;
    }
    easy_button.update();
    easy_button.render();
    medium_button.update();
    medium_button.render();
    hard_button.update();
    hard_button.render();
}

//added
void actionPerformed(String action, float pressure_input) {
  if (game_over == false) {
    println(action);
    println(baby_penguin.getRight() < parent_penguin.getLeft());
    
    if (action.equals(ACTION_RIGHT) && baby_penguin.getBottom() >= BABY_GROUND && baby_penguin.getRight() < parent_penguin.getLeft()) {
      baby_pressure_text = true;
      baby_penguin.set_pressure(pressure_input);
      println("performing right");
      baby_penguin.change_y = -MOVE_SPEED;
      baby_penguin.change_x = MOVE_SPEED;
      if (parent_penguin.get_pressure() - pressure_input > 80) {
         // doesn't have to be 80, could be any number
         baby_penguin.add_score(10);
         score += 5;
         baby_penguin.set_pressure(pressure_input);
         try_harder_message = true;
         show_jumping_face = true;
         jump_face = loadImage("data/drops.png");
         child_img = loadImage("data/baby_jump_bad.png");
       }
       else {
         baby_penguin.add_score(10);
         score += 10;
         baby_penguin.set_pressure(pressure_input);
         try_harder_message = false;
         show_jumping_face = true;
         jump_face = loadImage("data/faceHappy.png");
         child_img = loadImage("data/baby_jump_good.png");
       }
       
    } else if (action.equals(ACTION_LEFT) && parent_penguin.getBottom() >= PARENT_GROUND && parent_penguin.getLeft() < baby_penguin.getRight()) {
      baby_pressure_text = false;
      parent_pressure_text = true;
      parent_penguin.set_pressure(pressure_input);
      parent_penguin.change_y = -MOVE_SPEED;
      parent_penguin.change_x = MOVE_SPEED;
      parent_penguin.add_score(10);
      parent_penguin.set_pressure(pressure_input);
      parent_img = loadImage("data/parent_jump.png");
    }
    
    if (action.equals(ACTION_JUMP) && baby_penguin.getBottom() >= BABY_GROUND) {
      baby_pressure_text = false;
      parent_pressure_text = false;
      baby_penguin.change_y = -MOVE_SPEED*1.2;
    }
  }   
  else{
    if(keyPressed){
      restart_game();
    }
  }
}
