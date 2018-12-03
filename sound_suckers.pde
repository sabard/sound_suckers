import processing.sound.*;
import java.util.Iterator;

// bugs:
// two mates with no refractory period is allowed
// same species can still mate sometimes?

public static float BACKGROUND_NOISE = 0.0;
public static float SPAWN_RATE = 50.0;

AudioIn in;                                     // audio stream
Amplitude amp;                                  // audio amplitude 
float ampLev;                                   // amplitude level—essentially the volume
FFT fft;                                        // fourier transform of audio signal 
// freq seems to be centered fairly low (maybe even less than 1khz? Coulld have large numbemr of bands and just pick a few
// Could calibrate by using sine tones
int bands = 32;                                 // number of frequency bands to use to divide up fourier signal
int multiplier = 78;                            // must be set to window width / bands
float[] spectrum = new float[bands];            // fourier spectrum—power level for each band
int fftHeight = 100;                            // height of fft bands along bottom of the window
int[][] specieColors = new int[bands][3];       // colors for each fourier band
float suckerStd = 0.2;                          // variance for sucker spawn decision
int numSpecies = 4;                             // number of species supported
int maxPerSpecies = 50;                         // maximum number of suckers of this species type
int[] suckersPerSpecies = new int[numSpecies];  // number of suckers alive for each species
int[] specieBands = new int[numSpecies+1];      // frequency band boundaries that each specie are listening to
float[] specieEnergies = new float[numSpecies]; // amount of food/energy resources available per specie
float[] extraEnergies = new float[numSpecies];  // leftover energy each frame to be distributed among suckers
// ArrayList of all suckers in the scene 
ArrayList<Sucker> suckers = new ArrayList<Sucker>();
// ArrayList of all interactions in the scene 
ArrayList<Interaction> interactions = new ArrayList<Interaction>();


PShape heart;
PShape explosion;

// setup code
void setup() {
  // set window size and background
  size(2496, 1380);
  //background(150, 0, 255);
  background(0);
  //frameRate(30);
  
  // set colors for each frequency band
  for (int i = 0; i < bands; i++) {
    specieColors[i][0] = int(random(255));
    specieColors[i][1] = int(random(255)); 
    specieColors[i][2] = int(random(255)); 
  }
  
  // specify here the frequencies that each specie is concerned with
  specieBands[0] = 0;
  specieBands[1] = 2;
  specieBands[2] = 4;
  specieBands[3] = 6;
  specieBands[4] = bands;
  
  heart = loadShape("heart.svg");
  explosion = loadShape("explosion.svg");
    
  // Create the Input stream
  amp = new Amplitude(this);
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  fft.input(in);
}   

void draw() {
  ampLev = amp.analyze();
  fft.analyze(spectrum);
  
  seedEnergies();
  
  //background(120, 30, 180);
  background(0);
  
  // spawn new suckers
  spawnSuckers(); 
  
  // process current suckers 
  Sucker curS;
  for (Iterator<Sucker> iterator = suckers.iterator(); iterator.hasNext();) {
    curS = iterator.next();
    curS.age();
    if (!curS.dead() && !curS.testDie()) {
      curS.heal(extraEnergies[curS.species()]);
      curS.updateVel();
      curS.move();
      curS.draw();
      suckerInteract(curS);
    }
    else {
      iterator.remove();
    }
  }
  
  // process interactions
  Interaction curI;
  for (Iterator<Interaction> iterator = interactions.iterator(); iterator.hasNext();) {
    curI = iterator.next();
    curI.progress();
    if (curI.expired() || curI.defunct()) {
      curI.end();
      iterator.remove();
    }
    curI.draw();
  }
  
  // draw fourier spectrum on bottom of window
  int i = 0;
  for (int j = 0; j < bands; j++) {
    if (j >= specieBands[i+1]) i++;
    stroke(specieColors[i][0], specieColors[i][1], specieColors[i][2]);
    fill(specieColors[i][0], specieColors[i][1], specieColors[i][2]);
    int fftBarHeight = int(2 * spectrum[j] * fftHeight);
    if (fftBarHeight > fftHeight) fftBarHeight = fftHeight;
    rect(multiplier * j, height - fftBarHeight, multiplier, fftBarHeight);
  }
}
