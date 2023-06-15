public class Star{
  PImage star_img;
  float corner_x, corner_y;
  float w, h;
  boolean touched;
  PImage[] star_img_lst = new PImage[6];
  int lst_index = 0;
  int next_image_timer;
  int TIME = 120;
  
  public Star(float scale, float x, float y){
    //w = star_img.width * scale;
    //h = star_img.height * scale;
    corner_x = x;
    corner_y = y;
    initialize_list();
    lst_index = 0;
    next_image_timer = millis() + TIME;
  }

  public void display(){
    //for(PImage i:star_img_lst){
    //  image(i, corner_x,corner_y);
    //}
    if(millis() > next_image_timer){
      if(lst_index == 5){
        lst_index = 0;
      }
      else{
        lst_index ++;
      }
      next_image_timer = millis() + TIME;
    }
    image(star_img_lst[lst_index], corner_x,corner_y);
  }
  
  void initialize_list(){
    add_Image("data/gold_1.png");
    add_Image("data/gold_2.png");
    add_Image("data/gold_3.png");
    add_Image("data/gold_4.png");
    add_Image("data/gold_5.png");
    add_Image("data/gold_6.png");
  }
  
  void add_Image(String image){
    star_img = loadImage(image);
    int sx = int(star_img.width) / 2;
    int sy = int(star_img.height) / 2;
    star_img.resize(sx,sy);
//imageMode(CENTER);
    star_img_lst[lst_index] = (star_img);
    lst_index += 1;
  }
  
  void get_cur_image_index(){
  
  }
  
  float getBottom(){
    return corner_y + h;
  }
  
  float getLeft(){
  return corner_x;
  }
  
  float getRight(){
  return corner_x + w;
  }
  
  boolean getTouched(){
    return touched;
  }
  
  void touched(){
    touched =true;    
  }
}
