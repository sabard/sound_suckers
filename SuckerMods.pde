 // We first implement 4 different species of Sucker

// low fre
public class LFSucker extends Sucker {
  PShape body;
  
  private void setConstrAttrs() {
    setSize(80);
    setOrigSize(80);
    setSpd(100); 
    setOrigSpd(100);
    setAggr(int(randomGaussian() * 10 + 10));
    setLbdo(int(randomGaussian() * 10 - 10));
    body = loadShape("bac0.svg");
  }
  
  public LFSucker(float hp) {
     super(0, hp);
     setConstrAttrs();
  }
  
  public LFSucker(float hp, int x, int y) {
     super(0, hp, x, y);
     setConstrAttrs();
  }
  
  public void draw() {
    body.disableStyle();  // Ignore the colors in the SVG
    int[] clr = clr();
    stroke(clr[0], clr[1], clr[2]);
    fill(clr[0], clr[1], clr[2]);
    int size = getSize();
    //ellipse(x(), y(), size, size);
    shape(body, x()-size/2, y()-size/2, size, size);
  }
  
  public void reloadAttrs() {
    setSize(int(origSize() * hp()/(START_HP)));
    setSpd(int(origSpd() * hp()/(START_HP)));
  }
}

public class MLSucker extends Sucker {
  PShape body; 
  
  private void setConstrAttrs() {
    setSize(60);
    setOrigSize(60);
    setSpd(100);
    setOrigSpd(100);
    setAggr(int(randomGaussian() * 10 + 5));
    setLbdo(int(randomGaussian() * 10 - 5));
    body = loadShape("bac1.svg");
  }
  
  public MLSucker(float hp) {
     super(1, hp);
     setConstrAttrs();
  }
  
  public MLSucker(float hp, int x, int y) {
     super(1, hp, x, y);
     setConstrAttrs();
  }
  
  public void draw() {
    body.disableStyle();
    int[] clr = clr();
    stroke(clr[0], clr[1], clr[2]);
    fill(clr[0], clr[1], clr[2]);
    int size = getSize();
    //ellipse(x(), y(), size, size);
    shape(body, x()-size/2, y()-size/2, size, size);
  }
  
  public void reloadAttrs() {
    setSize(int(origSize() * hp()/(START_HP)));
  }
}

public class MHSucker extends Sucker {
  PShape body;
  
  private void setConstrAttrs() {
    setSize(40);
    setOrigSize(40);
    setSpd(100);
    setOrigSpd(100);
    setAggr(int(randomGaussian() * 10 - 5));
    setLbdo(int(randomGaussian() * 10 + 5));
    body = loadShape("bac2.svg");
  }
  
  public MHSucker(float hp) {
    super(2, hp);
    setConstrAttrs();
  }
   
  public MHSucker(float hp, int x, int y) {
     super(2, hp, x, y);
     setConstrAttrs();
  }

  public void draw() {
    body.disableStyle();
    int[] clr = clr();
    stroke(clr[0], clr[1], clr[2]);
    fill(clr[0], clr[1], clr[2]);
    int size = getSize();
    //rect(x() - size/2.0, y() - size/2.0, size, size);  
    shape(body, x()-size/2, y()-size/2, size, size);
  }
  
  public void reloadAttrs() {
    setSpd(int(origSpd() * hp()/(START_HP)));
  }
}

public class HFSucker extends Sucker {
  private void setConstrAttrs() {
    setSize(20);
    setOrigSize(20);
    setSpd(80);
    setOrigSpd(80);
    setAggr(int(randomGaussian() * 10 - 10));
    setLbdo(int(randomGaussian() * 10 + 20));
  }
  
  public HFSucker(float hp) {
    super(3, hp);
    setConstrAttrs();
  }
   
  public HFSucker(float hp, int x, int y) {
     super(3, hp, x, y);
     setConstrAttrs();
  }  

  public void draw() {
    int[] clr = clr();
    stroke(clr[0], clr[1], clr[2]);
    fill(clr[0], clr[1], clr[2]);
    int size = getSize();
    ellipse(x() - size/2.0, y() - size/2.0, size, size);
    //shape(body, x()-size/2, y()-size/2, size, size);
  }
  
  public void reloadAttrs() {
    setSpd(int(origSpd() * hp()/(START_HP)));
  }
}
