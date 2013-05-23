if [ ! -z "$JENKINS_HOME" ]
then
  # If we're Jenkins, run device patches on the tree. I'm lazy and this is easy for nightly builds.
  sh device/huawei/u8815/patches/apply.sh
fi
