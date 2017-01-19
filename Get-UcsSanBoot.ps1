function Get-UcsSanBoot () {
    $SvcProfiles = Get-UcsServiceProfile -Type instance

    foreach ($SvcProfile in $SvcProfiles) {
        $vHBAs = $SvcProfile | Get-UcsVhba
        $ChassisID = $SvcProfile.PnDn.Split('/') | 
            Where-Object {$_ -match 'chassis'}
        $SlotID = $SvcProfile.PnDn.Split('/') |
            Where-Object {
                $_ -match 'blade' -or
                $_ -match 'rack'
            }

        [PsCustomObject]@{
            Ucs = $SvcProfile.Ucs
            Name = $SvcProfile.Name
            WWNN = $vHBAs[0].NodeAddr
            'vHBA-A' = $vHBAs[0].Addr
            'vHBA-B' = $vHBAs[1].Addr
            BootPolicy = $SvcProfile.BootPolicyName
            Notes = $SvcProfile.UsrLbl
            Chassis = $ChassisID
            Slot = $SlotID
        }
    }
}
