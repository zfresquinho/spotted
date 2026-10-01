# Spotted — app Flutter

O repositório guarda só o código Dart (`lib/`) e o `pubspec.yaml`. As pastas de cada plataforma (`android/`, `ios/`…) geram-se **uma vez**, em cada computador:

```bash
cd app
flutter create . --project-name spotted --org pt.iade.spotted --platforms android,ios
flutter pub get
flutter run
```

> O `flutter create .` não substitui o `lib/main.dart` que já existe, só acrescenta o que falta. Depois de gerar `android/` e `ios/`, façam *commit* dessas pastas (o `.gitignore` já exclui o que é temporário), para todos terem a mesma configuração.

## Ligar à API local

1. Arrancar o servidor (`cd server && npm run dev`).
2. Em `lib/utils/config.dart`: emulador Android → `10.0.2.2`; telemóvel físico → IP do computador na mesma rede Wi-Fi.
3. O Android bloqueia `http://` por omissão. Em `android/app/src/main/AndroidManifest.xml`, acrescentar à tag `<application>`:
   ```xml
   android:usesCleartextTraffic="true"
   ```
   e, antes dela, `<uses-permission android:name="android.permission.INTERNET"/>`.

## Arquitetura (MVC)

```
lib/
├── main.dart            # arranque e providers
├── models/              # classes de dados (Spot, Utilizador, Checkin…) + fromJson
├── services/            # chamadas à API REST (http) e ao dispositivo (GPS, câmara)
├── controllers/         # estado da app (ChangeNotifier + provider)
├── views/
│   ├── screens/         # um ficheiro por ecrã
│   └── widgets/         # componentes reutilizáveis
└── utils/               # tema, configuração, cálculo da estimativa (BacCalculator)
```

Regra: as views nunca chamam a API diretamente; passam sempre por um controller.
