public static int DEATH_AGE = 1000;
public static float HP_INC = 0.1;
public static float START_HP = 100;

public abstract class Sucker {
  private int size;
  private int origSize;
  private int[] loc;
  private int [] vel;
  private boolean alive;
  private boolean busy;
  private int cd;  // cooldown
  private Sucker nearestNeighbor;
  
  // sucker has attributes:
  private int species;
  private float hp;   // health points. basically life force derived from audio signal
  private int aggr; // aggressiveness
  private int spd;  // speed
  private int origSpd;
  private int lbdo; // libido
  private int age;  // age
  private int[] clr; // color
  
  public Sucker(int spec, float health) {
    // initialize attributes
    species = spec;
    aggr = int(randomGaussian() * 100);
    lbdo = int(randomGaussian() * 100);
    clr = new int[3];
    for (int i = 0; i < 3; i++) {
      clr[i] = specieColors[species][i] + int(random(30));
      if (clr[i] < 0) clr[i] = 0;
      else if (clr[i] > 255) clr[i] = 255;
    }
    
    // initialize state variables
    alive = true;
    loc = new int[2];
    loc[1] = int(random(height - fftHeight - size) + size/2);
    loc[0] = int(random(width - size) + size/2);
    vel = new int[2];
    hp = health;
    busy = false;
    cd = 60; // do not interact for 1 second after spwn
    nearestNeighbor = null;
  }
  
  public Sucker(int spec, float health, int x, int y) {
     this(spec, health);
     loc[0] = x;
     loc[1] = y;
  }
  
  // getters
  public int x() { return loc[0]; }
  public int y() { return loc[1]; }
  public int vx() { return vel[0]; }
  public int vy() { return vel[1]; }
  public int spd() { return spd; }
  public int getSize() { return size; }
  public int species() { return species; }
  public int aggr() { return aggr; }
  public int lbdo() { return lbdo; }
  public boolean dead() { return !alive; };
  public int[] clr() { return clr; }
  public boolean busy() { return busy; }
  public boolean oncd() { return cd > 0; }
  public float hp() { return hp; }
  public int origSize() { return origSize; }
  public int origSpd() { return origSpd; }
  public Sucker nn() { return nearestNeighbor; }
  
  // setters
  public void setSize(int s) { size = s; }
  public void setSpecies(int s) { species = s; }
  public void setvx(int vx) { vel[0] = vx; }
  public void setvy(int vy) { vel[1] = vy; }
  public void setAggr(int a) { aggr = a; }
  public void setLbdo(int l) { lbdo = l; }
  public void die() { 
    suckersPerSpecies[species]--;
    alive = false; 
  }
  public void setSpd(int s) { spd = s; }
  public void setBusy(boolean b) { 
    if (b) {
      cd = 120;
    }
    busy = b; 
  }
  public void heal(float d) { 
    hp += d;
    reloadAttrs();
  }
  public void damage(float d) { 
    hp -= d; 
    reloadAttrs();
  }
  public void setOrigSize(int s) { origSize = s; }
  public void setOrigSpd(int s) { origSpd = s; }
  public void setNN(Sucker n) { nearestNeighbor = n; }
   
  // other methods
  public void busyClear() {
    if (busy) {
      vel[0] = 0;
      vel[1] = 0;
    }
  }
  
  // distance squared between this sucker and other
  public int dist2Between(Sucker other) {
    return (int)(Math.pow(other.loc[0] - loc[0], 2) + Math.pow(other.loc[1] - loc[1], 2));
  }
  
  // can this sucker intract with other? true if they are in contact
  public boolean interactable(Sucker other) {
    if (this == other) return false;
    return dist2Between(other) < Math.pow(size/2 + other.getSize()/2, 2);
  }
  
  // set velocities towards nearest neighbor with given delta
  public void towardsNN(int delvx, int delvy) {
    delvx *= Integer.signum(nn().x() - x());
    delvy *= Integer.signum(nn().y() - y());
    vel[0] += delvx;
    vel[1] += delvy;
  }
  
  public void awayNN(int delvx, int delvy) {
    delvx *= Integer.signum(x() - nn().x());
    delvy *= Integer.signum(y() - nn().y());
    vel[0] += delvx;
    vel[1] += delvy;
  }
  
  // increase age by one 
  public void age() {
    age += 1;
    cd -= 1;
    hp -= HP_INC;
  }
  
  // increase age by inc
  public void age(int inc) {
    age += inc; 
    cd -= inc;
    hp -= inc * HP_INC;
  }
  
  // update position based on current velocity
  // bounce off walls
  public void move() {
    if (busy) return;
    loc[0] += vel[0]; //int(random(5.0) - 2.5)
    if (loc[0] - size/2 < 0) {
      loc[0] = size/2;
      vel[0] = -vel[0];
    }
    else if (loc[0] + size/2 > width) {
     loc[0] = width - size/2;
     vel[0] = -vel[0];
    }
    loc[1] += vel[1]; //int(random(5.0) - 2.5); 
    if (loc[1] - size/2 < 0) {
      loc[1] = size/2;
      vel[1] = -vel[1];
    } else if (loc[1] + size/2 > height - fftHeight) {
     loc[1] = height - fftHeight - size/2;
     vel[1] = -vel[1];
    }
  }
  
  // draw animation for fight interaction
  public void fight(int frame) {
    drawExplosion(loc[0], loc[1], frame);
  }
  
  // draw animation for mate interaction
  public void mate(int frame) {
    drawHeart(loc[0], loc[1], frame);
  }
  
  // randomly die with age
  public boolean testDie() {
    if (age + randomGaussian() * 300 > DEATH_AGE) {
       die(); 
       return true;
    }
    return false;
  }
  
  public void updateVel() {
    // size is momentum
    busyClear();
    int delvx;
    int delvy;
    delvx = int(spd() * randomGaussian() / getSize());
    delvy = int(spd() * randomGaussian() / getSize());
    if (nn() != null) {
      if (nn().species() == 0) {
        if ((lbdo() > aggr() && lbdo() > 0) || (aggr() > lbdo() && aggr() > 0)) {
          // move towards nn
          towardsNN(delvx, delvy);
        } else {
          // move away from nn
          awayNN(delvx, delvy);
        }
      }
      else {
        if (aggr() > 0) {
          // move towards nn
          towardsNN(delvx, delvy);
        } else {
          // move awway from nn
          awayNN(delvx, delvy);
        }
      }
    } else {
      setvx(vx() + delvx);
      setvy(vy() + delvy); 
    }
  }
  
  // children classes must implement these methods
  public abstract void draw();
  // change attrs to reflect hp
  public abstract void reloadAttrs();
}
