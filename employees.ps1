
# קובץ שבו נשמור את נתוני העובדים
$employeesFile = "employees.json"

# פונקציה לטעינת נתונים מהקובץ
function Load-Employees {
    if (Test-Path $employeesFile) {
        return Get-Content $employeesFile | ConvertFrom-Json
    } else {
        return @()  # מחזיר רשימה ריקה אם הקובץ לא קיים
    }
}

# פונקציה לשמירת נתוני העובדים לקובץ
function Save-Employees($employees) {
    $employees | ConvertTo-Json -Depth 10 | Set-Content $employeesFile
}

# פונקציה להוספת עובד חדש
function Add-Employee {
    param (
        [string]$Name,
        [string]$Position,
        [int]$Salary
    )

    $employees = Load-Employees
    $id = ($employees | Measure-Object).Count + 1  # יצירת מזהה ייחודי

    $newEmployee = @{
        ID       = $id
        Name     = $Name
        Position = $Position
        Salary   = $Salary
    }

    $employees += $newEmployee
    Save-Employees $employees

    Write-Host "✅ עובד נוסף בהצלחה: $($newEmployee.Name)" -ForegroundColor Green
}

# פונקציה להצגת כל העובדים
function Show-Employees {
    $employees = Load-Employees
    if ($employees.Count -eq 0) {
        Write-Host "❌ אין עובדים רשומים!" -ForegroundColor Red
    } else {
        $employees | Format-Table ID, Name, Position, Salary -AutoSize
    }
}

# פונקציה לחיפוש עובד לפי שם
function Search-Employee {
    param ([string]$Name)

    $employees = Load-Employees
    $found = $employees | Where-Object { $_.Name -match $Name }

    if ($found) {
        $found | Format-Table ID, Name, Position, Salary -AutoSize
    } else {
        Write-Host "❌ לא נמצא עובד בשם '$Name'!" -ForegroundColor Red
    }
}

# פונקציה למחיקת עובד לפי מזהה
function Remove-Employee {
    param ([int]$ID)

    $employees = Load-Employees
    $updatedEmployees = $employees | Where-Object { $_.ID -ne $ID }

    if ($employees.Count -ne $updatedEmployees.Count) {
        Save-Employees $updatedEmployees
        Write-Host "✅ עובד עם מזהה $ID נמחק בהצלחה!" -ForegroundColor Green
    } else {
        Write-Host "❌ לא נמצא עובד עם מזהה $ID!" -ForegroundColor Red
    }
}

# תפריט אינטראקטיבי
do {
    Clear-Host
    Write-Host "==============================="
    Write-Host "   🔹 ניהול עובדים - PowerShell 🔹"
    Write-Host "==============================="
    Write-Host "1. הוספת עובד חדש"
    Write-Host "2. הצגת כל העובדים"
    Write-Host "3. חיפוש עובד לפי שם"
    Write-Host "4. מחיקת עובד לפי מזהה"
    Write-Host "5. יציאה"
    Write-Host "==============================="
    
    $choice = Read-Host "בחר אפשרות (1-5)"

    switch ($choice) {
        "1" {
            $name = Read-Host "הכנס שם העובד"
            $position = Read-Host "הכנס תפקיד"
            $salary = Read-Host "הכנס שכר"
            Add-Employee -Name $name -Position $position -Salary $salary
        }
        "2" { Show-Employees }
        "3" {
            $searchName = Read-Host "הכנס שם לחיפוש"
            Search-Employee -Name $searchName
        }
        "4" {
            $idToRemove = Read-Host "הכנס מזהה עובד למחיקה"
            Remove-Employee -ID $idToRemove
        }
        "5" { Write-Host "👋 יציאה..." }
        default { Write-Host "❌ בחירה לא חוקית, נסה שוב!" -ForegroundColor Red }
    }
    
    Pause
} while ($choice -ne "5")
