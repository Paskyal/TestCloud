permissionset 50000 "ENA PermissionSet"
{
    Assignable = true;
    Permissions = tabledata "ENA Enavation G/L Account" = RIMD,
        tabledata "ENA Enavation G/L Setup" = RIMD,
        table "ENA Enavation G/L Account" = X,
        table "ENA Enavation G/L Setup" = X,
        report "ENA Detail Trial Balance" = X,
        xmlport "ENA Data Exch. Import - BAI" = X;
}