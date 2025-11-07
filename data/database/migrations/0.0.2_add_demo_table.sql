-- 0.0.2_add_demo_table.sql
USE benchmarks;

CREATE TABLE IF NOT EXISTS demo_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    note VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
