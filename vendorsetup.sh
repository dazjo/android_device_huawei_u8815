if [ ! -z "$JENKINS_HOME" ]
then
  # If we're Jenkins, run device patches on the tree. I'm lazy and this is easy for nightly builds.
  sh device/huawei/u8815/patches/apply.sh
fi

add_lunch_combo full_u8815-eng
add_lunch_combo full_u8815-userdebug
