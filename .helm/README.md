This chart deploys IKO Iriscluster application

helm -n iko upgrade iris-maze --install . --set image.repository=eu.gcr.io/iris-community-demos/iris-maze --set image.tag=b01aadff57d668a498b8e2d0a29fcf2969d569e1
