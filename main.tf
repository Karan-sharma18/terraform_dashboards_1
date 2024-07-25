#apm dashboard - line 8
#infra dashboard - line 240
#browser dashboard - line 460


#FOR APM

resource "newrelic_one_dashboard" "relicstaurants_dash_new" {
  name        = "relicstaurants dashboard apm new"
  permissions = "public_read_only"

  page {
    name = "new relic terraform apm new"

    widget_billboard {
      title  = "total transactions"
      row    = 1
      column = 1
      width  = 6
      height = 3
      # colors {
      #   color = "yellow"
      # }

      nrql_query {
        query = "FROM Transaction SELECT count(*) AS 'total transactions'"
      }
    }

    # widget_bar {
    #   title  = "Average transaction duration, by application"
    #   row    = 4
    #   column = 1
    #   width  = 6
    #   height = 3

    #   nrql_query {
    #     account_id = 4438268
    #     query      = "FROM Transaction SELECT average(duration) FACET appName"
    #   }
    # }

    widget_line {
      title  = "Average transaction duration and the request per minute, by application"
      row    = 1
      column = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = 4438268
        query      = "FROM Transaction select max(duration) as 'max duration' where httpResponseCode = '504' timeseries"
      }

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute)"
      }

      threshold {
        name     = "Duration Threshold"
        from     = 1
        to       = 2
        severity = "critical"
      }

      threshold {
        name     = "Duration Threshold Two"
        from     = 2
        to       = 3
        severity = "warning"
      }

      units {
        unit = "ms"
        series_overrides {
          unit        = "ms"
          series_name = "max duration"
        }
      }


    }



    widget_billboard {
      title  = "application availability"
      row    = 10
      column = 8
      width  = 5
      height = 2

      nrql_query {
        account_id = 4438268
        query      = "SELECT percentage(count(*), WHERE `duration` > 0) AS Availability FROM Transaction SINCE 1 day ago"
      }
    }


    widget_bar {
      title  = "error rate"
      row    = 10
      column = 1
      width  = 7
      height = 1

      nrql_query {
        account_id = 4438268
        query      = "SELECT percentage(count(*), WHERE `error` IS true) AS ErrorRate FROM Transaction SINCE 1 day ago"
      }
    }
    




    widget_pie {
      title  = "application performance trends"
      row    = 4
      column = 1
      width  = 12
      height = 3

      nrql_query {
        account_id = 4438268
        query      = "SELECT average(`duration`) AS AvgResponseTime FROM Transaction SINCE 7 days ago COMPARE WITH 7 days ago"
      }
    }




    widget_funnel {
      title  = "transaction success rate"
      row    = 7
      column = 1
      width  = 7
      height = 3

      nrql_query {
        account_id = 4438268
        query      = "SELECT percentage(count(*), WHERE `error` IS false) AS TransactionSuccessRate FROM Transaction SINCE 1 day ago"
      }
    }




    widget_billboard {
      title  = "throughput"
      row    = 7
      column = 8
      width  = 5
      height = 3

      nrql_query {
        account_id = 4438268
        query      = "SELECT count(*) AS Throughput FROM Transaction SINCE 1 day ago"
      }
    }




    widget_billboard {
      title  = "database response time"
      row    = 11
      column = 1
      width  = 7
      height = 2

      nrql_query {
        account_id = 4438268
        query      = "SELECT average(databaseDuration) FROM Transaction TIMESERIES"
      }
    }

    

    # widget_markdown {
    #   title  = "Dashboard Note"
    #   row    = 7
    #   column = 1
    #   width  = 12
    #   height = 3

    #   text = "### Helpful Links\n\n* [New Relic One](https://one.newrelic.com)\n* [Developer Portal](https://developer.newrelic.com)"
    # }


    

    # widget_line {
    #   title  = "Overall CPU % Statistics"
    #   row    = 1
    #   column = 5
    #   height = 3
    #   width  = 4

    #   nrql_query {
    #     query = <<EOT
    #     SELECT average(cpuSystemPercent), average(cpuUserPercent), average(cpuIdlePercent), average(cpuIOWaitPercent) FROM SystemSample WHERE hostname = 'DESKTOP-DBGEEJK' SINCE 2 hour ago TIMESERIES
    #     EOT
    #   }
    #   null_values {
    #     null_value = "default"

    #     series_overrides {
    #       null_value  = "remove"
    #       series_name = "Avg Cpu User Percent"
    #     }

    #     series_overrides {
    #       null_value  = "zero"
    #       series_name = "Avg Cpu Idle Percent"
    #     }

    #     series_overrides {
    #       null_value  = "default"
    #       series_name = "Avg Cpu IO Wait Percent"
    #     }

    #     series_overrides {
    #       null_value  = "preserve"
    #       series_name = "Avg Cpu System Percent"
    #     }
    #   }

    # }

  }
}





#FOR INFRA


resource "newrelic_one_dashboard" "dash_infra_new" {
  name = "infra_dash_new"
  page {
    name = "new relic terraform infra new"
    
    widget_line {
      title  = "Overall CPU % Statistics"
      row    = 1
      column = 1
      height = 3
      width  = 8

      nrql_query {
        query = <<EOT
        SELECT average(cpuSystemPercent), average(cpuUserPercent), average(cpuIdlePercent), average(cpuIOWaitPercent) FROM SystemSample WHERE hostname = 'DESKTOP-DBGEEJK' SINCE 2 hour ago TIMESERIES
        EOT
      }
      null_values {
        null_value = "default"

        series_overrides {
          null_value  = "remove"
          series_name = "Avg Cpu User Percent"
        }

        series_overrides {
          null_value  = "zero"
          series_name = "Avg Cpu Idle Percent"
        }

        series_overrides {
          null_value  = "default"
          series_name = "Avg Cpu IO Wait Percent"
        }

        series_overrides {
          null_value  = "preserve"
          series_name = "Avg Cpu System Percent"
        }
      }

    }

    widget_bar {
      title = "CPU utilization"
      row = 4
      column = 1
      width = 4
      height = 2

      nrql_query {
        query = "SELECT average(cpuPercentage) AS AvgCpuUtilization FROM SystemSample"
      }
    }



    widget_bar {
      title = "Memory utilization"
      row = 6
      column = 1
      width = 5
      height = 2

      nrql_query {
        query = "SELECT average(memoryUsedBytes/memoryTotalBytes * 100) AS AvgMemoryUtilization FROM SystemSample"
      }
    }


    widget_bar {
      title = " Disk Usage"
      row = 8
      column = 1
      width = 5
      height = 1

      nrql_query {
        query = "SELECT latest(diskUsedPercent) AS CurrentDiskUsage FROM DiskSample"
      }
    }


    widget_pie {
      title = "Network Traffic"
      row = 4
      column = 5
      width = 8
      height = 2

      nrql_query {
        query = "SELECT average(recieveBytesPerSecond) AS AvgIncomingtraffic, average(transmitBytesPerSecond) AS AvgoutgoingTraffic FROM SystemSample"
      }
    }


    # widget_bar {
    #   title = "Response Time"
    #   row = 9
    #   column = 1
    #   width = 12
    #   height = 2

    #   nrql_query {
    #     query = "SELECT average(duration) AS AvgResponseTime FROM Transaction WHERE appName = 'browser-new-relicstaurants'"
    #   }
    # }



    widget_pie {
      title = "mean time to resolve"
      row = 6
      column = 6
      width = 7
      height = 3

      nrql_query {
        query = "SELECT average(`resolutionTime`) AS AvgResolutionTime FROM InfrastructureEvent SINCE 1 day ago"
      }
    }



    #  widget_billboard {
    #   title = "up time and availability"
    #   row = 1
    #   column = 9
    #   width = 4
    #   height = 3

    #   nrql_query {
    #     query = "SELECT percentage(count(*), WHERE `duration` > 0) AS Availability FROM InfrastructureEvent SINCE 1 day ago"
    #   }
    # }
    widget_billboard {
      title = "thread count"
      row = 1
      column = 9
      width = 4
      height = 3

      nrql_query {
        query = "SELECT threadCount FROM ProcessSample SINCE 1 hour ago"
      }
    }


      widget_billboard {
      title = "availability"
      row = 9
      column = 7
      width = 6
      height = 3

      nrql_query {
        query = "SELECT percentage(count(*), WHERE `duration` > 0) AS Availability FROM InfrastructureEvent SINCE 1 day ago"
      }
    }
    
    


    # widget_bullet {
    #   title = "cpu Idle Percentage"
    #   row = 9
    #   column =
    #   height = 3
    #   width = 4
    #   limit = 0
    #   legend_enabled = false
      

    #   nrql_query {
    #     query = "SELECT average(cpuIdlePercent) FROM SystemSample"
    #   }
    # }



    widget_billboard {
      title = "cpu idle percentage"
      column = 1
      height = 3
      row = 9
      width = 6

      nrql_query {
        query = "SELECT average(cpuIdlePercent) FROM SystemSample"
      }
    }




    widget_table {
      title = "process count"
      column = 1
      height = 3
      row = 12
      width = 12

      nrql_query {
        query = "SELECT count(*) FROM ProcessSample WHERE entityName = 'DESKTOP-DBGEEJK' FACET processDisplayName"
      }
    }



  }
  
}








#FOR BROWSER


resource "newrelic_one_dashboard" "browser_dash_new" {
  name = "browser dash new"
  page {
    name = "new relic terraform browser new"
    
    widget_line {
      title = "error rate"
      row = 4
      column = 1
      height = 3
      width = 5
      colors {
        color = "red"
      }

      nrql_query {
        query = "SELECT count(error) FROM Transaction WHERE appName = 'relics-browser'"
      }
    }
    

    widget_pie {
      title = "insights"
      row = 1
      column = 1
      width = 12
      height = 3

      nrql_query {
        query = "SELECT count(session) AS sessions, average(duration) AS AvgDuration, count(*) AS PageViews FROM PageView"
      }

    }

    widget_bar {
      title = "bounce rate"
      row = 4
      column = 6
      width = 7
      height = 3

      nrql_query {
        query = "SELECT (filter(count(session), WHERE sessionDuration < 1 * 60) / count(session)) * 100 AS BounceRate FROM PageView WHERE appName = 'relics-browser' TIMESERIES "
      }
    }

    widget_funnel {
      title = "funnel"
      row = 7
      column = 1
      width = 12
      height = 3
      colors {
        color = "#3366cc"
      }

      nrql_query {
        query = "SELECT count(session) AS sessions, average(duration) AS AvgDuration, count(*) AS PageViews,   funnel(session, where pageUrl = 'Restaurants') AS RestaurantsViews,  funnel(session, where pageUrl = 'Conatact') AS ContactViews,  funnel(session, where pageUrl = 'Payment') AS PaymentViews FROM PageView"
      }
      }
      



      widget_bar {
      title = "conversion rate"
      row = 10
      column = 5
      width = 8
      height = 2
      nrql_query {
        query = "SELECT funnel(session, WHERE conversionEvent = true) AS ConversionRate FROM PageView"
      }
      }




      widget_bar {
      title = "average order value"
      row = 12
      column = 5
      width = 8
      height = 2
      nrql_query {
        query = "SELECT average(orderValue) AS AvgOrderValue FROM Transaction"
      }
      }





      widget_bar {
      title = "revenue per visitor"
      row = 14
      column = 1
      width = 12
      height = 2
      nrql_query {
        query = "SELECT sum(totalRevenue) / count(uniqueUserIds) AS RevenuePerVisitor FROM Transaction"
      }
      }
      


      widget_line {
      title = "cart abandonment rate"
      row = 16
      column = 1
      width = 12
      height = 3
      nrql_query {
        query = "SELECT percentage(count(*), WHERE cartAbandoned = true) AS CartAbandonmentRate FROM PageView"
      }
      }




      # widget_billboard {
      # title = "customer lifetime value"
      # row = 7
      # column = 1
      # width = 12
      # height = 3
      # nrql_query {
      #   query = "SELECT sum(totalRevenue) / count(distinct userId) AS CustomerLifetimeValue FROM Transaction SINCE 1 day ago"
      # }
      # }



      widget_billboard {
      title = "average session duration"
      row = 12
      column = 1
      width = 4
      height = 2
      nrql_query {
        query = "SELECT average(sessionDuration) AS AvgSessionDuration FROM PageView"
      }
      }


      widget_billboard {
      title = "session detals"
      row = 10
      column = 1
      width = 4
      height = 2
      nrql_query {
        query = "SELECT uniqueCount(session) AS 'Sessions' FROM PageView  FACET city , countryCode SINCE 30 days ago"
      }
      }


    }
  }


# SELECT 
#   (filter(count(session), WHERE sessionDuration < 15 * 60) / count(session)) * 100 AS BounceRate
# FROM 
#   PageView
# WHERE
#   appName = 'YOUR_APPLICATION_NAME'
# SINCE 
#   1 day ago


# SELECT 
#   count(session) AS Sessions,
#   average(duration) AS AvgDuration,
#   percentile(duration, 95) AS P95Duration,
#   count(*) AS PageViews,
#   funnel(session, where pageUrl = 'Restaurants') AS RestaurantsViews,
#   funnel(session, where pageUrl = 'contact') AS contactViews,
#   funnel(session, where pageUrl = 'Payment') AS PaymentViews
# FROM 
#   PageView
# SINCE 
#   1 day ago
