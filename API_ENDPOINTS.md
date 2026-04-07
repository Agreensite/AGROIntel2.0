# AGROIntel API Endpoints Documentation

## Base URL
```
https://api.agrointel.com/v1
```

## Authentication
All endpoints require JWT token in header:
```
Authorization: Bearer <jwt_token>
```

---

## 1. Authentication Endpoints

### 1.1 User Registration
```
POST /auth/register
Content-Type: application/json

{
  "username": "farmer_john",
  "email": "john@example.com",
  "password": "SecurePassword123!",
  "first_name": "John",
  "last_name": "Doe",
  "phone": "+1-555-0100",
  "role": "farmer"
}

Response (201):
{
  "id": 1,
  "username": "farmer_john",
  "email": "john@example.com",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

### 1.2 User Login
```
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "SecurePassword123!"
}

Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "username": "farmer_john",
    "email": "john@example.com",
    "role": "farmer"
  }
}
```

### 1.3 Refresh Token
```
POST /auth/refresh
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}

Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "expires_in": 3600
}
```

### 1.4 Logout
```
POST /auth/logout
Response (200): { "message": "Logged out successfully" }
```

---

## 2. Organization Endpoints

### 2.1 Create Organization
```
POST /organizations
Content-Type: application/json

{
  "name": "Green Valley Farm",
  "org_type": "farm",
  "region": "Punjab",
  "country": "India",
  "latitude": 31.5497,
  "longitude": 74.3436,
  "total_area_hectares": 50,
  "description": "Mid-sized wheat and rice farm"
}

Response (201):
{
  "id": 1,
  "name": "Green Valley Farm",
  "owner_id": 1,
  "total_area_hectares": 50,
  "created_at": "2024-01-15T10:30:00Z"
}
```

### 2.2 Get Organization
```
GET /organizations/{org_id}

Response (200):
{
  "id": 1,
  "name": "Green Valley Farm",
  "org_type": "farm",
  "owner_id": 1,
  "region": "Punjab",
  "country": "India",
  "latitude": 31.5497,
  "longitude": 74.3436,
  "total_area_hectares": 50,
  "fields_count": 5,
  "active_sensors": 12,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

### 2.3 List Organizations
```
GET /organizations?page=1&limit=20&region=Punjab

Response (200):
{
  "total": 150,
  "page": 1,
  "limit": 20,
  "data": [...]
}
```

### 2.4 Update Organization
```
PUT /organizations/{org_id}
{
  "name": "Green Valley Farm Updated",
  "total_area_hectares": 55
}

Response (200): { "message": "Organization updated" }
```

### 2.5 Delete Organization
```
DELETE /organizations/{org_id}
Response (204): No Content
```

---

## 3. Field Endpoints

### 3.1 Create Field
```
POST /fields
{
  "organization_id": 1,
  "field_name": "North Field",
  "field_code": "GVF-001",
  "area_hectares": 10,
  "latitude": 31.5497,
  "longitude": 74.3436,
  "crop_type": "wheat",
  "planting_date": "2024-01-20",
  "expected_harvest_date": "2024-06-15",
  "irrigation_type": "drip",
  "description": "Primary wheat cultivation area"
}

Response (201):
{
  "id": 1,
  "field_code": "GVF-001",
  "field_name": "North Field",
  "crop_type": "wheat",
  "area_hectares": 10,
  "planting_date": "2024-01-20",
  "expected_harvest_date": "2024-06-15",
  "created_at": "2024-01-15T10:30:00Z"
}
```

### 3.2 Get Field Details
```
GET /fields/{field_id}

Response (200):
{
  "id": 1,
  "field_name": "North Field",
  "field_code": "GVF-001",
  "crop_type": "wheat",
  "area_hectares": 10,
  "planting_date": "2024-01-20",
  "days_since_planting": 45,
  "growth_stage": "vegetative",
  "soil_health_score": 78,
  "current_yield_prediction": 5.2,
  "yield_prediction_confidence": 0.87,
  "active_alerts": 2,
  "sensor_count": 3,
  "last_analysis_date": "2024-03-05T14:20:00Z"
}
```

### 3.3 List Fields
```
GET /fields?organization_id=1&crop_type=wheat&page=1

Response (200):
{
  "total": 5,
  "page": 1,
  "data": [...]
}
```

### 3.4 Update Field
```
PUT /fields/{field_id}
{
  "field_name": "North Field - Updated",
  "expected_harvest_date": "2024-06-20"
}

Response (200): { "message": "Field updated" }
```

---

## 4. Soil Analysis Endpoints

### 4.1 Submit Soil Sample
```
POST /soil/samples
{
  "field_id": 1,
  "sample_date": "2024-03-05",
  "depth_cm": 30,
  "soil_type": "loam",
  "ph_level": 7.2,
  "nitrogen_mg_per_kg": 45,
  "phosphorus_mg_per_kg": 22,
  "potassium_mg_per_kg": 180,
  "organic_matter_percent": 2.5,
  "moisture_percent": 22,
  "bulk_density_g_per_cm3": 1.35,
  "cec_meq_per_100g": 18,
  "electrical_conductivity_ds_per_m": 0.8,
  "lab_name": "Soil Lab Research Center"
}

Response (201):
{
  "id": 1,
  "field_id": 1,
  "sample_date": "2024-03-05",
  "soil_health_analysis": {
    "health_score": 78,
    "health_category": "good",
    "deficiencies": [
      {
        "nutrient": "nitrogen",
        "current_level": 45,
        "recommended_level": 60,
        "deficit": 15
      }
    ],
    "recommendations": [
      {
        "type": "fertilizer",
        "product": "Urea (46% N)",
        "quantity_kg": 30,
        "cost_usd": 45
      }
    ]
  },
  "created_at": "2024-03-05T10:30:00Z"
}
```

### 4.2 Get Soil Analysis
```
GET /soil/samples/{sample_id}

Response (200):
{
  "id": 1,
  "field_id": 1,
  "sample_date": "2024-03-05",
  "soil_type": "loam",
  "ph_level": 7.2,
  "nutrient_levels": {
    "nitrogen": 45,
    "phosphorus": 22,
    "potassium": 180
  },
  "health_score": 78,
  "health_category": "good",
  "deficiencies": [...],
  "risk_assessment": {
    "erosion_risk": "low",
    "compaction_risk": "medium",
    "waterlogging_risk": "low",
    "salinity_risk": "low"
  }
}
```

### 4.3 Get Field Soil History
```
GET /soil/samples?field_id=1&limit=12

Response (200):
{
  "total": 12,
  "samples": [
    {
      "id": 1,
      "sample_date": "2024-03-05",
      "health_score": 78
    },
    ...
  ],
  "trend_analysis": {
    "health_trend": "improving",
    "nitrogen_trend": "stable",
    "pH_trend": "slightly_decreasing"
  }
}
```

---

## 5. Yield Prediction Endpoints

### 5.1 Get Yield Prediction
```
GET /predictions/yield/{field_id}

Response (200):
{
  "field_id": 1,
  "crop_type": "wheat",
  "season_year": 2024,
  "season": "rabi",
  "predicted_yield": 5.8,
  "yield_unit": "tons_per_hectare",
  "confidence_interval": {
    "low": 5.2,
    "high": 6.4,
    "confidence_level": 0.87
  },
  "prediction_date": "2024-03-05T10:30:00Z",
  "expected_harvest_date": "2024-06-15",
  "days_to_harvest": 103,
  "confidence_factors": {
    "soil_health": "excellent",
    "weather_forecast": "favorable",
    "pest_pressure": "low",
    "irrigation_schedule": "optimal"
  },
  "compared_to_historical": {
    "average_yield": 5.2,
    "variance_percent": 11.5,
    "rank_percentile": 85
  }
}
```

### 5.2 Get Yield Prediction History
```
GET /predictions/yield/history/{field_id}?years=5

Response (200):
{
  "field_id": 1,
  "history": [
    {
      "season_year": 2020,
      "predicted_yield": 4.8,
      "actual_yield": 4.6,
      "prediction_error": 0.2
    },
    ...
  ],
  "historical_average": 5.1,
  "accuracy_metrics": {
    "mae": 0.28,
    "rmse": 0.35,
    "r_squared": 0.89
  }
}
```

---

## 6. Real-time Monitoring Endpoints

### 6.1 Register Sensor
```
POST /sensors
{
  "field_id": 1,
  "sensor_id": "SENSOR-001",
  "sensor_type": "soil_moisture",
  "sensor_brand": "RainDrop",
  "location_description": "North corner, 10m from irrigation line",
  "latitude": 31.5497,
  "longitude": 74.3436,
  "installation_date": "2024-01-15"
}

Response (201):
{
  "id": 1,
  "sensor_id": "SENSOR-001",
  "field_id": 1,
  "is_active": true,
  "battery_level_percent": 95,
  "last_reading_timestamp": "2024-03-05T14:25:00Z"
}
```

### 6.2 Get Real-time Sensor Data
```
GET /sensors/{sensor_id}/current

Response (200):
{
  "sensor_id": "SENSOR-001",
  "sensor_type": "soil_moisture",
  "timestamp": "2024-03-05T14:25:00Z",
  "value": 42.5,
  "unit": "percent",
  "battery_level": 92,
  "signal_strength": -75,
  "status": "active",
  "data_quality": "good",
  "anomaly_detected": false
}
```

### 6.3 Get Sensor Time-series Data
```
GET /sensors/{sensor_id}/data?start_date=2024-02-05&end_date=2024-03-05&interval=hourly

Response (200):
{
  "sensor_id": "SENSOR-001",
  "data_points": [
    {
      "timestamp": "2024-02-05T00:00:00Z",
      "value": 35.2
    },
    ...
  ],
  "statistics": {
    "min": 28.5,
    "max": 55.3,
    "mean": 42.1,
    "std_dev": 6.8
  },
  "anomalies": [
    {
      "timestamp": "2024-02-15T03:00:00Z",
      "value": 72.1,
      "severity": "high",
      "reason": "possible_sensor_malfunction"
    }
  ]
}
```

---

## 7. Recommendations Endpoints

### 7.1 Get Field Recommendations
```
GET /recommendations/{field_id}?include_applied=false

Response (200):
{
  "field_id": 1,
  "recommendations": [
    {
      "id": 1,
      "recommendation_type": "fertilizer",
      "title": "Nitrogen Application Required",
      "description": "Soil analysis shows nitrogen deficiency. Recommended: 30kg Urea per hectare",
      "priority_level": "high",
      "estimated_impact": "Yield increase: 0.4-0.6 tons/hectare",
      "implementation_cost_usd": 45,
      "recommended_date": "2024-03-10",
      "status": "pending",
      "expected_result": "Nitrogen level: 45 → 65 mg/kg"
    },
    {
      "id": 2,
      "recommendation_type": "irrigation",
      "title": "Irrigation Schedule Adjustment",
      "description": "Weather forecast suggests heavy rainfall expected. Reduce irrigation by 40%",
      "priority_level": "medium",
      "estimated_impact": "Water savings: 50mm, Cost savings: $120",
      "implementation_cost_usd": 0,
      "recommended_date": "2024-03-08",
      "status": "pending"
    }
  ]
}
```

### 7.2 Apply Recommendation
```
POST /recommendations/{recommendation_id}/apply
{
  "actual_quantity": 30,
  "application_date": "2024-03-10",
  "notes": "Applied as per recommendation"
}

Response (200):
{
  "recommendation_id": 1,
  "status": "applied",
  "applied_date": "2024-03-10"
}
```

---

## 8. Alert Endpoints

### 8.1 Get Active Alerts
```
GET /alerts?field_id=1&resolved=false&severity=high

Response (200):
{
  "total": 2,
  "alerts": [
    {
      "id": 1,
      "field_id": 1,
      "alert_type": "drought",
      "severity_level": "high",
      "title": "Drought Risk Detected",
      "description": "Low soil moisture + high temperature + no rainfall forecast",
      "detection_timestamp": "2024-03-05T14:00:00Z",
      "affected_area_percent": 85,
      "recommended_action": "Increase irrigation frequency. Expected relief: 5 days",
      "is_resolved": false
    }
  ]
}
```

### 8.2 Resolve Alert
```
PUT /alerts/{alert_id}/resolve
{
  "action_taken": "Increased irrigation to 4 hours/day",
  "resolved_date": "2024-03-06"
}

Response (200):
{
  "alert_id": 1,
  "is_resolved": true,
  "resolved_date": "2024-03-06"
}
```

---

## 9. Treatment Plan Endpoints

### 9.1 Create Treatment Plan
```
POST /treatment-plans
{
  "field_id": 1,
  "plan_type": "fertilizer",
  "start_date": "2024-03-10",
  "end_date": "2024-04-10",
  "description": "NPK supplementation for wheat crop",
  "items": [
    {
      "item_name": "Urea (46% N)",
      "quantity": 30,
      "unit": "kg",
      "application_date": "2024-03-10",
      "application_method": "broadcast",
      "cost_usd": 45
    },
    {
      "item_name": "DAP",
      "quantity": 20,
      "unit": "kg",
      "application_date": "2024-03-15",
      "application_method": "broadcast",
      "cost_usd": 35
    }
  ]
}

Response (201):
{
  "id": 1,
  "field_id": 1,
  "plan_type": "fertilizer",
  "status": "planned",
  "estimated_cost_usd": 80,
  "created_at": "2024-03-05T10:30:00Z"
}
```

### 9.2 Get Treatment Plan
```
GET /treatment-plans/{plan_id}

Response (200):
{
  "id": 1,
  "field_id": 1,
  "plan_type": "fertilizer",
  "start_date": "2024-03-10",
  "end_date": "2024-04-10",
  "status": "in_progress",
  "items": [
    {
      "id": 1,
      "item_name": "Urea (46% N)",
      "quantity": 30,
      "unit": "kg",
      "application_date": "2024-03-10",
      "application_method": "broadcast",
      "cost_usd": 45
    },
    ...
  ],
  "total_estimated_cost": 80
}
```

---

## 10. Weather Endpoints

### 10.1 Get Weather Forecast
```
GET /weather/{field_id}/forecast?days=14

Response (200):
{
  "field_id": 1,
  "location": "Punjab, India",
  "forecast": [
    {
      "date": "2024-03-06",
      "temperature_min": 18,
      "temperature_max": 32,
      "humidity": 65,
      "rainfall_mm": 0,
      "wind_speed_kmh": 12,
      "weather_condition": "sunny",
      "uvi": 8,
      "recommendation": "Good conditions for fertilizer application"
    },
    {
      "date": "2024-03-07",
      "temperature_min": 16,
      "temperature_max": 28,
      "humidity": 75,
      "rainfall_mm": 15,
      "wind_speed_kmh": 18,
      "weather_condition": "rainy",
      "uvi": 3,
      "recommendation": "Delay spraying; reduce irrigation"
    },
    ...
  ]
}
```

### 10.2 Get Historical Weather
```
GET /weather/{field_id}/history?start_date=2024-02-05&end_date=2024-03-05

Response (200):
{
  "field_id": 1,
  "records": [
    {
      "date": "2024-02-05",
      "temperature_celsius": 25.5,
      "humidity_percent": 68,
      "rainfall_mm": 2.3,
      "wind_speed_kmh": 10
    },
    ...
  ]
}
```

---

## 11. Reports Endpoints

### 11.1 Generate Report
```
POST /reports
{
  "field_id": 1,
  "report_type": "seasonal",
  "report_period_start": "2024-01-01",
  "report_period_end": "2024-03-31"
}

Response (202):
{
  "report_id": "RPT-123456",
  "status": "generating",
  "estimated_completion_time": 120,
  "message": "Report generation in progress"
}
```

### 11.2 Get Report
```
GET /reports/{report_id}

Response (200):
{
  "id": "RPT-123456",
  "field_id": 1,
  "report_type": "seasonal",
  "generated_date": "2024-03-05T15:30:00Z",
  "file_url": "https://cdn.agrointel.com/reports/RPT-123456.pdf",
  "summary": {
    "period": "Q1 2024",
    "crops_monitored": ["wheat"],
    "total_soil_samples": 3,
    "average_yield_prediction": 5.8,
    "total_recommendations": 5,
    "implemented_recommendations": 2,
    "cost_savings": 150,
    "key_insights": [...]
  }
}
```

---

## 12. Admin Endpoints

### 12.1 User Management
```
GET /admin/users?page=1&limit=50

Response (200):
{
  "total": 1523,
  "page": 1,
  "users": [...]
}

POST /admin/users/{user_id}/deactivate
Response (200): { "message": "User deactivated" }
```

### 12.2 Model Configuration
```
GET /admin/models

Response (200):
{
  "models": [
    {
      "name": "yield_prediction_v2.3",
      "type": "regression",
      "status": "production",
      "accuracy": 0.89,
      "version": "2.3",
      "deployment_date": "2024-02-15",
      "predictions_served": 45230
    }
  ]
}

POST /admin/models/deploy
{
  "model_name": "yield_prediction_v2.4",
  "deployment_strategy": "blue_green"
}

Response (200): { "message": "Deployment initiated" }
```

### 12.3 System Health
```
GET /admin/health

Response (200):
{
  "status": "healthy",
  "timestamp": "2024-03-05T14:25:00Z",
  "components": {
    "api": "healthy",
    "database": "healthy",
    "cache": "healthy",
    "ml_services": "healthy",
    "sensor_connections": { "total": 1230, "connected": 1189, "disconnected": 41 }
  },
  "metrics": {
    "uptime_hours": 720,
    "requests_per_minute": 245,
    "average_response_time_ms": 145,
    "error_rate_percent": 0.02
  }
}
```

---

## Error Responses

All errors follow this format:

```
{
  "error": {
    "code": "FIELD_NOT_FOUND",
    "message": "Field with ID 999 not found",
    "details": {
      "field_id": 999,
      "timestamp": "2024-03-05T14:25:00Z"
    }
  }
}
```

### Common HTTP Status Codes
- **200**: Success
- **201**: Created
- **202**: Accepted (async operation)
- **400**: Bad Request
- **401**: Unauthorized
- **403**: Forbidden
- **404**: Not Found
- **429**: Too Many Requests (rate limit)
- **500**: Internal Server Error
- **503**: Service Unavailable

---

**Rate Limiting:**
- 100 requests/minute for authenticated users
- 10 requests/minute for unauthenticated users
- WebSocket connections: unlimited

**Pagination:**
- Default limit: 20
- Max limit: 100
- Response includes: total, page, limit, data

