#define VRx A1
#define VRy A0

void setup() {
  Serial.begin(9600);
}

void loop() {
  int x = analogRead(VRx);
  int y = analogRead(VRy);

  if (x > 650) {
    Serial.println(3); // Direita
  }
  else if (x < 350) {
    Serial.println(2); // Esquerda
  }
  else if (y < 350) {
    Serial.println(1); // Cima
  }
  else if (y > 650) {
    Serial.println(0); // Baixo
  }

  delay(150); // Pequeno atraso para evitar excesso de leitura
}
