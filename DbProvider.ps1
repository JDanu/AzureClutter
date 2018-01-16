# Reference - https://social.technet.microsoft.com/wiki/contents/articles/30562.powershell-accessing-sqlite-databases.aspx

$databasePath = "C:\Danu\test5.db"

if(Test-Path($databasePath)){
    Write-Host("DB exists.")
}
else{
    Write-Host("DB does not exist. Creating DB.")
    
    $Query = "CREATE TABLE Termination (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Account TEXT,
        Tenant TEXT,
        Subscription TEXT,
        ResourceGroup TEXT,
        Resource TEXT,
        Command TEXT,
        TerminatedOn DATETIME)"

    #SQLite will create Names.SQLite for us
    Invoke-SqliteQuery -Query $Query -DataSource $databasePath

    # We have a database, and a table, let's view the table info
    Invoke-SqliteQuery -DataSource $databasePath -Query "PRAGMA table_info(NAMES)"
}