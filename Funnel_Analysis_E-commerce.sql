-- 1. Funnel Analysis
#Funnel analysis is a method of measuring the steps users take to reach a goal (usually a purchase) and how many people drop out at each step.

-- 1.1) General Funnel Conversion
#Purpose: To calculate the recycling rate.
#Business Problem: What percentage of users who visit the site make a purchase?
#Data to be used: events_clean
#Columns to be used: user_id, session_id, event_type, device_type, traffic_source

SELECT * FROM events_clean;

SELECT 
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END) AS add_to_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END) AS begin_checkouts
FROM events_clean;

#Conversion Rate: (Number of Conversions / Total Visitors) * 100
SELECT
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END)
        /
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END)
    * 100, 2) AS conversion_rate_percentage
FROM events_clean;

-- 1.2) Device based Conversion
#Business Problem: Why are there fewer conversions on desktop?

SELECT
    device_type,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END) AS begin_checkout,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END)
        /
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END)
    * 100,2) AS device_conversion_rate
FROM events_clean
GROUP BY device_type
ORDER BY device_conversion_rate DESC;

-- 1.3) Traffic Source based Conversion
#Business Problem: Which traffic is higher quality?

SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END) AS begin_checkout,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END)
        /
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END)
    * 100,2) AS traffic_conversion_rate
FROM events_clean
GROUP BY traffic_source
ORDER BY traffic_conversion_rate DESC;

-- 1.4) Step-by-Step Drop-off Analysis
#Business Problem: In which step is the biggest loss?

SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END) AS add_to_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END) AS begin_checkout,

    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END)
        /
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END)
    * 100,2) AS view_to_cart_rate,

    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END)
        /
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END)
    * 100,2) AS cart_to_begin_checkout_rate
FROM events_clean;












