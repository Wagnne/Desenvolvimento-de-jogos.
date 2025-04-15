
int[][] tabuleiro = new int[3][3]; 
int tamanhoQuadrado;
int margemTabuleiro = 50;


int jogadorAtual = 1; 
boolean jogoTerminado = false;
int vencedor = 0; 
boolean modoUmJogador = true; 
boolean menuInicial = true;
boolean jogadaComputador = false;

void setup() {
  size(500, 600);
  tamanhoQuadrado = (width - 2 * margemTabuleiro) / 3;
  resetarJogo();
  textAlign(CENTER, CENTER);
}

void draw() {
  background(240);
  
  if (menuInicial) {
    desenharMenuInicial();
  } else {
    desenharTabuleiro();
    desenharPecas();
    exibirStatusJogo();
    exibirBotaoReiniciar();
    exibirBotaoMenuInicial();
    
   
    if (modoUmJogador && jogadorAtual == 2 && !jogoTerminado && !jogadaComputador) {
      jogadaComputador = true;
      thread("jogarComputador");
    }
  }
}

void jogarComputador() {
  
  delay(500);
  

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiro[i][j] = 2;
        if (verificarVencedor() == 2) {
          verificarFimDeJogo();
          jogadorAtual = 1;
          jogadaComputador = false;
          return;
        }
        tabuleiro[i][j] = 0; 
      }
    }
  }
  
 
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiro[i][j] = 1;
        if (verificarVencedor() == 1) {
          tabuleiro[i][j] = 2;
          jogadorAtual = 1;
          jogadaComputador = false;
          return;
        }
        tabuleiro[i][j] = 0; 
      }
    }
  }
  
 
  if (tabuleiro[1][1] == 0) {
    tabuleiro[1][1] = 2;
    jogadorAtual = 1;
    jogadaComputador = false;
    return;
  }
  
 
  int[][] cantos = {{0, 0}, {0, 2}, {2, 0}, {2, 2}};
  for (int[] canto : cantos) {
    if (tabuleiro[canto[0]][canto[1]] == 0) {
      tabuleiro[canto[0]][canto[1]] = 2;
      jogadorAtual = 1;
      jogadaComputador = false;
      return;
    }
  }
  
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiro[i][j] = 2;
        jogadorAtual = 1;
        jogadaComputador = false;
        verificarFimDeJogo();
        return;
      }
    }
  }
  
  jogadaComputador = false;
}

void mousePressed() {
  if (menuInicial) {
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
        mouseY > height/2 - 50 && mouseY < height/2) {
      modoUmJogador = true;
      menuInicial = false;
      resetarJogo();
    }
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
        mouseY > height/2 + 20 && mouseY < height/2 + 70) {
      modoUmJogador = false;
      menuInicial = false;
      resetarJogo();
    }
  } else {
    if (mouseX > width/2 - 60 && mouseX < width/2 + 60 && 
        mouseY > height - 60 && mouseY < height - 20) {
      resetarJogo();
      return;
    }
    
    if (mouseX > width/2 - 60 && mouseX < width/2 + 60 && 
        mouseY > height - 100 && mouseY < height - 60) {
      menuInicial = true;
      return;
    }
    
    if (!jogoTerminado && !jogadaComputador) {
      int linha = (mouseY - margemTabuleiro) / tamanhoQuadrado;
      int coluna = (mouseX - margemTabuleiro) / tamanhoQuadrado;
      
      if (linha >= 0 && linha < 3 && coluna >= 0 && coluna < 3) {
        if (tabuleiro[linha][coluna] == 0) {
          tabuleiro[linha][coluna] = jogadorAtual;
          verificarFimDeJogo();
          
          jogadorAtual = (jogadorAtual == 1) ? 2 : 1;
        }
      }
    }
  }
}

void verificarFimDeJogo() {
  vencedor = verificarVencedor();
  if (vencedor > 0) {
    jogoTerminado = true;
  } 
  else {
    boolean temEspacos = false;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (tabuleiro[i][j] == 0) {
          temEspacos = true;
          break;
        }
      }
    }
    if (!temEspacos) {
      vencedor = 3; // Empate
      jogoTerminado = true;
    }
  }
}

int verificarVencedor() {
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][0] != 0 && tabuleiro[i][0] == tabuleiro[i][1] && tabuleiro[i][1] == tabuleiro[i][2]) {
      return tabuleiro[i][0];
    }
  }
  
 
  for (int j = 0; j < 3; j++) {
    if (tabuleiro[0][j] != 0 && tabuleiro[0][j] == tabuleiro[1][j] && tabuleiro[1][j] == tabuleiro[2][j]) {
      return tabuleiro[0][j];
    }
  }
  

  if (tabuleiro[0][0] != 0 && tabuleiro[0][0] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][2]) {
    return tabuleiro[0][0];
  }
  
  if (tabuleiro[0][2] != 0 && tabuleiro[0][2] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][0]) {
    return tabuleiro[0][2];
  }
  
  return 0; 
}

void resetarJogo() {
 
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      tabuleiro[i][j] = 0;
    }
  }
  jogadorAtual = 1;
  jogoTerminado = false;
  vencedor = 0;
  jogadaComputador = false;
}

void desenharMenuInicial() {
  fill(50);
  textSize(32);
  text("JOGO DA VELHA", width/2, height/4);
  

  if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
      mouseY > height/2 - 50 && mouseY < height/2) {
    fill(200);
  } else {
    fill(150);
  }
  rect(width/2 - 100, height/2 - 50, 200, 50, 10);
  
  
  if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
      mouseY > height/2 + 20 && mouseY < height/2 + 70) {
    fill(200);
  } else {
    fill(150);
  }
  rect(width/2 - 100, height/2 + 20, 200, 50, 10);
  
  fill(255);
  textSize(20);
  text("Um Jogador", width/2, height/2 - 25);
  text("Dois Jogadores", width/2, height/2 + 45);
}

void desenharTabuleiro() {
  stroke(0);
  strokeWeight(2);
  fill(255);
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      rect(margemTabuleiro + j * tamanhoQuadrado, 
           margemTabuleiro + i * tamanhoQuadrado, 
           tamanhoQuadrado, tamanhoQuadrado);
    }
  }
}

void desenharPecas() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = margemTabuleiro + j * tamanhoQuadrado + tamanhoQuadrado/2;
      float y = margemTabuleiro + i * tamanhoQuadrado + tamanhoQuadrado/2;
      
      if (tabuleiro[i][j] == 1) {
        
        stroke(255, 0, 0);
        strokeWeight(5);
        int offset = tamanhoQuadrado/4;
        line(x - offset, y - offset, x + offset, y + offset);
        line(x + offset, y - offset, x - offset, y + offset);
      } else if (tabuleiro[i][j] == 2) {
        
        stroke(0, 0, 255);
        strokeWeight(5);
        noFill();
        ellipse(x, y, tamanhoQuadrado/2, tamanhoQuadrado/2);
      }
    }
  }
}

void exibirStatusJogo() {
  fill(50);
  textSize(24);
  
  if (jogoTerminado) {
    if (vencedor == 1) {
      text("\nX venceu!", width/2, height - 150);
    } else if (vencedor == 2) {
      text("\nO venceu!", width/2, height - 150);
    } else {
      text("\nEmpate!", width/2, height - 150);
    }
  } else {
    String jogador = (jogadorAtual == 1) ? "X" : "O";
    String modo = modoUmJogador ? "\n\nModo: Um Jogador" : "\n\nModo: Dois Jogadores";
    
    if (modoUmJogador && jogadorAtual == 2) {
      text("\nVez do Computador (O)", width/2, height - 150);
    } else {
      text("\nVez do Jogador " + jogador, width/2, height - 150);
    }
    
    textSize(16);
    text(modo, width/2, height - 130);
  }
}

void exibirBotaoReiniciar() {

  if (mouseX > width/2 - 60 && mouseX < width/2 + 60 && 
      mouseY > height - 60 && mouseY < height - 20) {
    fill(200);
  } else {
    fill(150);
  }
  rect(width/2 - 60, height - 60, 120, 40, 10);
  
  fill(255);
  textSize(16);
  text("Reiniciar", width/2, height - 40);
}

void exibirBotaoMenuInicial() {
  
  if (mouseX > width/2 - 60 && mouseX < width/2 + 60 && 
      mouseY > height - 100 && mouseY < height - 60) {
    fill(200);
  } else {
    fill(150);
  }
  rect(width/2 - 60, height - 100, 120, 40, 10);
  
  fill(255);
  textSize(16);
  text("Menu Inicial", width/2, height - 80);
}
