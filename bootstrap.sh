command -v chef-solo >/dev/null && {
  echo "Chef is already bootstrapped"
  exit
}

apt-get update && \
apt-get install -y build-essential

case `uname -m` in
  x86_64)
    REE="http://rubyforge.org/frs/download.php/68720/ruby-enterprise_1.8.7-2010.01_amd64.deb"
    ;;
  *)
    REE="http://rubyforge.org/frs/download.php/68718/ruby-enterprise_1.8.7-2010.01_i386.deb"
    ;;
esac

echo "Fetching ${REE}"
curl -s -L -o ree.deb "${REE}" && \
dpkg -i ree.deb && \
rm ree.deb

RUBYGEMS_VERSION="1.3.7"
gem install -v ${RUBYGEMS_VERSION} rubygems-update && \
ruby `gem env gemdir`/gems/rubygems-update-${RUBYGEMS_VERSION}/setup.rb && \
gem install -v 0.5.6  ohai --no-rdoc --no-ri
gem install -v 0.9.8 chef --no-rdoc --no-ri

mkdir -p /etc/chef