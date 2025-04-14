/* 

1. Вывести имена и телефоны всех клиентов, у которых имя начинается на 'А' и отсортировать по фамилии:
*/
SELECT first_name, last_name, phone
FROM CLIENT
WHERE first_name LIKE 'А%'
ORDER BY last_name;

/* 

2. Показать список услуг и количество раз, когда каждая услуга была оказана, отсортированный по убыванию популярности:
*/
SELECT s.name, COUNT(rs.recording_id) AS service_count
FROM SERVICE s
JOIN RECORDING_SERVICES rs ON s.service_id = rs.services_id
GROUP BY s.name
ORDER BY service_count DESC;

/* 

3. Найти сотрудников (имя, фамилия), которые вносили изменения в историю записей после 1 апреля 2025 года, и количество этих изменений (GROUP BY и HAVING):
*/
SELECT e.first_name, e.last_name, COUNT(rh.history_id) AS changes_count
FROM EMPLOYEE e
JOIN RECORDING_HISTORY rh ON e.employee_id = rh.edit_by
WHERE rh.edit_timestemp > '2025-04-01'
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(rh.history_id) > 1 
ORDER BY changes_count DESC;

/* 

4. Вывести средний рейтинг для каждой услуги (оконная функция):
*/
SELECT
    s.name AS service_name,
    AVG(r.servise_rating) OVER (PARTITION BY s.service_id) AS average_rating
FROM
    SERVICE s
JOIN REVIEWS r ON s.service_id = r.service_id;

/* 

5. Найти имена клиентов, которые оставили отзывы с рейтингом 5, используя подзапрос с IN:
*/
SELECT first_name, last_name
FROM CLIENT
WHERE client_id IN (SELECT client_id FROM REVIEWS WHERE servise_rating = 5);

/* 

6. Найти услуги, которые не были оценены ни одним клиентом (LEFT JOIN и WHERE IS NULL):
*/
SELECT s.name
FROM SERVICE s
LEFT JOIN REVIEWS r ON s.service_id = r.service_id
WHERE r.review_id IS NULL;

/* 

7. Вывести список всех изменений статусов для записи с recording_id = 1, включая предыдущий и следующий статус (оконные функции LAG и LEAD):
*/
SELECT
    rh.edit_timestemp,
    rh.old_status,
    rh.new_status,
    LAG(rh.new_status, 1, 'Initial') OVER (ORDER BY rh.edit_timestemp) AS previous_status,
    LEAD(rh.new_status, 1, 'Final') OVER (ORDER BY rh.edit_timestemp) AS next_status
FROM
    RECORDING_HISTORY rh
WHERE rh.recording_id = 1
ORDER BY rh.edit_timestemp;

/* 

8. Определить топ-3 самых дорогих услуг (LIMIT и ORDER BY):
*/
SELECT name, price
FROM SERVICE
ORDER BY price DESC
LIMIT 3;

/* 

9. Список сотрудников со статусом 'Активен', работающих с записью, имеющей самый высокий recording_id (подзапрос и JOIN):
*/
SELECT e.first_name, e.last_name
FROM EMPLOYEE e
JOIN RECORDING_EMPLOYEES re ON e.employee_id = re.employee_id
WHERE re.recording_id = (SELECT MAX(recording_id) FROM RECORDING)
AND e.status = 'Активен';

/* 

10. Вывести все записи и связанные с ними услуги, отсортированные по дате записи, начиная с 5-ой записи (LIMIT и OFFSET):
*/
SELECT r.recording_id, s.name AS service_name, r.recording_date
FROM RECORDING r
JOIN RECORDING_SERVICES rs ON r.recording_id = rs.recording_id
JOIN SERVICE s ON rs.services_id = s.service_id
ORDER BY r.recording_date
LIMIT 10 OFFSET 4;
