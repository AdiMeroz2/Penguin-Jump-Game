public class Iceberg{
  PImage ice_img;
  float w, h;
  float center_x, center_y;
    
  public Iceberg(String filename, int scale, float x, float y){
    ice_img = loadImage(filename);
    int sx = int(ice_img.width) / scale;
    int sy = int(ice_img.height) / scale;
    ice_img.resize(sx,sy);
    center_x = x;
    center_y = y;
  }
  
  //public Iceberg(PImage img, float scale){
  //  ice_img = img;
  //  w = ice_img.width * scale;
  //  h = ice_img.height * scale;
  //  ice_img.resize(200,100);
  //  center_x = 0;
  //  center_y = 0;
  //  //print(getLeft()+ " " );
  //}
  
  public Iceberg(PImage img, float scale, int x, int y){
    ice_img = img;
    ice_img.resize(x,y);
    w = ice_img.width * scale;
    h = ice_img.height * scale;
    center_x = 0;
    center_y = 0;
    //print(getLeft()+ " " );
  }
  
  public void display(){
    image(ice_img, center_x, center_y);
  }
  
  void resize_ice(int x, int y){
      ice_img.resize(x,y);
  }
  float getLeft(){
  return center_x - w/2;
  }
  
  float getRight(){
  return center_x + w/2;
  }
  
  float getTop(){
  return center_y - 0.25*(h/2);
  }
  
  float getBottom(){
  return center_y + h/2;
  }
}
