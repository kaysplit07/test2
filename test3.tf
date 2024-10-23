(strcontains(local.variables_row.purpose, "/") ? 
            split("/", local.variables_row.purpose)[0] :
            local.variables_row.purpose != "" ? local.variables_row.purpose : "defined")



Load Balancer

{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "loadBalancerName": {
            "value": "ari-dev-eus2-sgs-lbi-01"
        },
        "frontendIPConfigurations": {
            "value": [
                 {
                   "name": "internal-sgs-server-feip",
                   "properties": {
                     "publicIPAddressId": "",
                     "subnetId": "/subscriptions/abd31edb-064b-4039-a183-2daf45cb764c/resourceGroups/6425-dev-eus2-spokenetwork-rg/providers/Microsoft.Network/virtualNetworks/6425-dev-eus2-vnet-01/subnets/lz6425-dev-eus2-vm-snet-01",
                     "privateIPAddress": "10.82.58.233"
                   }
                 }
            ]
        },
        "backendAddressPools": {
            "value": [{
                "name": "internal-sgs-server-bepool"
            }]
        },
        "loadBalancingRules": {
            "value": [
                {
                    "name": "internal-sgs-server-tcp-lbrule",
                    "properties": {
                      "frontendIPConfigurationName": "internal-sgs-server-feip",
                      "frontendPort": 20000,
                      "backendPort": 20000,
                      "enableFloatingIP": false,
                      "idleTimeoutInMinutes": 5,
                      "protocol": "TCP",
                      "enableTcpReset": false,
                      "disableOutboundSnat": false,
                      "probeName": "internal-sgs-server-tcp-probe",
                      "backendAddressPoolName": "internal-sgs-server-bepool"
                    }
                  },
                  {
                      "name": "internal-sgs-server-https-lbrule",
                      "properties": {
                        "frontendIPConfigurationName": "internal-sgs-server-feip",
                        "frontendPort": 443,
                        "backendPort": 443,
                        "enableFloatingIP": false,
                        "idleTimeoutInMinutes": 4,
                        "protocol": "TCP",
                        "enableTcpReset": false,
                        "disableOutboundSnat": false,
                        "probeName": "internal-sgs-server-tcp-probe",
                        "backendAddressPoolName": "internal-sgs-server-bepool"
                      }
                    }
            ]
        },
        "probes": {
            "value": [{
                "name": "internal-sgs-server-tcp-probe",
                "properties": {
                    "protocol": "TCP",
                    "port": 200005,
                    "requestPath": "/",
                    "intervalInSeconds": 10,
                    "numberOfProbes": 5
                }
            }]
        }
    }
}
