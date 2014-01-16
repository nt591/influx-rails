$ ->
  if $("#container").length > 0
    $.getJSON '/influx', (data) ->
      $.each data, (i, v) ->
        $.each data[i], (index, value) ->
          js_time =  data[i][index].x * 1000
          data[i][index].x = new Date(js_time)

      $('#container').highcharts
        chart: 
            type: 'line'
        
        title: 
            text: 'Events per day'
        
        xAxis:
          title:
            text: 'time'
          type: 'datetime'
          dateTimeLabelFormats: 
            day: '%e %b %y'

        yAxis: 
            title: 
              text: 'Events'
        
        series: [
            name: 'open',
            data: data.open
          , 
            name: 'click',
            data: data.click
          , 
            name: 'delivered',
            data: data.delivered
          , 
            name: 'bounce',
            data: data.bounce
          , 
            name: 'unsubscribe',
            data: data.unsubscribe
        ]

  if $('#sql').length > 0
    $.getJSON '/mysql', (data) ->
      $.each data, (i, v) ->
        $.each data[i], (index, value) ->
          date = new Date(data[i][index].x)
          data[i][index].x = date

      $('#sql').highcharts
        chart: 
            type: 'line'
        
        title: 
            text: 'Events per day'
        
        xAxis:
          title:
            text: 'time'
          type: 'datetime'
          dateTimeLabelFormats: 
            day: '%e %b %y'

        yAxis: 
            title: 
              text: 'Events'
        
        series: [
            name: 'open',
            data: data.open
          , 
            name: 'click',
            data: data.click
          , 
            name: 'delivered',
            data: data.delivered
          , 
            name: 'bounce',
            data: data.bounce
          , 
            name: 'unsubscribe',
            data: data.unsubscribe
        ]
