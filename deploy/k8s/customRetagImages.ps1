Param(
    [parameter(Mandatory=$true)][string]$acrName
)

# Predefined images suffixes
$imageSuffixCollections = @(
    "eshop/mobileshoppingagg:linux-latest",
    "eshop/ordering.signalrhub:linux-latest"
);

# Check if CR is that of Azure
if ( $azureContainerRegistry -contains '.azurecr.io' ) {
    throw 'Please use only repo name'
}

# Create resource group
Write-Host "Retagging Your local images..." -ForegroundColor Yellow

Foreach($image in $imageSuffixCollections){
    Write-Host "Tagging $image ...";
    docker tag $image $acrName".azurecr.io/"$image
}



# Create kubernetes cluster in AKS
Write-Host "Pushing your images to private repo on $acrName" -ForegroundColor Yellow


Foreach($image in $imageSuffixCollections){
    Write-Host "Pushing to your ACR: $image ...";
    # docker push <acs-registry-name>.azurecr.io/eshop/mobileshoppingagg:linux-latest
    docker push $acrName".azurecr.io/"$image
}


