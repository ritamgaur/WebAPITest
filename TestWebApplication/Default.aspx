<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TestWebApplication.Default" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Weight Addition WebAPI Client</title>
    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <!--        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">-->
    <link href="css/modern-business.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script type="application/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <!-- Latest compiled and minified CSS -->
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link href="css/style.css" rel="stylesheet">
    <style>
        table th {
            background: #9573b7;
            color: white;
        }

        table,
        th,
        td {
            border: 1px solid black;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 5px;
            text-align: left;
        }
    </style>
    <script>
        $(document).ready(function () {
            //addRow();
            getUnit(2);
            $('.loader').hide();
            $('#divMsg').hide();
            $('#divErrorMsg').hide();
            unitSelect();
        });

        function Delete(thisParam) {
            thisParam.closest('tr').remove();
        }

        function unitSelect() {
            getUnit(1);
        }

        function addRow(data) {
            var i = $('#tbl tbody tr').length;
            var AddOption = '';
            $.each(data.units, function (i, item) {
                AddOption += '<option value="' + item + '">' + item + '</option>'
            });
            var tableRow = '<tr>';
            tableRow += '<td><input type="text" class="data form-control decimal" id="Value' + i + ' " placeholder="Value"></td>';
            tableRow += '<td><select class="data form-control" id="Unit' + i + '">' + AddOption + ' </select></td>';
            tableRow += '<td><button class="btn btn-dange" style="background-color:transparent;" onclick="Delete($(this))"> <i class="fa fa-trash-o"></i></button> </td>';
            tableRow += '</tr>';
            $('#tbl tbody').append(tableRow);
        }

        function getUnit(param) {
            $.ajax("https://unitscalcwebapi.azurewebsites.net/api/GetUnits/GetUnit", {
                type: "GET"
                , dataType: "json"
                , contentType: "application/json; charset=UTF-8"
                //, data: JSON.stringify(abc)
            }).done(function (data) {
                if (param === 1) {
                    bindDropdown(data);
                }
                else if (param === 2) {
                    addRow(data);
                }
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR);
                console.log(textStatus);
                console.log(errorThrown);
                OnError(jqXHR, textStatus, errorThrown);
            });
            async: false
        }

        function bindDropdown(data) {
            var AddOption = '';
            $.each(data.units, function (i, item) {
                AddOption += '<option value="' + item + '">' + item + '</option>'
            });
            $('#unitSelect').append(AddOption);
        }

        function submit() {
            let counter = 0;
            if ($('#tbl tbody tr').length < 1) {
                alert('Please add at least one row');
                return false;
            }
            $('table tbody tr').children("td").not(':last').each(function () {
                if ($(this).children('.data').val() === '') counter = counter + 1;
            })
            if (counter > 0) {
                alert('Please enter all the values!!');
                return false;
            }
            $('.loader').show();
            $('.Save').hide();
            var keys = []
                , arrayObj = [];
            keys.push('value');
            keys.push('unit');
            //            $("table thead tr th").not(':last').each(function () {
            //                keys.push($(this).html().toLowerCase());
            //            });
            $("table tbody tr").each(function () {
                var obj = {}
                    , i = 0;
                $(this).children("td").not(':last').each(function () {
                    obj[keys[i]] = $(this).children('.data').val();
                    i++;
                })
                arrayObj.push(obj);
            });
            console.log(JSON.stringify(arrayObj));
            var abc = {
                "items": arrayObj
            };
            $.ajax("https://unitscalcwebapi.azurewebsites.net/api/Values/Calculate", {
                type: "POST"
                , dataType: "json"
                , contentType: "application/json; charset=UTF-8"
                , data: JSON.stringify(abc)
            }).done(function (data) {
                OnSuccess(data);
            }).fail(function (jqXHR, textStatus, errorThrown) {
                //                a = jqXHR.responseText;
                //                console.log(a);
                //                console.log(textStatus);
                //                console.log(errorThrown);
                OnError(jqXHR, textStatus, errorThrown);
            });
            $('.loader').hide();
            $('.Save').show();
        }

        function OnError(jqXHR, textStatus, errorThrown) {
            var data = JSON.parse(jqXHR.responseText);
            console.log(data);
            $('#divErrorMsg').show();
            //$('#lblErrorMsg').text("Status : "+textStatus + "\n Error : "+errorThrown);
            $('#lblErrorMsg').text(data.Message);
        }

        function OnSuccess(data) {
            var viewUnitsIn = $('#unitSelect').val();
            var result = 0.00;
            var response = data.Value;
            if (viewUnitsIn.toLowerCase() == 'g') {
                result = parseFloat(response / 1000.00).toFixed(6);
            }
            else if (viewUnitsIn.toLowerCase() == 'kg') {
                result = parseFloat(response / 1000000.00).toFixed(6);
            }
            else {
                result = parseFloat(response).toFixed(2);
            }
            $('#divErrorMsg').hide();
            $('#lblErrorMsg').text("");
            $('#divMsg').show();
            $('#lblMsg').text(result + ' ' + viewUnitsIn);
        }
    </script>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.html">Weight Addition API Client</a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
        </div>
    </nav>
    <!-- Page Content -->
    <div class="container">
        <!-- Page Heading/Breadcrumbs -->
        <!-- Page Heading/Breadcrumbs -->
        <h5 class="mt-4 mb-3">
            <small><span>Enter data by entering values(numbers), selecting respective units, and clicking "Add". You can add as many rows.
                        <br />
                Once done, click on the "Perform Addition" button to get a sum of all values. You can also select the unit in which you would like to see the total sum of all values. 
            </span>
            </small>
        </h5>
        <div class="row">
            <table class="table table-bordered" style="width: 100%" id="tbl">
                <thead>
                    <tr>
                        <th class="value">Value</th>
                        <th class="unit">Unit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody></tbody>
                <tfoot>
                    <tr>
                        <td colspan="3"><a href="#" class="btn" title="Add new row" onclick="getUnit(2)"><i class="fa fa-plus"></i>Add Row</a>
                    </tr>
                </tfoot>
            </table>
            <br>
        </div>
        <div class="row" style="padding-top: 15px; width:40%">
            <div class="col-sm-4">Show results in:</div>
            <div class="col-sm-3">
                <select class="data form-control" id="unitSelect"></select>
            </div>
            <div class="col-sm-3" >
                <a href="#" class="btn btn-info" id="Save" title="Submit" onclick="submit()"><i class="fa fa-floppy-o"></i>Submit</a>
                <!--<button class="btn btn-success" id="Save" onclick="submit()"> <i class="fa fa-floppy-o"></i> Submit</button>-->
            </div>
            <div class="col-sm-2">
                <div class="loader">Loading...</div>
            </div>
        </div>
        <div class="row" id="divMsg" style="padding-top: 15px;">
            <br />
            <br />
            <label>The Result is <strong><span id="lblMsg"></span></strong></label>
        </div>

        <div class="row" style="padding-top: 15px;">
            <small><span>The results are shown upto 6 decimal places to ensure the smallest units are included when displayed in the results. </span></small>            
        </div>
        <div class="row" id="divErrorMsg" style="color: red; font-weight: normal;">
            <strong><span id="lblErrorMsg"></span></strong>
        </div>
        <div style="padding-top: 15px;">
            <p><a class="btn btn-default" href="https://testweightaddapi.azurewebsites.net/default2">Check out the C#/Code Behind Implementation... &raquo;</a></p>
        </div>
        <!-- /.row -->
    </div>
</body>
</html>
