# Task Management

A full-stack task management application with a **Node.js (Express + Prisma + PostgreSQL)** backend and a **Flutter** mobile frontend.

---

## Prerequisites

- **Node.js** (v18 or later) and **npm**
- **PostgreSQL** (running locally or accessible URL)
- **Flutter SDK** (3.9+)
- **Dart** (3.9+)

---

## Project structure

```
.
├── backend/          # Node.js API (Express, Prisma, PostgreSQL)
├── frontend/         # Flutter app
├── .env.example      # Example environment variables (backend)
└── README.md
```

---

## 1. Backend (Node.js + Prisma + PostgreSQL)

### 1.1 Install dependencies

```bash
cd backend
npm install
```

### 1.2 Environment variables

Copy the example env file and set your values:

```bash
cp .env.example .env
```

Edit `.env` and configure:

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | PostgreSQL connection string, e.g. `postgresql://USER:PASSWORD@localhost:5432/taskdb` |
| `JWT_ACCESS_SECRET` | Secret for access tokens |
| `JWT_REFRESH_SECRET` | Secret for refresh tokens |

Example:

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/taskdb"
JWT_ACCESS_SECRET="your_access_secret"
JWT_REFRESH_SECRET="your_refresh_secret"
```

### 1.3 Database setup

Create the database (if it doesn’t exist), then run migrations and generate the Prisma client:

```bash
cd backend
npx prisma migrate deploy
npx prisma generate
```

For a fresh dev database you can use:

```bash
npx prisma migrate dev
npx prisma generate
```

### 1.4 Run the backend

**Development (with auto-reload):**

```bash
cd backend
npm run dev
```

**Production build and run:**

```bash
cd backend
npm run build
npm start
```

The API runs at **http://localhost:3000**. You can check it with:

```bash
curl http://localhost:3000
# Expected: "API Running..."
```

---

## 2. Frontend (Flutter)

### 2.1 Install dependencies

```bash
cd frontend
flutter pub get
```

### 2.2 Configure API base URL (optional)

The app is set to use **http://localhost:3000** by default (see `frontend/lib/core/services/api_service.dart`).

- **iOS Simulator / same machine:** `localhost:3000` is fine.
- **Android Emulator:** use `http://10.0.2.2:3000` (Android’s alias for host machine).
- **Physical device:** use your machine’s LAN IP, e.g. `http://192.168.1.x:3000`, and ensure the device and computer are on the same network.

Change the `baseUrl` in `api_service.dart` if needed.

### 2.3 Run the Flutter app

**List devices:**

```bash
cd frontend
flutter devices
```

**Run on a connected device or emulator:**

```bash
cd frontend
flutter run
```

**Run on a specific target (examples):**

```bash
flutter run -d chrome          # Web
flutter run -d macos            # macOS
flutter run -d <device_id>      # Use ID from `flutter devices`
```

---

## 3. Running everything together

1. **Start PostgreSQL** (if not already running).
2. **Start the backend:**
   ```bash
   cd backend && npm run dev
   ```
3. **Start the Flutter app** (in another terminal):
   ```bash
   cd frontend && flutter run
   ```

Ensure the backend is up and reachable at the URL configured in the Flutter app (default: http://localhost:3000).

---

## Backend API overview

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Health check |
| POST | `/auth/register` | Register |
| POST | `/auth/login` | Login |
| POST | `/auth/refresh` | Refresh access token |
| GET | `/auth/profile` | Get current user (auth required) |
| GET | `/tasks` | List tasks (auth required) |
| POST | `/tasks` | Create task (auth required) |
| GET | `/tasks/:id` | Get task by id (auth required) |
| PUT/PATCH | `/tasks/:id` | Update task (auth required) |
| DELETE | `/tasks/:id` | Delete task (auth required) |
| PATCH | `/tasks/:id/toggle` | Toggle task status (auth required) |

---

## Troubleshooting

- **Backend won’t start:** Check `DATABASE_URL`, that PostgreSQL is running, and that the database exists. Run `npx prisma migrate deploy` (or `migrate dev`) again if needed.
- **Flutter can’t reach API:** Confirm the backend is running and the `baseUrl` in `api_service.dart` matches your environment (localhost, 10.0.2.2, or LAN IP).
- **Prisma errors:** Run `npx prisma generate` after changing `schema.prisma` or cloning the repo.
