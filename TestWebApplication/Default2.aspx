<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default2.aspx.cs" Inherits="WebApplication2.Default2" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Addition WebAPI Example</title>
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
</script>
</head>

<body>
    <!-- Navigation -->
    <form id="form" runat="server">
        <nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark fixed-top">
            <div class="container">
                <a class="navbar-brand" href="index.html">Unit Conversion</a>
                <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>

            </div>
        </nav>
        <!-- Page Content -->
        <div class="container">
            <!-- Page Heading/Breadcrumbs -->
            <h5 class="mt-4 mb-3">
                <small><span>
                    Enter data by entering values(numbers), selecting respective units, and clicking "Add". You can add as many rows.
                        <br />
                        Once done, click on the "Perform Addition" button to get a sum of all values. You can also select the unit in which you would like to see the total sum of all values.
                </span>
                </small>
            </h5>
            <div class="row">
                <div class="col-sm-3 form-group">

                    <label><strong>Enter a value</strong></label>
                    <div class="input-group">
                        <span class="input-group"></span>
                        <asp:TextBox ID="txtvalues" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Value is required" ControlToValidate="txtvalues"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="col-sm-3 form-group">
                    <label><strong>Select a unit</strong></label>
                    <div class="input-group">
                        <span class="input-group"></span>
                        <asp:DropDownList ID="ddlunits" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-3 form-group" style="padding-top: 5px;">
                    <label></label>
                    <div class="input-group">
                        <asp:Button ID="btnadd" runat="server" Text="Add" CssClass="btn-success" OnClick="btnadd_Click" />
                    </div>
                </div>
            </div>
            <%-- <div class="row">--%>
            <div class="table-responsive">
                <asp:GridView ID="gvunits" CssClass="table-bordered table-responsive table-row" runat="Server" AutoGenerateColumns="false" Visible="true">
                    <Columns>
                        <asp:BoundField HeaderText="Value" DataField="value" />
                        <asp:BoundField HeaderText="Units" DataField="units" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkdelete" runat="server" CssClass="btn-danger" Text="Delete" CommandArgument='<%#Eval("id") %>' OnCommand="lnkdelete_Command"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>No records found</EmptyDataTemplate>
                </asp:GridView>
            </div>

            <br />

            <div class="col-sm-3 form-group">
                <label>Show results in: </label>
                <div class="input-group">
                    <span class="input-group">
                        <asp:DropDownList ID="ddlResultUnits" runat="server" CssClass="form-control"></asp:DropDownList>&nbsp; &nbsp;&nbsp;
                            <asp:Button ID="btnsubmit" runat="server" Text="Perform Addition" CssClass="btn-success" OnClick="btnsubmit_Click" />
                    </span>

                </div>
            </div>

            <div class="col-sm-3 form-group">
                
                <div class="input-group">
                    <asp:Label runat="server" ID="lblResult" Visible="false" Font-Bold="true"></asp:Label>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
