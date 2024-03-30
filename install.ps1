# Create ansible-ctrl container
docker build . -f "ansible-ctrl.dockerfile" -t ansible-ctrl
docker run -itd --name ansible-ctrl -v ${pwd}:/data -v ${env:UserProfile}\.aws:/root/.aws ansible-ctrl