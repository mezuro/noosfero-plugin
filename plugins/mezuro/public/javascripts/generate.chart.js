
function generateChart(div_id, title, data_name, data, start_date) {
        jQuery('.'+div_id).highcharts({
            chart: {
                type: 'area'
            },
            title: {
                text: title
            },
            subtitle: {
                text: 'by Kalibro'
            },
            xAxis: {
                title: {
                    text: 'Dates'
                },
                labels: {
                    formatter: function() {
                        return this.value; // clean, unformatted number for year
                    }
                }
            //minorTickInterval: 0.1
            },
            yAxis: {
                title: {
                    text: 'Value'
                },
                labels: {
                    formatter: function() {
                        return this.value;
                    }
                }
            },
            tooltip: {
                pointFormat: 'The value of '+data_name+' was <b>{point.y:,.2f}</b><br/>in {point.x}'
            },
            plotOptions: {
                area: {
                    pointStart: parseInt(start_date, 10),
                    marker: {
                        enabled: false,
                        symbol: 'circle',
                        radius: 2,
                        states: {
                            hover: {
                                enabled: true
                            }
                        }
                    }
                }
            },
            series: [{
                name: data_name,
                data: data
            }]
        });
    }



