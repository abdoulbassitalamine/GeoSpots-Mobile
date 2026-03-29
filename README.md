# GeoSpots - Application Flutter de gestion et partage de lieux

Application Flutter permettant de gerer des lieux personnels, des collections, des imports/exports geographiques, des images et le partage securise via JWT et tokens d'acces.

## Membres du groupe

- DIALLO Mamadou Cherif
- LAMINOU AMADOU Abdoul Bassit
- KANE Abdou Latif
- IDRISS Abakar Nokour
- DIALLO Mohamed Moussa

## Stack du projet

- Flutter
- Dart
- Riverpod / Hooks Riverpod
- Go Router
- Dio
- Freezed / Json Serializable
- Flutter Map
- Flutter Dotenv

## Versions requises

Le projet declare dans [pubspec.yaml](pubspec.yaml) :

- Flutter `>=3.38.7`
- Dart `>=3.10.7 <4.0.0`

Verification :

```bash
flutter --version
dart --version
```

Si besoin, verifiez aussi votre environnement Flutter :

```bash
flutter doctor
```

## Prerequis

Installez avant de lancer le projet :

- Flutter SDK compatible
- Dart SDK compatible
- Android Studio si vous ciblez Android
- Xcode si vous ciblez iOS
- Un emulateur Android, un simulateur iOS ou un appareil physique

## Installation du projet

### 1. Cloner le depot

```bash
git clone <url-du-repo>
cd geo_spots
```

### 2. Recuperer les dependances

```bash
flutter pub get
```

### 3. Configurer le fichier `.env`

L'application charge automatiquement le fichier `env/.env` au demarrage via [lib/main.dart](lib/main.dart) et [lib/launch.dart](lib/launch.dart).

Le projet contient deja un modele : [env/template.env](env/template.env)

Creer ou mettre a jour [env/.env](env/.env) :

```env
API_BASE_URL=https://mint-silkworm-optimum.ngrok-free.app
```

Important :

- ne mettez pas de guillemets
- remplacez l'URL par celle de votre backend si besoin
- adaptez aussi le port a celui de votre service backend

### 4. Configurer l'URL du backend selon votre environnement

Exemples utiles pour `API_BASE_URL` :

- iOS Simulator : `http://127.0.0.1:8080`
- Android Emulator : `http://10.0.2.2:8080`
- Appareil physique sur le meme Wi-Fi : `http://192.168.1.42:8080`
- Backend distant : `https://mint-silkworm-optimum.ngrok-free.app`

Par defaut, Spring Boot demarre souvent sur le port `8080`, mais vous devez mettre le port reel de votre service.

Exemple :

- si votre backend tourne sur `http://localhost:8080`, utilisez `:8080`
- si votre backend tourne sur `http://localhost:9090`, remplacez par `:9090`

Donc :

```env
API_BASE_URL=http://127.0.0.1:8080
```

ou

```env
API_BASE_URL=http://127.0.0.1:9090
```

Si vous utilisez un appareil physique, le backend doit ecouter sur `0.0.0.0` et non seulement sur `127.0.0.1`.

## Generation des fichiers (etape obligatoire)

> **Important** : les fichiers generes (`*.g.dart`, `*.freezed.dart`) ne sont **pas inclus dans le code source**. Ils doivent etre generes avant le premier lancement. Sans cette etape, le projet ne compile pas.

Le projet utilise la generation de code pour 4 librairies :

| Librairie | Fichiers generes | Role |
| --- | --- | --- |
| **Freezed** | `*.freezed.dart` | Entites immuables : `copyWith`, `==`, `hashCode`, pattern union |
| **Riverpod Generator** | `*.g.dart` (providers) | Providers type-safe a partir des annotations `@riverpod` |
| **Go Router Builder** | `app_router.g.dart` | Routes de navigation type-safe |
| **JSON Serializable** | `*.g.dart` (DTOs) | Serialisation / deserialisation JSON des DTOs |

### Generer une seule fois (build)

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Mode watch (developpement actif)

Si vous modifiez des models, providers ou routes, utilisez le mode watch pour regenerer automatiquement a chaque sauvegarde :

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Quand regenerer ?

- apres un `git clone` ou `git pull` (toujours)
- apres ajout ou modification d'un model `@freezed`
- apres ajout ou modification d'un provider `@riverpod`
- apres ajout ou modification d'une route
- apres modification d'un DTO avec `@JsonSerializable`

## Lancer l'application

### Voir les appareils disponibles

```bash
flutter devices
```

### Lancer sur un appareil detecte

```bash
flutter run
```

### Lancer sur Android

```bash
flutter run -d android
```

### Lancer sur iOS

```bash
flutter run -d ios
```

## Workflow recommande pour lancer le projet sans souci

A la racine du projet :

```bash
flutter doctor
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Commandes utiles

### Analyser le code

```bash
dart analyze
```

### Lancer les tests

```bash
flutter test
```

### Nettoyer le projet

```bash
flutter clean
flutter pub get
```

### Regenerer les icones de l'application

```bash
dart run flutter_launcher_icons
```

### Regenerer le splash screen natif

```bash
dart run flutter_native_splash:create
```

## Fonctionnalites principales

- Authentification avec access token et refresh token
- Gestion CRUD des lieux
- Recherche de lieux
- Affichage cartographique avec Flutter Map
- Gestion de collections
- Import / export geographique
- Partage de lieux et de collections
- Upload et affichage d'images
- Gestion du profil utilisateur
- Ouverture de ressources partagees

## Structure du projet

```text
geo_spots/
├── android/
├── ios/
├── assets/
├── env/
│   ├── .env
│   └── template.env
├── lib/
│   ├── core/
│   ├── features/
│   │   ├── authentication/
│   │   ├── collections/
│   │   ├── map/
│   │   ├── places/
│   │   ├── settings/
│   │   └── tracking/
│   ├── gen/
│   ├── shared/
│   ├── app.dart
│   ├── launch.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

## Fichiers importants

- [pubspec.yaml](pubspec.yaml) : dependances et versions
- [env/.env](env/.env) : URL du backend utilisee par l'app
- [env/template.env](env/template.env) : modele de configuration
- [lib/main.dart](lib/main.dart) : point d'entree
- [lib/launch.dart](lib/launch.dart) : initialisation globale

## Depannage

### Erreur `API_BASE_URL` manquante

Verifiez que [env/.env](env/.env) existe bien et contient :

```env
API_BASE_URL=http://127.0.0.1:8080
```

### Le backend local ne repond pas sur Android Emulator

N'utilisez pas `127.0.0.1` ou `localhost`. Utilisez :

```env
API_BASE_URL=http://10.0.2.2:8080
```

### Le backend local ne repond pas sur un vrai telephone

- verifiez que le telephone et la machine sont sur le meme reseau
- utilisez l'IP locale de votre machine
- assurez-vous que le backend ecoute sur `0.0.0.0`

Exemple :

```env
API_BASE_URL=http://192.168.1.42:8080
```

### Erreurs sur les fichiers `.g.dart` ou `.freezed.dart`

Regenerer :

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Les dependances ne sont pas a jour

```bash
flutter clean
flutter pub get
```

### Problemes de build iOS

```bash
cd ios
pod install
cd ..
flutter run -d ios
```

## Resume rapide

Pour lancer le projet proprement :

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Et avant cela, configurez bien :

```env
API_BASE_URL=...
```
