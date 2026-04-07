-- AGROIntel Database Schema

-- 1. Users & Authentication
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    role VARCHAR(50) DEFAULT 'farmer', -- farmer, agribusiness, admin
    is_active BOOLEAN DEFAULT TRUE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    profile_picture_url TEXT
);

-- 2. Organizations (Agribusiness, Farms)
CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    org_type VARCHAR(50) DEFAULT 'farm', -- farm, agribusiness, cooperative
    owner_id INTEGER REFERENCES users(id),
    region VARCHAR(100),
    country VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    total_area_hectares DECIMAL(10, 2),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Fields/Plots
CREATE TABLE fields (
    id SERIAL PRIMARY KEY,
    organization_id INTEGER REFERENCES organizations(id) ON DELETE CASCADE,
    field_name VARCHAR(255) NOT NULL,
    field_code VARCHAR(50) UNIQUE,
    area_hectares DECIMAL(10, 2),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    crop_type VARCHAR(100), -- wheat, maize, rice, etc.
    planting_date DATE,
    expected_harvest_date DATE,
    irrigation_type VARCHAR(100), -- drip, flood, rain-fed
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Soil Data
CREATE TABLE soil_samples (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    sample_date DATE NOT NULL,
    depth_cm INTEGER, -- sampling depth in cm
    soil_type VARCHAR(100), -- clay, loam, sandy
    ph_level DECIMAL(4, 2),
    nitrogen_mg_per_kg DECIMAL(8, 2),
    phosphorus_mg_per_kg DECIMAL(8, 2),
    potassium_mg_per_kg DECIMAL(8, 2),
    organic_matter_percent DECIMAL(5, 2),
    moisture_percent DECIMAL(5, 2),
    bulk_density_g_per_cm3 DECIMAL(4, 2),
    cec_meq_per_100g DECIMAL(5, 2), -- Cation Exchange Capacity
    electrical_conductivity_ds_per_m DECIMAL(5, 2),
    notes TEXT,
    lab_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Real-time Monitoring Data (for InfluxDB integration metadata)
CREATE TABLE sensor_metadata (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    sensor_id VARCHAR(100) UNIQUE NOT NULL,
    sensor_type VARCHAR(50), -- temperature, humidity, soil_moisture, pressure
    sensor_brand VARCHAR(100),
    location_description VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    installation_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    battery_level_percent INTEGER,
    last_reading_timestamp TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Yield Data (Historical & Predicted)
CREATE TABLE yield_records (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    season_year INTEGER,
    season VARCHAR(20), -- rabi, kharif, summer
    predicted_yield_tons_per_hectare DECIMAL(8, 2),
    actual_yield_tons_per_hectare DECIMAL(8, 2),
    confidence_interval_percent DECIMAL(5, 2),
    prediction_date TIMESTAMP,
    harvest_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Weather Integration
CREATE TABLE weather_records (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    date DATE,
    temperature_celsius DECIMAL(5, 2),
    humidity_percent INTEGER,
    rainfall_mm DECIMAL(8, 2),
    wind_speed_kmh DECIMAL(5, 2),
    weather_condition VARCHAR(100), -- sunny, rainy, cloudy, etc.
    uvi INTEGER, -- UV Index
    pressure_mb DECIMAL(7, 2),
    source VARCHAR(50), -- openweathermap, weatherapi, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Recommendations
CREATE TABLE recommendations (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    recommendation_type VARCHAR(50), -- fertilizer, irrigation, pest, disease
    title VARCHAR(255),
    description TEXT,
    estimated_impact TEXT,
    implementation_cost_usd DECIMAL(10, 2),
    priority_level VARCHAR(20), -- high, medium, low
    recommended_date DATE,
    expected_result TEXT,
    status VARCHAR(50) DEFAULT 'pending', -- pending, applied, completed
    applied_date DATE,
    result_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Alerts & Anomalies
CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    alert_type VARCHAR(50), -- drought, disease, pest, soil_degradation, extreme_weather
    severity_level VARCHAR(20), -- critical, high, medium, low
    title VARCHAR(255),
    description TEXT,
    detection_timestamp TIMESTAMP,
    affected_area_percent DECIMAL(5, 2),
    recommended_action TEXT,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Fertilizer & Irrigation Plans
CREATE TABLE treatment_plans (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    plan_type VARCHAR(50), -- fertilizer, irrigation, pest_control
    start_date DATE,
    end_date DATE,
    description TEXT,
    expected_outcome TEXT,
    estimated_cost_usd DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'planned', -- planned, in_progress, completed
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Treatment Plan Details (line items)
CREATE TABLE treatment_plan_items (
    id SERIAL PRIMARY KEY,
    plan_id INTEGER REFERENCES treatment_plans(id) ON DELETE CASCADE,
    item_name VARCHAR(255),
    quantity DECIMAL(10, 2),
    unit VARCHAR(50), -- kg, liters, units
    application_date DATE,
    application_method VARCHAR(100),
    notes TEXT,
    cost_usd DECIMAL(10, 2)
);

-- 12. Historical Predictions & Model Performance
CREATE TABLE prediction_records (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    model_version VARCHAR(50),
    prediction_type VARCHAR(50), -- yield, soil_health, disease_risk
    input_features JSONB,
    predicted_value DECIMAL(10, 4),
    confidence_score DECIMAL(5, 4),
    actual_value DECIMAL(10, 4),
    prediction_error DECIMAL(10, 4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 13. User Activities & Audit Log
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100),
    entity_type VARCHAR(50),
    entity_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Subscriptions & Billing
CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    organization_id INTEGER REFERENCES organizations(id),
    plan_type VARCHAR(50), -- free, basic, pro, enterprise
    monthly_price_usd DECIMAL(10, 2),
    max_fields INTEGER,
    max_sensors INTEGER,
    features JSONB,
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    auto_renew BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. Reports
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    field_id INTEGER REFERENCES fields(id) ON DELETE CASCADE,
    report_type VARCHAR(50), -- monthly, seasonal, annual, custom
    generated_date TIMESTAMP,
    report_period_start DATE,
    report_period_end DATE,
    content JSONB,
    file_url TEXT,
    generated_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_organizations_owner_id ON organizations(owner_id);
CREATE INDEX idx_fields_organization_id ON fields(organization_id);
CREATE INDEX idx_soil_samples_field_id ON soil_samples(field_id);
CREATE INDEX idx_soil_samples_sample_date ON soil_samples(sample_date);
CREATE INDEX idx_yield_records_field_id ON yield_records(field_id);
CREATE INDEX idx_yield_records_season_year ON yield_records(season_year);
CREATE INDEX idx_weather_records_field_id ON weather_records(field_id);
CREATE INDEX idx_weather_records_date ON weather_records(date);
CREATE INDEX idx_recommendations_field_id ON recommendations(field_id);
CREATE INDEX idx_recommendations_status ON recommendations(status);
CREATE INDEX idx_alerts_field_id ON alerts(field_id);
CREATE INDEX idx_alerts_severity ON alerts(severity_level);
CREATE INDEX idx_alerts_resolved ON alerts(is_resolved);
CREATE INDEX idx_sensor_metadata_field_id ON sensor_metadata(field_id);
CREATE INDEX idx_predictions_field_id ON prediction_records(field_id);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Enable PostGIS for geographical features
CREATE EXTENSION IF NOT EXISTS postgis;

-- Add spatial index for field locations
CREATE INDEX idx_fields_geom ON fields USING GIST(ST_GeomFromText(concat('POINT(', longitude, ' ', latitude, ')'), 4326));
