
int ruaCarteira;
int tentativaAtual = 0;
int tentativas = 0;
int pontuacao = 1000;
boolean encontrou = false;
boolean gameOver = false;

PFont fonte;

void setup() {
  size(800, 600);
  smooth();
  noStroke();
  
  fonte = createFont("Arial", 24);
  textFont(fonte);
  
  reiniciarJogo();
}

void draw() {
  background(10, 20, 40);
  desenharEstrelas();
  desenharTitulo();
  desenharMarciano();
  desenharInterface();
  desenharFeedback();
  desenharPontuacao();
  
  if (gameOver) {
    desenharBotaoReiniciar();
  }
}

void desenharEstrelas() {
  fill(255, 255, 255, random(150, 255));
  for (int i = 0; i < 100; i++) {
    if (random(1) > 0.95) {
      ellipse(random(width), random(height/2), random(1, 3), random(1, 3));
    }
  }
}

void desenharTitulo() {
  fill(50, 200, 150);
  textSize(36);
  textAlign(CENTER);
  text("JOGO DO MARCIANO", width/2, 60);
  
  fill(200, 200, 255);
  textSize(18);
  text("Encontre sua carteira em uma das 100 ruas!", width/2, 90);
}

void desenharMarciano() {
  fill(0, 200, 100);
  ellipse(width/2, 180, 120, 80);
  
  fill(255);
  ellipse(width/2 - 30, 170, 30, 40);
  ellipse(width/2 + 30, 170, 30, 40);
  
  fill(0);
  ellipse(width/2 - 30, 170, 15, 20);
  ellipse(width/2 + 30, 170, 15, 20);
  
  noFill();
  stroke(0);
  strokeWeight(2);
  arc(width/2, 190, 40, 20, 0, PI);
  noStroke();
}

void desenharInterface() {
  fill(255, 150);
  rect(width/2 - 100, 300, 200, 50, 10);
  
  textSize(24);
  textAlign(CENTER, CENTER);
  if (tentativaAtual == 0) {
    fill(100);
    text("Digite 1-100", width/2, 325);
  } else {
    fill(0);
    text(tentativaAtual, width/2, 325);
  }
  
  fill(50, 150, 200);
  rect(width/2 - 80, 370, 160, 50, 10);
  fill(255);
  textSize(20);
  text("PROCURAR", width/2, 395);
}

void desenharFeedback() {
  if (tentativas > 0 && !encontrou && !gameOver) {
    String dica = (tentativaAtual < ruaCarteira) ? "MAIS A FRENTE!" : "JA PASSOU!";
    int cor = (tentativaAtual < ruaCarteira) ? color(100, 200, 100) : color(200, 100, 100);
    
    fill(cor);
    textSize(22);
    text(dica, width/2, 270);
  }
  
  if (encontrou) {
    fill(100, 255, 150);
    textSize(28);
    text("ENCONTROU NA RUA " + ruaCarteira + "!", width/2, 270);
    textSize(20);
    text("Tentativas: " + tentativas, width/2, 470);
  }
  
  if (gameOver && !encontrou) {
    fill(255, 100, 100);
    textSize(28);
    text("FIM DE JOGO!", width/2, 270);
    textSize(20);
    text("A carteira estava na rua " + ruaCarteira, width/2, 470);
  }
}

void desenharPontuacao() {
  fill(255, 200, 0);
  textSize(24);
  textAlign(LEFT);
  text("PONTUACAO: " + pontuacao, 50, 550);
  
  float progresso = map(pontuacao, 0, 1000, 0, width-100);
  fill(255, 200, 0, 100);
  rect(50, 570, progresso, 10);
}

void desenharBotaoReiniciar() {
  fill(100, 200, 100);
  rect(width/2 - 100, 500, 200, 50, 10);
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("JOGAR NOVAMENTE", width/2, 525);
}

void reiniciarJogo() {
  ruaCarteira = (int)random(1, 101);
  tentativaAtual = 0;
  tentativas = 0;
  pontuacao = 1000;
  encontrou = false;
  gameOver = false;
}

void mousePressed() {
  if (mouseX > width/2 - 80 && mouseX < width/2 + 80 && 
      mouseY > 370 && mouseY < 420 && !gameOver && tentativaAtual > 0) {
    tentativas++;
    
    if (tentativaAtual == ruaCarteira) {
      encontrou = true;
      gameOver = true;
    } else {
      pontuacao = max(0, pontuacao - 50);
      
      if (pontuacao <= 0) {
        gameOver = true;
      }
    }
  }
  
  if (gameOver && mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
      mouseY > 500 && mouseY < 550) {
    reiniciarJogo();
  }
}

void keyPressed() {
  if (!gameOver) {
    if (key >= '0' && key <= '9') {
      if (tentativaAtual == 0) {
        tentativaAtual = key - '0';
      } else {
        tentativaAtual = tentativaAtual * 10 + (key - '0');
      }
      tentativaAtual = min(tentativaAtual, 100);
    } else if (key == BACKSPACE || key == DELETE) {
      tentativaAtual = tentativaAtual / 10;
    } else if (key == ENTER || key == RETURN) {
      if (tentativaAtual > 0) {
        mousePressed();
      }
    }
  }
}
