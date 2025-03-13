"""The Databricks connect test script."""
import json
import os

import msal  # pip install msal


def get_aad_token_public(input_config_dict):
    """Get token from Azure."""
    app = msal.PublicClientApplication(
        input_config_dict["client_id"], authority=input_config_dict["authority"]
    )
    result = app.acquire_token_interactive(input_config_dict["scope"])

    return result["access_token"]


def set_databricks_connect_file(input_config_dict):
    """Set the Databricks connect file."""
    databricks_connect_dict = {}
    databricks_connect_dict["host"] = input_config_dict["host"]
    databricks_connect_dict["token"] = get_aad_token_public(input_config_dict)
    databricks_connect_dict["cluster_id"] = input_config_dict["cluster_id"]
    databricks_connect_dict["org_id"] = input_config_dict["org_id"]
    databricks_connect_dict["port"] = input_config_dict["port"]

    # Set token in .databricks-connect
    with open(
        input_config_dict["databricks-connect_path"], "r+"
    ) as databricks_connect_file:
        databricks_connect_file.seek(0)
        databricks_connect_file.truncate(0)
        json.dump(databricks_connect_dict, databricks_connect_file)
        databricks_connect_file.close()


if __name__ == "__main__":
    # TODO: Modify config here
    config_dict = {
        # The application ID of your application. You can obtain one by registering your application with our Application registration portal.
        "client_id": "xxxx",
        # The Authority URL for your application.
        "authority": "https://login.microsoftonline.com/xxx/",
        "scope": ["2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default"],

        "host": "https://adb-xxx.11.azuredatabricks.net/",
        "cluster_id": "xxx",
        "org_id": "xxx",

        # "host": "https://adb-2949000197705444.4.azuredatabricks.net/",
        # "cluster_id": "0117-090640-2yv41qf1",
        # "org_id": "2949000197705444",

        "port": "15001",  # Default port
        "databricks-connect_path": "C:\\Users\\%s\\.databricks-connect"
        % (os.getlogin()),
    }
    #
    set_databricks_connect_file(config_dict)  # If using your AAD = False
    # Run test
    os.system("databricks-connect test")
