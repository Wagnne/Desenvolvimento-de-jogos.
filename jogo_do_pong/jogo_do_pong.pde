int paddleWidth = 10, paddleHeight = 80;
int ballSize = 15;
int leftPaddleY, rightPaddleY;
int leftPaddleX = 20, rightPaddleX;
int ballX, ballY, ballSpeedX = 5, ballSpeedY = 5;
int leftScore = 0, rightScore = 0;
int paddleSpeed = 6;
int aiSpeed = 4;
boolean isSinglePlayer = true; 
boolean gameStarted = false; 
boolean gameOver = false;
boolean choosingDifficulty = false;
String winnerMessage = "";
String gameMode = "";

void setup() {
  size(800, 400);
  rightPaddleX = width - 30;
  leftPaddleY = rightPaddleY = height / 2 - paddleHeight / 2;
  resetBall();
}

void draw() {
  background(0);
  if (!gameStarted && !gameOver && !choosingDifficulty) {
    showMenu();
  } else if (choosingDifficulty) {
    showDifficultyMenu();
  } else if (gameOver) {
    showGameOver();
  } else {
    drawPaddles();
    drawBall();
    moveBall();
    movePaddles();
    checkScore();
    checkCollisions();
    displayScore();
  }
}

void showMenu() {
  textSize(32);
  fill(255);
  textAlign(CENTER);
  text("Escolha o modo de jogo", width / 2, height / 3);
  text("Pressione '1' para Jogar contra a Máquina", width / 2, height / 2);
  text("Pressione '2' para Jogar Player vs Player", width / 2, height / 2 + 40);
}

void showDifficultyMenu() {
  textSize(32);
  fill(255);
  textAlign(CENTER);
  text("Escolha a dificuldade", width / 2, height / 3);
  text("Pressione '1' para Fácil", width / 2, height / 2);
  text("Pressione '2' para Médio", width / 2, height / 2 + 40);
  text("Pressione '3' para Difícil", width / 2, height / 2 + 80);
}

void drawPaddles() {
  fill(255);
  rect(leftPaddleX, leftPaddleY, paddleWidth, paddleHeight);
  rect(rightPaddleX, rightPaddleY, paddleWidth, paddleHeight);
}

void drawBall() {
  ellipse(ballX, ballY, ballSize, ballSize);
}

void moveBall() {
  ballX += ballSpeedX;
  ballY += ballSpeedY;
}

void movePaddles() {
  if (keyPressed) {
    if (key == 'w' && leftPaddleY > 0) leftPaddleY -= paddleSpeed;
    if (key == 's' && leftPaddleY < height - paddleHeight) leftPaddleY += paddleSpeed;
    if (!isSinglePlayer) { 
      if (keyCode == UP && rightPaddleY > 0) rightPaddleY -= paddleSpeed;
      if (keyCode == DOWN && rightPaddleY < height - paddleHeight) rightPaddleY += paddleSpeed;
    }
  }
  
  if (isSinglePlayer) {
    aiMove(); 
  }
}

void aiMove() {
  if (ballY > rightPaddleY + paddleHeight / 2) {
    rightPaddleY += aiSpeed;
  } else if (ballY < rightPaddleY + paddleHeight / 2) {
    rightPaddleY -= aiSpeed;
  }
}

void checkCollisions() {
  if (ballY <= 0 || ballY + ballSize >= height) ballSpeedY *= -1;
  
  if (ballX <= leftPaddleX + paddleWidth && ballY >= leftPaddleY && ballY <= leftPaddleY + paddleHeight) {
    ballSpeedX *= -1;
  }
  if (ballX >= rightPaddleX - ballSize && ballY >= rightPaddleY && ballY <= rightPaddleY + paddleHeight) {
    ballSpeedX *= -1;
  }
}

void checkScore() {
  if (ballX + ballSize <= 0) {
    rightScore++;
    if (rightScore >= 3) {
      winnerMessage = "Jogador da Direita venceu!";
      gameOver = true;
      gameStarted = false;
    } else {
      resetBall();
    }
  }
  if (ballX >= width) {
    leftScore++;
    if (leftScore >= 3) {
      winnerMessage = "Jogador da Esquerda venceu!";
      gameOver = true;
      gameStarted = false;
    } else {
      resetBall();
    }
  }
}

void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
  int baseSpeed = 5;
  if (gameMode.equals("fácil")) baseSpeed = 3;
  if (gameMode.equals("difícil")) baseSpeed = 7;
  ballSpeedX = (random(1) > 0.5) ? baseSpeed : -baseSpeed;
  ballSpeedY = (random(1) > 0.5) ? baseSpeed : -baseSpeed;
}

void displayScore() {
  textSize(32);
  fill(255);
  text(leftScore, width / 4, 50);
  text(rightScore, 3 * width / 4, 50);
}

void showGameOver() {
  textSize(32);
  fill(255, 0, 0);
  textAlign(CENTER);
  text("Fim de Jogo", width / 2, height / 2 - 60);
  text(winnerMessage, width / 2, height / 2 - 20);
  textSize(20);
  fill(255);
  text("Pressione 'R' para tentar novamente", width / 2, height / 2 + 20);
  text("Pressione 'M' para voltar ao menu", width / 2, height / 2 + 50);
}

void keyPressed() {
  if (!gameStarted && !gameOver && !choosingDifficulty) {
    if (key == '1') {
      isSinglePlayer = true;
      choosingDifficulty = true;
    } else if (key == '2') {
      isSinglePlayer = false;
      gameMode = "médio";
      setDifficulty();
      startGame();
    }
  } else if (choosingDifficulty) {
    if (key == '1') {
      gameMode = "fácil";
      setDifficulty();
      startGame();
    } else if (key == '2') {
      gameMode = "médio";
      setDifficulty();
      startGame();
    } else if (key == '3') {
      gameMode = "difícil";
      setDifficulty();
      startGame();
    }
  } else if (gameOver) {
    if (key == 'r' || key == 'R') {
      gameStarted = true;
      gameOver = false;
      leftScore = 0;
      rightScore = 0;
      resetBall();
    } else if (key == 'm' || key == 'M') {
      gameOver = false;
      gameStarted = false;
      choosingDifficulty = false;
      leftScore = 0;
      rightScore = 0;
    }
  }
}

void setDifficulty() {
  if (gameMode.equals("fácil")) {
    aiSpeed = 2;
  } else if (gameMode.equals("médio")) {
    aiSpeed = 4;
  } else if (gameMode.equals("difícil")) {
    aiSpeed = 6;
  }
}

void startGame() {
  choosingDifficulty = false;
  gameStarted = true;
  gameOver = false;
  leftScore = 0;
  rightScore = 0;
  resetBall();
}
