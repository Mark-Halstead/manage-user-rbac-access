# Login to Azure
Write-Host "Logging in to Azure..."
Connect-AzAccount

# Function to list RBAC roles for a given user or group
function List-RBAC {
    $principalId = Read-Host "Enter the object ID of the user or group"
    $roleAssignments = Get-AzRoleAssignment -ObjectId $principalId
    if ($roleAssignments) {
        Write-Host "Role assignments for ${principalId}:"
        $roleAssignments | Format-Table RoleDefinitionName, Scope
    } else {
        Write-Host "No roles assigned to this principal."
    }
}

# Function to assign RBAC role to a user or group
function Assign-RBAC {
    $principalId = Read-Host "Enter the object ID of the user or group"
    $roleName = Read-Host "Enter the role name (e.g., 'Contributor', 'Reader')"
    $scope = Read-Host "Enter the scope (e.g., '/subscriptions/{subscriptionId}' or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}')"
    New-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName $roleName -Scope $scope
    Write-Host "Role $roleName assigned to ${principalId} at scope $scope."
}

# Function to remove RBAC role from a user or group
function Remove-RBAC {
    $principalId = Read-Host "Enter the object ID of the user or group"
    $roleName = Read-Host "Enter the role name (e.g., 'Contributor', 'Reader')"
    $scope = Read-Host "Enter the scope (e.g., '/subscriptions/{subscriptionId}' or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}')"
    $roleAssignment = Get-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName $roleName -Scope $scope
    if ($roleAssignment) {
        Remove-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName $roleName -Scope $scope
        Write-Host "Role $roleName removed from ${principalId} at scope $scope."
    } else {
        Write-Host "No role assignment found for $roleName at the specified scope."
    }
}

# Main menu for the user
function Show-Menu {
    Write-Host "Select an option:"
    Write-Host "1: List RBAC roles"
    Write-Host "2: Assign RBAC role"
    Write-Host "3: Remove RBAC role"
    Write-Host "4: Exit"
}

# Main script loop
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        1 { List-RBAC }
        2 { Assign-RBAC }
        3 { Remove-RBAC }
        4 { break }
        default { Write-Host "Invalid choice. Please select a valid option." }
    }
}

# End of script
Write-Host "Exiting..."
