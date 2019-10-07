<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1.Default" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Addition WebAPI Example</title>
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
            addRow();
            $('.loader').hide();
            unitSelect();
        });

        function Delete(thisParam) {
            thisParam.closest('tr').remove();
        }

        function unitSelect() {
            $('#unitSelect').append(getUnit());
        }

        function addRow() {
            var i = $('#tbl tbody tr').length;
            var tableRow = '<tr>';
            tableRow += '<td><input type="text" class="data form-control" name="ItemName[]" id="Value' + i + ' " placeholder="Value"></td>';
            tableRow += '<td><select class="data form-control" id="Unit' + i + '">' + getUnit() + ' </select></td>';
            tableRow += '<td><button class="btn btn-dange" style="background-color:transparent;" onclick="Delete($(this))"> <i class="fa fa-trash-o"></i></button> </td>';
            tableRow += '</tr>';
            $('#tbl tbody').append(tableRow);
        }




        function getUnit() {
            $.ajax({
                type: "GET"
                , url: "http://localhost:8080/api/GetUnits/GetUnit"
               , dataType: "json"
                , async: !1
                , success: function (response) {
                    //alert("Success: " + response);
                    var AddOption = '';
                    var data;
                    var obj; //= JSON.parse(data);

                    console.log(response);
                    data = JSON.stringify(response);
                    alert(data);
                    //data = response;
                    obj = JSON.parse(data);
                    //alert(obj.units.length);
                    //alert("FirstUnit:" + obj.units[0]);

                    for (i = 0; i < obj.units.length; i++) {
                        AddOption += '<option value="' + obj.units[i].toString() + '">' + obj.units[i].toString() + '</option>'
                    }

                    //alert(AddOption);
                    return AddOption;

                }
                , error: function (response) {
                    alert(JSON.stringify(response));
                }
            })
            
            
            //$.each(data, function (i, item) {
            //    AddOption += '<option value="' + data[i].unit + '">' + data[i].unit + '</option>'
            //});
            //alert("AdOption:\n" + AddOption);
            //return AddOption;
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

            $("table thead tr th").not(':last').each(function () {
                keys.push($(this).html());
            });

            $("table tbody tr").each(function () {
                var obj = {}
                    , i = 0;
                $(this).children("td").not(':last').each(function () {
                    obj[keys[i]] = $(this).children('.data').val();
                    i++;
                })
                arrayObj.push(obj);
            });
            console.log(JSON.stringify({
                items: arrayObj
            }));

            //You need to pass the Json Object and Extra parameter i.e. dropdown value in which the user want to see the result.


            var UnitResult = $('#unitSelect').val();

            $.ajax({
                type: "POST"
                , url: "http://localhost:8080/api/Values/Calculate"
                , data: JSON.stringify({
                    items: arrayObj
                })
                , contentType: "application/json;charset=UTF-8"
                , dataType: "json"
                , success: function (response) {
                    alert(response.d);
                }
                , error: function (response) {
                    alert(response.d);
                }
            })
            $('.loader').hide();
            $('.Save').show();
        }
    </script>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.html">Unit Conversion</a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <!--
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item"> <a class="nav-link" href="about.html">About</a> </li>
                    <li class="nav-item active"> <a class="nav-link" href="services.html">Services</a> </li>
                    <li class="nav-item"> <a class="nav-link" href="contact.html">Contact</a> </li>
                    <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownPortfolio" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              Portfolio
            </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownPortfolio"> <a class="dropdown-item" href="portfolio-1-col.html">1 Column Portfolio</a> <a class="dropdown-item" href="portfolio-2-col.html">2 Column Portfolio</a> <a class="dropdown-item" href="portfolio-3-col.html">3 Column Portfolio</a> <a class="dropdown-item" href="portfolio-4-col.html">4 Column Portfolio</a> <a class="dropdown-item" href="portfolio-item.html">Single Portfolio Item</a> </div>
                    </li>
                    <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownBlog" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              Blog
            </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownBlog"> <a class="dropdown-item" href="blog-home-1.html">Blog Home 1</a> <a class="dropdown-item" href="blog-home-2.html">Blog Home 2</a> <a class="dropdown-item" href="blog-post.html">Blog Post</a> </div>
                    </li>
                    <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownBlog" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              Other Pages
            </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownBlog"> <a class="dropdown-item" href="full-width.html">Full Width Page</a> <a class="dropdown-item" href="sidebar.html">Sidebar Page</a> <a class="dropdown-item" href="faq.html">FAQ</a> <a class="dropdown-item" href="404.html">404</a> <a class="dropdown-item" href="pricing.html">Pricing Table</a> </div>
                    </li>
                </ul>
            </div>
-->
        </div>
    </nav>
    <!-- Page Content -->
    <div class="container">
        <!-- Page Heading/Breadcrumbs -->
        <h3 class="mt-4 mb-3">
            <small>Please enter the details</small>
        </h3>

        <!--
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="index.html">Home</a>
              </li>
              <li class="breadcrumb-item active">Services</li>
            </ol>
        -->
        <!-- Image Header -->
        <!--    <img class="img-fluid rounded mb-4" src="http://placehold.it/1200x300" alt="">-->
        <!-- Marketing Icons Section -->
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
                        <td colspan="3">
                            <a href="#" class="btn" title="Add new row" onclick="addRow()"><i class="fa fa-plus"></i>Add Row</a>
                            <!--<button class="btn" style="background-color:transparent;" onclick="addRow()"><i class="fa fa-plus"></i> Add Row</button>-->
                            <!--<input type="button" value="Add Row" class="btn btn-success" onclick="addRow()"> </td>-->
                    </tr>
                </tfoot>
            </table>
            <br>
            <!--<input type="button" value="Submit" class="btn btn-info" onclick="submit()"> </body>-->
        </div>
        <div class="row">
            <div class="col-sm-4">Please select the result type from dropdown</div>
            <div class="col-sm-3">
                <select class="data form-control" id="unitSelect"></select>
            </div>
            <div class="col-sm-3">
                <a href="#" class="btn btn-info" id="Save" title="Submit" onclick="submit()"><i class="fa fa-floppy-o"></i>Submit</a>
                <!--<button class="btn btn-success" id="Save" onclick="submit()"> <i class="fa fa-floppy-o"></i> Submit</button>-->
            </div>
            <div class="col-sm-2">
                <div class="loader">Loading...</div>
            </div>
        </div>
        <!-- /.row -->
    </div>
