public class Penguin{
  PImage penguin_img;
  float center_x, center_y;
  float change_x, change_y;
  float w, h;
  float score;
  float pressure;
  
  public Penguin(PImage img, float scale, float x, float y){
    penguin_img = img;
    w = penguin_img.width * scale;
    h = penguin_img.height * scale;
    center_x = x;
    center_y = y;
    change_x = 0;
    change_y = 0;
    score = 0;
  }

  public void display(PImage image){
    image(image, center_x, center_y);
  }
  
  public void update(){
    center_x += change_x;
    center_y += change_y;
  }
  
  float getLeft(){
  return center_x - w/2;
  }
  
  float getRight(){
  return center_x + w/2;
  }
  
  float getTop(){
  return center_y - h/2;
  }
  
  float getBottom(){
  return center_y + h/2;
  }
  
  void setBottom(float bottom){
    center_y = bottom - h/2;
  }
  
  void add_score(float s){
    score = score + s;
  }
  
  float get_score(){
    return score;
  }
  
  void set_pressure(float p){
    pressure = p;
  }
  
  float get_pressure(){
    return pressure;
  }
  
  void talk(PImage img){
    image(img, center_x, center_y - 1.2 * w);
  }
  
}
