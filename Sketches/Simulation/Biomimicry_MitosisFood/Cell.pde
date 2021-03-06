
float CELL_RADIUS = 6;
float CELL_PARTICLE_MASS = 1;
float CELL_ATTRACTION = 20;
float CELL_REPULSION = -30;

int maxCellPopulation = 200;

int minLifespan = 30;
int maxLifespan = 80;

//int minGrowthInterval = 20;
//int maxGrowthInterval = 40;



class Cell {
  Particle p;
  
  int lifespan;
//  int timeToReproduce;

  float radius;
  ArrayList<Attraction> attractions;
  boolean shouldDie;
  float eatRate;
  float reproduceAfterEating;
  float amountEaten;
  
  Cell(float x, float y) {
    this.p = ps.makeParticle(CELL_PARTICLE_MASS, x, y, 0.0);
    
    this.radius = CELL_RADIUS;
    this.attractions = new ArrayList<Attraction>();
    this.shouldDie = false;
    
    this.eatRate = 0.01;
    this.amountEaten = 0.0;
    this.reproduceAfterEating = 0.5;
    
    if (ENABLE_LIFESPAN)
      this.lifespan = int(random(minLifespan, maxLifespan));

//    resetReproductionTime();
  }
  
  void resetReproductionTime() {
//    this.timeToReproduce = int(random(minGrowthInterval, maxGrowthInterval));
  }
  
  void reproduce(){
    if (cells.size() > maxCellPopulation) return;
    
    float x = this.p.position().x();
    float y = this.p.position().y();
    
    Cell c = new Cell(x + random(-1, 1), y + random(-1, 1));
    cells.add(c);
    
    for (int i = 0; i < cells.size(); i ++) {
      Cell other = cells.get(i);
      if (other.p != c.p) {
        if (ENABLE_COHESION){
          Attraction a1 = ps.makeAttraction(other.p, c.p, CELL_ATTRACTION, this.radius * 2);
          other.attractions.add(a1);
          c.attractions.add(a1);
        }
        
        Attraction a2 = ps.makeAttraction(other.p, c.p, CELL_REPULSION, this.radius / 2);
        other.attractions.add(a2);
        c.attractions.add(a2);
      }
    }
  }
  
  void tick() {
    if (ENABLE_LIFESPAN)
      this.lifespan--;
    
//    this.timeToReproduce--;
    
    float x = this.p.position().x();
    float y = this.p.position().y();
    
    // Adds a lifespan to the cell. After it lives this long, it dies.
    if (ENABLE_LIFESPAN && this.lifespan == 0){
      this.shouldDie = true;
    }
    else 
    if (food.getFoodAt(x, y) < 0.0001){
      this.shouldDie = true;
    }
    // Adds a reproduction time to the Cell. After it lives this long, then it reproduces.
//    else if (this.timeToReproduce == 0) {
//      this.reproduce();
//      resetReproductionTime();
//    }
    else
    if (this.amountEaten > this.reproduceAfterEating) {
      this.reproduce();
      this.amountEaten = 0.0;
    }
    
    this.amountEaten += this.eatRate;
    food.eatAt(x, y, this.eatRate);
  }
  
  void checkForDeath() {
    if (this.shouldDie) die();
  }
  
  void die() {
    for (int i = 0; i < this.attractions.size(); i ++ ) {
      Attraction a = this.attractions.get(i);
      ps.removeAttraction(a);
    }
    ps.removeParticle(this.p);
    cells.remove(this);
  }
  
  void draw() {
    float x = this.p.position().x();
    float y = this.p.position().y();
    ellipse(x, y, this.radius * 2, this.radius * 2);
  }
    
}

