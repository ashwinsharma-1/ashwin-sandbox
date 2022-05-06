"select
lead_created_date
, lead_country
    , count(distinct case when lead_touched_by_self_serve then lead_id else null end) leads
    , count(distinct case when lead_touched_by_self_serve and lead_is_converted then lead_id else null end) as opportunities
    , count(distinct case when lead_touched_by_self_serve and opp_is_won then lead_id else null end) closed_won
    , count(distinct case when lead_touched_by_self_serve
            and lead_dropped_to_sales
            and opp_is_won
            and closed_won_ts < dateadd(days, 28, lead_created_ts)
            then opportunity_id end) as sales_assisted_at_lead_28d
    , sum(case when lead_touched_by_self_serve
            and lead_dropped_to_sales
            and opp_is_won
            and closed_won_ts < dateadd(days, 28, lead_created_ts)
      then datediff(hours, lead_created_ts, closed_won_ts) end) sales_assisted_at_lead_hours
    , count(distinct case when opportunity_touched_by_self_serve_28d
            and opportunity_dropped_to_sales
            and opp_is_won
            and closed_won_ts < dateadd(days, 28, lead_created_ts)
            then opportunity_id end) as sales_assisted_at_opportunity
    , sum(case when opportunity_touched_by_self_serve_28d
            and opportunity_dropped_to_sales
            and opp_is_won
            and closed_won_ts < dateadd(days, 28, lead_created_ts)
      then datediff(hours, lead_created_ts, closed_won_ts) end) sales_assisted_at_opp_hours
    , count(distinct case when opportunity_touched_by_self_serve_28d
            and not self_serve_dropped
            and opp_is_won
            and closed_won_ts < dateadd(days, 28, lead_created_ts)
            then opportunity_id end) as pure_self_serve_restaurants
    , sum(case when opportunity_touched_by_self_serve_28d
            and not self_serve_dropped
            and opp_is_won
            and closed_won_ts < dateadd(days, 28, lead_created_ts)
      then datediff(hours, lead_created_ts, closed_won_ts) end) pure_sso_hours
from production.denormalised.restaurant_acquisition_funnel
where lead_created_ts >= '2021-09-01'
group by 1,2
order by 1,2 desc"
