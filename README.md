# AGROIntel - Intelligent Agricultural Platform

A comprehensive, production-grade AI-powered platform for soil analysis, crop yield prediction, real-time monitoring, and decision support for farmers and agribusinesses.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Development](#development)
- [Deployment](#deployment)
- [Testing](#testing)
- [Contributing](#contributing)

## ✨ Features

### Core Capabilities
- **Soil Analysis**: AI-powered soil health assessment with nutrient deficiency detection
- **Yield Prediction**: LSTM-based crop yield forecasting with confidence intervals
- **Real-time Monitoring**: IoT sensor integration with real-time data streaming
- **Anomaly Detection**: Machine learning models for early warning of drought, diseases, pests
- **Smart Recommendations**: AI-driven fertilizer, irrigation, and pest management plans
- **Weather Integration**: OpenWeather API integration with detailed forecasting
- **Decision Support**: Actionable insights with cost-benefit analysis

### User Features
- Multi-language support (English, Hindi, Local languages)
- Responsive mobile-first design
- Interactive dashboards with charts and maps
- Historical data analysis and trend tracking
- Regional performance benchmarking
- Automated report generation

### Admin Features
- User and organization management
- ML model configuration and deployment
- System health monitoring
- Analytics and KPI tracking

## 🏗️ Architecture

### Technology Stack
```
Frontend:  React 18 + TypeScript + TailwindCSS + Vite
Backend:   Python 3.11 + FastAPI + SQLAlchemy
Database:  PostgreSQL 15 + InfluxDB 2.x + Redis 7
ML/AI:     TensorFlow 2.x + PyTorch + Scikit-learn + XGBoost
Tasks:     Celery + RabbitMQ
Monitoring: Prometheus + Grafana
Deployment: Docker + Docker Compose + Kubernetes
```

### System Components
1. **API Layer** (FastAPI): REST API with JWT authentication, WebSocket support
2. **Database Layer**: PostgreSQL (relational) + InfluxDB (time-series) + Redis (cache)
3. **ML Pipeline**: Training, inference, and model serving
4. **Message Queue**: Celery for async tasks and scheduled jobs
5. **Frontend**: React SPA with interactive dashboards
6. **Monitoring**: Prometheus metrics + Grafana dashboards

## 🚀 Quick Start

### Prerequisites
- Docker 24.0+
- Docker Compose 2.20+
- Python 3.11 (for local development)
- Node.js 20 LTS (for frontend development)

### Using Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/agrointel/platform.git
cd agrointel

# Create environment file
cp .env.example .env

# Start all services
docker-compose up -d

# Wait for services to be healthy (2-3 minutes)
docker-compose ps

# Access the application
# Frontend: http://localhost:3000
# API Docs: http://localhost:8000/api/docs
# RabbitMQ UI: http://localhost:15672 (user: agrointel / pass: rabbitmq_password_123)
# Grafana: http://localhost:3001 (user: admin / pass: admin_password_123)
```

### Local Development Setup

#### Backend Setup
```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env

# Run migrations
alembic upgrade head

# Start the server
uvicorn main:app --reload --port 8000
```

#### Frontend Setup
```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Start development server
npm run dev
```

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
# Database
DATABASE_URL=postgresql://agrointel_user:secure_password_123@postgres:5432/agrointel_db
INFLUXDB_URL=http://influxdb:8086
INFLUXDB_TOKEN=your_influxdb_token
REDIS_URL=redis://:redis_password_123@redis:6379/0

# Authentication
JWT_SECRET_KEY=your-very-secret-key-min-32-chars
JWT_ALGORITHM=HS256
TOKEN_EXPIRE_HOURS=24

# External APIs
OPENWEATHER_API_KEY=your_openweathermap_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Email Configuration
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# AWS S3 (for reports and file storage)
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret
AWS_S3_BUCKET=agrointel-files
AWS_REGION=us-east-1

# Environment
ENVIRONMENT=development
LOG_LEVEL=info
```

### Database Initialization

```bash
# Using Docker Compose (automatic)
docker-compose up postgres

# Manual with psql
psql postgresql://agrointel_user:secure_password_123@localhost:5432/agrointel_db < database_schema.sql

# Using Alembic migrations
cd backend
alembic upgrade head
```

## 🛠️ Development

### Project Structure

```
agrointel/
├── backend/
│   ├── main.py                 # FastAPI application
│   ├── models.py               # SQLAlchemy models
│   ├── routers/                # API route handlers
│   ├── services/               # Business logic
│   ├── schemas/                # Pydantic schemas
│   ├── ml_models/              # ML model implementations
│   ├── tasks.py                # Celery tasks
│   ├── requirements.txt
│   ├── Dockerfile
│   └── tests/
├── frontend/
│   ├── src/
│   │   ├── components/         # React components
│   │   ├── pages/              # Page components
│   │   ├── services/           # API services
│   │   ├── store/              # Redux state management
│   │   ├── utils/              # Utility functions
│   │   └── App.tsx
│   ├── package.json
│   ├── vite.config.ts
│   └── Dockerfile
├── database_schema.sql         # PostgreSQL schema
├── docker-compose.yml          # Container orchestration
├── AGROINTEL_ARCHITECTURE.md   # System architecture
├── API_ENDPOINTS.md            # API documentation
├── ML_PIPELINE.md              # ML pipeline documentation
├── DEVELOPMENT_ROADMAP.md      # Roadmap and milestones
└── README.md
```

### Running Tests

```bash
# Backend tests
cd backend
pytest tests/ -v --cov=.

# Frontend tests
cd frontend
npm test
```

### Code Quality

```bash
# Backend linting and formatting
cd backend
black . --line-length 100
flake8 . --max-line-length=100
mypy . --ignore-missing-imports
isort .

# Frontend linting
cd frontend
npm run lint
npm run format
```

## 📦 Deployment

### Docker Compose Production

```bash
# Build images
docker-compose build

# Start services with production settings
ENVIRONMENT=production docker-compose up -d

# View logs
docker-compose logs -f backend

# Scale services
docker-compose up -d --scale celery_worker=3
```

### Kubernetes Deployment

```bash
# Build and push images to registry
docker tag agrointel-backend:latest myregistry/agrointel-backend:latest
docker tag agrointel-frontend:latest myregistry/agrointel-frontend:latest
docker push myregistry/agrointel-backend:latest
docker push myregistry/agrointel-frontend:latest

# Deploy to Kubernetes
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/redis.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml

# Check deployment status
kubectl get pods -n agrointel
```

### AWS Deployment

```bash
# Using ECS (Elastic Container Service)
aws ecs create-cluster --cluster-name agrointel
aws ecs register-task-definition --cli-input-json file://task-definition.json
aws ecs create-service --cluster agrointel --service-name backend --task-definition agrointel-backend:1 --desired-count 3

# Using RDS for PostgreSQL
aws rds create-db-instance --db-instance-identifier agrointel-postgres --db-instance-class db.t3.micro --engine postgres --master-username admin

# Using ElastiCache for Redis
aws elasticache create-cache-cluster --cache-cluster-id agrointel-redis --cache-node-type cache.t3.micro --engine redis
```

## 🧪 Testing

### Unit Tests

```bash
cd backend
pytest tests/unit/ -v
```

### Integration Tests

```bash
cd backend
pytest tests/integration/ -v
```

### Load Testing

```bash
# Using Apache Bench
ab -n 10000 -c 100 http://localhost:8000/api/v1/health

# Using K6
k6 run tests/load/script.js
```

## 📊 Monitoring & Observability

### Prometheus Metrics

Access Prometheus at `http://localhost:9090`

Metrics tracked:
- Request latency (p50, p95, p99)
- Error rates by endpoint
- Model inference latency
- Database query performance
- Cache hit rates

### Grafana Dashboards

Access Grafana at `http://localhost:3001`

Default dashboards:
- System Overview
- API Performance
- ML Model Metrics
- Database Performance
- Business KPIs

### Logging

```bash
# View backend logs
docker-compose logs -f backend

# View all services
docker-compose logs -f

# View specific service
docker-compose logs -f celery_worker
```

## 🔐 Security

### Best Practices Implemented

- ✅ JWT-based authentication
- ✅ Role-based access control (RBAC)
- ✅ Input validation with Pydantic
- ✅ SQL injection prevention (SQLAlchemy ORM)
- ✅ CORS policy enforcement
- ✅ Rate limiting on API endpoints
- ✅ Password hashing with bcrypt
- ✅ HTTPS/TLS enforcement
- ✅ Secrets management with environment variables
- ✅ Audit logging for sensitive operations

## 📚 API Documentation

Complete API documentation available at:
- **Interactive Docs**: http://localhost:8000/api/docs (Swagger UI)
- **ReDoc**: http://localhost:8000/api/redoc
- **API_ENDPOINTS.md**: Comprehensive endpoint reference

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards

- Follow PEP 8 for Python
- Use ESLint for JavaScript/TypeScript
- Write tests for new features
- Update documentation

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🙋 Support

- **Documentation**: See docs/ directory
- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions
- **Email**: support@agrointel.com

## 🚀 Roadmap

See [DEVELOPMENT_ROADMAP.md](DEVELOPMENT_ROADMAP.md) for detailed roadmap and milestones.

### Current Status: Alpha (v1.0.0-alpha)
- ✅ Core backend API
- ✅ Database schema
- ✅ Authentication system
- ✅ ML pipeline setup
- ⏳ Frontend dashboard
- ⏳ Real-time monitoring
- ⏳ Advanced ML models
- ⏳ Mobile app

## 📞 Contact

- **Website**: https://agrointel.com
- **Email**: info@agrointel.com
- **LinkedIn**: https://linkedin.com/company/agrointel
- **Twitter**: @AGROIntel

---

**Built with ❤️ for sustainable agriculture**
