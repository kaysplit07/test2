(strcontains(local.variables_row.purpose, "/") ? 
            split("/", local.variables_row.purpose)[0] :
            local.variables_row.purpose != "" ? local.variables_row.purpose : "defined")
