-- Таблица Клиентов
CREATE TABLE CLIENT (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20)
);

-- Таблица Услуг
CREATE TABLE SERVICE (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

-- Таблица Сотрудников
CREATE TABLE EMPLOYEE (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    phone VARCHAR(20), 
    status VARCHAR(20) 
);

-- Таблица REVIEWS (Отзывы)
DROP TABLE IF EXISTS reviews;

CREATE TABLE REVIEWS (
    review_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    servise_rating INTEGER NOT NULL CHECK (servise_rating BETWEEN 1 AND 5),
    FOREIGN KEY (client_id) REFERENCES CLIENT (client_id),
    FOREIGN KEY (service_id) REFERENCES SERVICE (service_id)
);
-- Таблица Записей (RECORDING)
CREATE TABLE RECORDING (
    recording_id SERIAL PRIMARY KEY,
    review_id INTEGER NULL, -- Похоже, должен быть nullable, если запись может быть создана до отзыва
    status VARCHAR(50) NOT NULL CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    recording_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Дата создания записи
    status_update_time TIMESTAMP, -- Дата изменения статуса
    FOREIGN KEY (review_id) REFERENCES REVIEWS (review_id) -- Теперь ссылка верна, т.к. REVIEWS создана
);

-- Таблица Связи RECORDING_EMPLOYEES 
CREATE TABLE RECORDING_EMPLOYEES (
    recording_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    PRIMARY KEY (recording_id, employee_id),
    FOREIGN KEY (recording_id) REFERENCES RECORDING (recording_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id)
);

-- Таблица Связи RECORDING_SERVICES 
CREATE TABLE RECORDING_SERVICES (
    recording_id INTEGER NOT NULL,
    services_id INTEGER NOT NULL,
    PRIMARY KEY (recording_id, services_id),
    FOREIGN KEY (recording_id) REFERENCES RECORDING (recording_id),
    FOREIGN KEY (services_id) REFERENCES SERVICE (service_id)
);

-- Таблица History (История изменений записи)
CREATE TABLE RECORDING_HISTORY (
    history_id SERIAL PRIMARY KEY,
    recording_id INTEGER NOT NULL,
    old_status VARCHAR(50) NOT NULL,
    new_status VARCHAR(50) NOT NULL,
    edit_timestemp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    edit_by INTEGER,
    FOREIGN KEY (recording_id) REFERENCES RECORDING (recording_id)
);