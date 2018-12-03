void spawnSuckers() {
  for (int i = 0; i < numSpecies; i++) {
    //float spawnDecision = randomGaussian() * suckerStd + spectrum[i]; // fix so not direct mapping to spectrum
    // later, could have the number spawned be some function of this decision variable
    // right now, only spawns one
    boolean spawned = false;
    if (specieEnergies[i] > START_HP) { 
      spawnSucker(i, START_HP);
      specieEnergies[i] -= START_HP;
      spawned = true;
    }
    if ((spawned || suckersPerSpecies[i] == maxPerSpecies) && specieEnergies[i] > 0) {
      // have current suckers consume extra energy
      extraEnergies[i] = specieEnergies[i]/suckersPerSpecies[i];
    } else {
      extraEnergies[i] =  0;
    }
  }
}

// spawn sucker given species s, hp, and optional location
Sucker spawnSucker(int s, float hp, int x, int y, boolean randomLoc) {
  Sucker sucker = null;
  if (s == 0) {
    if (suckersPerSpecies[s] < maxPerSpecies) {
      if (randomLoc) sucker = new LFSucker(hp);
      else sucker = new LFSucker(hp, x, y);
      suckersPerSpecies[s]++;
    }
  }
  else if (s == 1) {
    if (suckersPerSpecies[s] < maxPerSpecies) {
      if (randomLoc) sucker = new MLSucker(hp);
      else sucker = new MLSucker(hp, x, y);
      suckersPerSpecies[s]++;
    }
  }
  else if (s == 2) {
    if (suckersPerSpecies[s] < maxPerSpecies) {
      if (randomLoc) sucker = new MHSucker(hp);
      else sucker = new MHSucker(hp, x, y);
      suckersPerSpecies[s]++;
    }
   }
  else {
    if (suckersPerSpecies[s] < maxPerSpecies) {
      if (randomLoc) sucker = new HFSucker(hp);
      else sucker = new HFSucker(hp, x, y);
      suckersPerSpecies[s]++;
    }
  }
  if (sucker != null) {
    suckers.add(sucker);
  }
  return sucker;
}

// overloader for spawn sucker at random location
Sucker spawnSucker(int s, float hp) {
  return spawnSucker(s, hp, 0, 0, true);
}

// overloader for spawn sucker at specific location
Sucker spawnSucker(int s, float hp, int x, int y) {
  return spawnSucker(s, hp, x, y, false);
}

// create interactions
void suckerInteract(Sucker s1) {
  float minDist = height * width;
  Sucker s2;
  for (int i = 0; i < suckers.size(); i++) {   
    s2 = suckers.get(i);
    if (s1 == s2) continue;
    float dist = s1.dist2Between(s2);
    if (dist < minDist) {
       minDist = dist;
       s1.setNN(s2);
    }
    if (s1.interactable(s2)) {
      if (!s1.busy() && !s1.oncd() && !s2.busy() && !s2.oncd()) {
        Interaction inter = new Interaction(s1, s2);
        interactions.add(inter);
      }
    }
  }
}

// draw heart for mating
void drawHeart(int x, int y, int size) {
  heart.disableStyle();  // Ignore the colors in the SVG
  fill(255, 192, 203);   // Set the SVG fill to pink
  stroke(255, 192, 203); // Set the SVG stroke to pink
  shape(heart, x-size/2, y-size/2, size, size);
}

// draw explosion for fighting
void drawExplosion(int x, int y, int size) {
  explosion.disableStyle(); // Ignore the colors in the SVG
  fill(255, 0, 0);          // Set the SVG fill to red
  stroke(255, 0, 0);        // Set the SVG stroke to red
  shape(explosion, x-size/2, y-size/2, size, size);
}

// determine energies that are available per species for distribution each frame
void seedEnergies() {
  for (int i = 0; i < numSpecies; i++) {
     for (int j = specieBands[i]; j < specieBands[i+1]; j++) {
       specieEnergies[i] += SPAWN_RATE*spectrum[j] - BACKGROUND_NOISE;
       if (specieEnergies[i] < 0) specieEnergies[i] = 0;
     }
  }
}
