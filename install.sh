# Create ansible-ctrl container

GLIBC_ARCH="x86_64"
if [[ $(uname -m) == 'arm64' ]]; then
  GLIBC_ARCH="aarch64" # For Mac M1
fi

docker build --build-arg GLIBC_ARCH=$GLIBC_ARCH . -f "ansible-ctrl.dockerfile" -t ansible-ctrl
docker run -itd --name ansible-ctrl -v $(pwd):/data -v ~/.aws:/root/.aws ansible-ctrl # may need to update ~/.aws