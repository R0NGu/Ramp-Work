WITH daily AS (
  SELECT
    CONVERT(date, transaction_time) AS [day],
    SUM(CAST(transaction_amount AS decimal(18,2))) AS daily_total
  FROM dbo.transactions
  GROUP BY CONVERT(date, transaction_time)
),
rolling AS (
  SELECT
    [day],
    daily_total,
    AVG(CAST(daily_total AS decimal(18,2))) OVER (
      ORDER BY [day]
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3d_avg
  FROM daily
)
SELECT
  [day] AS target_day,
  CAST(rolling_3d_avg AS decimal(18,2)) AS rolling_3d_avg_daily_total
FROM rolling
WHERE [day] = DATEFROMPARTS(2021, 1, 31);