public static int INTERACTION_TIME = 60;  // duration of interactions
public static float NOM_EFFICIENCY = 1.0; // ratio of energy translated during figiht

// defines an interaction between two suckers
public class Interaction {
  private Sucker s1;
  private Sucker s2;
  private boolean noaction;
  private boolean fight;
  private int time;
  private boolean active;
  
  public Interaction(Sucker sucker1, Sucker sucker2) {
    s1 = sucker1;
    s2 = sucker2;
    time = 0;
    noaction = true;
    decideInteraction();
    active = true;
    s1.setBusy(true);
    s2.setBusy(true);
  }
  
  // mate occurs semi-randomly based of libido
  private void decideMate() {
    if (s1.lbdo() + s2.lbdo() + randomGaussian() * 10 > 0) {
      noaction = false;
      fight = false;
    }
  }
  
  // fight happens semi-randomly based off agressiveness
  private void decideFight() {
    if (s1.aggr() + s2.aggr() + randomGaussian() * 10 > 0) {
      noaction = false;
      fight = true;
    }
  }
  
  public Sucker s1() { return s1; }
  public Sucker s2() { return s2; }
  
  // end the interaction and create necessary objects for interaction conclusion (birth, death, etc.)
  public void end() {
    if (noaction) {
      s1.setBusy(false);
      s2.setBusy(false);
      return;
    }
    if (fight) {
      // fight end
      // kill one and give their resources to the other
      // fight is fairly determined by size
      Sucker winner;
      Sucker loser;
      if (s1.getSize() + randomGaussian() * 40 > s2.getSize()) {
        winner = s1;
        loser = s2;
      } else {
       winner = s2;
       loser = s1;
      }
      winner.heal(loser.hp() * NOM_EFFICIENCY);
      loser.die();
    } else {
      // mate end
      // spawn new if there is room under max
      if (suckersPerSpecies[s1.species()] < maxPerSpecies) {
        float s1hp = s1.hp()/3;
        float s2hp = s2.hp()/3;
        Sucker s = spawnSucker(s1.species(), START_HP, (s1.x() + s2.x())/2, (s1.y() + s2.y())/2);
        s1.damage(s1hp);
        s2.damage(s2hp);
        s.setvx(int(random(30)));
        s.setvy(int(random(30)));
      }
      s1.age(DEATH_AGE/4);
      s2.age(DEATH_AGE/4);
    }
    s1.setBusy(false);
    s2.setBusy(false);
  }
  
  public boolean expired() {
    return !active;
  }
  
  public boolean defunct() {
    return noaction; 
  }
  
  // age the interaction by one timestep
  public void progress() { 
    time++; 
    if (time > INTERACTION_TIME) {
       active = false ;
    }
  } 
  
  // decide if this should be a fight or mate interaction (or no interaction)
  public void decideInteraction() {    
    if (s1.species() == s2.species()) {
      // could be mate or fight
      if (s1.lbdo() + s2.lbdo() > s1.aggr() + s2.aggr() + randomGaussian() * 10) {
        // mate  
        decideMate();
      }
      else {
        decideFight(); 
      }
    }
    else {
      // must be fight
      decideFight();
    }
  }
  
  // draw the interaction
  public void draw() {
    if (noaction) return;
    
    if (fight) {
      s1.fight(time);
      s2.fight(time);
    }
    else {
      s1.mate(time);
      s2.mate(time);
    }
  }
}
