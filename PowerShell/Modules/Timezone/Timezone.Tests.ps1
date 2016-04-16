Import-Module "$PSScriptRoot\Timezone.psm1"

Describe 'Get-Timezone' {
    Context 'UTC' {
        It 'Returns the current Timezone object' {
            $timezone = Get-Timezone
            $timezone.Timezone | Should Not Be $null
            $timezone.UTCOffset | Should Not Be $null
            $timezone.ExampleLocation | Should Not Be $null
        }
    }
    
    Context 'Ahead of GMT timezone' {
        It 'Returns a Singapore (UTC+08:00) Timezone object' {
            $timezone = (Get-Timezone -Timezone 'Singapore Standard Time')
            $timezone.Timezone | Should Be 'Singapore Standard Time'
            $timezone.UTCOffset | Should Be '+08:00'
            $timezone.ExampleLocation | Should Be '(UTC+08:00) Kuala Lumpur, Singapore'
        }
    }
    
    Context 'Behind GMT timezone' {
        It 'Returns a Central America (UTC-06:00) Timezone object' {
            $timezone = (Get-Timezone -Timezone 'Central America Standard Time')
            $timezone.Timezone | Should Be 'Central America Standard Time'
            $timezone.UTCOffset | Should Be '-06:00'
            $timezone.ExampleLocation | Should Be '(UTC-06:00) Central America'
        }
    }

    Context 'Validation' {
        It 'Tries to get an invalid timezone' {
            { Get-Timezone -Timezone 'My First Timezone' } | Should Throw
            { Get-Timezone -Timezone 0 } | Should Throw
            { Get-Timezone -Timezone 19:00 } | Should Throw
        }
    }
}

Describe 'Get-TimezoneFromOffset' {
    Context 'UTC' {
        It 'Returns the UTC timezone offset' {
            @('00:00', '+00:00', '-00:00') | ForEach-Object {
                $utcTz = Get-Timezone -Timezone 'UTC'
                $timezone = Get-TimezoneFromOffset $_
                $timezone.Timezone -contains $utcTz.Timezone | Should Be $true
                $timezone.UTCOffset -contains $utcTz.UTCOffset | Should Be $true
                $timezone.ExampleLocation -contains $utcTz.ExampleLocation | Should Be $true
            }
        }
    }

    Context 'Current' {
        It 'Returns the current timezone offset' {
            $currentTz = Get-Timezone
            $timezone = Get-TimezoneFromOffset
            $timezone.Timezone -contains $currentTz.Timezone | Should Be $true
            $timezone.UTCOffset -contains $currentTz.UTCOffset | Should Be $true
            $timezone.ExampleLocation -contains $currentTz.ExampleLocation | Should Be $true
        }
    }

    Context 'All' {
        It 'Checks all Timezone Offsets for consistency with Get-Timezone' {
            foreach ($timezone in Get-Timezone -All) {
                $tzo = Get-TimezoneFromOffset -UTCOffset $timezone.UTCOffset
                $tzo.Timezone -contains $timezone.Timezone | Should Be $true
                $tzo.UTCOffset -contains $timezone.UTCOffset | Should Be $true
                $tzo.ExampleLocation -contains $timezone.ExampleLocation | Should Be $true
            }
        }
    }

    Context 'Validation' {
        It 'Tries to get an invalid timezone offset' {
            { Get-TimezoneFromOffset -UTCOffset 'My First Timezone' } | Should Throw
            { Get-TimezoneFromOffset -UTCOffset 0 } | Should Throw
            Get-TimezoneFromOffset -UTCOffset 19:00 | Should Be $null
        }
    }
}

Describe 'Set-Timezone-UTC' {
    It 'Sets the timezone to UTC' {
        Set-Timezone -Timezone "UTC" -WhatIf | Should Be $null
    }

    It 'Tries to set an invalid timezone' {
        { Set-Timezone -Timezone 'My First Timezone' } | Should Throw
    }
}
