
function generateChart(div_id, title, data_name, data) {
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
                    text: 'Number of Analysis'
                },
                labels: {
                    formatter: function() {
                        return this.value; // clean, unformatted number for year
                    }
                }
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
                pointFormat: 'The value of '+data_name+' was <b>{point.y:,.2f}</b><br/>in the {point.x}th analysis'
            },
            plotOptions: {
                area: {
                    pointStart: 1,
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



