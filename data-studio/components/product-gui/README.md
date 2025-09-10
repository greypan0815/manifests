# Install with a single command

1. Installed in `kubeflow` namespace.
    ```shell
    kustomize build data-studio/base/
    ```

2. Integrate with DataStudio UI - edit ConfigMap `centraldashboard-config` in `kubeflow` namespace, add following items in `data.links` fields.
    ```json
    {
        "type": "item",
        "link": "/tb/",
        "text": "Tumblebug",
        "icon": "icons:extension"
    },
    {
        "type": "item",
        "link": "/aml/",
        "text": "AutoMLab",
        "icon": "icons:extension"
    },
    {
        "type": "item",
        "link": "/mole/",
        "text": "Mole",
        "icon": "icons:extension"
    },
    {
        "type": "item",
        "link": "/whl/",
        "text": "Whale",
        "icon": "icons:extension"
    },
    ```

# Install individual components

* Tumblebug UI   
    ```shell
    kustomize build tumblebug-web-app/base/ -n kubeflow
    ```
* AutoMLab UI   
    ```shell
    kustomize build automlab-web-app/base/ -n kubeflow
    ```
* Mole UI   
    ```shell
    kustomize build mole-web-app/base/ -n kubeflow
    ```
* Whale UI   
    ```shell
    kustomize build whale-web-app/base/ -n kubeflow
    ```