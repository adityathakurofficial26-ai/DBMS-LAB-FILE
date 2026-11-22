            IF(i % 2 = 0, 'Confirmed', 'Waiting')
        );

        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;

CALL InsertBookings();

-- Verify total records
SELECT COUNT(*) AS Total_Records FROM RailwayBooking;

-- 1. Query before indexing
EXPLAIN
SELECT * FROM RailwayBooking
WHERE TrainID = 105;

SELECT * FROM RailwayBooking
WHERE TrainID = 105;

-- 2. Create single-column index
CREATE INDEX idx_train
ON RailwayBooking(TrainID);

-- Query after single index
EXPLAIN
SELECT * FROM RailwayBooking
WHERE TrainID = 105;

SELECT * FROM RailwayBooking
WHERE TrainID = 105;

-- 3. Create composite index
CREATE INDEX idx_train_date
ON RailwayBooking(TrainID, JourneyDate);

-- Query after composite index
EXPLAIN
SELECT * FROM RailwayBooking
WHERE TrainID = 105
AND JourneyDate = '2026-01-06';

SELECT * FROM RailwayBooking
WHERE TrainID = 105
AND JourneyDate = '2026-01-06';

-- 4. Display indexes
SHOW INDEX FROM RailwayBooking;

-- 5. Check query execution plan
EXPLAIN
SELECT * FROM RailwayBooking
WHERE TrainID = 105
AND JourneyDate = '2026-01-06';