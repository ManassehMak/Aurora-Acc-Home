-- PostgreSQL Schema for AuroraDSK Catalog
-- Комментируем SET TIME ZONE, чтобы избежать ошибки
-- SET TIME ZONE 'UTC';

-- Drop existing tables if they exist
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS project_tags CASCADE;
DROP TABLE IF EXISTS balconies CASCADE;
DROP TABLE IF EXISTS bathrooms CASCADE;
DROP TABLE IF EXISTS bedrooms CASCADE;
DROP TABLE IF EXISTS project_files CASCADE;
DROP TABLE IF EXISTS project_images CASCADE;
DROP TABLE IF EXISTS project_params CASCADE;
DROP TABLE IF EXISTS project_sections CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Users table with external user support
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'manager', 'user', 'external_user')),
    is_external BOOLEAN DEFAULT FALSE,
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Projects table with extensible fields
CREATE TABLE projects (
    ID SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    main_pic VARCHAR(255),
    floors VARCHAR(2) NOT NULL CHECK (floors IN ('1', '2')),
    has_project VARCHAR(1) DEFAULT 'Y' CHECK (has_project IN ('Y', 'N')),
    notes TEXT,
    custom_fields JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    model_3d_view VARCHAR(512),
    model_3d_skp VARCHAR(255),
    embed_code TEXT,
    rd_zip_path VARCHAR(255)
);

CREATE INDEX idx_projects_floors ON projects (floors);
CREATE INDEX idx_projects_has_project ON projects (has_project);

-- Project parameters with extensible fields
CREATE TABLE project_params (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL UNIQUE REFERENCES projects (ID) ON DELETE CASCADE,
    foundation_shape VARCHAR(50) NOT NULL CHECK (foundation_shape IN ('Прямоугольный', 'Фигурный', 'Г-образный', 'П-образный', 'Другой')),
    sizes VARCHAR(100),
    square_fund NUMERIC(10,2),
    total_area NUMERIC(10,2) DEFAULT 0.00,
    square_1fl NUMERIC(10,2),
    square_2fl NUMERIC(10,2),
    square_terrace_1fl NUMERIC(10,2),
    square_terrace_2fl NUMERIC(10,2),
    kitchen_living_combined VARCHAR(1) DEFAULT 'N' CHECK (kitchen_living_combined IN ('Y', 'N')),
    square_kitchen_living NUMERIC(10,2),
    square_kitchen NUMERIC(10,2),
    square_living NUMERIC(10,2),
    master_bedroom VARCHAR(1) DEFAULT 'N' CHECK (master_bedroom IN ('Y', 'N')),
    sq_master_bedroom NUMERIC(10,2),
    dirt_room NUMERIC(10,2),
    tech_room NUMERIC(10,2),
    sauna_room VARCHAR(1) DEFAULT 'N' CHECK (sauna_room IN ('Y', 'N')),
    sq_sauna_room NUMERIC(10,2),
    ceiling_height NUMERIC(4,2),
    roof_type VARCHAR(50) CHECK (roof_type IN ('Двускатная', 'Вальмовая', 'Плоская', 'Мансардная', 'Другая')),
    wall_material VARCHAR(100),
    foundation_type VARCHAR(100),
    custom_params JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Project sections
CREATE TABLE project_sections (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    section_code VARCHAR(10) NOT NULL CHECK (section_code IN ('АР', 'КР', 'ЭОМ', 'ОВ', 'ВК', 'СС', 'ПОС'))
);

-- Project images
CREATE TABLE project_images (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    image_path VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    sort_order INTEGER DEFAULT 0,
    is_main VARCHAR(1) DEFAULT 'N' CHECK (is_main IN ('Y', 'N')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Project files
CREATE TABLE project_files (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(10) NOT NULL CHECK (file_type IN ('pdf', 'dwg', '3d', 'doc', 'xls', 'other')),
    file_name VARCHAR(255),
    file_size INTEGER,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bedrooms
CREATE TABLE bedrooms (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    bedroom_number INTEGER NOT NULL,
    bedroom_size NUMERIC(10,2) NOT NULL
);

-- Bathrooms
CREATE TABLE bathrooms (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    bathroom_number INTEGER NOT NULL,
    bathroom_size NUMERIC(10,2) NOT NULL
);

-- Balconies
CREATE TABLE balconies (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    balcony_number INTEGER NOT NULL,
    balcony_size NUMERIC(10,2) NOT NULL
);

-- Project tags for categorization
CREATE TABLE project_tags (
    ID SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects (ID) ON DELETE CASCADE,
    tag_name VARCHAR(100) NOT NULL
);

CREATE INDEX idx_project_tags_project_id ON project_tags (project_id);

-- Audit logs for tracking changes
CREATE TABLE audit_logs (
    ID SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users (ID) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INTEGER,
    details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for project_params
CREATE TRIGGER update_project_params_updated_at
    BEFORE UPDATE ON project_params
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for project_files
CREATE TRIGGER update_project_files_updated_at
    BEFORE UPDATE ON project_files
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Insert initial users (passwords are bcrypt-hashed 'password123')
INSERT INTO users (username, password_hash, role, email, is_external, permissions) VALUES
('admin', '$2y$10$DDNBVd7sk.xaTruN8fYA9epE2NVJa2TyGysgUx4eUGf5F36TkIvPu', 'admin', 'admin@example.com', FALSE, '{}'),
('manager', '$2y$10$z0eI4MjGh1Be7AwH.nxfleXjcHJG7DEvOKh37WJ5IiRCLGHAOYZXa', 'manager', 'manager@example.com', FALSE, '{}'),
('external1', '$2y$10$wdmQK9YhlDwh1BJk0gRYo.auDT8Rfy3Ajc2qAzSpRH4gb19Q4r86a', 'external_user', 'external1@example.com', TRUE, '{"projects": [7, 8]}');