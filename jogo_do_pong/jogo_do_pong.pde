int paddleWidth = 10, paddleHeight = 80;
int ballSize = 15;
int leftPaddleY, rightPaddleY;
int leftPaddleX = 20, rightPaddleX;
int ballX, ballY, ballSpeedX = 5, ballSpeedY = 5;
int leftScore = 0, rightScore = 0;
int paddleSpeed = 6;
boolean isSinglePlayer = true; 
boolean gameStarted = false; 

void setup() {
  size(800, 400);
  rightPaddleX = width - 30;
  leftPaddleY = rightPaddleY = height / 2 - paddleHeight / 2;
  resetBall();
}

void draw() {
  background(0);
  if (!gameStarted) {
    showMenu();
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
    rightPaddleY += paddleSpeed - 2;
  } else if (ballY < rightPaddleY + paddleHeight / 2) {
    rightPaddleY -= paddleSpeed - 2;
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
    resetBall();
  }
  if (ballX >= width) {
    leftScore++;
    resetBall();
  }
}

void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = (random(1) > 0.5) ? 5 : -5;
  ballSpeedY = (random(1) > 0.5) ? 5 : -5;
}

void displayScore() {
  textSize(32);
  fill(255);
  text(leftScore, width / 4, 50);
  text(rightScore, 3 * width / 4, 50);
}

void keyPressed() {
  if (!gameStarted) {
    if (key == '1') {
      isSinglePlayer = true;
      gameStarted = true;
    } else if (key == '2') {
      isSinglePlayer = false;
      gameStarted = true;
    }
  }
}
