# AGROIntel Implementation Guide

## Getting Started with Full Development Setup

This guide walks you through setting up and deploying AGROIntel on your local machine or cloud infrastructure.

## 1. Prerequisites Installation

### macOS
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install docker docker-compose python@3.11 node git

# Verify installations
docker --version
docker-compose --version
python3 --version
node --version
```

### Ubuntu/Debian
```bash
# Update package manager
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Python, Node, Git
sudo apt install -y python3.11 python3-pip nodejs npm git

# Verify installations
docker --version
docker-compose --version
python3 --version
node --version
```

### Windows
1. Download and install Docker Desktop from https://www.docker.com/products/docker-desktop
2. Download and install Python 3.11 from https://www.python.org/downloads/
3. Download and install Node.js LTS from https://nodejs.org/
4. Download and install Git from https://git-scm.com/download/win

## 2. Repository Setup

```bash
# Clone the repository
git clone https://github.com/agrointel/platform.git
cd agrointel

# Initialize git submodules (if any)
git submodule update --init --recursive

# Create necessary directories
mkdir -p ./backend/routers ./backend/services ./backend/schemas ./backend/ml_models ./backend/tests
mkdir -p ./frontend/src/{components,pages,services,store,utils,assets}
mkdir -p ./monitoring ./k8s ./docs

# Copy environment files
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

## 3. Full Docker Setup (Recommended)

### Step 1: Start All Services

```bash
# Start all services in the background
docker-compose up -d

# Watch the startup process
docker-compose ps

# Monitor logs
docker-compose logs -f

# Wait for all services to be healthy (2-3 minutes)
```

### Step 2: Verify Services

```bash
# Check if all containers are running
docker-compose ps

# Expected output:
# NAME                    STATUS
# agrointel-postgres      Up (healthy)
# agrointel-influxdb      Up (healthy)
# agrointel-redis         Up (healthy)
# agrointel-rabbitmq      Up (healthy)
# agrointel-backend       Up (healthy)
# agrointel-celery-worker Up
# agrointel-celery-beat   Up
# agrointel-frontend      Up (healthy)
# agrointel-prometheus    Up
# agrointel-grafana       Up

# Test backend
curl http://localhost:8000/api/v1/health

# Test frontend
curl http://localhost:3000
```

### Step 3: Access the Platform

| Service | URL | Credentials |
|---------|-----|-------------|
| Frontend | http://localhost:3000 | N/A |
| API Docs | http://localhost:8000/api/docs | N/A |
| ReDoc | http://localhost:8000/api/redoc | N/A |
| RabbitMQ | http://localhost:15672 | agrointel / rabbitmq_password_123 |
| Grafana | http://localhost:3001 | admin / admin_password_123 |
| Prometheus | http://localhost:9090 | N/A |

## 4. Local Development Setup (Without Docker)

### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python3.11 -m venv venv

# Activate virtual environment
source venv/bin/activate  # macOS/Linux
# or
venv\Scripts\activate  # Windows

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt

# Create environment file
cat > .env << EOF
DATABASE_URL=postgresql://agrointel_user:secure_password_123@localhost:5432/agrointel_db
INFLUXDB_URL=http://localhost:8086
INFLUXDB_TOKEN=admin_password_123
REDIS_URL=redis://:redis_password_123@localhost:6379/0
RABBITMQ_URL=amqp://agrointel:rabbitmq_password_123@localhost:5672/
JWT_SECRET_KEY=your-secret-key-change-in-production
ENVIRONMENT=development
LOG_LEVEL=info
EOF

# Run migrations (if using Alembic)
alembic upgrade head

# Start the backend server
uvicorn main:app --reload --port 8000
```

### Frontend Setup

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Create environment file
cat > .env << EOF
VITE_API_URL=http://localhost:8000/api/v1
VITE_WS_URL=ws://localhost:8000/api/v1/ws
EOF

# Start development server
npm run dev

# Application will be available at http://localhost:5173
```

## 5. Database Initialization

### Option 1: Docker Compose (Automatic)
The database schema is automatically applied when containers start.

### Option 2: Manual with psql

```bash
# Connect to PostgreSQL
psql postgresql://agrointel_user:secure_password_123@localhost:5432/agrointel_db

# Apply schema
\i database_schema.sql

# Verify tables
\dt

# Exit
\q
```

### Option 3: Using Alembic

```bash
cd backend

# Create a new migration
alembic revision --autogenerate -m "Initial migration"

# Apply migrations
alembic upgrade head

# Check migration history
alembic history
```

## 6. Data Population (Optional)

### Generate Sample Data

```bash
cd backend

# Create a data generator script
python scripts/generate_sample_data.py

# Or manually insert test data
python

# In Python shell:
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import User, Organization, Field

engine = create_engine("postgresql://agrointel_user:secure_password_123@localhost/agrointel_db")
Session = sessionmaker(bind=engine)
session = Session()

# Create test user
user = User(
    username="testfarmer",
    email="test@agrointel.com",
    password_hash="hashed_password",
    first_name="John",
    last_name="Farmer",
    role="farmer"
)
session.add(user)
session.commit()

# Create test organization
org = Organization(
    name="Test Farm",
    org_type="farm",
    owner_id=user.id,
    region="Punjab",
    country="India",
    total_area_hectares=50
)
session.add(org)
session.commit()
```

## 7. Authentication Setup

### Create Admin User

```bash
cd backend

# Using the authentication router
python

# In Python shell:
from models import User
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from passlib.context import CryptContext

DATABASE_URL = "postgresql://agrointel_user:secure_password_123@localhost/agrointel_db"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
session = Session()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

admin_user = User(
    username="admin",
    email="admin@agrointel.com",
    password_hash=pwd_context.hash("admin123"),
    first_name="Admin",
    last_name="User",
    role="admin",
    is_active=True,
    is_email_verified=True
)
session.add(admin_user)
session.commit()
print(f"Admin user created with ID: {admin_user.id}")
```

### Generate JWT Token

```bash
# Using the login endpoint
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@agrointel.com","password":"admin123"}'

# Response will include token:
# {"token":"eyJhbGciOiJIUzI1NiIs...","user":{...}}
```

## 8. Configuration & Customization

### API Configuration

Edit `backend/main.py`:
```python
# Update CORS origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",  # Your frontend URL
        "https://app.agrointel.com"
    ],
    # ...
)

# Update API metadata
app = FastAPI(
    title="AGROIntel API",
    description="Your description",
    version="1.0.0"
)
```

### Database Configuration

Edit `.env`:
```env
# PostgreSQL Connection
DATABASE_URL=postgresql://user:password@host:port/database

# InfluxDB Connection
INFLUXDB_URL=http://localhost:8086
INFLUXDB_TOKEN=your_token

# Redis Connection
REDIS_URL=redis://:password@localhost:6379/0
```

### Frontend Theming

Edit `frontend/src/config/theme.ts`:
```typescript
export const theme = {
  primary: '#22c55e',      // Green for agriculture
  secondary: '#1f2937',    // Dark gray
  accent: '#f59e0b',       // Amber
  // ...
}
```

## 9. ML Models Setup

### Train Yield Prediction Model

```bash
cd backend/ml_models

# Download training data
python download_training_data.py

# Train model
python train_yield_prediction.py \
  --data_path ./data/historical_yield.csv \
  --output_model ./models/yield_v1.0.h5 \
  --epochs 100

# Evaluate model
python evaluate_model.py --model_path ./models/yield_v1.0.h5
```

### Train Soil Health Model

```bash
python train_soil_health.py \
  --data_path ./data/soil_samples.csv \
  --output_model ./models/soil_health_v1.0.pkl \
  --model_type xgboost
```

## 10. Deployment

### AWS Deployment

```bash
# Create AWS resources
aws cloudformation create-stack \
  --stack-name agrointel \
  --template-body file://k8s/aws-cf-template.yaml \
  --parameters ParameterKey=Environment,ParameterValue=production

# Deploy to ECS
aws ecs update-service \
  --cluster agrointel \
  --service backend \
  --force-new-deployment
```

### Google Cloud Deployment

```bash
# Build and push images
gcloud builds submit --tag gcr.io/your-project/agrointel-backend .

# Deploy to Cloud Run
gcloud run deploy agrointel-backend \
  --image gcr.io/your-project/agrointel-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Kubernetes Deployment

```bash
# Create namespace
kubectl create namespace agrointel

# Create secrets
kubectl create secret generic agrointel-secrets \
  --from-literal=database-url="postgresql://..." \
  -n agrointel

# Deploy
kubectl apply -f k8s/ -n agrointel

# Verify deployment
kubectl get pods -n agrointel
kubectl describe deployment backend -n agrointel
```

## 11. Monitoring & Troubleshooting

### View Logs

```bash
# Docker Compose
docker-compose logs -f backend

# Kubernetes
kubectl logs deployment/backend -n agrointel -f

# Specific container
kubectl logs pod/backend-xyz -n agrointel
```

### Common Issues

**PostgreSQL connection refused**
```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Restart PostgreSQL
docker-compose restart postgres

# Verify connection
psql postgresql://agrointel_user:secure_password_123@localhost/agrointel_db -c "SELECT 1"
```

**Redis connection failed**
```bash
# Check Redis status
redis-cli ping

# Verify Redis is running
docker ps | grep redis

# Check Redis logs
docker-compose logs redis
```

**Model inference timeout**
```bash
# Check GPU availability
nvidia-smi

# Increase TensorFlow timeout
export TF_CPP_MIN_LOG_LEVEL=2
export CUDA_VISIBLE_DEVICES=0
```

## 12. Testing

### Run Tests

```bash
cd backend

# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/test_auth.py -v

# Run with coverage
pytest tests/ --cov=. --cov-report=html

# View coverage report
open htmlcov/index.html
```

### Load Testing

```bash
# Install k6
brew install k6  # macOS

# Run load test
k6 run tests/load/test_api.js

# Run with specific duration
k6 run --duration 5m --vus 100 tests/load/test_api.js
```

## 13. Production Checklist

Before deploying to production:

- [ ] Change all default passwords and secrets
- [ ] Enable HTTPS/TLS
- [ ] Set up proper logging and monitoring
- [ ] Configure automated backups
- [ ] Set up disaster recovery plan
- [ ] Perform security audit
- [ ] Load test the platform
- [ ] Set up CI/CD pipeline
- [ ] Document deployment procedures
- [ ] Train support team

## 14. Next Steps

1. **Customize UI**: Modify React components for your branding
2. **Add ML Models**: Train models with your regional data
3. **Configure Integrations**: Set up weather APIs, satellite data
4. **Set Up Monitoring**: Configure Prometheus scrape targets
5. **Create Dashboards**: Build custom Grafana dashboards
6. **Deploy to Cloud**: Use provided Kubernetes/AWS templates
7. **Launch Beta**: Invite farmers for testing
8. **Iterate**: Collect feedback and improve

---

For more information, see the complete documentation in the docs/ directory.
