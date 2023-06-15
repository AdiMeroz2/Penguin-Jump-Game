public class Button
{
  PVector Pos = new PVector(0,0);
  float Width = 200;
  float Height = 100;
  color Color;
  String Text;
  boolean Pressed = false;
  boolean Clicked = false;
  
  public Button(int x, int y, String t, int r, int g, int b){
    Pos.x = x;
    Pos.y = y;
    Color = color(r, g, b);
    Text = t;
  }
  
  void update(){
    if(mousePressed == true && mouseButton == LEFT && Pressed == false)
    {
      Pressed = true;
      if(mouseX >= Pos.x && mouseX <= Pos.x + Width && mouseY >= Pos.y && mouseY <= Pos.y+Height)
      {
        Clicked = true;
      }
    }
    else
    {
      Clicked = false;
      Pressed = false;
    }
  }
  
  void render()
  {
    fill(Color);
    rect(Pos.x, Pos.y, Width, Height);
    
    fill(0);
    textAlign(CENTER, CENTER);
    text(Text, Pos.x+(Width/2), Pos.y+(Height/2));
  }
  
  boolean isClicked()
  {
    return Clicked;
  }
}
